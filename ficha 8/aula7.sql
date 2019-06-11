-- 1.1

drop table colocados cascade constraints;
drop table matriculas cascade constraints;
drop table cursos cascade constraints;
drop table cadeiras cascade constraints;
drop table planos cascade constraints;
drop table inscricoes cascade constraints;
--
drop table inativas cascade constraints;

create table colocados(
  idCandidato number(11,0),
  nome varchar2(30),
  curso varchar2(4),
  ano number(4,0)
);

create table matriculas(
  numero number(6,0),
  idCandidato number(11,0),
  curso varchar2(4),
  dataMatr date
);

create table cursos(
  curso varchar2(4),
  nomeCurso varchar2(255)
);

create table cadeiras(
  cadeira number(5,0),
  nomeCad varchar2(200),
  ects number(2,0)
);

create table planos(
  cadeira number(5,0),
  curso varchar2(4),
  semestre number(2,0)
);

create table inscricoes(
  numero number(6,0),
  curso varchar2(4),
  cadeira number(5,0),
  anoLetivo number(4,0),
  dataInscr date
);

-- 1.2

-- Chaves primárias
alter table colocados add constraint pk_col primary key(idCandidato);
alter table matriculas add constraint pk_mat primary key(numero);
alter table cursos add constraint pk_cur primary key(curso);
alter table cadeiras add constraint pk_cad primary key(cadeira);
alter table planos add constraint pk_pla primary key(cadeira,curso);
alter table inscricoes add constraint pk_ins primary key(numero,cadeira,anoLetivo);

-- Chaves candidatas e estrangeiras
alter table colocados add constraint fk_colcurso foreign key (curso) references cursos(curso);

alter table matriculas add constraint un_mat unique(idCandidato);
-- Antes de referir a fk em matriculas é preciso indicar o unique em colocados
alter table colocados add constraint un_col unique(idCandidato,curso);
alter table matriculas add constraint fk_matrcolcurso foreign key (idCandidato,curso) references colocados(idCandidato,curso);

alter table planos add constraint fk_pcur foreign key (curso) references cursos(curso);
alter table planos add constraint fk_pcad foreign key (cadeira) references cadeiras(cadeira);

alter table matriculas add constraint un_matnumcur unique(numero,curso);
alter table inscricoes add constraint fk_inscurso foreign key (numero,curso) references matriculas(numero,curso);
alter table inscricoes add constraint fk_insplano foreign key (curso,cadeira) references planos(curso,cadeira);


-- Outras restricoes
alter table cadeiras add constraint numCred check(ects >= 3 and ects <=60);

-- 1.3

-- Criação prévia de sinónimos
create or replace synonym candidatos for candidaturas.candidatos;
create or replace synonym colocacoes for candidaturas.colocacoes;


-- Inserir os dados a partir de candidaturas
insert into cursos
  select curso, nomeCurso
  from candidaturas.cursos natural join candidaturas.ofertas
  where estab = '0903';

insert into colocados
  select idCandidato, nome, curso, 2016
  from candidatos inner join colocacoes using (idCandidato)
  where estab = '0903';
  
-- 1.4

-- Cadeiras
delete from planos;
delete from cadeiras;

insert into cadeiras values (7155, 'Análise e Métodos Socio-Ambientais', 3);
insert into cadeiras values (7156, 'Climatologia', 3);
insert into cadeiras values (7170, 'Poluição Acústica', 3);
insert into cadeiras values (10345, 'Ambiente e Desenvolvimento Sustentável', 3);
insert into cadeiras values (10346, 'Desenho Técnico', 3);
insert into cadeiras values (10351, 'Geologia', 3);
insert into cadeiras values (10352, 'Competências Transversais para Ciências e Tecnologia', 3);
insert into cadeiras values (10356, 'Ecologia Geral', 3);
insert into cadeiras values (10357, 'Processos em Ambiente e Energia', 3);
insert into cadeiras values (10358, 'Ciência, Tecnologia e Sociedade', 3);
insert into cadeiras values (10359, 'Microbiologia C', 3);
insert into cadeiras values (10364, 'Ecologia Terrestre', 3);
insert into cadeiras values (10372, 'Urbanismo, Transportes e Ambiente', 3);
insert into cadeiras values (10380, 'Empreendedorismo', 3);
insert into cadeiras values (10389, 'Seminário de Política e Inovação em Ambiente', 3);
insert into cadeiras values (10397, 'Hidráulica Urbana', 3);
insert into cadeiras values (10398, 'Sistemas Avançados de Tratamento de Águas', 3);
insert into cadeiras values (10400, 'Laboratório de Operações e Processos', 3);
insert into cadeiras values (10405, 'Equipamentos Eletromecânicos e Automação', 3);
insert into cadeiras values (10406, 'Introdução à Ciência e Engenharia de Materiais', 3);
insert into cadeiras values (10413, 'Desenho Técnico Assistido por Computador', 3);
insert into cadeiras values (10415, 'Cerâmicos Técnicos', 3);
insert into cadeiras values (10416, 'Introdução às Micro e Nanotecnologias', 3);
insert into cadeiras values (10422, 'Seminários em Micro e Nanotecnologias', 3);
insert into cadeiras values (10423, 'Gestão de Empresas', 3);
insert into cadeiras values (10425, 'Iniciação à Dissertação', 3);
insert into cadeiras values (10426, 'Desenho Técnico', 3);
insert into cadeiras values (10427, 'Geologia para Engenharia Civil', 3);
insert into cadeiras values (10428, 'Introdução à Engenharia Civil', 3);
insert into cadeiras values (10430, 'Desenho Assistido por Computador', 3);
insert into cadeiras values (10431, 'Topografia e Sistemas de Informação Geográfica', 3);
insert into cadeiras values (10434, 'Arquitetura', 3);
insert into cadeiras values (10437, 'Métodos Computacionais em Engenharia', 3);
insert into cadeiras values (10441, 'Segurança Estrutural', 3);
insert into cadeiras values (10446, 'Edificações', 3);
insert into cadeiras values (10450, 'Planeamento da Construção', 3);
insert into cadeiras values (10459, 'Temas de Estruturas', 3);
insert into cadeiras values (10464, 'Modelação em Geotecnia', 3);
insert into cadeiras values (10473, 'Desenho Assistido por Computador', 3);
insert into cadeiras values (10478, 'Cálculo Numérico', 3);
insert into cadeiras values (10481, 'Instrumentação e Medidas Elétricas', 3);
insert into cadeiras values (10496, 'Introdução às Tecnologias e Processos Mecânicos', 3);
insert into cadeiras values (10511, 'Introdução à Dissertação', 3);
insert into cadeiras values (10518, 'Desenho Técnico', 3);
insert into cadeiras values (10520, 'Biologia Celular B', 3);
insert into cadeiras values (10521, 'Biologia Molecular C', 3);
insert into cadeiras values (10528, 'Tópicos de Engenharia Biomédica', 3);
insert into cadeiras values (10530, 'Criogenia', 3);
insert into cadeiras values (10531, 'Lasers', 3);
insert into cadeiras values (10538, 'Introdução à Física Experimental', 3);
insert into cadeiras values (10546, 'Ensaios Destrutivos e não Destrutivos', 3);
insert into cadeiras values (10574, 'Introdução à Engenharia Industrial', 3);
insert into cadeiras values (10579, 'Economia', 3);
insert into cadeiras values (10581, 'Eletrónica Geral', 3);
insert into cadeiras values (10588, 'Ergonomia', 3);
insert into cadeiras values (10610, 'Segurança e Higiene Ocupacionais', 3);
insert into cadeiras values (10614, 'Metodologias de Investigação', 3);
insert into cadeiras values (10649, 'Técnicas de Laboratório em Biologia I', 3);
insert into cadeiras values (10653, 'Bio-Segurança e Bioética', 3);
insert into cadeiras values (10662, 'Seminário', 3);
insert into cadeiras values (10665, 'Petrologia  Ígnea e Metamórfica', 3);
insert into cadeiras values (10669, 'Geoquímica', 3);
insert into cadeiras values (10671, 'Geologia de Portugal', 3);
insert into cadeiras values (10672, 'Prospeção Mecânica', 3);
insert into cadeiras values (10677, 'Computação', 3);
insert into cadeiras values (10705, 'Química Computacional', 3);
insert into cadeiras values (10716, 'Quimio-informática', 3);
insert into cadeiras values (10748, 'Processos, Desenvolvimento e Monitorização', 3);
insert into cadeiras values (10824, 'Técnicas de Laboratório', 3);
insert into cadeiras values (10866, 'Química Inorgânica II', 3);
insert into cadeiras values (10874, 'Programa de Introdução à Investigação Científica em Bioquímica', 3);
insert into cadeiras values (10925, 'Materiais, Processos e Gestão da Construção', 3);
insert into cadeiras values (10942, 'Introdução à Física', 3);
insert into cadeiras values (11005, 'Desenho', 3);
insert into cadeiras values (11006, 'Fotografia Documental', 3);
insert into cadeiras values (11024, 'Cartografia Geológica', 3);
insert into cadeiras values (11025, 'Rochas Industriais e Ornamentais', 3);
insert into cadeiras values (11035, 'Programa de Introdução à Investigação Científica em Química Aplicada', 3);
insert into cadeiras values (11191, 'Aspetos Socio-Profissionais da Informática', 3);
insert into cadeiras values (11506, 'Nanomateriais e Nanotecnologias', 3);
insert into cadeiras values (11507, 'Projeto de Dissertação', 3);
insert into cadeiras values (11508, 'Seleção de Materiais e Sustentabilidade', 3);
insert into cadeiras values (11512, 'Eletromagnetismo Avançado', 3);
insert into cadeiras values (11513, 'Projeto de Iniciação', 3);
insert into cadeiras values (11514, 'Ótica', 3);
insert into cadeiras values (11517, 'Nanofísica', 3);
insert into cadeiras values (11518, 'Técnicas de Espetroscopia', 3);
insert into cadeiras values (11521, 'Física dos Novos Materiais', 3);
insert into cadeiras values (11523, 'Técnicas Experimentais de Física Molecular', 3);
insert into cadeiras values (11536, 'Tecnologia de Superfícies e Interfaces', 3);
insert into cadeiras values (11826, 'Biomecânica', 3);
insert into cadeiras values (11827, 'Hemodinâmica', 3);
insert into cadeiras values (11828, 'Desenho Técnico', 3);
insert into cadeiras values (1116, 'Biologia Molecular B', 6);
insert into cadeiras values (1473, 'Estruturas Metálicas', 6);
insert into cadeiras values (1491, 'Física de Polímeros', 6);
insert into cadeiras values (1525, 'Física Nuclear', 6);
insert into cadeiras values (1712, 'Inteligência Artificial', 6);
insert into cadeiras values (1837, 'Materiais de Construção I', 6);
insert into cadeiras values (1839, 'Materiais de Construção II', 6);
insert into cadeiras values (1849, 'Materiais Semicondutores', 6);
insert into cadeiras values (1897, 'Metalurgia Física e Metalografia', 6);
insert into cadeiras values (2077, 'Princípios de Mineralogia e Geologia', 6);
insert into cadeiras values (2184, 'Propagação e Radiação', 6);
insert into cadeiras values (2212, 'Química Física I', 6);
insert into cadeiras values (2227, 'Química Inorgânica (CR)', 6);
insert into cadeiras values (2309, 'Simulação', 6);
insert into cadeiras values (2363, 'Sistemas Robóticos e CIM', 6);
insert into cadeiras values (2424, 'Tecnologia de Controlo', 6);
insert into cadeiras values (2468, 'Teoria da Computação', 6);
insert into cadeiras values (2478, 'Teoria de Sistemas', 6);
insert into cadeiras values (2567, 'Microprocessadores', 6);
insert into cadeiras values (2626, 'Produção Integrada por Computador', 6);
insert into cadeiras values (2641, 'Gestão da Produção', 6);
insert into cadeiras values (2672, 'Materiais Metálicos', 6);
insert into cadeiras values (2677, 'Diagnóstico e Conservação de Metais', 6);
insert into cadeiras values (2680, 'Diagnóstico e Conservação de Documentos Gráficos', 6);
insert into cadeiras values (2685, 'História da Arte da Antiguidade', 6);
insert into cadeiras values (2690, 'História da Arte Medieval', 6);
insert into cadeiras values (2691, 'História da Arte da Idade Moderna', 6);
insert into cadeiras values (2693, 'História da Arte Contemporânea', 6);
insert into cadeiras values (2696, 'Princípios de Bioquímica', 6);
insert into cadeiras values (2761, 'Hidrogeologia', 6);
insert into cadeiras values (2784, 'Obras Geotécnicas', 6);
insert into cadeiras values (2826, 'Alta Tensão', 6);
insert into cadeiras values (2846, 'Controlo e Decisão na Energia', 6);
insert into cadeiras values (3086, 'Fisiologia', 6);
insert into cadeiras values (3107, 'Introdução à Investigação Operacional', 6);
insert into cadeiras values (3466, 'Biologia Vegetal', 6);
insert into cadeiras values (3622, 'Introdução à Programação (B)', 6);
insert into cadeiras values (3629, 'Matemática Discreta', 6);
insert into cadeiras values (3645, 'Probabilidades e Estatística', 6);
insert into cadeiras values (3651, 'Mecânica Aplicada II', 6);
insert into cadeiras values (3654, 'Mecânica dos Sólidos I', 6);
insert into cadeiras values (3656, 'Mecânica dos Sólidos II', 6);
insert into cadeiras values (3658, 'Dinâmica dos Fluidos I', 6);
insert into cadeiras values (3660, 'Comportamento Mecânico dos Materiais', 6);
insert into cadeiras values (3666, 'Orgãos de Máquinas I', 6);
insert into cadeiras values (3668, 'Vibrações Mecânicas e Ruído', 6);
insert into cadeiras values (3669, 'Termodinâmica Aplicada', 6);
insert into cadeiras values (3683, 'Teoria da Ligação Química', 6);
insert into cadeiras values (3689, 'Termodinâmica Química', 6);
insert into cadeiras values (3690, 'Química Orgânica Geral', 6);
insert into cadeiras values (3705, 'Planeamento e Controlo da Qualidade', 6);
insert into cadeiras values (3708, 'Contabilidade e Análise de Custos', 6);
insert into cadeiras values (3710, 'Logística', 6);
insert into cadeiras values (3731, 'Sistemas de Informação para a Indústria', 6);
insert into cadeiras values (3733, 'Planeamento e Controlo da Produção', 6);
insert into cadeiras values (3736, 'Marketing e Inovação', 6);
insert into cadeiras values (3737, 'Introdução à Química da Vida', 6);
insert into cadeiras values (3742, 'Algoritmos e Estruturas de Dados', 6);
insert into cadeiras values (3745, 'Sistemas Lógicos II', 6);
insert into cadeiras values (3748, 'Teoria de Sinais', 6);
insert into cadeiras values (3752, 'Teoria de Controlo', 6);
insert into cadeiras values (3753, 'Sistemas de Tempo Real', 6);
insert into cadeiras values (3804, 'Microbiologia B', 6);
insert into cadeiras values (3813, 'Petrologia Sedimentar e Sedimentologia', 6);
insert into cadeiras values (3827, 'Mecânica dos Solos', 6);
insert into cadeiras values (3919, 'Física Estatística', 6);
insert into cadeiras values (4094, 'Engenharia Económica', 6);
insert into cadeiras values (5004, 'Análise Matemática III C', 6);
insert into cadeiras values (5005, 'Análise Matemática III B', 6);
insert into cadeiras values (5006, 'Análise Matemática IV B', 6);
insert into cadeiras values (5016, 'Fiabilidade e Gestão da Manutenção', 6);
insert into cadeiras values (5278, 'Modelação Computacional de Materiais', 6);
insert into cadeiras values (5284, 'Métodos de Imagem Médica', 6);
insert into cadeiras values (5289, 'Análise de Sinais', 6);
insert into cadeiras values (5294, 'Sistemas Lógicos', 6);
insert into cadeiras values (5324, 'Biossensores', 6);
insert into cadeiras values (5340, 'Biomateriais', 6);
insert into cadeiras values (5353, 'Microbiologia A', 6);
insert into cadeiras values (5474, 'Mecânica dos Solos C', 6);
insert into cadeiras values (7087, 'Química Orgânica I', 6);
insert into cadeiras values (7095, 'Química Orgânica II', 6);
insert into cadeiras values (7102, 'Métodos de Separação', 6);
insert into cadeiras values (7104, 'Genética Molecular B', 6);
insert into cadeiras values (7107, 'Análise Estrutural', 6);
insert into cadeiras values (7112, 'Engenharia Genética', 6);
insert into cadeiras values (7122, 'Biologia Celular C', 6);
insert into cadeiras values (7171, 'Hidrologia', 6);
insert into cadeiras values (7214, 'Gestão de Stocks', 6);
insert into cadeiras values (7226, 'Modelação de Dados em Engenharia', 6);
insert into cadeiras values (7228, 'Supervisão Inteligente', 6);
insert into cadeiras values (7268, 'Tecnologias Limpas e Química Verde', 6);
insert into cadeiras values (7289, 'Fenómenos de Transferência I', 6);
insert into cadeiras values (7300, 'Bioquímica Analítica', 6);
insert into cadeiras values (7303, 'Comunicação Sem Fios', 6);
insert into cadeiras values (7305, 'Sistemas de Controlo', 6);
insert into cadeiras values (7311, 'Redes Integradas de Telecomunicações I', 6);
insert into cadeiras values (7312, 'Sistemas de Decisão', 6);
insert into cadeiras values (7316, 'Empresas Virtuais', 6);
insert into cadeiras values (7317, 'Sistemas de Aquisição de Dados', 6);
insert into cadeiras values (7319, 'Processos de Separação I', 6);
insert into cadeiras values (7321, 'Bioquímica Geral B', 6);
insert into cadeiras values (7336, 'Lógica Computacional', 6);
insert into cadeiras values (7340, 'Química Física II', 6);
insert into cadeiras values (7342, 'Instrumentação e Controlo de Processos', 6);
insert into cadeiras values (7382, 'Matemática I', 6);
insert into cadeiras values (7396, 'Física I C', 6);
insert into cadeiras values (7399, 'Matemática II', 6);
insert into cadeiras values (7403, 'Engenharia Bioquímica II', 6);
insert into cadeiras values (7414, 'Conservação Preventiva', 6);
insert into cadeiras values (7417, 'Diagnóstico e Conservação de Pedra', 6);
insert into cadeiras values (7418, 'Diagnóstico e Conservação de Cerâmicos e Vidro', 6);
insert into cadeiras values (7419, 'Direito do Património', 6);
insert into cadeiras values (7420, 'Gestão do Património', 6);
insert into cadeiras values (7436, 'Reologia dos Materiais', 6);
insert into cadeiras values (7454, 'Materiais e Tecnologias de Mostradores Planos', 6);
insert into cadeiras values (7464, 'Materiais Cerâmicos e Vidros', 6);
insert into cadeiras values (7471, 'Propriedades Físicas dos Materiais', 6);
insert into cadeiras values (7474, 'Técnicas de Instrumentação', 6);
insert into cadeiras values (7477, 'Sistemas Sensoriais', 6);
insert into cadeiras values (7490, 'Tratamentos Térmicos e Mecânicos', 6);
insert into cadeiras values (7492, 'Materiais para a Conversão e Conservação de Energia', 6);
insert into cadeiras values (7494, 'Superfícies e Interfaces', 6);
insert into cadeiras values (7522, 'Tecnologias de Revestimentos e Películas Finas', 6);
insert into cadeiras values (7544, 'Análise Matemática III D', 6);
insert into cadeiras values (7580, 'Dinâmica de Estruturas', 6);
insert into cadeiras values (7588, 'Anatomia', 6);
insert into cadeiras values (7661, 'Sistemas de Informação  Médica', 6);
insert into cadeiras values (7663, 'Física', 6);
insert into cadeiras values (7702, 'Topografia e Geologia de Campo', 6);
insert into cadeiras values (7706, 'Estratigrafia e Paleontologia', 6);
insert into cadeiras values (7712, 'Geologia Estrutural', 6);
insert into cadeiras values (7715, 'Resistência de Materiais', 6);
insert into cadeiras values (7719, 'Geologia de Engenharia', 6);
insert into cadeiras values (7747, 'Bases de Dados', 6);
insert into cadeiras values (7777, 'Programação de Microprocessadores', 6);
insert into cadeiras values (7792, 'Vias de Comunicação', 6);
insert into cadeiras values (7813, 'Análise Complexa', 6);
insert into cadeiras values (7814, 'Equações Diferenciais', 6);
insert into cadeiras values (7816, 'Medida, Integração e Probabilidades', 6);
insert into cadeiras values (7933, 'Biologia Animal', 6);
insert into cadeiras values (7996, 'Análise Matemática II E', 6);
insert into cadeiras values (8143, 'Técnicas de Laboratório em Biologia II', 6);
insert into cadeiras values (8147, 'Linguagens e Ambientes de Programação', 6);
insert into cadeiras values (8148, 'Métodos de Desenvolvimento de Software', 6);
insert into cadeiras values (8149, 'Redes de Computadores', 6);
insert into cadeiras values (8150, 'Computação Gráfica e Interfaces', 6);
insert into cadeiras values (8153, 'Sistemas Distribuídos', 6);
insert into cadeiras values (8154, 'Análise e Desenho de Algoritmos', 6);
insert into cadeiras values (8163, 'Estudo do Trabalho', 6);
insert into cadeiras values (8437, 'Lajes e Cascas', 6);
insert into cadeiras values (8575, 'Introdução à Investigação Operacional', 6);
insert into cadeiras values (8708, 'Organização e Gestão de Obras', 6);
insert into cadeiras values (8789, 'Elementos de Análise e Álgebra II', 6);
insert into cadeiras values (8791, 'Metabolismo e Regulação B', 6);
insert into cadeiras values (8792, 'Estatística', 6);
insert into cadeiras values (9279, 'Química Física II A', 6);
insert into cadeiras values (9369, 'Estática', 6);
insert into cadeiras values (9376, 'Hidráulica Urbana', 6);
insert into cadeiras values (9377, 'Análise de Estruturas Geotécnicas', 6);
insert into cadeiras values (9379, 'Análise de Estruturas II', 6);
insert into cadeiras values (9387, 'Instalações Prediais', 6);
insert into cadeiras values (9398, 'Obras Subterrâneas', 6);
insert into cadeiras values (9405, 'Obras de Terra', 6);
insert into cadeiras values (9414, 'Probabilidades e Estatística E', 6);
insert into cadeiras values (9477, 'Técnicas de Caracterização de Materiais', 6);
insert into cadeiras values (10106, 'Introdução à Conservação e Restauro II', 6);
insert into cadeiras values (10130, 'Introdução à Conservação e Restauro I', 6);
insert into cadeiras values (10144, 'Compósitos - Materiais e Aplicações', 6);
insert into cadeiras values (10194, 'Mecânica dos Materiais I', 6);
insert into cadeiras values (10195, 'Mecânica dos Materiais II', 6);
insert into cadeiras values (10197, 'Tecnologias de Enformação de Materiais Metálicos', 6);
insert into cadeiras values (10199, 'Tecnologia de Cerâmicos e Vidros', 6);
insert into cadeiras values (10200, 'Processamento e Reciclagem de Polímeros', 6);
insert into cadeiras values (10201, 'Cristais Líquidos e Aplicações', 6);
insert into cadeiras values (10288, 'Produção e Transporte de Energia', 6);
insert into cadeiras values (10343, 'Química A', 6);
insert into cadeiras values (10344, 'Informática para Ciências e Engenharias', 6);
insert into cadeiras values (10347, 'Análise Matemática II C', 6);
insert into cadeiras values (10348, 'Bioquímica Geral C', 6);
insert into cadeiras values (10349, 'Física I', 6);
insert into cadeiras values (10350, 'Biologia', 6);
insert into cadeiras values (10353, 'Física II', 6);
insert into cadeiras values (10354, 'Probabilidades e Estatística D', 6);
insert into cadeiras values (10355, 'Topografia e Tecnologias de Informação Geográfica', 6);
insert into cadeiras values (10360, 'Técnicas Laboratoriais em Ambiente', 6);
insert into cadeiras values (10361, 'Investigação Operacional', 6);
insert into cadeiras values (10362, 'Hidráulica Geral', 6);
insert into cadeiras values (10363, 'Introdução às Probabilidades Estatística e Investigação Operacional', 6);
insert into cadeiras values (10365, 'Análise de Dados e Simulação em Ambiente', 6);
insert into cadeiras values (10366, 'Poluição da Água', 6);
insert into cadeiras values (10367, 'Planeamento e Ordenamento do Território', 6);
insert into cadeiras values (10368, 'Solo e Poluição do Solo', 6);
insert into cadeiras values (10369, 'Economia do Ambiente', 6);
insert into cadeiras values (10370, 'Poluição e Gestão do Ar', 6);
insert into cadeiras values (10371, 'Ecotoxicologia e Saúde Ambiental', 6);
insert into cadeiras values (10375, 'Gestão de Resíduos', 6);
insert into cadeiras values (10376, 'Abastecimento e Tratamento de Águas', 6);
insert into cadeiras values (10377, 'Drenagem e Tratamento de Águas Residuais', 6);
insert into cadeiras values (10378, 'Gestão do Ambiente', 6);
insert into cadeiras values (10379, 'Gestão da Água', 6);
insert into cadeiras values (10388, 'Projeto em Engenharia do Ambiente', 6);
insert into cadeiras values (10399, 'Sistemas de Tratamento de Águas Residuais  e Efluentes Industriais', 6);
insert into cadeiras values (10401, 'Sistemas de Tratamentos de Resíduos', 6);
insert into cadeiras values (10407, 'Química B', 6);
insert into cadeiras values (10408, 'Cristaloquímica', 6);
insert into cadeiras values (10410, 'Probabilidades e Estatística C', 6);
insert into cadeiras values (10411, 'Física III', 6);
insert into cadeiras values (10412, 'Química dos Polímeros', 6);
insert into cadeiras values (10417, 'Tecnologia de Nanomateriais', 6);
insert into cadeiras values (10418, 'Comportamento Mecânico de Nanomateriais', 6);
insert into cadeiras values (10419, 'Bioquímica Geral B', 6);
insert into cadeiras values (10420, 'Gestão da Qualidade', 6);
insert into cadeiras values (10424, 'Nanofabricação e Caracterização de Nanoestruturas', 6);
insert into cadeiras values (10429, 'Química C', 6);
insert into cadeiras values (10432, 'Dinâmica dos Corpos Rígidos', 6);
insert into cadeiras values (10433, 'Hidráulica', 6);
insert into cadeiras values (10435, 'Hidrologia e Obras de Drenagem', 6);
insert into cadeiras values (10436, 'Mecânica dos Meios Contínuos', 6);
insert into cadeiras values (10438, 'Planeamento Regional e Urbano', 6);
insert into cadeiras values (10439, 'Resistência de Materiais I', 6);
insert into cadeiras values (10440, 'Resistência de Materiais II', 6);
insert into cadeiras values (10442, 'Análise de Estruturas I', 6);
insert into cadeiras values (10443, 'Estruturas de Betão Armado I', 6);
insert into cadeiras values (10444, 'Física das Construções', 6);
insert into cadeiras values (10445, 'Tecnologias da Construção', 6);
insert into cadeiras values (10447, 'Estruturas de Betão Armado II', 6);
insert into cadeiras values (10448, 'Tecnologia de Revestimentos', 6);
insert into cadeiras values (10451, 'Reabilitação de Edifícios', 6);
insert into cadeiras values (10454, 'Gestão do Território e Prevenção de Riscos', 6);
insert into cadeiras values (10455, 'Método dos Elementos Finitos', 6);
insert into cadeiras values (10462, 'Engenharia Sísmica', 6);
insert into cadeiras values (10463, 'Fundações Especiais e Contenções', 6);
insert into cadeiras values (10465, 'Projeto Geotécnico', 6);
insert into cadeiras values (10466, 'Urbanismo, Infraestruturas e Equipamentos Urbanos', 6);
insert into cadeiras values (10467, 'Complementos de Vias de Comunicação', 6);
insert into cadeiras values (10468, 'Mobilidade e Transportes', 6);
insert into cadeiras values (10469, 'Pavimentos Rodoviários', 6);
insert into cadeiras values (10470, 'Projeto de Urbanismo', 6);
insert into cadeiras values (10475, 'Sistemas Lógicos I', 6);
insert into cadeiras values (10476, 'Análise Matemática II B', 6);
insert into cadeiras values (10477, 'Tecnologias de Corte', 6);
insert into cadeiras values (10479, 'Introdução às Telecomunicações', 6);
insert into cadeiras values (10480, 'Sistemas de Telecomunicações', 6);
insert into cadeiras values (10482, 'Desenho de Construção Mecânica', 6);
insert into cadeiras values (10485, 'Comunicação Digital', 6);
insert into cadeiras values (10486, 'Dinâmica dos Fluidos II', 6);
insert into cadeiras values (10487, 'Configuração e Gestão de Redes', 6);
insert into cadeiras values (10489, 'Acionamentos Eletromecânicos Especiais', 6);
insert into cadeiras values (10490, 'Economia Industrial', 6);
insert into cadeiras values (10493, 'Automação', 6);
insert into cadeiras values (10494, 'Tecnologias de Fundição e Soldadura', 6);
insert into cadeiras values (10495, 'Teoria e Metodologias de Projeto', 6);
insert into cadeiras values (10499, 'Instalações Elétricas', 6);
insert into cadeiras values (10501, 'Nanocircuitos e Sistemas Analógicos', 6);
insert into cadeiras values (10503, 'Tecnologias de Enformação Plástica', 6);
insert into cadeiras values (10504, 'Redes Móveis', 6);
insert into cadeiras values (10505, 'Transmissão do Calor', 6);
insert into cadeiras values (10515, 'Biofísica', 6);
insert into cadeiras values (10517, 'Sistemas Lógicos', 6);
insert into cadeiras values (10519, 'Eletromagnetismo', 6);
insert into cadeiras values (10522, 'Vibrações e Ondas', 6);
insert into cadeiras values (10523, 'Introdução aos Biomateriais', 6);
insert into cadeiras values (10524, 'Eletrónica', 6);
insert into cadeiras values (10525, 'Mecânica Quântica', 6);
insert into cadeiras values (10526, 'Eletrónica Aplicada', 6);
insert into cadeiras values (10527, 'Física Atómica e Molecular', 6);
insert into cadeiras values (10532, 'Fisiopatologia', 6);
insert into cadeiras values (10534, 'Eletrofisiologia', 6);
insert into cadeiras values (10535, 'Imagiologia', 6);
insert into cadeiras values (10536, 'Radiação e Radioterapia', 6);
insert into cadeiras values (10537, 'Preparação da Dissertação', 6);
insert into cadeiras values (10539, 'Mecânica', 6);
insert into cadeiras values (10540, 'Termodinâmica', 6);
insert into cadeiras values (10541, 'Cálculo Numérico', 6);
insert into cadeiras values (10544, 'Tecnologia de Vácuo e de Partículas Carregadas', 6);
insert into cadeiras values (10551, 'Técnicas de Caraterização de Materiais e de Superfícies', 6);
insert into cadeiras values (10571, 'Desenho Industrial', 6);
insert into cadeiras values (10572, 'Análise Matemática II D', 6);
insert into cadeiras values (10573, 'Tecnologias e Processos Químicos', 6);
insert into cadeiras values (10575, 'Ciência dos Materiais', 6);
insert into cadeiras values (10576, 'Mecânica Aplicada I', 6);
insert into cadeiras values (10577, 'Tecnologias e Processos Mecânicos', 6);
insert into cadeiras values (10578, 'Mecânica dos Sólidos', 6);
insert into cadeiras values (10580, 'Métodos Quantitativos', 6);
insert into cadeiras values (10587, 'Dinâmica de Fluidos', 6);
insert into cadeiras values (10633, 'Desenho Assistido por Computador', 6);
insert into cadeiras values (10647, 'Introdução à Biologia', 6);
insert into cadeiras values (10648, 'Matemática para Biologia', 6);
insert into cadeiras values (10650, 'Bioquímica Geral A', 6);
insert into cadeiras values (10651, 'Fundamentos de Ecologia', 6);
insert into cadeiras values (10652, 'Metabolismo e Regulação', 6);
insert into cadeiras values (10654, 'Biologia Molecular A', 6);
insert into cadeiras values (10655, 'Genética Molecular A', 6);
insert into cadeiras values (10660, 'Biotecnologia', 6);
insert into cadeiras values (10661, 'Fisiologia', 6);
insert into cadeiras values (10663, 'Geologia Geral', 6);
insert into cadeiras values (10664, 'Mineralogia', 6);
insert into cadeiras values (10666, 'Geostatística e Tratamento de Dados', 6);
insert into cadeiras values (10667, 'Sistemas de Representação Geológica e Geográfica', 6);
insert into cadeiras values (10668, 'Geofísica', 6);
insert into cadeiras values (10670, 'Deteção Remota', 6);
insert into cadeiras values (10675, 'Introdução à Engenharia Química e Bioquímica', 6);
insert into cadeiras values (10676, 'Química Inorgânica I', 6);
insert into cadeiras values (10678, 'Fenómenos de Transferência II', 6);
insert into cadeiras values (10679, 'Engenharia Bioquímica I', 6);
insert into cadeiras values (10681, 'Operações Sólido-Fluido', 6);
insert into cadeiras values (10683, 'Reatores Químicos II', 6);
insert into cadeiras values (10684, 'Simulação e Otimização de Processos', 6);
insert into cadeiras values (10690, 'Introdução à Química-Física', 6);
insert into cadeiras values (10692, 'Matemática Geral', 6);
insert into cadeiras values (10693, 'Introdução à Bioquímica', 6);
insert into cadeiras values (10694, 'Bioinorgânica', 6);
insert into cadeiras values (10695, 'Química Orgânica', 6);
insert into cadeiras values (10696, 'Química-Física', 6);
insert into cadeiras values (10697, 'Bioquímica', 6);
insert into cadeiras values (10698, 'Química Analítica', 6);
insert into cadeiras values (10699, 'Mecanismos de Reações Químicas e Biológicas', 6);
insert into cadeiras values (10701, 'Biossíntese de Produtos Naturais', 6);
insert into cadeiras values (10702, 'Fundamentos de Bioquímica Estrutural', 6);
insert into cadeiras values (10704, 'Síntese Orgânica', 6);
insert into cadeiras values (10707, 'Elementos de Análise e Álgebra I', 6);
insert into cadeiras values (10709, 'Métodos Instrumentais de Análise', 6);
insert into cadeiras values (10710, 'Mecanismos de Reações Químicas', 6);
insert into cadeiras values (10713, 'Química Geral', 6);
insert into cadeiras values (10714, 'Enzimologia', 6);
insert into cadeiras values (10715, 'Química dos Elementos', 6);
insert into cadeiras values (10721, 'Espectroscopia em Bioquímica', 6);
insert into cadeiras values (10822, 'Reatores Químicos I', 6);
insert into cadeiras values (10867, 'Química Orgânica (CR)', 6);
insert into cadeiras values (10917, 'Física do Estado Sólido', 6);
insert into cadeiras values (10918, 'Conceção de Sistemas Digitais', 6);
insert into cadeiras values (10919, 'Eletrónica de Potência em Acionamentos', 6);
insert into cadeiras values (10920, 'Eletrónica de Rádio Frequência', 6);
insert into cadeiras values (10922, 'Eletrónica III', 6);
insert into cadeiras values (10923, 'Eletrónica IV', 6);
insert into cadeiras values (10924, 'Teoria de Circuitos Elétricos', 6);
insert into cadeiras values (10932, 'Eletrónica I', 6);
insert into cadeiras values (10933, 'Eletrónica II', 6);
insert into cadeiras values (10946, 'Eletrotecnia Teórica', 6);
insert into cadeiras values (10960, 'Controlo por Computador', 6);
insert into cadeiras values (10967, 'Tração Elétrica', 6);
insert into cadeiras values (10970, 'Álgebra Linear I', 6);
insert into cadeiras values (10972, 'Análise Matemática II A', 6);
insert into cadeiras values (10974, 'Geometria', 6);
insert into cadeiras values (10975, 'Probabilidades e Estatística I', 6);
insert into cadeiras values (10976, 'Análise Matemática III A', 6);
insert into cadeiras values (10979, 'Análise Numérica I', 6);
insert into cadeiras values (10980, 'Análise Matemática IV A', 6);
insert into cadeiras values (10981, 'Álgebra II', 6);
insert into cadeiras values (10982, 'Análise Numérica II', 6);
insert into cadeiras values (10983, 'Otimização Linear', 6);
insert into cadeiras values (10984, 'Topologia e Introdução à Análise Funcional', 6);
insert into cadeiras values (10993, 'Controlo Inteligente', 6);
insert into cadeiras values (10994, 'Sistemas Distribuídos de Manufatura', 6);
insert into cadeiras values (10997, 'Degradação e Proteção de Superfícies', 6);
insert into cadeiras values (10998, 'Eletrotécnica e Máquinas Elétricas', 6);
insert into cadeiras values (11007, 'Polímeros em Conservação', 6);
insert into cadeiras values (11008, 'Aquisição e Tratamento de Imagem', 6);
insert into cadeiras values (11009, 'Diagnóstico e Conservação de Pintura', 6);
insert into cadeiras values (11010, 'Biologia Celular A', 6);
insert into cadeiras values (11011, 'Bioinformática', 6);
insert into cadeiras values (11026, 'Avaliação Ambiental Estratégica e de Projetos', 6);
insert into cadeiras values (11027, 'Ecologia Marinha e de Águas Interiores', 6);
insert into cadeiras values (11044, 'Microeletrónica I', 6);
insert into cadeiras values (11045, 'Microeletrónica II', 6);
insert into cadeiras values (11046, 'Microeletrónica III', 6);
insert into cadeiras values (11048, 'Optoeletrónica', 6);
insert into cadeiras values (11053, 'Reatores Químicos III', 6);
insert into cadeiras values (11054, 'Eletrotécnica Geral', 6);
insert into cadeiras values (11055, 'Projeto de Máquinas', 6);
insert into cadeiras values (11057, 'Técnicas de Caraterização e Ensaios não Destrutivos', 6);
insert into cadeiras values (11068, 'Conversão Eletromecânica de Energia', 6);
insert into cadeiras values (11073, 'Informática para Ciências e Engenharias A', 6);
insert into cadeiras values (11141, 'Programação Orientada pelos Objetos B', 6);
insert into cadeiras values (11146, 'Informática para Ciências e Engenharias B', 6);
insert into cadeiras values (11147, 'Informática para Ciências e Engenharias C', 6);
insert into cadeiras values (11148, 'Informática para Ciências e Engenharias D', 6);
insert into cadeiras values (11149, 'Informática para Ciências e Engenharias E', 6);
insert into cadeiras values (11194, 'Química Orgânica Geral A', 6);
insert into cadeiras values (11195, 'Química Orgânica Geral B', 6);
insert into cadeiras values (11273, 'Hidráulica Geral', 6);
insert into cadeiras values (11456, 'Robótica', 6);
insert into cadeiras values (11459, 'Eletrónica de Reduzida Tensão e Gestão de Potência', 6);
insert into cadeiras values (11504, 'Análise Matemática I', 6);
insert into cadeiras values (11505, 'Álgebra Linear e Geometria Analítica', 6);
insert into cadeiras values (11511, 'Processos e Materiais da Eletrónica', 6);
insert into cadeiras values (11515, 'Física Atómica', 6);
insert into cadeiras values (11519, 'Instrumentação Analógica', 6);
insert into cadeiras values (11520, 'Instrumentação Digital', 6);
insert into cadeiras values (11522, 'Aplicações Avançadas de Instrumentação', 6);
insert into cadeiras values (11537, 'Simulação e Modelação Computacional em Engenharia Física', 6);
insert into cadeiras values (11678, 'Métodos Matemáticos da Física', 6);
insert into cadeiras values (11821, 'Termodinâmica B', 6);
insert into cadeiras values (11823, 'Introdução à Biofísica A', 6);
insert into cadeiras values (11825, 'Aplicações Avançadas de Instrumentação Biomédica', 6);
insert into cadeiras values (11832, 'Introdução à Biofísica B', 6);
insert into cadeiras values (3082, 'Física I B', 9);
insert into cadeiras values (10637, 'Introdução à Programação', 9);
insert into cadeiras values (10640, 'Bases de Dados', 9);
insert into cadeiras values (10687, 'Projeto I', 9);
insert into cadeiras values (10873, 'Química-Física (CR)', 9);
insert into cadeiras values (10969, 'Análise Matemática I A', 9);
insert into cadeiras values (10971, 'Introdução à Lógica e Matemática Elementar', 9);
insert into cadeiras values (10973, 'Álgebra Linear II', 9);
insert into cadeiras values (10977, 'Álgebra I', 9);
insert into cadeiras values (10978, 'Probabilidades e Estatística II', 9);
insert into cadeiras values (11004, 'Princípios de Química e Técnicas de Laboratório e Segurança', 9);
insert into cadeiras values (11152, 'Arquitetura de Computadores', 9);
insert into cadeiras values (11153, 'Programação Orientada pelos Objetos', 9);
insert into cadeiras values (11154, 'Algoritmos e Estruturas de Dados', 9);
insert into cadeiras values (11155, 'Fundamentos de Sistemas de Operação', 9);
insert into cadeiras values (10700, 'Projeto de Bioquímica', 12);
insert into cadeiras values (10711, 'Projeto de Biotecnologia', 12);
insert into cadeiras values (10712, 'Projeto de Química Orgânica', 12);
insert into cadeiras values (10961, 'Preparação de Dissertação', 12);
insert into cadeiras values (11232, 'Preparação de Dissertação (MIEI)', 12);
insert into cadeiras values (11156, 'Atividade Prática de Desenvolvimento Curricular', 15);
insert into cadeiras values (10689, 'Projeto II', 18);
insert into cadeiras values (10962, 'Dissertação em Engenharia Eletrotécnica e de Computadores', 18);
insert into cadeiras values (8911, 'Dissertação em Engenharia Biomédica', 30);
insert into cadeiras values (8912, 'Dissertação em Engenharia Física', 30);
insert into cadeiras values (8914, 'Dissertação em Engenharia Química e Bioquímica', 30);
insert into cadeiras values (9039, 'Dissertação em Engenharia do Ambiente', 30);
insert into cadeiras values (9275, 'Dissertação em Eng. e Gestão Industrial', 30);
insert into cadeiras values (9276, 'Dissertação em Eng. Mecânica', 30);
insert into cadeiras values (9479, 'Dissertação em Engenharia de Micro e Nanotecnologias', 30);
insert into cadeiras values (10205, 'Dissertação em Engenharia de Materiais', 30);
insert into cadeiras values (10449, 'Dissertação em Engenharia Civil', 30);
insert into cadeiras values (11233, 'Elaboração de Dissertação (MIEI)', 30);
insert into cadeiras values (10794, 'Dissertação em Engenharia Informática', 42);

-- Planos

insert into planos values (1116, '9015', 4);
insert into planos values (1116, '9224', 4);
insert into planos values (1473, '9360', 9);
insert into planos values (1491, '9363', 4);
insert into planos values (1525, '9359', 6);
insert into planos values (1525, '9368', 6);
insert into planos values (1712, 'G005', 5);
insert into planos values (1837, '9360', 5);
insert into planos values (1839, '9360', 6);
insert into planos values (1849, '8334', 5);
insert into planos values (1849, '9363', 5);
insert into planos values (1897, '9363', 3);
insert into planos values (2077, '8036', 3);
insert into planos values (2184, '9367', 6);
insert into planos values (2212, '9224', 3);
insert into planos values (2227, '8036', 2);
insert into planos values (2309, '9509', 7);
insert into planos values (2363, '9367', 9);
insert into planos values (2424, '9367', 7);
insert into planos values (2468, 'G005', 4);
insert into planos values (2478, '9369', 5);
insert into planos values (2478, '9509', 5);
insert into planos values (2567, '9367', 3);
insert into planos values (2626, '9509', 9);
insert into planos values (2641, '9369', 8);
insert into planos values (2672, '8036', 5);
insert into planos values (2677, '8036', 6);
insert into planos values (2680, '8036', 6);
insert into planos values (2685, '8036', 1);
insert into planos values (2690, '8036', 2);
insert into planos values (2691, '8036', 3);
insert into planos values (2693, '8036', 4);
insert into planos values (2696, '8036', 4);
insert into planos values (2761, '9116', 6);
insert into planos values (2784, '9360', 7);
insert into planos values (2826, '9367', 9);
insert into planos values (2846, '9367', 9);
insert into planos values (3082, '9359', 2);
insert into planos values (3086, '9359', 6);
insert into planos values (3107, '9209', 4);
insert into planos values (3466, '9348', 4);
insert into planos values (3622, '9209', 1);
insert into planos values (3622, '9359', 1);
insert into planos values (3622, '9368', 1);
insert into planos values (3629, 'G005', 2);
insert into planos values (3645, '9369', 3);
insert into planos values (3645, '9509', 3);
insert into planos values (3651, '9369', 4);
insert into planos values (3654, '9369', 5);
insert into planos values (3656, '9369', 6);
insert into planos values (3658, '9369', 5);
insert into planos values (3660, '9369', 6);
insert into planos values (3666, '9369', 7);
insert into planos values (3668, '9369', 8);
insert into planos values (3669, '9369', 4);
insert into planos values (3683, '9224', 1);
insert into planos values (3683, '9370', 1);
insert into planos values (3689, '9370', 3);
insert into planos values (3690, '9370', 3);
insert into planos values (3705, '8334', 6);
insert into planos values (3705, '9363', 8);
insert into planos values (3705, '9370', 8);
insert into planos values (3705, '9509', 8);
insert into planos values (3708, '9509', 5);
insert into planos values (3710, '9509', 9);
insert into planos values (3731, '9509', 8);
insert into planos values (3733, '9509', 6);
insert into planos values (3736, '9509', 6);
insert into planos values (3737, '9348', 1);
insert into planos values (3742, '9367', 2);
insert into planos values (3745, '9367', 1);
insert into planos values (3748, '9367', 4);
insert into planos values (3752, '9367', 5);
insert into planos values (3753, '9367', 5);
insert into planos values (3804, '9015', 4);
insert into planos values (3804, '9224', 4);
insert into planos values (3804, '9348', 4);
insert into planos values (3813, '9116', 3);
insert into planos values (3827, '9116', 6);
insert into planos values (3919, '9368', 5);
insert into planos values (4094, '9370', 6);
insert into planos values (4094, '9509', 8);
insert into planos values (5004, '8334', 3);
insert into planos values (5004, '9116', 3);
insert into planos values (5004, '9360', 3);
insert into planos values (5004, '9363', 3);
insert into planos values (5004, '9370', 3);
insert into planos values (5004, '9508', 3);
insert into planos values (5005, '9359', 3);
insert into planos values (5005, '9367', 3);
insert into planos values (5005, '9368', 3);
insert into planos values (5006, '9359', 3);
insert into planos values (5006, '9367', 3);
insert into planos values (5006, '9368', 3);
insert into planos values (5016, '9509', 9);
insert into planos values (5278, '9363', 8);
insert into planos values (5284, '9359', 7);
insert into planos values (5289, '9359', 8);
insert into planos values (5294, 'G005', 1);
insert into planos values (5324, '8334', 7);
insert into planos values (5340, '8334', 7);
insert into planos values (5340, '9363', 7);
insert into planos values (5353, '9370', 4);
insert into planos values (5474, '9360', 5);
insert into planos values (7087, '9224', 2);
insert into planos values (7095, '9224', 3);
insert into planos values (7102, '9015', 4);
insert into planos values (7102, '9224', 4);
insert into planos values (7104, '9015', 5);
insert into planos values (7107, '9224', 5);
insert into planos values (7112, '9348', 6);
insert into planos values (7122, '9015', 1);
insert into planos values (7155, '9508', 5);
insert into planos values (7156, '9508', 3);
insert into planos values (7170, '9508', 5);
insert into planos values (7171, '9508', 5);
insert into planos values (7214, '9509', 6);
insert into planos values (7226, '9367', 6);
insert into planos values (7228, '9367', 7);
insert into planos values (7268, '9370', 7);
insert into planos values (7289, '9370', 3);
insert into planos values (7300, '9015', 5);
insert into planos values (7303, '9367', 7);
insert into planos values (7305, '9367', 8);
insert into planos values (7311, '9367', 7);
insert into planos values (7312, '9367', 7);
insert into planos values (7316, '9367', 8);
insert into planos values (7317, '9367', 8);
insert into planos values (7319, '9370', 6);
insert into planos values (7321, '9370', 3);
insert into planos values (7336, 'G005', 3);
insert into planos values (7340, '9224', 4);
insert into planos values (7342, '9370', 6);
insert into planos values (7382, '8036', 1);
insert into planos values (7396, '8036', 3);
insert into planos values (7399, '8036', 2);
insert into planos values (7403, '9370', 8);
insert into planos values (7414, '8036', 4);
insert into planos values (7417, '8036', 5);
insert into planos values (7418, '8036', 5);
insert into planos values (7419, '8036', 6);
insert into planos values (7420, '8036', 6);
insert into planos values (7436, '9363', 7);
insert into planos values (7454, '8334', 8);
insert into planos values (7464, '9363', 4);
insert into planos values (7471, '8334', 4);
insert into planos values (7471, '9363', 4);
insert into planos values (7474, '8334', 3);
insert into planos values (7474, '9363', 5);
insert into planos values (7477, '9367', 7);
insert into planos values (7490, '9363', 6);
insert into planos values (7492, '9363', 6);
insert into planos values (7494, '8334', 6);
insert into planos values (7522, '9363', 8);
insert into planos values (7544, '9369', 3);
insert into planos values (7544, '9509', 3);
insert into planos values (7580, '9360', 9);
insert into planos values (7588, '9359', 6);
insert into planos values (7661, '9359', 7);
insert into planos values (7661, '9367', 9);
insert into planos values (7663, 'G005', 3);
insert into planos values (7702, '9116', 2);
insert into planos values (7706, '9116', 2);
insert into planos values (7712, '9116', 4);
insert into planos values (7715, '9116', 5);
insert into planos values (7719, '9116', 6);
insert into planos values (7747, '9368', 2);
insert into planos values (7777, '9367', 1);
insert into planos values (7792, '9360', 5);
insert into planos values (7813, '9209', 5);
insert into planos values (7814, '9209', 5);
insert into planos values (7816, '9209', 5);
insert into planos values (7933, '9348', 3);
insert into planos values (7996, 'G005', 2);
insert into planos values (8143, '9348', 4);
insert into planos values (8147, 'G005', 4);
insert into planos values (8148, 'G005', 5);
insert into planos values (8149, 'G005', 5);
insert into planos values (8150, 'G005', 5);
insert into planos values (8153, 'G005', 6);
insert into planos values (8154, 'G005', 6);
insert into planos values (8163, '9509', 6);
insert into planos values (8437, '9360', 8);
insert into planos values (8575, 'G005', 7);
insert into planos values (8708, '9360', 8);
insert into planos values (8789, '9224', 2);
insert into planos values (8791, '9015', 3);
insert into planos values (8792, '9015', 3);
insert into planos values (8792, '9224', 3);
insert into planos values (8911, '9359', 9);
insert into planos values (8912, '9368', 9);
insert into planos values (8914, '9370', 9);
insert into planos values (9039, '9508', 9);
insert into planos values (9275, '9509', 9);
insert into planos values (9276, '9369', 9);
insert into planos values (9279, '9370', 6);
insert into planos values (9369, '9360', 2);
insert into planos values (9376, '9360', 6);
insert into planos values (9377, '9360', 6);
insert into planos values (9379, '9360', 8);
insert into planos values (9387, '9360', 9);
insert into planos values (9398, '9360', 9);
insert into planos values (9405, '9360', 9);
insert into planos values (9414, '9368', 2);
insert into planos values (9414, 'G005', 4);
insert into planos values (9477, '8334', 3);
insert into planos values (9479, '8334', 9);
insert into planos values (10106, '8036', 2);
insert into planos values (10130, '8036', 1);
insert into planos values (10144, '9363', 5);
insert into planos values (10194, '9363', 4);
insert into planos values (10195, '9363', 6);
insert into planos values (10197, '9363', 7);
insert into planos values (10199, '9363', 6);
insert into planos values (10200, '9363', 9);
insert into planos values (10201, '9363', 9);
insert into planos values (10205, '9363', 9);
insert into planos values (10288, '9367', 8);
insert into planos values (10343, '9508', 1);
insert into planos values (10344, '9116', 3);
insert into planos values (10345, '9508', 1);
insert into planos values (10346, '9508', 1);
insert into planos values (10347, '8334', 1);
insert into planos values (10347, '9116', 1);
insert into planos values (10347, '9360', 1);
insert into planos values (10347, '9363', 1);
insert into planos values (10347, '9370', 1);
insert into planos values (10347, '9508', 1);
insert into planos values (10348, '9508', 2);
insert into planos values (10349, '8334', 1);
insert into planos values (10349, '9116', 2);
insert into planos values (10349, '9224', 2);
insert into planos values (10349, '9363', 1);
insert into planos values (10349, '9367', 2);
insert into planos values (10349, '9369', 1);
insert into planos values (10349, '9370', 2);
insert into planos values (10349, '9508', 2);
insert into planos values (10349, '9509', 1);
insert into planos values (10350, '9508', 2);
insert into planos values (10351, '9508', 2);
insert into planos values (10352, '8334', 2);
insert into planos values (10352, '9015', 2);
insert into planos values (10352, '9116', 2);
insert into planos values (10352, '9209', 2);
insert into planos values (10352, '9224', 2);
insert into planos values (10352, '9348', 2);
insert into planos values (10352, '9359', 2);
insert into planos values (10352, '9360', 2);
insert into planos values (10352, '9363', 2);
insert into planos values (10352, '9367', 2);
insert into planos values (10352, '9368', 2);
insert into planos values (10352, '9369', 2);
insert into planos values (10352, '9370', 2);
insert into planos values (10352, '9508', 2);
insert into planos values (10352, '9509', 2);
insert into planos values (10352, 'G005', 2);
insert into planos values (10353, '8334', 1);
insert into planos values (10353, '9360', 3);
insert into planos values (10353, '9363', 1);
insert into planos values (10353, '9367', 5);
insert into planos values (10353, '9369', 1);
insert into planos values (10353, '9508', 3);
insert into planos values (10353, '9509', 2);
insert into planos values (10354, '9116', 3);
insert into planos values (10354, '9359', 5);
insert into planos values (10355, '9508', 3);
insert into planos values (10356, '9508', 3);
insert into planos values (10357, '9508', 3);
insert into planos values (10358, '8334', 4);
insert into planos values (10358, '9015', 4);
insert into planos values (10358, '9116', 4);
insert into planos values (10358, '9209', 4);
insert into planos values (10358, '9224', 4);
insert into planos values (10358, '9348', 4);
insert into planos values (10358, '9359', 4);
insert into planos values (10358, '9360', 4);
insert into planos values (10358, '9363', 4);
insert into planos values (10358, '9367', 4);
insert into planos values (10358, '9368', 4);
insert into planos values (10358, '9369', 4);
insert into planos values (10358, '9370', 4);
insert into planos values (10358, '9508', 4);
insert into planos values (10358, '9509', 4);
insert into planos values (10358, 'G005', 4);
insert into planos values (10359, '9508', 4);
insert into planos values (10360, '9508', 4);
insert into planos values (10361, '9360', 4);
insert into planos values (10361, '9369', 6);
insert into planos values (10361, '9509', 4);
insert into planos values (10362, '9508', 4);
insert into planos values (10363, '8334', 2);
insert into planos values (10363, '9363', 2);
insert into planos values (10363, '9508', 4);
insert into planos values (10364, '9508', 4);
insert into planos values (10365, '9508', 5);
insert into planos values (10366, '9508', 5);
insert into planos values (10367, '9508', 5);
insert into planos values (10368, '9508', 6);
insert into planos values (10369, '9508', 6);
insert into planos values (10370, '9508', 6);
insert into planos values (10371, '9508', 6);
insert into planos values (10372, '9508', 6);
insert into planos values (10375, '9508', 7);
insert into planos values (10376, '9508', 7);
insert into planos values (10377, '9508', 7);
insert into planos values (10378, '9508', 7);
insert into planos values (10379, '9508', 7);
insert into planos values (10380, '8334', 8);
insert into planos values (10380, '9359', 8);
insert into planos values (10380, '9360', 8);
insert into planos values (10380, '9363', 8);
insert into planos values (10380, '9367', 8);
insert into planos values (10380, '9368', 8);
insert into planos values (10380, '9369', 8);
insert into planos values (10380, '9370', 8);
insert into planos values (10380, '9508', 8);
insert into planos values (10380, '9509', 8);
insert into planos values (10380, 'G005', 8);
insert into planos values (10388, '9508', 9);
insert into planos values (10389, '9508', 9);
insert into planos values (10397, '9508', 8);
insert into planos values (10398, '9508', 8);
insert into planos values (10399, '9508', 8);
insert into planos values (10400, '9508', 8);
insert into planos values (10401, '9508', 9);
insert into planos values (10405, '9508', 9);
insert into planos values (10406, '9363', 1);
insert into planos values (10407, '8334', 1);
insert into planos values (10407, '9359', 1);
insert into planos values (10407, '9363', 1);
insert into planos values (10408, '9363', 2);
insert into planos values (10410, '8334', 2);
insert into planos values (10410, '9348', 2);
insert into planos values (10410, '9360', 4);
insert into planos values (10410, '9367', 4);
insert into planos values (10410, '9370', 4);
insert into planos values (10411, '8334', 3);
insert into planos values (10411, '9363', 3);
insert into planos values (10411, '9367', 3);
insert into planos values (10411, '9369', 3);
insert into planos values (10411, '9370', 4);
insert into planos values (10411, '9509', 3);
insert into planos values (10412, '9363', 3);
insert into planos values (10413, '8334', 4);
insert into planos values (10413, '9363', 3);
insert into planos values (10415, '9363', 7);
insert into planos values (10416, '8334', 1);
insert into planos values (10417, '8334', 5);
insert into planos values (10418, '8334', 4);
insert into planos values (10419, '9359', 4);
insert into planos values (10420, '8334', 5);
insert into planos values (10420, '9509', 5);
insert into planos values (10422, '8334', 6);
insert into planos values (10423, '8334', 9);
insert into planos values (10423, '9359', 3);
insert into planos values (10423, '9369', 7);
insert into planos values (10423, '9370', 5);
insert into planos values (10424, '8334', 9);
insert into planos values (10425, '8334', 9);
insert into planos values (10426, '9360', 1);
insert into planos values (10427, '9360', 1);
insert into planos values (10428, '9360', 1);
insert into planos values (10429, '9116', 1);
insert into planos values (10429, '9360', 1);
insert into planos values (10429, '9368', 1);
insert into planos values (10429, '9369', 1);
insert into planos values (10429, '9509', 1);
insert into planos values (10430, '9360', 2);
insert into planos values (10431, '9360', 2);
insert into planos values (10432, '9360', 3);
insert into planos values (10433, '9360', 3);
insert into planos values (10434, '9360', 4);
insert into planos values (10435, '9360', 4);
insert into planos values (10436, '9360', 4);
insert into planos values (10437, '9360', 4);
insert into planos values (10438, '9360', 5);
insert into planos values (10439, '9360', 5);
insert into planos values (10440, '9360', 6);
insert into planos values (10441, '9360', 6);
insert into planos values (10442, '9360', 7);
insert into planos values (10443, '9360', 7);
insert into planos values (10444, '9360', 7);
insert into planos values (10445, '9360', 7);
insert into planos values (10446, '9360', 8);
insert into planos values (10447, '9360', 8);
insert into planos values (10448, '9360', 8);
insert into planos values (10449, '9360', 9);
insert into planos values (10450, '9360', 9);
insert into planos values (10451, '9360', 9);
insert into planos values (10454, '9360', 9);
insert into planos values (10455, '9360', 8);
insert into planos values (10459, '9360', 9);
insert into planos values (10462, '9360', 8);
insert into planos values (10463, '9360', 8);
insert into planos values (10464, '9360', 9);
insert into planos values (10465, '9360', 9);
insert into planos values (10466, '9360', 8);
insert into planos values (10467, '9360', 8);
insert into planos values (10468, '9360', 9);
insert into planos values (10469, '9360', 9);
insert into planos values (10470, '9360', 9);
insert into planos values (10473, '9367', 1);
insert into planos values (10475, '9367', 1);
insert into planos values (10476, '9359', 1);
insert into planos values (10476, '9367', 1);
insert into planos values (10476, '9368', 1);
insert into planos values (10477, '9369', 6);
insert into planos values (10478, '9367', 3);
insert into planos values (10479, '9367', 3);
insert into planos values (10480, '9367', 4);
insert into planos values (10481, '9367', 6);
insert into planos values (10482, '9369', 1);
insert into planos values (10485, '9367', 9);
insert into planos values (10486, '9369', 6);
insert into planos values (10487, '9367', 9);
insert into planos values (10489, '9367', 9);
insert into planos values (10490, '9368', 7);
insert into planos values (10493, '9369', 4);
insert into planos values (10494, '9369', 5);
insert into planos values (10495, '9369', 7);
insert into planos values (10496, '9369', 2);
insert into planos values (10499, '9367', 7);
insert into planos values (10501, '9367', 7);
insert into planos values (10503, '9369', 7);
insert into planos values (10504, '9367', 8);
insert into planos values (10505, '9369', 7);
insert into planos values (10511, '9369', 9);
insert into planos values (10515, '9359', 1);
insert into planos values (10517, '9359', 2);
insert into planos values (10517, '9368', 2);
insert into planos values (10518, '9368', 3);
insert into planos values (10519, '9359', 3);
insert into planos values (10519, '9368', 3);
insert into planos values (10520, '9359', 3);
insert into planos values (10521, '9359', 3);
insert into planos values (10522, '9359', 4);
insert into planos values (10522, '9368', 4);
insert into planos values (10523, '9359', 4);
insert into planos values (10524, '9359', 5);
insert into planos values (10524, '9368', 5);
insert into planos values (10525, '8334', 5);
insert into planos values (10525, '9359', 5);
insert into planos values (10525, '9368', 5);
insert into planos values (10526, '9368', 6);
insert into planos values (10527, '9359', 6);
insert into planos values (10528, '9359', 7);
insert into planos values (10530, '9368', 7);
insert into planos values (10531, '9368', 8);
insert into planos values (10532, '9359', 8);
insert into planos values (10534, '9359', 8);
insert into planos values (10535, '9359', 9);
insert into planos values (10536, '9359', 7);
insert into planos values (10537, '9359', 9);
insert into planos values (10537, '9368', 9);
insert into planos values (10538, '9368', 1);
insert into planos values (10539, '9359', 2);
insert into planos values (10539, '9368', 2);
insert into planos values (10540, '9368', 3);
insert into planos values (10541, '9368', 4);
insert into planos values (10541, '9369', 4);
insert into planos values (10544, '9368', 8);
insert into planos values (10546, '9368', 8);
insert into planos values (10551, '9368', 9);
insert into planos values (10571, '9509', 1);
insert into planos values (10572, '9369', 1);
insert into planos values (10572, '9509', 1);
insert into planos values (10573, '9509', 2);
insert into planos values (10574, '9509', 2);
insert into planos values (10575, '9369', 3);
insert into planos values (10575, '9370', 5);
insert into planos values (10575, '9509', 3);
insert into planos values (10576, '9116', 3);
insert into planos values (10576, '9369', 3);
insert into planos values (10576, '9509', 3);
insert into planos values (10577, '9509', 4);
insert into planos values (10578, '9509', 4);
insert into planos values (10579, '9116', 6);
insert into planos values (10579, '9369', 4);
insert into planos values (10579, '9509', 4);
insert into planos values (10580, '9509', 5);
insert into planos values (10581, '9369', 5);
insert into planos values (10581, '9509', 5);
insert into planos values (10587, '9509', 6);
insert into planos values (10588, '9509', 7);
insert into planos values (10610, '9509', 8);
insert into planos values (10614, '9509', 9);
insert into planos values (10633, '9369', 2);
insert into planos values (10637, 'G005', 1);
insert into planos values (10640, 'G005', 4);
insert into planos values (10647, '9348', 1);
insert into planos values (10648, '9348', 1);
insert into planos values (10649, '9348', 1);
insert into planos values (10650, '9224', 2);
insert into planos values (10650, '9348', 2);
insert into planos values (10651, '9348', 3);
insert into planos values (10652, '9224', 3);
insert into planos values (10652, '9348', 3);
insert into planos values (10653, '9348', 4);
insert into planos values (10654, '9348', 4);
insert into planos values (10655, '9348', 5);
insert into planos values (10660, '9348', 6);
insert into planos values (10661, '9015', 4);
insert into planos values (10661, '9348', 6);
insert into planos values (10662, '9348', 6);
insert into planos values (10663, '9116', 1);
insert into planos values (10664, '9116', 1);
insert into planos values (10665, '9116', 2);
insert into planos values (10666, '9116', 4);
insert into planos values (10667, '9116', 4);
insert into planos values (10668, '9116', 4);
insert into planos values (10669, '9116', 4);
insert into planos values (10670, '9116', 5);
insert into planos values (10671, '9116', 5);
insert into planos values (10672, '9116', 5);
insert into planos values (10675, '9370', 2);
insert into planos values (10676, '9224', 2);
insert into planos values (10676, '9370', 2);
insert into planos values (10677, '9370', 4);
insert into planos values (10678, '9370', 4);
insert into planos values (10679, '9370', 5);
insert into planos values (10681, '9370', 5);
insert into planos values (10683, '9370', 6);
insert into planos values (10684, '9370', 7);
insert into planos values (10687, '9370', 7);
insert into planos values (10689, '9370', 9);
insert into planos values (10690, '9224', 1);
insert into planos values (10690, '9370', 1);
insert into planos values (10692, '9015', 1);
insert into planos values (10693, '9015', 1);
insert into planos values (10694, '9015', 2);
insert into planos values (10695, '9015', 2);
insert into planos values (10696, '9015', 2);
insert into planos values (10697, '9015', 2);
insert into planos values (10698, '9015', 3);
insert into planos values (10698, '9224', 3);
insert into planos values (10699, '9015', 3);
insert into planos values (10700, '9015', 5);
insert into planos values (10701, '9224', 5);
insert into planos values (10702, '9015', 6);
insert into planos values (10704, '9224', 6);
insert into planos values (10705, '9224', 6);
insert into planos values (10707, '9224', 1);
insert into planos values (10709, '9224', 5);
insert into planos values (10710, '9224', 5);
insert into planos values (10711, '9224', 5);
insert into planos values (10712, '9224', 5);
insert into planos values (10713, '9015', 1);
insert into planos values (10713, '9348', 1);
insert into planos values (10713, '9368', 1);
insert into planos values (10714, '9015', 3);
insert into planos values (10715, '9224', 1);
insert into planos values (10716, '9224', 6);
insert into planos values (10721, '9015', 5);
insert into planos values (10748, '9224', 6);
insert into planos values (10794, 'G005', 9);
insert into planos values (10822, '9370', 5);
insert into planos values (10824, '9015', 1);
insert into planos values (10824, '9224', 1);
insert into planos values (10824, '9370', 1);
insert into planos values (10866, '9224', 4);
insert into planos values (10867, '8036', 2);
insert into planos values (10873, '8036', 3);
insert into planos values (10874, '9015', 6);
insert into planos values (10917, '9368', 6);
insert into planos values (10918, '9367', 7);
insert into planos values (10919, '9367', 7);
insert into planos values (10920, '9367', 9);
insert into planos values (10922, '9367', 8);
insert into planos values (10923, '9367', 8);
insert into planos values (10924, '9367', 2);
insert into planos values (10925, '9508', 9);
insert into planos values (10932, '8334', 4);
insert into planos values (10932, '9367', 4);
insert into planos values (10933, '8334', 5);
insert into planos values (10933, '9367', 5);
insert into planos values (10942, '9209', 4);
insert into planos values (10946, '9367', 5);
insert into planos values (10960, '9367', 6);
insert into planos values (10961, '9367', 9);
insert into planos values (10962, '9367', 9);
insert into planos values (10967, '9367', 8);
insert into planos values (10969, '9209', 1);
insert into planos values (10970, '9209', 1);
insert into planos values (10971, '9209', 1);
insert into planos values (10972, '9209', 2);
insert into planos values (10973, '9209', 2);
insert into planos values (10974, '9209', 2);
insert into planos values (10975, '9209', 2);
insert into planos values (10976, '9209', 3);
insert into planos values (10977, '9209', 3);
insert into planos values (10978, '9209', 3);
insert into planos values (10979, '9209', 3);
insert into planos values (10980, '9209', 4);
insert into planos values (10981, '9209', 4);
insert into planos values (10982, '9209', 4);
insert into planos values (10983, '9209', 5);
insert into planos values (10984, '9209', 5);
insert into planos values (10993, '9367', 7);
insert into planos values (10994, '9367', 9);
insert into planos values (10997, '9363', 8);
insert into planos values (10998, '9369', 8);
insert into planos values (11004, '8036', 1);
insert into planos values (11005, '8036', 1);
insert into planos values (11006, '8036', 3);
insert into planos values (11007, '8036', 4);
insert into planos values (11008, '8036', 4);
insert into planos values (11009, '8036', 5);
insert into planos values (11010, '9348', 3);
insert into planos values (11011, '9348', 5);
insert into planos values (11024, '9116', 6);
insert into planos values (11025, '9116', 6);
insert into planos values (11026, '9508', 8);
insert into planos values (11027, '9508', 4);
insert into planos values (11035, '9224', 6);
insert into planos values (11044, '8334', 6);
insert into planos values (11044, '9363', 6);
insert into planos values (11044, '9368', 6);
insert into planos values (11045, '8334', 7);
insert into planos values (11046, '8334', 8);
insert into planos values (11048, '8334', 9);
insert into planos values (11053, '9370', 7);
insert into planos values (11054, '9368', 4);
insert into planos values (11054, '9509', 4);
insert into planos values (11055, '9369', 8);
insert into planos values (11057, '9363', 5);
insert into planos values (11068, '9367', 6);
insert into planos values (11073, '9508', 1);
insert into planos values (11141, '9359', 4);
insert into planos values (11146, '9348', 2);
insert into planos values (11146, '9370', 2);
insert into planos values (11147, '9360', 2);
insert into planos values (11148, '9369', 2);
insert into planos values (11148, '9509', 2);
insert into planos values (11149, '8334', 2);
insert into planos values (11149, '9363', 4);
insert into planos values (11152, 'G005', 2);
insert into planos values (11153, 'G005', 2);
insert into planos values (11154, 'G005', 3);
insert into planos values (11155, 'G005', 3);
insert into planos values (11156, 'G005', 5);
insert into planos values (11191, 'G005', 8);
insert into planos values (11194, '9348', 2);
insert into planos values (11194, '9359', 2);
insert into planos values (11195, '8334', 2);
insert into planos values (11195, '9363', 2);
insert into planos values (11232, 'G005', 9);
insert into planos values (11233, 'G005', 9);
insert into planos values (11273, '9116', 5);
insert into planos values (11456, '9367', 8);
insert into planos values (11459, '9367', 9);
insert into planos values (11504, '8334', 1);
insert into planos values (11504, '9116', 1);
insert into planos values (11504, '9359', 1);
insert into planos values (11504, '9360', 1);
insert into planos values (11504, '9363', 1);
insert into planos values (11504, '9367', 1);
insert into planos values (11504, '9368', 1);
insert into planos values (11504, '9369', 1);
insert into planos values (11504, '9370', 1);
insert into planos values (11504, '9508', 1);
insert into planos values (11504, '9509', 1);
insert into planos values (11504, 'G005', 1);
insert into planos values (11505, '8334', 1);
insert into planos values (11505, '9116', 1);
insert into planos values (11505, '9359', 1);
insert into planos values (11505, '9360', 1);
insert into planos values (11505, '9363', 1);
insert into planos values (11505, '9367', 1);
insert into planos values (11505, '9368', 1);
insert into planos values (11505, '9369', 1);
insert into planos values (11505, '9370', 1);
insert into planos values (11505, '9508', 1);
insert into planos values (11505, '9509', 1);
insert into planos values (11505, 'G005', 1);
insert into planos values (11506, '9363', 5);
insert into planos values (11507, '9363', 9);
insert into planos values (11508, '9363', 9);
insert into planos values (11511, '8334', 6);
insert into planos values (11512, '9368', 4);
insert into planos values (11513, '9368', 4);
insert into planos values (11514, '9359', 5);
insert into planos values (11514, '9368', 5);
insert into planos values (11515, '9368', 6);
insert into planos values (11517, '9368', 7);
insert into planos values (11518, '9368', 7);
insert into planos values (11519, '9359', 7);
insert into planos values (11519, '9368', 7);
insert into planos values (11520, '9359', 8);
insert into planos values (11520, '9368', 8);
insert into planos values (11521, '9368', 8);
insert into planos values (11522, '9368', 9);
insert into planos values (11523, '9368', 9);
insert into planos values (11536, '9368', 8);
insert into planos values (11537, '9368', 9);
insert into planos values (11678, '9368', 5);
insert into planos values (11821, '9348', 3);
insert into planos values (11821, '9359', 3);
insert into planos values (11823, '9348', 2);
insert into planos values (11825, '9359', 9);
insert into planos values (11826, '9359', 6);
insert into planos values (11827, '9359', 6);
insert into planos values (11828, '9359', 2);
insert into planos values (11832, '9015', 2);



-- 1.5

drop sequence seq_num_aluno;

create sequence seq_num_aluno
start with 53000
increment by 1;

-- 1.6
insert into matriculas values (seq_num_aluno.nextval,122199,'G005',to_date('2016.09.10','YYYY.MM.DD'));
insert into matriculas values (seq_num_aluno.nextval,116461,'G005',to_date('2016.09.10','YYYY.MM.DD'));
insert into matriculas values (seq_num_aluno.nextval,111985,'G005',to_date('2016.09.10','YYYY.MM.DD'));

-- 2.1
create or replace trigger inscreve_novo_aluno
	after insert on matriculas
	for each row
	begin
		insert into inscricoes 
      select :new.numero, curso, cadeira, to_number(extract(year from :new.dataMatr)), :new.dataMatr
      from planos
      where curso = :new.curso and semestre = 1;
  end;
/

-- 2.2
insert into matriculas values (seq_num_aluno.nextval,122264,'G005',to_date('2016.09.10','YYYY.MM.DD'));

-- 3.1
-- Ajuda começar por ter uma view que a cada momento diz o nº de creditos a que cada aluno
-- está inscrito em cada ano
create or replace view totalCred as
    select numero, anoLetivo, sum(ects) as total
    from inscricoes I natural join cadeiras
    group by numero, anoLetivo;

-- Agora vamos a um trigger que depois de cada inserção em inscricoes
-- verifica se não há nenhum aluno que ficou com mais de 72 créditos
create or replace trigger verifica_limite
  after insert on inscricoes
  declare NumECTS number;
  begin
    select max(total) into NumECTS from totalCred;
    if (NumECTS >  72)
      then Raise_Application_Error (-20100, 'Atingiu o limite de créditos. Inscrição não aceite!');
    end if;
  end;
/

-- 3.2
insert into inscricoes values (53003, 'G005', 10640, 2016, to_date('2016.09.10','YYYY.MM.DD'));
insert into inscricoes values (53003, 'G005', 11152, 2016, to_date('2016.09.10','YYYY.MM.DD'));
insert into inscricoes values (53003, 'G005', 11153, 2016, to_date('2016.09.10','YYYY.MM.DD'));
insert into inscricoes values (53003, 'G005', 11154, 2016, to_date('2016.09.10','YYYY.MM.DD'));
insert into inscricoes values (53003, 'G005', 7996, 2016, to_date('2016.09.10','YYYY.MM.DD'));

delete from inscricoes where cadeira = 7996;
insert into inscricoes values (53003, 'G005', 7336, 2016, to_date('2016.09.10','YYYY.MM.DD'));

-- Para a coisa ficar mesmo "à prova de bala", também há que fazer a verificação  quando se mudam os
-- créditos de uma cadeira,  e quando se muda uma inscricao.
-- Mas é tudo muito igual
create or replace trigger verifica_limite_credCadeira
  after update of ects on cadeiras
  declare NumECTS number;
  begin
    select max(total) into NumECTS from totalCred;
    if (NumECTS >  72)
      then Raise_Application_Error (-20100, 'Atingiu o limite de créditos. Inscrição não aceite!');
    end if;
  end;
/

create or replace trigger verifica_limite_muda_ins
  after update on inscricoes
  declare NumECTS number;
  begin
    select max(total) into NumECTS from totalCred;
    if (NumECTS >  72)
      then Raise_Application_Error (-20100, 'Atingiu o limite de créditos. Inscrição não aceite!');
    end if;
  end;
/

-- 4.1
alter table colocados drop constraint pk_col;
alter table matriculas drop constraint fk_matrcolcurso;
alter table colocados drop constraint un_col;
alter table colocados add constraint pk_col primary key (idCandidato, ano);


-- Nota: com isto o esquema deixa de estar normalizado!
-- Repare que idCandidato -> Nome 
-- Antes isso não tinha problema pois idCandidato era chave. Mas agora deixa de ser!
-- Haveria que decompor a tabela de colocações em duas:
-- nomesColocados(idCandidato, Nome)
-- colocados(idCandidato, curso, ano).

-- Por agora, para simplificar o exercício, não vamos fazer isso, tendo apenas o cuidado de manter a consistência dos nomes
-- Fica como exercício extra fazer a coisa como deve ser. Ou seja, com a decomposição.

insert into colocados values (122264,'PEDRO M. S. L.','9209',2017);

-- 4.2

alter table matriculas add ano number(4,0);
update matriculas set ano = 2016;

alter table matriculas drop constraint un_mat;
alter table matriculas add constraint un_mat unique(idCandidato, ano);

alter table colocados add constraint un_col unique(idCandidato,curso,ano);
alter table matriculas add constraint fk_matrcolcurso foreign key (idCandidato,curso,ano) references colocados(idCandidato,curso,ano);

-- 4.3

create table inativas (
  numero number(6,0),
  curso varchar2(4)
  );
  
alter table inativas add constraint pk_ina primary key (numero, curso);
alter table inativas add constraint fk_ina foreign key (numero, curso) references matriculas(numero, curso);

-- 4.4
create or replace trigger muda_curso
  before insert on matriculas
  for each row
  declare Existe number;
  begin
    select count(*) into Existe 
    from matriculas where idCandidato = :new.idcandidato;
    if Existe > 0
      then
        insert into inativas 
          select numero, curso
          from matriculas
          where idCandidato = :new.idcandidato;
    end if;
  end;
/

-- 4.5
-- Tentemos então matricular o aluno 122264 em 2017, no curso de Matemática
insert into matriculas values (seq_num_aluno.nextval,122264,'9209',to_date('2017.09.10','YYYY.MM.DD'),2017);

-- 4.6
create or replace trigger impede_matr_ant
  before insert or update on inscricoes
  for each row
  declare Existe number;
  begin
    select count(*) into Existe 
    from inativas
    where numero = :new.numero and curso = :new.curso;
    if Existe > 0
      then Raise_Application_Error (-20100, 'O aluno já não está nesse curso. Inscrição não aceite!');
    end if;
  end;
/

insert into inscricoes values (53004, '9209', 3107, 2017, to_date('2017.09.11','YYYY.MM.DD'));

create or replace TRIGGER  COD_ALUNO
BEFORE INSERT ON matriculas
FOR EACH ROW
DECLARE
  num_aluno number;
BEGIN
  SELECT seq_num_aluno.nextval
    INTO num_aluno
    FROM dual;
  :new.NUMERO := num_aluno;
END;
/

insert into matriculas values (seq_num_aluno.nextval,140097,'9367',to_date('2016.09.10','YYYY.MM.DD'),2016);

create or replace FUNCTION calc_ects(aluno NUMBER) RETURN NUMBER
IS
   totalECTS NUMBER;
BEGIN
  SELECT sum(ECTS)
  INTO totalECTS
  FROM inscricoes i, cadeiras c
  WHERE aluno=i.numero AND i.cadeira = c.cadeira;
  RETURN totalECTS;
END calc_ects;

