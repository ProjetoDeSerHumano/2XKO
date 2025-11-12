CREATE TABLE usuario(

	idUsuario bigserial constraint pk_usuario PRIMARY KEY,
	username varchar(12) UNIQUE,
	password text,
	pontos decimal,
	deleted boolean DEFAULT false

);

CREATE TABLE premio(

	idPremio bigserial constraint pk_premio PRIMARY KEY,
	nome varchar(50),
	custo decimal,
	deleted boolean DEFAULT false,
	imagem text,
	quantidade integer

);

CREATE TABLE historicoRoleta(

	idRoleta bigserial constraint pk_roleta PRIMARY KEY,
	vlrGanho integer,
	vlrPerdido integer,
	mensagem text,
	dataRoleta date,
	idUsuario bigint constraint fk_usuario_roleta REFERENCES usuario,
	deleted boolean DEFAULT false
		
);

CREATE TABLE resgatarPremio(
		
	status text,
	dataResgate date,
	idResgate bigserial constraint pk_resgate PRIMARY KEY,
	idPremio bigint constraint fk_premio REFERENCES premio(idPremio),
	idUsuario bigint constraint fk_usuario REFERENCES usuario(idUsuario),
	deleted boolean DEFAULT false
);

CREATE EXTENSION if NOT EXISTS pgcrypto;