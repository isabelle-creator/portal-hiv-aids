package com.portalhiv.repository;

import com.portalhiv.entity.Conteudo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ConteudoRepository extends JpaRepository<Conteudo, Long> {
    List<Conteudo> findByCategoriaIdAndAtivoTrueOrderByOrdemExibicaoAsc(Long categoriaId);
    List<Conteudo> findByAtivoTrueOrderByCategoriaIdAscOrdemExibicaoAsc();
}
