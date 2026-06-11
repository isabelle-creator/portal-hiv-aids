
DROP DATABASE IF EXISTS portal_hiv;
CREATE DATABASE portal_hiv CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE portal_hiv;


CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT,
    icone VARCHAR(50),
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE conteudos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    categoria_id INT NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    subtitulo VARCHAR(255),
    corpo TEXT NOT NULL,
    referencias TEXT,
    fonte_principal VARCHAR(500),
    ano_referencia INT,
    tipo ENUM('artigo','mito_fato','faq','procedimento') DEFAULT 'artigo',
    ordem_exibicao INT DEFAULT 0,
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

CREATE TABLE mitos_fatos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mito TEXT NOT NULL,
    fato TEXT NOT NULL,
    referencia VARCHAR(500),
    ordem_exibicao INT DEFAULT 0,
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE base_conhecimento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    intencao VARCHAR(100) NOT NULL,
    palavras_chave TEXT NOT NULL,
    pergunta_exemplo TEXT,
    resposta TEXT NOT NULL,
    fonte VARCHAR(500),
    prioridade INT DEFAULT 5,
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE historico_chat (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sessao_id VARCHAR(64) NOT NULL,
    pergunta TEXT NOT NULL,
    resposta TEXT NOT NULL,
    intencao_detectada VARCHAR(100),
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_sessao (sessao_id),
    INDEX idx_criado (criado_em)
);


CREATE TABLE estatisticas_acesso (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    pagina VARCHAR(100),
    total_acessos INT DEFAULT 0,
    data_referencia DATE,
    UNIQUE KEY uk_pagina_data (pagina, data_referencia)
);


INSERT INTO categorias (nome, slug, descricao, icone) VALUES
('O que é HIV/AIDS', 'o-que-e', 'Informações básicas sobre o vírus e a doença', 'info-circle'),
('Transmissão e Prevenção', 'transmissao-prevencao', 'Como o HIV se transmite e como se prevenir', 'shield-check'),
('PEP - Profilaxia Pós-Exposição', 'pep', 'Medicamento de emergência após exposição ao HIV', 'clock'),
('PrEP - Profilaxia Pré-Exposição', 'prep', 'Medicamento preventivo para quem tem maior risco', 'capsule'),
('Testagem e Diagnóstico', 'testagem', 'Como e onde fazer o teste de HIV', 'vial'),
('Tratamento e Qualidade de Vida', 'tratamento', 'Tudo sobre o tratamento antirretroviral', 'heartbeat'),
('Acolhimento e Direitos', 'acolhimento', 'Suporte emocional e direitos das pessoas vivendo com HIV', 'hands-helping');


INSERT INTO conteudos (categoria_id, titulo, subtitulo, corpo, referencias, fonte_principal, ano_referencia, tipo, ordem_exibicao) VALUES

(1, 'HIV e AIDS: entendendo a diferença', 'São condições diferentes, mas relacionadas',
'O HIV (Vírus da Imunodeficiência Humana) é o vírus que, quando não tratado, pode progredir para AIDS. HIV e AIDS não são a mesma coisa.

Quem vive com HIV e faz o tratamento corretamente — o tratamento antirretroviral (TARV) — pode ter uma carga viral indetectável no sangue. Isso significa que o sistema imunológico se mantém protegido e a pessoa vive com saúde e qualidade de vida.

A AIDS (Síndrome da Imunodeficiência Adquirida) é o estágio avançado da infecção pelo HIV, quando o sistema imunológico fica muito comprometido e surgem doenças oportunistas. Esse estágio hoje é considerado evitável com diagnóstico precoce e tratamento adequado.

No Brasil, o Ministério da Saúde oferece o tratamento antirretroviral de forma gratuita e universal pelo SUS desde 1996, sendo referência mundial nessa política.',
'Ministério da Saúde. Protocolo Clínico e Diretrizes Terapêuticas para Manejo da Infecção pelo HIV em Adultos. Brasília: MS, 2018. | OMS. HIV/AIDS Key Facts. Geneva: WHO, 2023.',
'PCDT HIV - Ministério da Saúde, 2018', 2018, 'artigo', 1),

(1, 'Como o sistema imunológico é afetado', 'O papel das células CD4 na defesa do organismo',
'O HIV infecta principalmente os linfócitos T CD4+, células fundamentais para coordenar a resposta do sistema imunológico. O vírus usa essas células para se replicar e, ao longo do tempo, reduz a quantidade delas no sangue.

A contagem de células CD4 é um dos principais exames para monitorar a saúde de quem vive com HIV. Valores normais variam entre 500 e 1.500 células/mm³. Quando a contagem cai abaixo de 200 células/mm³ sem tratamento, o organismo fica vulnerável a infecções oportunistas — doenças que um sistema imune saudável conseguiria combater facilmente.

Com o tratamento antirretroviral, a replicação viral é suprimida, a contagem de CD4 se recupera e o risco de AIDS é praticamente eliminado.',
'Fauci AS, Lane HC. Human Immunodeficiency Virus Disease: AIDS and Related Disorders. In: Harrison\'s Principles of Internal Medicine. 20th ed. McGraw-Hill, 2018.',
'Harrison\'s Principles of Internal Medicine, 20ª ed.', 2018, 'artigo', 2),

(2, 'Como o HIV é transmitido', 'Vias confirmadas de transmissão do vírus',
'O HIV está presente em concentrações suficientes para transmissão em quatro fluidos corporais: sangue, leite materno, líquido seminal e fluido vaginal/retal.

As principais formas de transmissão são:
- Relação sexual sem preservativo (anal, vaginal ou oral com lesões)
- Compartilhamento de seringas e agulhas
- Transmissão vertical (da mãe para o bebê durante gravidez, parto ou amamentação)
- Transfusão de sangue contaminado (risco praticamente eliminado no Brasil com a triagem obrigatória)

O risco varia conforme a via: o sexo anal receptivo tem o maior risco estimado (1,4% por ato sem preservativo), seguido do anal insertivo (0,11%) e do vaginal receptivo (0,08%). O sexo oral tem risco extremamente baixo, com relatos raros na literatura científica.',
'Cohen MS, et al. Antiretroviral Therapy for the Prevention of HIV-1 Transmission. N Engl J Med. 2016;375(9):830-839. | PCDT HIV - Ministério da Saúde, 2018.',
'New England Journal of Medicine, 2016; PCDT HIV MS, 2018', 2018, 'artigo', 1),

(2, 'Como o HIV NÃO é transmitido', 'Desmistificando os medos mais comuns',
'O HIV não sobrevive fora do corpo humano por tempo prolongado e não se transmite pelo ar, água ou superfícies. Não há registro científico de transmissão por:

- Abraços, apertos de mão ou beijos no rosto
- Picadas de mosquito ou outros insetos
- Utensílios de cozinha, pratos ou talheres compartilhados
- Assentos de vaso sanitário
- Piscinas, saunas ou banheiras
- Tosse ou espirro
- Contato com suor ou lágrimas
- Convivência no trabalho ou em ambientes sociais

O HIV é um vírus frágil fora do organismo humano. Medo e desinformação sobre formas de transmissão ainda alimentam o estigma que afasta pessoas do diagnóstico e do tratamento.',
'Centers for Disease Control and Prevention (CDC). How is HIV Transmitted? Atlanta: CDC, 2023. | Ministério da Saúde. HIV/AIDS: Perguntas e Respostas. Brasília: MS, 2022.',
'CDC, 2023; Ministério da Saúde, 2022', 2023, 'artigo', 2),

(3, 'O que é a PEP e como funciona', 'Profilaxia de emergência após exposição ao HIV',
'A PEP (Profilaxia Pós-Exposição) é um tratamento de emergência com antirretrovirais indicado para pessoas que tiveram uma possível exposição ao HIV. Funciona interrompendo a replicação do vírus antes que ele estabeleça infecção permanente.

Para ser eficaz, a PEP deve ser iniciada em até 72 horas após a exposição — quanto mais cedo, maior a eficácia. O tratamento dura 28 dias e não deve ser interrompido antes do prazo.

A PEP é indicada nos seguintes casos:
- Relação sexual desprotegida com parceiro HIV positivo ou de status desconhecido, com risco
- Acidente com material perfurocortante potencialmente contaminado (profissionais de saúde)
- Violência sexual
- Compartilhamento de seringas com pessoa HIV positiva

Eficácia comprovada: quando iniciada em até 2 horas após a exposição e mantida por 28 dias, a PEP tem eficácia estimada superior a 80% na prevenção da infecção pelo HIV.',
'Ministério da Saúde. Protocolo Clínico e Diretrizes Terapêuticas para Profilaxia Antirretroviral Pós-Exposição de Risco à Infecção pelo HIV, IST e Hepatites Virais (PEP). Brasília: MS, 2021. | Cardo DM et al. A case-control study of HIV seroconversion in health care workers after percutaneous exposure. N Engl J Med. 1997;337(21):1485-90.',
'PCDT PEP - Ministério da Saúde, 2021', 2021, 'procedimento', 1),

(3, 'Onde conseguir a PEP gratuitamente', 'Acesso pelo SUS em todo o Brasil',
'A PEP é disponibilizada gratuitamente pelo SUS em unidades de saúde de referência para ISTs e HIV. O acesso é simples e não exige agendamento prévio em casos de emergência.

Onde procurar:
- UPAs (Unidades de Pronto Atendimento)
- Hospitais públicos com serviço de urgência
- CRT/SAEs (Centros de Referência e Tratamento/Serviços de Atendimento Especializado)
- COAS e CTA (Centros de Testagem e Aconselhamento)

Em casos de violência sexual, o atendimento também pode ser feito em serviços de referência para violência, que acionam automaticamente o protocolo de PEP.

O Disque Saúde (136) pode indicar a unidade de saúde mais próxima disponível 24 horas.',
'Ministério da Saúde. PEP - Profilaxia Pós-Exposição. Portal do Departamento de HIV/AIDS, Tuberculose, Hepatites Virais e Infecções Sexualmente Transmissíveis. Brasília: MS, 2022.',
'Portal DIAHV - Ministério da Saúde, 2022', 2022, 'procedimento', 2),

(4, 'O que é a PrEP e para quem é indicada', 'Prevenção antes da exposição ao HIV',
'A PrEP (Profilaxia Pré-Exposição) é o uso de antirretrovirais por pessoas HIV negativas com maior risco de contrair o HIV, como forma de prevenção contínua. No Brasil, o medicamento utilizado é o tenofovir/entricitabina (TDF/FTC), disponível gratuitamente no SUS.

Quando usada corretamente, a PrEP reduz em até 99% o risco de contrair HIV via relação sexual.

É indicada para pessoas com maior exposição ao HIV:
- Homens que fazem sexo com homens (HSH) com práticas de risco
- Mulheres transgênero
- Profissionais do sexo
- Casais sorodiscordantes (um parceiro HIV positivo e outro negativo)
- Pessoas que usam drogas injetáveis
- Pessoas com múltiplos parceiros e uso irregular de preservativo

A PrEP não substitui o preservativo: ela protege do HIV, mas não protege contra outras ISTs como gonorreia, sífilis e hepatite.',
'Ministério da Saúde. Protocolo Clínico e Diretrizes Terapêuticas para Profilaxia Pré-Exposição de Risco à Infecção pelo HIV (PrEP). Brasília: MS, 2022. | Grant RM et al. Preexposure Chemoprophylaxis for HIV Prevention in Men Who Have Sex with Men. N Engl J Med. 2010;363(27):2587-99.',
'PCDT PrEP - Ministério da Saúde, 2022; NEJM, 2010', 2022, 'procedimento', 1),

(5, 'Tipos de teste para HIV', 'Entendendo as opções disponíveis',
'Existem diferentes tipos de teste para detectar o HIV, cada um com características específicas de janela imunológica e método de coleta:

Teste rápido: Resultado em até 30 minutos. Detecta anticorpos anti-HIV. Disponível gratuitamente nos CTA, UBS e durante campanhas. A janela imunológica é de aproximadamente 30 dias (3ª geração) ou 18 dias (4ª geração, que detecta também antígeno p24).

ELISA: Exame de sangue laboratorial, mais sensível. Janela imunológica de 18 a 45 dias.

Teste molecular (PCR/carga viral): Detecta o próprio vírus, não os anticorpos. Útil nos primeiros dias após exposição e obrigatório como teste confirmatório no Brasil pelo fluxograma do Ministério da Saúde.

No SUS, o diagnóstico segue um fluxograma com dois testes consecutivos para confirmação. Qualquer resultado reagente em um único teste não é diagnóstico definitivo.',
'Ministério da Saúde. Portaria nº 29, de 17 de dezembro de 2013: Aprova o Manual Técnico para o Diagnóstico da Infecção pelo HIV. Brasília: MS, 2013. Atualizado 2018.',
'Manual Técnico para Diagnóstico do HIV - Ministério da Saúde, 2018', 2018, 'procedimento', 1),

(6, 'Tratamento antirretroviral: como funciona', 'A TARV e a carga viral indetectável',
'O tratamento antirretroviral (TARV) é a combinação de medicamentos que impedem o HIV de se replicar no organismo. No Brasil, o tratamento é gratuito, fornecido pelo SUS e recomendado para toda pessoa diagnosticada com HIV, independentemente da contagem de CD4.

Os medicamentos antirretrovirais atuam em diferentes etapas do ciclo de vida do HIV. A combinação de ao menos três antirretrovirais de duas classes diferentes é a estratégia padrão, chamada de terapia tríplice.

O objetivo do tratamento é atingir a carga viral indetectável (abaixo de 50 cópias/mL de sangue). Quando indetectável:
- O sistema imunológico se recupera e se mantém protegido
- A pessoa tem expectativa de vida equivalente à da população geral
- O risco de transmissão sexual do HIV é eliminado (princípio I=I: Indetectável = Intransmissível)

O conceito I=I foi confirmado pelos estudos PARTNER, HPTN 052 e Opposites Attract, que juntos acompanharam mais de 4.000 casais sorodiscordantes sem nenhum caso de transmissão quando a carga viral era indetectável.',
'Ministério da Saúde. PCDT para Manejo da Infecção pelo HIV em Adultos. Brasília: MS, 2018. | Rodger AJ et al. Risk of HIV transmission through condomless sex in serodifferent gay couples with the HIV-positive partner taking suppressive antiretroviral therapy (PARTNER): final results of a multicentre, prospective, observational study. Lancet. 2019;393(10189):2428-38.',
'PCDT HIV MS, 2018; Lancet, 2019 (Estudo PARTNER 2)', 2019, 'artigo', 1),

(7, 'Seus direitos como pessoa vivendo com HIV', 'Proteção legal e acesso garantido',
'Pessoas vivendo com HIV têm direitos garantidos por lei no Brasil. O desconhecimento desses direitos é uma das principais formas pelas quais o estigma se manifesta em prejuízo real.

Direito ao sigilo: A soropositividade é dado de saúde sensível e protegido. Divulgação sem consentimento pode configurar crime (Lei nº 9.029/1995 e LGPD).

Direito ao trabalho: É proibida a demissão por discriminação relacionada ao HIV. A lei 9.029/1995 proíbe qualquer prática discriminatória na relação de emprego por condição de saúde.

Direito ao tratamento: O acesso ao TARV pelo SUS é garantido pela Lei nº 9.313/1996 e suas atualizações.

Benefício de prestação continuada (BPC): Pessoas com AIDS que comprovem incapacidade para o trabalho e renda familiar per capita inferior a ¼ do salário mínimo têm direito ao BPC (Lei nº 8.742/1993).

Isenção de imposto de renda: Pessoas com AIDS têm direito à isenção do IRPF sobre proventos de aposentadoria, conforme Lei nº 7.713/1988.',
'Lei nº 9.313, de 13 de novembro de 1996. | Lei nº 9.029, de 13 de abril de 1995. | Lei nº 7.713, de 22 de dezembro de 1988. | Lei nº 8.742, de 7 de dezembro de 1993 (LOAS). | Brasil. Lei Geral de Proteção de Dados Pessoais (LGPD), Lei nº 13.709/2018.',
'Legislação Federal Brasileira', 2018, 'artigo', 1);


INSERT INTO mitos_fatos (mito, fato, referencia, ordem_exibicao) VALUES

('Quem tem HIV vai morrer cedo.',
'Com o tratamento antirretroviral disponível hoje, uma pessoa diagnosticada com HIV aos 20 anos e que inicia o tratamento tem expectativa de vida equivalente à de uma pessoa sem HIV. Estudos publicados na revista Lancet mostram que pessoas em TARV estável chegam à terceira idade com saúde.',
'May MT et al. Impact on life expectancy of HIV-1 positive individuals of CD4+ cell count and viral load response to antiretroviral therapy. AIDS. 2014;28(8):1193-202.',
1),

('Dá pra saber se alguém tem HIV só de olhar.',
'O HIV não tem sintomas visíveis por anos. Muitas pessoas soropositivas não apresentam nenhum sinal externo da infecção. A única forma de saber é fazendo o teste.',
'Ministério da Saúde. Manual Técnico para o Diagnóstico da Infecção pelo HIV. Brasília: MS, 2018.',
2),

('Mosquito pode transmitir HIV.',
'Não existe nenhum registro científico de transmissão do HIV por picada de inseto. O vírus não se reproduz dentro do mosquito e não fica concentrado em quantidade suficiente para transmissão na probóscide do inseto.',
'CDC. Transmission of HIV. Atlanta: CDC, 2023.',
3),

('Quem tem HIV não pode ter filhos.',
'Com o tratamento adequado durante a gravidez, o risco de transmissão do HIV da mãe para o bebê cai para menos de 2%, e pode ser ainda menor com carga viral indetectável. A transmissão vertical é prevenível quando há acompanhamento pré-natal.',
'Ministério da Saúde. Protocolo Clínico e Diretrizes Terapêuticas para Prevenção da Transmissão Vertical do HIV. Brasília: MS, 2019.',
4),

('Pessoa com HIV não pode ter relação sexual.',
'Pessoas com carga viral indetectável e em tratamento regular têm risco zero de transmitir o HIV para parceiros soronegativos via relação sexual. Esse princípio — I=I (Indetectável = Intransmissível) — foi confirmado por estudos com mais de 4.000 casais.',
'Rodger AJ et al. PARTNER Study. Lancet. 2019.',
5),

('Só homossexuais contraem HIV.',
'O HIV pode infectar qualquer pessoa sexualmente ativa, independentemente de orientação sexual, gênero, classe social ou raça. No Brasil, o perfil epidemiológico da epidemia inclui homens heterossexuais, mulheres cisgênero e jovens de todas as origens.',
'Ministério da Saúde. Boletim Epidemiológico HIV/AIDS. Brasília: MS, 2023.',
6);


INSERT INTO base_conhecimento (intencao, palavras_chave, pergunta_exemplo, resposta, fonte, prioridade) VALUES

('pep_urgencia', 'pep,profilaxia,emergência,emergencia,exposição,exposicao,72 horas,tive relação,acidente,agulha,violência sexual',
'Tive uma relação sem camisinha ontem à noite. Preciso de PEP?',
'Se você teve uma possível exposição ao HIV nas últimas 72 horas, pode ser indicado tomar a PEP — Profilaxia Pós-Exposição. Ela é um tratamento de emergência com antirretrovirais que, quando iniciado em até 72 horas após a exposição, pode prevenir a infecção.

Não perca tempo: quanto antes você iniciar, mais eficaz ela é. Vá agora a uma UPA, pronto-socorro ou CTA (Centro de Testagem e Aconselhamento). O atendimento é gratuito pelo SUS, sem precisar de agendamento.

Se você não souber onde ir, ligue para o Disque Saúde: 136. Eles funcionam 24 horas e indicam a unidade mais próxima de você.

Lembre-se: depois de 72 horas a PEP não é mais indicada, então não adie.',
'PCDT PEP - Ministério da Saúde, 2021', 10),

('prep_informacao', 'prep,pre-exposição,preexposição,profilaxia preventiva,prevenção contínua,prevenção continua,quero me prevenir',
'O que é PrEP e como consigo pelo SUS?',
'A PrEP (Profilaxia Pré-Exposição) é um comprimido tomado diariamente por pessoas HIV negativas para se proteger do HIV. Quando usada corretamente, ela reduz em até 99% o risco de contrair o vírus.

No Brasil, a PrEP é disponibilizada gratuitamente pelo SUS nos SAEs (Serviços de Atendimento Especializado) e em algumas UBS de referência. Para ter acesso, você faz uma consulta médica, realiza alguns exames (incluindo o teste de HIV, que precisa ser negativo) e, se indicado, começa o tratamento.

A PrEP é indicada para pessoas com maior exposição ao HIV: HSH (homens que fazem sexo com homens), mulheres trans, profissionais do sexo, pessoas com múltiplos parceiros e uso irregular de preservativo, e casais sorodiscordantes.

Para encontrar um serviço próximo, acesse prepxds.com.br ou ligue para o 136.',
'PCDT PrEP - Ministério da Saúde, 2022', 9),

('teste_hiv', 'teste,testar,exame,resultado,janela imunológica,janela imunologica,onde fazer,gratuito,saber se tenho',
'Onde posso fazer o teste de HIV gratuitamente?',
'Você pode fazer o teste de HIV de forma gratuita, rápida e confidencial em vários pontos pelo SUS:

• CTA/CTA-SAE (Centros de Testagem e Aconselhamento): são os locais especializados, com atendimento sigiloso e resultado rápido.
• UBS (Unidade Básica de Saúde): muitas unidades oferecem o teste rápido.
• Farmácias do Programa Farmácia Popular: oferecem autoteste de HIV.
• Durante campanhas de saúde, como no Dia Mundial de Luta contra a AIDS (1° de dezembro).

O teste rápido dá resultado em até 30 minutos. Se você teve uma exposição recente, saiba que existe uma janela imunológica — o período em que o teste ainda pode dar falso negativo. Para sexo sem preservativo, essa janela é de cerca de 30 dias com os testes mais modernos.

Ligue para o 136 ou acesse o site do Ministério da Saúde para encontrar o ponto mais próximo de você.',
'Ministério da Saúde. Pontos de Testagem. Portal DIAHV, 2023', 8),

('transmissao_duvida', 'transmissão,transmissao,pegar,contaminar,contágio,contagio,como pega,como se pega,relação oral,beijo,compartilhar,copo',
'Dá pra pegar HIV pelo beijo ou pelo copo?',
'Não, não é possível contrair HIV pelo beijo, por copo compartilhado, abraços, apertos de mão, picadas de mosquito ou qualquer contato social no dia a dia.

O HIV está presente em concentrações suficientes para transmissão em apenas quatro fluidos: sangue, líquido seminal, fluido vaginal/retal e leite materno.

As formas reais de transmissão são:
• Relação sexual sem preservativo (anal, vaginal ou oral com lesões)
• Compartilhamento de seringa/agulha
• Transfusão de sangue não testado (raro no Brasil com a triagem atual)
• Da mãe para o bebê durante gravidez, parto ou amamentação, sem tratamento

Muito do medo em torno do HIV vem de informação errada que circula há décadas. Conhecer as formas reais de transmissão é o primeiro passo para acabar com o preconceito.',
'CDC. HIV Transmission. 2023; Ministério da Saúde, 2022', 7),

('tratamento_tarv', 'tratamento,remédio,medicamento,antirretroviral,TARV,ART,cura,indetectável,indetectavel',
'Quem tem HIV precisa tomar remédio para sempre?',
'Atualmente, sim — não existe cura para o HIV ainda, mas o tratamento antirretroviral (TARV) controla completamente o vírus. Com o tratamento, o HIV fica em níveis indetectáveis no sangue, o sistema imunológico se recupera e a pessoa vive com plena saúde.

Uma pessoa com carga viral indetectável tem expectativa de vida igual à da população geral e, segundo o princípio I=I (Indetectável = Intransmissível), não transmite o HIV pelo sexo.

No Brasil, o tratamento é gratuito, distribuído pelo SUS, e hoje os esquemas modernos costumam ser um único comprimido por dia. Os efeitos colaterais dos antirretrovirais atuais são muito menores do que os das gerações anteriores.

A pesquisa por uma cura funcional e por vacinas contra o HIV está ativa em todo o mundo, com avanços sendo publicados regularmente.',
'PCDT HIV - Ministério da Saúde, 2018; Estudo PARTNER, Lancet, 2019', 8),

('apoio_emocional', 'medo,assustado,assustada,chorar,deprimido,deprimida,ansioso,ansiosa,vergonha,estigma,preconceito,sozinho,sozinha,não sei o que fazer',
'Estou com medo depois do diagnóstico. O que eu faço?',
'É completamente compreensível sentir medo, confusão ou choque após um diagnóstico. Isso não significa fraqueza — é uma reação humana diante de uma notícia que muda sua perspectiva.

O mais importante que você pode fazer agora é buscar atendimento médico o quanto antes. O SUS tem serviços especializados (SAEs) com equipe multiprofissional que inclui médicos, enfermeiros, psicólogos e assistentes sociais — exatamente para esse momento.

Algumas coisas que vale saber logo de início:
• HIV hoje é uma condição crônica manejável, não uma sentença.
• Com tratamento, você vai poder viver com saúde e qualidade de vida.
• Você não está sozinho/a — há uma rede de apoio disponível.

Se quiser conversar com alguém agora, o CVV (Centro de Valorização da Vida) atende pelo 188, 24 horas. Você também pode buscar grupos de apoio para pessoas vivendo com HIV — eles fazem uma diferença real.',
'Ministério da Saúde. Guia de Atenção Integral às Pessoas que Vivem com HIV/AIDS. Brasília: MS, 2020', 9),

('indetectavel_transmissao', 'indetectável,indetectavel,transmissão,transmissao,relação sem camisinha,I=I,parceiro,parceira,sorodiscordante',
'Meu parceiro tem HIV indetectável. Posso ter relação sem camisinha?',
'O conceito I=I (Indetectável = Intransmissível) é reconhecido pela OMS, pelo CDC e pelo Ministério da Saúde do Brasil. Ele significa que uma pessoa com carga viral indetectável e em tratamento estável não transmite o HIV pelo sexo.

Isso foi demonstrado por estudos de longa duração com mais de 4.000 casais sorodiscordantes — nenhum caso de transmissão foi registrado quando a carga viral estava indetectável.

Dito isso, essa é uma decisão que você e seu parceiro/parceira devem tomar juntos, com informação completa. Algumas considerações:
• A carga viral precisa estar indetectável de forma consistente, com exames regulares.
• O preservativo continua sendo a única proteção contra outras ISTs, como sífilis, gonorreia e HPV.
• A PrEP pode ser uma opção adicional para o parceiro soronegativo, se desejar.

Converse sobre isso com um profissional de saúde num SAE — eles podem orientar o casal de forma individualizada.',
'Rodger AJ et al. PARTNER Study. Lancet. 2019; OMS, I=I Statement, 2017', 9),

('direitos_trabalho', 'trabalho,emprego,demissão,demissao,discriminação,discriminacao,direito,lei,sigilo,revelar',
'Meu chefe pode me demitir por causa do HIV?',
'Não. A demissão motivada por condição de saúde — incluindo soropositividade para o HIV — é ilegal no Brasil e configura discriminação. A Lei nº 9.029/1995 proíbe expressamente práticas discriminatórias nas relações de trabalho por condição de saúde.

Além disso, você não tem obrigação de revelar seu status sorológico para o empregador. Essa informação é protegida como dado sensível pela LGPD (Lei nº 13.709/2018) e pelo sigilo médico.

Se você foi discriminado ou demitido por causa do HIV, pode:
• Registrar boletim de ocorrência na delegacia
• Procurar o sindicato da sua categoria
• Entrar com ação trabalhista na Justiça do Trabalho
• Procurar a Defensoria Pública gratuitamente

O Ministério Público do Trabalho também recebe denúncias de discriminação por condição de saúde.',
'Lei nº 9.029/1995; Lei nº 13.709/2018 (LGPD); CLT Art. 482', 7);


SELECT 'Categorias inseridas:' AS info, COUNT(*) AS total FROM categorias
UNION ALL
SELECT 'Conteúdos inseridos:', COUNT(*) FROM conteudos
UNION ALL
SELECT 'Mitos e fatos inseridos:', COUNT(*) FROM mitos_fatos
UNION ALL
SELECT 'Base de conhecimento (chatbot):', COUNT(*) FROM base_conhecimento;
