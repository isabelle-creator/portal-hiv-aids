package com.portalhiv.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.portalhiv.entity.BaseConhecimento;
import com.portalhiv.entity.HistoricoChat;
import com.portalhiv.repository.BaseConhecimentoRepository;
import com.portalhiv.repository.HistoricoChatRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import java.util.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class AssistenteVirtualService {

    private final BaseConhecimentoRepository baseConhecimentoRepository;
    private final HistoricoChatRepository historicoChatRepository;
    private final WebClient anthropicWebClient;
    private final ObjectMapper objectMapper;

    @Value("${anthropic.api.model}")
    private String modelo;

    @Value("${anthropic.api.max-tokens}")
    private int maxTokens;

    private static final String SYSTEM_PROMPT = """
            Você é a Ana, assistente virtual do Portal HIV/AIDS do SUS. Seu objetivo é oferecer informações
            precisas, acolhedoras e baseadas em ciência sobre HIV/AIDS, PEP, PrEP, testagem e direitos das
            pessoas que vivem com HIV.
            
            Diretrizes de comunicação:
            - Linguagem direta, empática e sem jargão médico desnecessário
            - Nunca use frases como "é crucial lembrar", "vale ressaltar", "no cenário atual"
            - Seja acolhedora, especialmente com quem demonstra medo ou angústia
            - Nunca emita diagnóstico médico; oriente sempre a buscar atendimento profissional
            - Em situações de urgência (possível exposição recente), priorize orientar sobre PEP e UPA
            - Cite fontes oficiais quando relevante: Ministério da Saúde, OMS, CDC
            - Não julgue comportamentos; trate todos com respeito e dignidade
            - Respostas concisas: máximo de 4 parágrafos. Prefira listas quando listar múltiplos itens.
            - Se não souber, diga claramente e oriente a ligar para o 136 (Disque Saúde)
            
            Você não responde sobre temas fora de saúde, HIV/AIDS ou direitos relacionados.
            """;

    /**
     * Processa a pergunta do usuário, tenta matching na base local primeiro,
     * usa API Anthropic como fallback enriquecido com contexto da base.
     */
    public String processar(String pergunta, String sessaoId) {
        String resposta;
        String intencaoDetectada = "geral";

        try {
            // 1. Tenta encontrar resposta na base de conhecimento local
            Optional<BaseConhecimento> matchLocal = buscarNaBase(pergunta);

            if (matchLocal.isPresent()) {
                BaseConhecimento bc = matchLocal.get();
                intencaoDetectada = bc.getIntencao();
                resposta = bc.getResposta();
                log.info("Resposta via base local. Intenção: {}", intencaoDetectada);
            } else {
                // 2. Fallback: envia para Claude com contexto da base
                resposta = chamarAnthropicAPI(pergunta, sessaoId);
                log.info("Resposta via API Anthropic");
            }

        } catch (Exception e) {
            log.error("Erro ao processar pergunta: {}", e.getMessage());
            resposta = respostaFallbackSeguro();
            intencaoDetectada = "erro_sistema";
        }

        // Salva no histórico anonimizado
        salvarHistorico(sessaoId, pergunta, resposta, intencaoDetectada);

        return resposta;
    }

    /**
     * Busca na base de conhecimento por palavras-chave na pergunta.
     */
    private Optional<BaseConhecimento> buscarNaBase(String pergunta) {
        if (pergunta == null || pergunta.isBlank()) return Optional.empty();

        String perguntaNorm = normalizar(pergunta);
        List<BaseConhecimento> base = baseConhecimentoRepository.findByAtivoTrueOrderByPrioridadeDesc();

        BaseConhecimento melhorMatch = null;
        int maiorScore = 0;

        for (BaseConhecimento bc : base) {
            int score = calcularScore(perguntaNorm, bc);
            if (score > maiorScore) {
                maiorScore = score;
                melhorMatch = bc;
            }
        }

        // Threshold mínimo de relevância
        if (maiorScore >= 2) {
            return Optional.ofNullable(melhorMatch);
        }
        return Optional.empty();
    }

    /**
     * Calcula score de relevância entre a pergunta e um item da base.
     */
    private int calcularScore(String perguntaNorm, BaseConhecimento bc) {
        int score = 0;
        String[] palavrasChave = bc.getPalavrasChave().toLowerCase().split(",");

        for (String palavra : palavrasChave) {
            String p = palavra.trim();
            if (!p.isEmpty() && perguntaNorm.contains(p)) {
                score += p.length() > 4 ? 2 : 1; // Palavras maiores têm mais peso
            }
        }

        // Boost por prioridade da intenção
        score += bc.getPrioridade() / 5;

        return score;
    }

    /**
     * Chama a API da Anthropic com contexto da base de conhecimento.
     */
    private String chamarAnthropicAPI(String pergunta, String sessaoId) {
        try {
            // Monta contexto com itens relevantes da base
            String contexto = montarContextoBase(pergunta);

            String promptComContexto = String.format("""
                    Contexto de referência do portal (use como base científica):
                    %s
                    
                    Pergunta do usuário: %s
                    """, contexto, pergunta);

            // Monta o corpo da requisição
            ObjectNode requestBody = objectMapper.createObjectNode();
            requestBody.put("model", modelo);
            requestBody.put("max_tokens", maxTokens);
            requestBody.put("system", SYSTEM_PROMPT);

            ArrayNode messages = requestBody.putArray("messages");
            ObjectNode message = messages.addObject();
            message.put("role", "user");
            message.put("content", promptComContexto);

            // Faz a chamada
            String responseJson = anthropicWebClient.post()
                    .bodyValue(requestBody.toString())
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();

            // Extrai o texto da resposta
            JsonNode responseNode = objectMapper.readTree(responseJson);
            return responseNode.path("content").get(0).path("text").asText();

        } catch (WebClientResponseException e) {
            log.error("Erro na API Anthropic: {} - {}", e.getStatusCode(), e.getResponseBodyAsString());
            return respostaFallbackSeguro();
        } catch (Exception e) {
            log.error("Erro inesperado na chamada API: {}", e.getMessage());
            return respostaFallbackSeguro();
        }
    }

    /**
     * Monta um contexto resumido da base para enriquecer o prompt.
     */
    private String montarContextoBase(String pergunta) {
        String perguntaNorm = normalizar(pergunta);
        List<BaseConhecimento> base = baseConhecimentoRepository.findByAtivoTrueOrderByPrioridadeDesc();

        StringBuilder sb = new StringBuilder();
        int count = 0;

        for (BaseConhecimento bc : base) {
            if (count >= 3) break;
            int score = calcularScore(perguntaNorm, bc);
            if (score > 0) {
                sb.append("---\n");
                sb.append("Tema: ").append(bc.getIntencao()).append("\n");
                sb.append(bc.getResposta().substring(0, Math.min(300, bc.getResposta().length()))).append("...\n");
                sb.append("Fonte: ").append(bc.getFonte()).append("\n");
                count++;
            }
        }

        return sb.length() > 0 ? sb.toString() : "Nenhum contexto específico encontrado na base local.";
    }

    private void salvarHistorico(String sessaoId, String pergunta, String resposta, String intencao) {
        try {
            HistoricoChat historico = new HistoricoChat(sessaoId, pergunta, resposta, intencao);
            historicoChatRepository.save(historico);
        } catch (Exception e) {
            log.warn("Não foi possível salvar histórico do chat: {}", e.getMessage());
        }
    }

    private String normalizar(String texto) {
        return texto.toLowerCase()
                .replaceAll("[àáâãä]", "a")
                .replaceAll("[èéêë]", "e")
                .replaceAll("[ìíîï]", "i")
                .replaceAll("[òóôõö]", "o")
                .replaceAll("[ùúûü]", "u")
                .replaceAll("[ç]", "c")
                .replaceAll("[^a-z0-9 ]", " ")
                .replaceAll("\\s+", " ")
                .trim();
    }

    private String respostaFallbackSeguro() {
        return """
                Estou com dificuldade técnica no momento para processar sua pergunta. \
                Para informações confiáveis sobre HIV/AIDS, você pode ligar para o **Disque Saúde: 136** \
                (gratuito, 24 horas) ou acessar o portal do Departamento de HIV/AIDS do Ministério da Saúde \
                em aids.gov.br. Se você está precisando de PEP com urgência, vá a uma UPA agora.
                """;
    }
}
