package com.portalhiv.controller;

import com.portalhiv.service.AssistenteVirtualService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/chat")
@RequiredArgsConstructor
@Slf4j
public class ChatController {

    private final AssistenteVirtualService assistenteVirtualService;

    /**
     * Endpoint principal do chatbot.
     * Recebe a pergunta do usuário e retorna a resposta da Ana.
     */
    @PostMapping("/mensagem")
    public ResponseEntity<Map<String, String>> processarMensagem(
            @RequestBody Map<String, String> payload,
            HttpSession session) {

        String pergunta = payload.get("pergunta");

        if (pergunta == null || pergunta.isBlank()) {
            return ResponseEntity.badRequest()
                    .body(Map.of("erro", "Pergunta não pode estar vazia."));
        }

        if (pergunta.length() > 1000) {
            return ResponseEntity.badRequest()
                    .body(Map.of("erro", "Pergunta muito longa. Tente resumir em até 1000 caracteres."));
        }

        // Sessão anônima para o histórico
        String sessaoId = (String) session.getAttribute("sessaoId");
        if (sessaoId == null) {
            sessaoId = UUID.randomUUID().toString().replace("-", "");
            session.setAttribute("sessaoId", sessaoId);
        }

        log.info("Nova pergunta recebida. Sessão: {}...", sessaoId.substring(0, 8));

        String resposta = assistenteVirtualService.processar(pergunta, sessaoId);

        return ResponseEntity.ok(Map.of("resposta", resposta));
    }

    /**
     * Health check do chatbot
     */
    @GetMapping("/status")
    public ResponseEntity<Map<String, String>> status() {
        return ResponseEntity.ok(Map.of(
                "status", "online",
                "assistente", "Ana - Portal HIV/AIDS"
        ));
    }
}
