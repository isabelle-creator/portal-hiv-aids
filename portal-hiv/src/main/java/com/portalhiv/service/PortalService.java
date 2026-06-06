package com.portalhiv.service;

import com.portalhiv.entity.Conteudo;
import com.portalhiv.entity.MitoFato;
import com.portalhiv.repository.ConteudoRepository;
import com.portalhiv.repository.MitoFatoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PortalService {

    private final ConteudoRepository conteudoRepository;
    private final MitoFatoRepository mitoFatoRepository;

    public List<Conteudo> buscarConteudosPorCategoria(Long categoriaId) {
        return conteudoRepository.findByCategoriaIdAndAtivoTrueOrderByOrdemExibicaoAsc(categoriaId);
    }

    public List<Conteudo> buscarTodosConteudos() {
        return conteudoRepository.findByAtivoTrueOrderByCategoriaIdAscOrdemExibicaoAsc();
    }

    public List<MitoFato> buscarMitosFatos() {
        return mitoFatoRepository.findByAtivoTrueOrderByOrdemExibicaoAsc();
    }

    public List<Conteudo> buscarConteudosPorTipo(Conteudo.TipoConteudo tipo) {
        return conteudoRepository.findByAtivoTrueOrderByCategoriaIdAscOrdemExibicaoAsc()
                .stream()
                .filter(c -> tipo.equals(c.getTipo()))
                .collect(Collectors.toList());
    }

    public List<Conteudo> buscarConteudosPorSlugCategoria(String slug) {
        // Categorias fixas por slug
        long categoriaId = switch (slug) {
            case "o-que-e" -> 1L;
            case "transmissao-prevencao" -> 2L;
            case "pep" -> 3L;
            case "prep" -> 4L;
            case "testagem" -> 5L;
            case "tratamento" -> 6L;
            case "acolhimento" -> 7L;
            default -> 0L;
        };
        if (categoriaId == 0) return List.of();
        return buscarConteudosPorCategoria(categoriaId);
    }
}
