-- Ficha 4
-- Proposta de solução

-- Muda a sessão para aceder, por default, às tabelas do utilizador candidaturas
alter session set current_schema = candidaturas;

-- 1
-- Quais o nome e média do secundário dos vários candidatos ao ensino superior?
select nome, mediaSec from candidatos order by MEDIASEC desc;

-- 2
-- Para cada candidato qual o nome da escola secundária que frequentou?
select nome, nomeEscola
from candidatos, escolas
where candidatos.escola = escolas.escola;

-- ou
select nome, nomeEscola
from candidatos inner join escolas using (escola);

-- ou
select nome, nomeescola
from candidatos inner join escolas on (candidatos.escola=escolas.escola);

-- mas não:
select nome, nomeescola
from candidatos natural join escolas;

-- 3
-- Quais os candidatos que frequentaram uma escola secundária no mesmo concelho em que residiam (e qual o nome da escola e do concelho)?
select nome, nomeEscola, descrConcelho
from candidatos inner join escolas using (escola, distrito, concelho)
                inner join concelhos using (distrito, concelho);

-- 4
-- A que cursos (e onde) se candidatou o candidato com identificador 32345, dizendo para cada curso a ordem em que o colocou e a média de candidatura? 
select ordem, nomeCurso, nomeEstab, notaCand
from candidaturas inner join estabelecimentosSup using (estab)
                  inner join cursos using (curso)
where idCandidato = 32345;

-- 5
-- Relembre a que curso é que você se candidatou?
select ordem, nomeCurso, nomeEstab, notaCand
from candidatos inner join candidaturas using (idCandidato)
                inner join estabelecimentosSup using (estab) 
                inner join cursos using (curso)
where nome = 'META AQUI O SEU NOME'
order by ordem;

-- 6
-- Que notas teve o candidato com identificador 32345 nos vários exames que fez?
select nomeExame, ano, fase, nota
from notasExames natural join exames
where idCandidato = 32345;

-- Já agora, relembre as suas notas nos exames.
select nomeExame, ano, fase, nota
from candidatos inner join notasExames using (idCandidato)
                inner join exames using (exame)
where nome = 'META AQUI O SEU NOME';

-- 7
-- Onde ficaram colocados os candidatos com `Afonso' no nome?
select nome, nomeCurso, nomeEstab
from colocacoes inner join candidatos using (idCandidato)
                inner join cursos using (curso)
                inner join estabelecimentosSup using (estab)
where nome like '%AFONSO%';

-- 8
-- Quais os candidatos colocados em Informática na Nova, e para cada um deles o seu nome, a média de candidatura, a média do secundário, a ordem de preferência, e a escola secundária que frequentaram?
select nome, notaCand, mediaSec, ordem, nomeEscola
from candidatos inner join escolas using (escola)
                inner join candidaturas using (idCandidato)
                inner join colocacoes using (idCandidato, estab, curso)
                inner join cursos using (curso)
                inner join estabelecimentosSup  using (estab)
where nomeCurso like '%Informática%' and nomeEstab like '%Nova%';

-- 9
-- Quais os seus colegas do secundário que foram colocados na FCT (estabelecimento 903), e em que curso?
 select nome, nomeCurso
 from candidatos inner join colocacoes using (idCandidato)
                 inner join cursos using (curso)
                 inner join escolas using (escola)
 where nomeEscola like '%Gabriel Pereira' -- Escola de exemplo. Deve meter a sua escola do secundário
      and estab = 903;

-- 10
-- Quais os candidatos colocados na Nova que não entraram num curso de Engenharia, mostrando para cada um deles em que curso entraram?
select nome, nomeCurso
from candidatos inner join colocacoes using (idCandidato)
                inner join cursos using (curso)
                inner join estabelecimentosSup  using (estab)
where nomeEstab like '%Nova%' and nomeCurso not like 'Engenharia%';

-- 11
-- Quais os colocados deslocados (i.e. residentes num distrito diferente daquale em que se situa o estabelecimento
-- de ensino superior onde foram colocados).
-- Para cada um deles, mostre o nome, o distrito onde foram colocados, e o distrito onde residem. .
select nome, Col.descrDistrito as Colocado, Res.descrDistrito as Residente
from candidatos inner join colocacoes using (idcandidato)
                inner join estabelecimentossup using (estab)
                inner join distritos Res on (candidatos.distrito=Res.distrito), distritos Col                
where candidatos.distrito != estabelecimentossup.distrito and Col.distrito=estabelecimentossup.distrito;

-- 12
-- Apresente a pauta do exame de Português de 1ª fase de 2016, dos colocados em ``Biologia Celular e Molecular''
select nome, nota
from candidatos inner join colocacoes using (idCandidato)
                inner join cursos using (curso)
                inner join notasExames using (idCandidato)
                inner join exames using (exame)
where nomeCurso = 'Biologia Celular e Molecular'
	and nomeExame like 'Português'
  and fase = 1 and ano = 2016
order by nome;

-- 13
-- Quais os candidatos que se candidataram ao curso G005 (que é o vosso) e ao curso 9367 (que é o MIEEC) no estabelecimento 903 (que é a FCT)
-- e que, acertadamente, preferiam o curso G005? Para cada um apresente o nome, e a ordem em que colocou o MIEI e o MIEEC.
select nome, CandMIEI.ordem OrdemMIEI, CandMIEEC.ordem OrdemMIEEC
from candidaturas CandMIEI, candidaturas CandMIEEC, candidatos
where candidatos.idCandidato = CandMIEI.idCandidato and CandMIEI.idCandidato = CandMIEEC.idCandidato
	and CandMIEI.curso = 'G005' and CandMIEEC.curso = '9367' and CandMIEI.estab = 903 and CandMIEEC.estab = 903
	and CandMIEI.ordem < CandMIEEC.ordem;
  
-- 14
-- Quais os candidatos que se candidataram a Informática na Nova e no Técnico, mas que, acertadamente, preferiam a Nova?
-- Para cada um apresente o nome, e a ordem em que colocou a Nova e o Técnico.
select nome, CandNova.ordem OrdemNova, CandTecn.ordem OrdemTecnico
from candidaturas CandNova inner join estabelecimentosSup EstNova using (estab)
                           inner join cursos CursoNova using (curso),
     candidaturas CandTecn inner join estabelecimentosSup EstTecn using (estab)
                           inner join cursos CursoTecn using (curso),
     candidatos
where candidatos.idCandidato = CandNova.idCandidato and CandNova.idCandidato = CandTecn.idCandidato
	and EstNova.nomeEstab like '%Nova%' and EstTecn.nomeEstab like '%Técnico'
	and CursoNova.nomeCurso like '%Informática%' and CursoTecn.nomeCurso like '%Informática%' 
	and CandNova.ordem < CandTecn.ordem;

-- 15
-- Quais os candidatos não colocados?
(select nome, idcandidato from candidatos)
minus
(select nome, idcandidato
from candidatos inner join colocacoes using (idcandidato));
-- ou 
select nome, idcandidato
from candidatos left outer join colocacoes using (idcandidato)
where estab is null
order by idcandidato;

-- 16
-- Quais os cursos do estabelecimento 903 (a FCT) que tiveram colocados com uma negativa no exame de Português?
select distinct nomeCurso
from colocacoes inner join notasExames using (idCandidato)
                inner join exames using (exame)
                inner join cursos using (curso)
where nomeExame = 'Português' and estab = 903 and nota < 95;

-- 17
-- Quais os cursos do estabelecimento 903 (a FCT) que tiveram colocados com uma negativa no exame de Português
-- e que também tiveram candidatos com uma negativa a Matemática A
(select nomeCurso
from colocacoes inner join notasExames using (idCandidato)
                inner join exames using (exame)
                inner join cursos using (curso)
where nomeExame = 'Português' and estab = 903 and nota < 95)
intersect
(select nomeCurso
from colocacoes inner join notasExames using (idCandidato)
                inner join exames using (exame)
                inner join cursos using (curso)
where nomeExame = 'Matemática A' and estab = 903 and nota < 95);

-- 18
-- Quais os cursos do estabelecimento 903 (a FCT) que tiveram colocados com uma negativa no exame de Português e com uma negativa a Matemática A?
select distinct nomeCurso
from colocacoes      inner join notasExames on (colocacoes.IDCANDIDATO = notasExames.IDCANDIDATO)
                     inner join exames using (exame),
     colocacoes ColM inner join notasExames notasM on (ColM.IDCANDIDATO = notasM.IDCANDIDATO)
                     inner join exames ExM using (exame),
    cursos
where exames.nomeExame = 'Português' and ExM.nomeExame = 'Matemática A' 
	and colocacoes.estab = 903 and ColM.estab = 903
  and notasExames.nota < 95 and notasM.nota < 95
	and colocacoes.idCandidato = ColM.idCandidato
  and cursos.curso = colocacoes.curso;
