package com.portalhiv.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "mitos_fatos")
@Data
@NoArgsConstructor
public class MitoFato {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String mito;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String fato;

    @Column(length = 500)
    private String referencia;

    @Column(name = "ordem_exibicao")
    private Integer ordemExibicao = 0;

    private Boolean ativo = true;

    @Column(name = "criado_em")
    private LocalDateTime criadoEm;

    @PrePersist
    public void prePersist() {
        this.criadoEm = LocalDateTime.now();
    }
}
