package com.portalhiv.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "historico_chat")
@Data
@NoArgsConstructor
public class HistoricoChat {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "sessao_id", nullable = false, length = 64)
    private String sessaoId;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String pergunta;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String resposta;

    @Column(name = "intencao_detectada", length = 100)
    private String intencaoDetectada;

    @Column(name = "criado_em")
    private LocalDateTime criadoEm;

    @PrePersist
    public void prePersist() {
        this.criadoEm = LocalDateTime.now();
    }

    public HistoricoChat(String sessaoId, String pergunta, String resposta, String intencaoDetectada) {
        this.sessaoId = sessaoId;
        this.pergunta = pergunta;
        this.resposta = resposta;
        this.intencaoDetectada = intencaoDetectada;
    }
}
