drop table rankings cascade constraints;
drop table pilotos cascade constraints;
drop table aeronaves cascade constraints;
drop table pilota cascade constraints;
drop table esquadroes cascade constraints;
drop table pertence cascade constraints;
drop table modelos cascade constraints;
drop table participa cascade constraints;
drop table missoes cascade constraints;
drop table sorties cascade constraints;
drop table armamentos cascade constraints;

drop trigger alreadyBelongsEsquadrao;
drop trigger addEsquadrao;
drop trigger removeEsquadrao;
drop trigger nonExistMissao;
drop trigger excceededCapacity;
drop trigger addPiloto;
drop trigger addSortie;

drop sequence seq_idPiloto;
drop sequence seq_numEsquadrao;
drop sequence seq_idArm;

create sequence seq_idPiloto
start with 1
increment by 1;

create sequence seq_numEsquadrao
start with 1
increment by 1;

create sequence seq_idArm
start with 1
increment by 1;

create table rankings (
	ranking varchar(20) primary key,
	titulo varchar(20)
);

create table pilotos (
	id number primary key,
	nome varchar(20),
	ranking varchar(20),
	licencaPiloto number not null,
	camarata varchar(20),
	horasVoo number default 0 check(horasVoo >= 0),
	foreign key(ranking) references rankings
);

create table modelos (
	nome varchar(20) primary key,
	fabricante varchar(20),
	lugares number not null,
	especializacao varchar(30),
	autonomia number not null, check(autonomia > 0)
);

create table aeronaves (
	id number primary key,
	idade number not null check(idade >= 0),
	horasVoo number default 0 check(horasVoo >= 0),
	nome varchar(20),
	foreign key (nome) references modelos
);

create table pilota (
	idPiloto number,
	idAeronave number,
	primary key(idPiloto, idAeronave),
	foreign key (idPiloto) references pilotos,
	foreign key (idAeronave) references aeronaves
);

create table esquadroes (
	numero number,
	tipo varchar(20),
	estadoOperacional varchar(20),
	numMembros number,
	primary key (numero, tipo)
);

create table pertence (
	idPiloto number,
	idAeronave number,
	numero number not null,
	tipo varchar(20),
	primary key (idPiloto, idAeronave),
	foreign key (idPiloto, idAeronave) references pilota,
	foreign key (numero, tipo) references esquadroes
);

create table missoes (
	codmissao number primary key,
	localizacao varchar(20),
	tipoMissao varchar(20)
);

create table participa (
	id number,
	codMissao number,
	primary key (id, codMissao),
	foreign key (id) references aeronaves,
	foreign key (codMissao) references missoes
);

create table armamentos (
	idArm number primary key,
	tipo varchar(20),
	modelo varchar(20)
);

create table sorties (
	codMissao number,
	numSortie number,
	data date,
	combustivel number check(combustivel >= 0),
	armamento number default null check (armamento >=0),
	primary key (codMissao, numSortie),
	foreign key (codMissao) references missoes,
	foreign key (armamento) references armamentos
);

create trigger alreadyBelongsEsquadrao before insert on pertence
for each row
declare 
	numEsquadrao number;
begin
	select numero into numEsquadrao
	from pertence
	where :new.idAeronave = pertence.idAeronave and
		  :new.idPiloto = pertence.idPiloto;
		  
	if numEsquadrao != :new.numero then
		Raise_Application_Error (-20100, 'Aeronave e/ou piloto ja pertencem a um esquadrao.');
	end if;	
		  
exception
	when NO_DATA_FOUND then
		null;
end;
/

create trigger addEsquadrao after insert on pertence
for each row
declare 
	numEsquadrao number;
	membros number;
begin
	select numero into numEsquadrao
	from esquadroes
	where :new.numero = esquadroes.numero;
		  
	update esquadroes
	set numMembros = numMembros + 1
	where numEsquadrao = numero;
	
	select numMembros into membros
	from esquadroes
	where :new.numero = esquadroes.numero;
	
	if membros > 5 then
		update esquadroes
		set estadoOperacional = 'ativo'
		where numEsquadrao = numero;
	end if;
end;
/

create trigger removeEsquadrao after delete on pertence
for each row
declare 
	numEsquadrao number;
	membros number;
begin
	select numero into numEsquadrao
	from esquadroes
	where :new.numero = esquadroes.numero;
		  
	update esquadroes
	set numMembros = numMembros - 1
	where numEsquadrao = numero;
	
	select numMembros into membros
	from esquadroes
	where :new.numero = esquadroes.numero;
	
	if membros <= 5 then
		update esquadroes
		set estadoOperacional = 'recruta'
		where numEsquadrao = numero;
	end if;
end;
/

create trigger nonExistMissao before insert on sorties
for each row
declare 
	codMissao number;
begin
	select codMissao into codMissao
	from missoes
	where :new.codMissao = missoes.codmissao;
	
exception
	when NO_DATA_FOUND then
		Raise_Application_Error (-20100, 'Missao inexistente.');
end;
/

create trigger excceededCapacity before insert on pilota
for each row
declare
	numPilotos number;
	capacity number;
begin
	select count(*) into numPilotos
	from pilota
	where :new.idAeronave = pilota.idAeronave;
	
	select lugares into capacity
	from aeronaves inner join modelos using(nome)
	where aeronaves.id = :new.idAeronave;
	
	if numPilotos >= capacity then
		Raise_Application_Error (-20100, 'Capacidade da aeronave excedida.');
	end if;
end;
/

create trigger addPiloto before insert on pilotos
for each row
declare
	licenca number;
begin
	:new.id := seq_idPiloto.nextval;
	
	select licencaPiloto into licenca
	from pilotos
	where :new.licencaPiloto = pilotos.licencaPiloto;
	
	if licenca = :new.licencaPiloto then
		Raise_Application_Error (-20100, 'Licenca de piloto ja inserida.');
	end if;
	
exception
	when NO_DATA_FOUND then
		null;
end;
/

create trigger addSortie before insert on sorties
for each row
declare
	idArmamento number;
begin
	select idArm into idArmamento
	from armamentos
	where :new.armamento = armamentos.idArm;
	
exception
	when NO_DATA_FOUND then
		Raise_Application_Error (-20100, 'Armamento nao pertence a base de dados.');
end;
/

--Valores a inserir

--modelos

insert into modelos values ('EA-18G Growler', 'Boeing', 2, 'Electronic warfare', 2346);
insert into modelos values ('E-2 Hawkeye', 'Northrop Grumman', 5, 'Airborne early warning', 2708);
insert into modelos values ('F/A-18 Hornet', 'McDonnell Douglas', 2, 'Multirole Combat', 2017);
insert into modelos values ('F/A-18F Super Hornet', 'McDonnell Douglas', 2, 'Multirole Combat', 3330);
insert into modelos values ('P-3C Orion', 'Loockheed', 12, 'Maritime surveillance', 4400);
insert into modelos values ('P-8A Poseidon', 'Boeing', 22, 'Anti-submarine warfare', 8300);
insert into modelos values ('EP-3E Aries II', 'Loockheed', 22, 'Air reconnaissance', 5556);
insert into modelos values ('E-6 Mercury', 'Boeing', 22, 'Air reconnaissance', 12144);

--esquadroes

insert into esquadroes values (seq_numEsquadrao.nextval, 'VAQ', 'recruta', 0);
insert into esquadroes values (seq_numEsquadrao.nextval, 'VAQ', 'recruta', 0);
insert into esquadroes values (seq_numEsquadrao.nextval, 'VAQ', 'recruta', 0);
insert into esquadroes values (seq_numEsquadrao.nextval, 'VAW', 'recruta', 0);
insert into esquadroes values (seq_numEsquadrao.nextval, 'VAW', 'recruta', 0);
insert into esquadroes values (seq_numEsquadrao.nextval, 'VAW', 'recruta', 0);
insert into esquadroes values (seq_numEsquadrao.nextval, 'VFA', 'recruta', 0);
insert into esquadroes values (seq_numEsquadrao.nextval, 'VFA', 'recruta', 0);
insert into esquadroes values (seq_numEsquadrao.nextval, 'VFA', 'recruta', 0);
insert into esquadroes values (seq_numEsquadrao.nextval, 'VFC', 'recruta', 0);
insert into esquadroes values (seq_numEsquadrao.nextval, 'VFC', 'recruta', 0);
insert into esquadroes values (seq_numEsquadrao.nextval, 'VFC', 'recruta', 0);
insert into esquadroes values (seq_numEsquadrao.nextval, 'VP', 'recruta', 0);
insert into esquadroes values (seq_numEsquadrao.nextval, 'VP', 'recruta', 0);
insert into esquadroes values (seq_numEsquadrao.nextval, 'VP', 'recruta', 0);
insert into esquadroes values (seq_numEsquadrao.nextval, 'VQ', 'recruta', 0);
insert into esquadroes values (seq_numEsquadrao.nextval, 'VQ', 'recruta', 0);
insert into esquadroes values (seq_numEsquadrao.nextval, 'VQ', 'recruta', 0);

--rankings

insert into rankings values('ENS', 'Ensign');
insert into rankings values('LTJG', 'Lieutenant (junior)');
insert into rankings values('LT', 'Lieutenant');
insert into rankings values('LCDR', 'Lieutenant Commander');
insert into rankings values('CDR', 'Commander');
insert into rankings values('CAPT', 'Captain');

--armamentos

insert into armamentos values(seq_idArm.nextval, 'Municao', '20x102');
insert into armamentos values(seq_idArm.nextval, 'AShM', 'AGM-84');
insert into armamentos values(seq_idArm.nextval, 'SEAD', 'AGM-88');
insert into armamentos values(seq_idArm.nextval, 'IR_AGM', 'AGM-65');
insert into armamentos values(seq_idArm.nextval, 'AShM', 'AGM-119');
insert into armamentos values(seq_idArm.nextval, 'IR_AAM', 'AIM-9');
insert into armamentos values(seq_idArm.nextval, 'RAD_AAM', 'AIM-7');
insert into armamentos values(seq_idArm.nextval, 'RAD_AAM', 'AIM-120');
insert into armamentos values(seq_idArm.nextval, 'GBU', 'GBU-27/B');
insert into armamentos values(seq_idArm.nextval, 'CBU', 'CBU-100');
insert into armamentos values(seq_idArm.nextval, 'BLU', 'Mk82');

--pilotos

insert into pilotos(nome, ranking, licencaPiloto, camarata, horasVoo, idSuperior) values('Piloto1', 'ENS', '456', 'Piso 3', 0, null);
insert into pilotos(nome, ranking, licencaPiloto, camarata, horasVoo, idSuperior) values('Piloto2', 'CAPT', '333', 'Piso 1', 2, null);
insert into pilotos(nome, ranking, licencaPiloto, camarata, horasVoo, idSuperior) values('Piloto3', 'CDR', '123', 'Piso 1', 4, null);
insert into pilotos(nome, ranking, licencaPiloto, camarata, horasVoo, idSuperior) values('Piloto4', 'LT', '98', 'Piso 2', 5, null);
insert into pilotos(nome, ranking, licencaPiloto, camarata, horasVoo, idSuperior) values('Piloto5', 'LCDR', '3457', 'Piso 3', 6, null);
insert into pilotos(nome, ranking, licencaPiloto, camarata, horasVoo, idSuperior) values('Piloto6', 'LT', '11', 'Piso 2', 2, null);
insert into pilotos(nome, ranking, licencaPiloto, camarata, horasVoo, idSuperior) values('Piloto7', 'ENS', '1000', 'Piso 3', 0, null);
insert into pilotos(nome, ranking, licencaPiloto, camarata, horasVoo, idSuperior) values('Piloto8', 'ENS', '63565', 'Piso 3', 0, null);
insert into pilotos(nome, ranking, licencaPiloto, camarata, horasVoo, idSuperior) values('Piloto9', 'ENS', '43', 'Piso 3', 0, null);
insert into pilotos(nome, ranking, licencaPiloto, camarata, horasVoo, idSuperior) values('Piloto10', 'LTJG', '654', 'Piso 2', 3, null);
insert into pilotos(nome, ranking, licencaPiloto, camarata, horasVoo, idSuperior) values('Piloto11', 'CDR', '8964', 'Piso 1', 7, null);
insert into pilotos(nome, ranking, licencaPiloto, camarata, horasVoo, idSuperior) values('Piloto12', 'LTJG', '32', 'Piso 3', 0, null);

--aeronaves

insert into aeronaves values(324, 2, 12, 'EA-18G Growler');
insert into aeronaves values(111, 1, 0, 'E-2 Hawkeye');
insert into aeronaves values(666, 1, 0, 'F/A-18F Super Hornet');
insert into aeronaves values(954, 6, 24, 'F/A-18F Super Hornet');
insert into aeronaves values(245, 5, 35, 'P-3C Orion');
insert into aeronaves values(3344, 5, 29, 'P-3C Orion');
insert into aeronaves values(4314, 5, 31, 'EP-3E Aries II');
insert into aeronaves values(332, 3, 20, 'E-2 Hawkeye');
insert into aeronaves values(434, 4, 24, 'EA-18G Growler');
insert into aeronaves values(653, 2, 10, 'P-8A Poseidon');
insert into aeronaves values(975, 1, 0, 'E-2 Hawkeye');
insert into aeronaves values(431, 1, 0, 'P-8A Poseidon');
insert into aeronaves values(967, 1, 0, 'F/A-18 Hornet');
insert into aeronaves values(54, 2, 12, 'E-6 Mercury');
insert into aeronaves values(6533, 3, 18, 'F/A-18 Hornet');
insert into aeronaves values(3646, 1, 0, 'F/A-18F Super Hornet');
insert into aeronaves values(3245, 1, 0, 'EP-3E Aries II');

