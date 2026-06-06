package com.portalhiv.repository;

import com.portalhiv.entity.BaseConhecimento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BaseConhecimentoRepository extends JpaRepository<BaseConhecimento, Long> {

    List<BaseConhecimento> findByAtivoTrueOrderByPrioridadeDesc();

    @Query("SELECT b FROM BaseConhecimento b WHERE b.ativo = true " +
           "AND (LOWER(b.palavrasChave) LIKE LOWER(CONCAT('%', :termo, '%')) " +
           "OR LOWER(b.perguntaExemplo) LIKE LOWER(CONCAT('%', :termo, '%'))) " +
           "ORDER BY b.prioridade DESC")
    List<BaseConhecimento> buscarPorTermo(@Param("termo") String termo);
}
