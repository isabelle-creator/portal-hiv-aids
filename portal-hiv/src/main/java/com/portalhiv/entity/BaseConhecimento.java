package com.portalhiv.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "base_conhecimento")
@Data
@NoArgsConstructor
public class BaseConhecimento {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String intencao;

    @Column(name = "palavras_chave", columnDefinition = "TEXT", nullable = false)
    private String palavrasChave;

    @Column(name = "pergunta_exemplo", columnDefinition = "TEXT")
    private String perguntaExemplo;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String resposta;

    @Column(length = 500)
    private String fonte;

    private Integer prioridade = 5;

    private Boolean ativo = true;

    @Column(name = "criado_em")
    private LocalDateTime criadoEm;

    @PrePersist
    public void prePersist() {
        this.criadoEm = LocalDateTime.now();
    }
}
