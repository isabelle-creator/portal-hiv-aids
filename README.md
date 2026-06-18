
# Portal HIV/AIDS — Informação, Prevenção e Acolhimento

Projeto de extensão universitária desenvolvido na disciplina de Inteligência Artificial para Devs.

## O que é

Portal web informativo sobre HIV/AIDS com assistente virtual de IA (Ana),
baseado nas diretrizes oficiais do Ministério da Saúde do Brasil.

## Tecnologias

- Java 17 + Spring Boot 3.2.5
- MySQL 8 — banco de dados hospedado no **Railway**
- Thymeleaf (frontend)
- API Anthropic Claude (IA do chatbot)
- Aplicação hospedada no **Railway**

> **Atenção:** no plano gratuito do Railway, o serviço pode entrar em modo
> de hibernação após período de inatividade. Caso o site não carregue,
> basta aguardar alguns segundos para o container ser reativado.

## Variáveis de ambiente necessárias (Railway)

| Variável | Descrição |
|---|---|
| `SPRING_DATASOURCE_URL` | URL completa de conexão com o MySQL |
| `SPRING_DATASOURCE_USERNAME` | Usuário do banco |
| `SPRING_DATASOURCE_PASSWORD` | Senha do banco |
| `ANTHROPIC_API_KEY` | Chave da API Anthropic (opcional) |

## Como rodar localmente

**1. Execute o SQL no MySQL Workbench:**
