package com.portalhiv.repository;

import com.portalhiv.entity.MitoFato;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MitoFatoRepository extends JpaRepository<MitoFato, Long> {
    List<MitoFato> findByAtivoTrueOrderByOrdemExibicaoAsc();
}
