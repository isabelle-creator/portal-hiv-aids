package com.portalhiv.repository;

import com.portalhiv.entity.HistoricoChat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HistoricoChatRepository extends JpaRepository<HistoricoChat, Long> {
    List<HistoricoChat> findBySessaoIdOrderByCriadoEmAsc(String sessaoId);
    long countBySessaoId(String sessaoId);
}
