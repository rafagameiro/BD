-- 1.1
-- É só correr o ficheiro criaMatriculas.sql

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
-- É só correr o ficheiro insereCadeiras.sql

-- 1,5
create sequence seq_num_aluno
start with 53000
increment by 1;

-- 1.6
insert into matriculas values (seq_num_aluno.nextval,122199,'G005',to_date('2016.09.10','YYYY.MM.DD'));
insert into matriculas values (seq_num_aluno.nextval,116461,'9209',to_date('2016.09.10','YYYY.MM.DD'));
insert into matriculas values (seq_num_aluno.nextval,116461,'G005',to_date('2016.09.10','YYYY.MM.DD'));
insert into matriculas values (seq_num_aluno.nextval,111985,'G005',to_date('2016.09.10','YYYY.MM.DD'));

-- Já agora, ver quem ficou matriculado.
select numero, nome, nomeCurso, dataMatr
from matriculas natural join colocados natural join cursos;

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
-- Vamos testar matriculando o aluno 122264
insert into matriculas values (seq_num_aluno.nextval,122264,'G005',to_date('2016.09.10','YYYY.MM.DD'));

-- Vejamos então o que está nas matrículas e nas inscrições
select * from matriculas;
select * from inscricoes natural join cadeiras;

-- 3.1
-- Ajuda começar por ter uma view que a cada momento diz o nº de creditos a que cada aluno
-- está inscrito em cada ano
create or replace view totalCred as
    select numero, anoLetivo, sum(ects) as total
    from inscricoes I natural join cadeiras
    group by numero, anoLetivo;

select * from totalCred;

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
-- Vamos inscrever o aluno nº 53009 a umas quantas cadeiras mais
-- No seu caso escolha um aluno com um nº que esteja matriculado
-- De preferência escolhe um aluno que matriculou depois do trigger do grupo 2 já a funcionar

-- Comecemos por tentar inscrevê-lo a uma cadeira que não é do seu curso
-- Por exemplo, tentemos dizer que ele é de Matemática e se quer inscrever a Álgebra 1
insert into inscricoes values (53009, '9209', 10970, 2016, to_date('2016.09.10','YYYY.MM.DD'));

-- Falhou, certo? Diz que o curso está mal...

-- Agora vamos inscrevê-lo como aluno de Informática, mas nessa cadeira
insert into inscricoes values (53009, 'G005', 10970, 2016, to_date('2016.09.10','YYYY.MM.DD'));

-- Voltou a falhar, certo? Agora diz que o plano está mal...

-- Vamos então inscrevê-lo a cadeiras do curso dele
insert into inscricoes values (53009, 'G005', 10640, 2016, to_date('2016.09.10','YYYY.MM.DD'));
insert into inscricoes values (53009, 'G005', 11152, 2016, to_date('2016.09.10','YYYY.MM.DD'));
insert into inscricoes values (53009, 'G005', 11153, 2016, to_date('2016.09.10','YYYY.MM.DD'));
insert into inscricoes values (53009, 'G005', 11154, 2016, to_date('2016.09.10','YYYY.MM.DD'));
insert into inscricoes values (53009, 'G005', 7996, 2016, to_date('2016.09.10','YYYY.MM.DD'));

-- So far so good...
-- Vejamos a quantos créditos já está inscrito em 2016
select sum(ects)
from inscricoes natural join cadeiras
where anoLetivo = 2016 and numero = 53009;

-- Esse aluno já deve ter 69 créditos (se no seu caso ainda não tiver, inscreva-o a mais umas quantas cadeiras).
-- Se agora o tentarmos inscrever a mais uma cadeira de 6 créditos a coisa não deve funcionar
insert into inscricoes values (53009, 'G005', 7336, 2016, to_date('2016.09.10','YYYY.MM.DD'));

-- E cá está! Deu erro e não o inscreveu!
select sum(ects)
from inscricoes natural join cadeiras
where anoLetivo = 2016 and numero = 53009;

-- Se agora o desinscrevermos à cadeira 7996, depois já o conseguimos inscrever à 7336
delete from inscricoes where cadeira = 7996;
insert into inscricoes values (53009, 'G005', 7336, 2016, to_date('2016.09.10','YYYY.MM.DD'));
select * from inscricoes natural join cadeiras;

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
alter table colocados drop constraint un_col;
alter table colocados add constraint pk_col primary key (idCandidato, ano);
alter table matriculas drop constraint fk_matrcolcurso;

-- Nota: com isto o esquema deixa de estar normalizado!
-- Repare que idCandidato -> Nome 
-- Antes isso não tinha problema pois idCandidato era chave. Mas agora deixa de ser!
-- Haveria que decompor a tabela de colocações em duas:
-- nomesColocados(idCandidato, Nome)
-- colocados(idCandidato, curso, ano).

-- Por agora, para simplificar o exercício, não vamos fazer isso, tendo apenas o cuidado de manter a consistência dos nomes
-- Fica como exercício extra fazer a coisa como deve ser. Ou seja, com a decomposição.

-- Vamos então adicionar algumas colocações, agora para Matemática, para o aluno que já tinha inscrições
insert into colocados values (122264,'PEDRO M. S. L.','9209',2016);
-- Dá erro, pois no mesmo ano não pode ser!
-- Mas em 2017 já deve dar...
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
alter table matriculas add constraint uni_num_cur unique (numero, curso);
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

-- Podemos verificar que ficou matriculado
select * from matriculas;

-- que a sua anterior matrícula ficou inativa  
select * from inativas;

-- e que em 2017 está inscrito a todas as cadeiras do primeiro ano de Matemática 
-- mantendo-se as suas inscrições em 2016 em informática
select * from inscricoes;

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

-- Tentemos inscrever o aluno que mudou de curso (no meu caso é o 53021, mas no seu pode ser diferente)
-- numa cadeira do curso de matemática
insert into inscricoes values (53021, '9209', 3107, 2017, to_date('2017.09.11','YYYY.MM.DD'));
-- Inscreveu sem problema, certo?

-- Tentemos agora inscrevê-lo numa cadeira de informática
insert into inscricoes values (53021, 'G005', 2468, 2017, to_date('2017.09.11','YYYY.MM.DD'));
-- Agora não dá porque o aluno 50021 não é de Informática - o aluno 53009 é que era!

-- tentemos então inscrever o aluno 53009 (pode ser nº diferente no seu caso) nessa cadeira de Informática
insert into inscricoes values (53009, 'G005', 2468, 2017, to_date('2017.09.11','YYYY.MM.DD'));

-- E cá está o erro! Esse aluno já não é do curso de Informática!
