# Portal HIV/AIDS — Informação, Prevenção e Acolhimento

Portal Web Informativo com Assistente Virtual de IA desenvolvido como projeto de extensão universitária.

## Tecnologias

- **Backend:** Java 17 + Spring Boot 3.2.5
- **Frontend:** Thymeleaf + HTML/CSS/JS (sem frameworks externos)
- **Banco de dados:** MySQL 8.x
- **IA:** API Anthropic (Claude) + base de conhecimento local
- **Build:** Maven

---

## Pré-requisitos

- Java 17+
- Maven 3.8+
- MySQL 8.x rodando localmente
- Chave de API Anthropic (console.anthropic.com)

---

## 1. Banco de Dados

Abra o MySQL Workbench e execute o script completo:

```
sql/portal_hiv_completo.sql
```

Ele cria o banco `portal_hiv`, todas as tabelas e insere os dados iniciais.

---

## 2. Configurar a aplicação

Edite `src/main/resources/application.properties`:

```properties
# Banco de dados
spring.datasource.username=root
spring.datasource.password=SUA_SENHA_MYSQL

# API Anthropic
anthropic.api.key=SUA_CHAVE_AQUI
```

> **Atenção:** Nunca commite a chave da API no GitHub. Use variáveis de ambiente em produção.

---

## 3. Executar

```bash
# Na raiz do projeto
mvn spring-boot:run
```

Acesse: **http://localhost:8080**

---

## 4. Estrutura do projeto

```
portal-hiv/
├── sql/
│   └── portal_hiv_completo.sql       # Script SQL completo
├── src/main/java/com/portalhiv/
│   ├── PortalHivApplication.java     # Main
│   ├── config/
│   │   ├── JacksonConfig.java        # ObjectMapper
│   │   └── WebClientConfig.java      # WebClient Anthropic
│   ├── controller/
│   │   ├── PortalController.java     # Páginas web
│   │   └── ChatController.java       # API REST do chat
│   ├── entity/                       # Entidades JPA
│   ├── repository/                   # Repositórios Spring Data
│   └── service/
│       ├── AssistenteVirtualService.java  # IA + lógica do chat
│       └── PortalService.java             # Conteúdo do portal
└── src/main/resources/
    ├── application.properties
    └── templates/
        └── index.html                # Frontend completo
```

---

## 5. Como o chatbot funciona

1. O usuário envia uma pergunta via POST `/api/chat/mensagem`
2. O sistema faz matching por palavras-chave na tabela `base_conhecimento`
3. Se encontrar match relevante (score ≥ 2), retorna a resposta local
4. Se não encontrar, envia para a API do Claude com contexto da base local
5. Toda conversa é salva anonimamente na tabela `historico_chat`

---

## Fontes científicas

- PCDT HIV, PEP e PrEP — Ministério da Saúde do Brasil (2018–2022)
- Estudo PARTNER 2 — Rodger AJ et al. Lancet. 2019
- iPrEx Study — Grant RM et al. N Engl J Med. 2010
- OMS/UNAIDS Global HIV Statistics, 2023
- CDC — HIV Transmission, 2023
- Legislação Federal: Leis nº 9.313/96, 9.029/95, 7.713/88, 13.709/18

---

*Projeto de Extensão Universitária — Disciplina de Inteligência Artificial para Devs*
