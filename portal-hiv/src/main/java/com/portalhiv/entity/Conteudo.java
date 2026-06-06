package com.portalhiv.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "conteudos")
@Data
@NoArgsConstructor
public class Conteudo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "categoria_id", nullable = false)
    private Categoria categoria;

    @Column(nullable = false, length = 255)
    private String titulo;

    @Column(length = 255)
    private String subtitulo;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String corpo;

    @Column(columnDefinition = "TEXT")
    private String referencias;

    @Column(name = "fonte_principal", length = 500)
    private String fontePrincipal;

    @Column(name = "ano_referencia")
    private Integer anoReferencia;

    @Enumerated(EnumType.STRING)
    private TipoConteudo tipo;

    @Column(name = "ordem_exibicao")
    private Integer ordemExibicao = 0;

    private Boolean ativo = true;

    @Column(name = "criado_em")
    private LocalDateTime criadoEm;

    @PrePersist
    public void prePersist() {
        this.criadoEm = LocalDateTime.now();
    }

    public enum TipoConteudo {
        artigo, mito_fato, faq, procedimento
    }
}
