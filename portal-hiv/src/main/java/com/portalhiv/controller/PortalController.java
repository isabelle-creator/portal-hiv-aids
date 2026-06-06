package com.portalhiv.controller;

import com.portalhiv.entity.Conteudo;
import com.portalhiv.entity.MitoFato;
import com.portalhiv.service.AssistenteVirtualService;
import com.portalhiv.service.PortalService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@Controller
@RequiredArgsConstructor
@Slf4j
public class PortalController {

    private final PortalService portalService;
    private final AssistenteVirtualService assistenteVirtualService;

    /**
     * Página principal do portal
     */
    @GetMapping("/")
    public String index(Model model) {
        List<MitoFato> mitosFatos = portalService.buscarMitosFatos();
        List<Conteudo> conteudosPep = portalService.buscarConteudosPorSlugCategoria("pep");
        List<Conteudo> conteudosPrep = portalService.buscarConteudosPorSlugCategoria("prep");
        List<Conteudo> conteudosOQueE = portalService.buscarConteudosPorSlugCategoria("o-que-e");
        List<Conteudo> conteudosTransmissao = portalService.buscarConteudosPorSlugCategoria("transmissao-prevencao");
        List<Conteudo> conteudosTratamento = portalService.buscarConteudosPorSlugCategoria("tratamento");
        List<Conteudo> conteudosDireitos = portalService.buscarConteudosPorSlugCategoria("acolhimento");

        model.addAttribute("mitosFatos", mitosFatos);
        model.addAttribute("conteudosPep", conteudosPep);
        model.addAttribute("conteudosPrep", conteudosPrep);
        model.addAttribute("conteudosOQueE", conteudosOQueE);
        model.addAttribute("conteudosTransmissao", conteudosTransmissao);
        model.addAttribute("conteudosTratamento", conteudosTratamento);
        model.addAttribute("conteudosDireitos", conteudosDireitos);

        return "index";
    }
}
