# Portal HIV/AIDS — Informação, Prevenção e Acolhimento

Projeto de extensão universitária desenvolvido na disciplina de Inteligência Artificial para Devs.

## O que é

Portal web informativo sobre HIV/AIDS com assistente virtual de IA (Ana),
baseado nas diretrizes oficiais do Ministério da Saúde do Brasil.

## Tecnologias

- Java 17 + Spring Boot 3.2.5
- MySQL 8 — banco de dados hospedado na **Aiven**
- Thymeleaf (frontend)
- API Anthropic Claude (IA do chatbot)
- Aplicação hospedada na **Render**


## Variáveis de ambiente necessárias (Render)

| Variável | Descrição |
|---|---|
| `AIVEN_HOST` | Host do banco MySQL fornecido pela Aiven |
| `AIVEN_PORT` | Porta do banco (geralmente 3306) |
| `AIVEN_DATABASE` | Nome do banco de dados |
| `AIVEN_USER` | Usuário do banco |
| `AIVEN_PASSWORD` | Senha do banco |
| `ANTHROPIC_API_KEY` | Chave da API Anthropic |
