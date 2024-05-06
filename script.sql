CREATE USER 'totemMaster'@'localhost' IDENTIFIED BY '12345';
GRANT ALL PRIVILEGES ON *.* TO 'totemMaster'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;

DROP DATABASE if exists totemTech;
CREATE DATABASE totemTech;
USE totemTech;

-- Criação das tabelas

CREATE TABLE endereco (
  idEndereco INT primary key AUTO_INCREMENT,
  logradouro VARCHAR(45),
  bairro VARCHAR(45),
  numero INT,
  cep CHAR(8),
  complemento VARCHAR(45));


CREATE TABLE contrato (
  idplano INT primary key auto_increment,
  codigo CHAR(9),
  contasContratadas INT,
  dtInicio DATE,
  dtFinal DATE);


CREATE TABLE empresa (
  idEmpresa INT primary key auto_increment,
  nome VARCHAR(45),
  codigoAcesso CHAR(6),
  endereco INT,
  assinatura INT,
  razaoSocial VARCHAR(65),
  nomeFantasia VARCHAR(45),
  cnpj CHAR(15),
  CONSTRAINT fk_empresa_endereco
    FOREIGN KEY (endereco)
    REFERENCES endereco (idEndereco),
  CONSTRAINT fk_empresa_assinatura
    FOREIGN KEY (assinatura)
    REFERENCES contrato (idplano));



CREATE TABLE tipo (
  idtipo INT primary key AUTO_INCREMENT,
  descricao VARCHAR(45));



CREATE TABLE usuario (
  idusuario INT primary key auto_increment,
  nome VARCHAR(45),
  email VARCHAR(70) unique,
  senha VARCHAR(12),
  empresa INT,
  tipo INT,
  CONSTRAINT fk_usuario_empresa
    FOREIGN KEY (empresa)
    REFERENCES empresa (idEmpresa),
  CONSTRAINT fk_usuario_tipo
    FOREIGN KEY (tipo)
    REFERENCES tipo (idtipo));


CREATE TABLE totem (
  idtotem INT primary key auto_increment,
  nome VARCHAR(45),
  login VARCHAR(45) unique,
  senha VARCHAR(45),
  sistemaOperacional VARCHAR(45),
  empresa INT,
  CONSTRAINT fk_totem_empresa
    FOREIGN KEY (empresa)
    REFERENCES empresa (idEmpresa));


CREATE TABLE interrupcoes (
  idinterrupcoes INT primary key AUTO_INCREMENT,
  horario DATETIME default current_timestamp,
  motivo VARCHAR(45),
  totem INT,
  CONSTRAINT fk_interrupcoes_totem
    FOREIGN KEY (totem)
    REFERENCES totem (idtotem));
    

CREATE TABLE cpu (
  idcpu INT auto_increment,
  medidaVelocidade VARCHAR(45),
  velocidadeBase Double,
  totem INT,
  PRIMARY KEY (idcpu, totem),
  CONSTRAINT fk_cpu_totem
    FOREIGN KEY (totem)
    REFERENCES totem (idtotem));


CREATE TABLE cpuRegistro (
  idcpuRegistro INT auto_increment,
  utilizacao DOUBLE,
  horario DATETIME default current_timestamp,
  processos INT,
  cpu INT,
  totem INT,
  PRIMARY KEY (idcpuRegistro, cpu, totem),
  CONSTRAINT fk_cpuRegistro_cpu
    FOREIGN KEY (cpu, totem)
    REFERENCES cpu (idcpu, totem));


CREATE TABLE redeRegistro (
  idredeRegistro INT auto_increment,
  velocidade DOUBLE,
  horario DATETIME default current_timestamp,
  totem INT,
  PRIMARY KEY (idredeRegistro, totem),
  CONSTRAINT fk_redeRegistro_totem
    FOREIGN KEY (totem)
    REFERENCES totem (idtotem));


CREATE TABLE memoria (
  idmemoria INT auto_increment,
  total DOUBLE,
  medida VARCHAR(45),
  totem INT,
  PRIMARY KEY (idmemoria, totem),
  CONSTRAINT fk_memoria_totem
    FOREIGN KEY (totem)
    REFERENCES totem (idtotem));


CREATE TABLE disco (
  iddisco INT auto_increment,
  tipo VARCHAR(90),
  total DOUBLE,
  medida VARCHAR(45),
  totem INT,
  PRIMARY KEY (iddisco, totem),
  CONSTRAINT fk_disco_totem
    FOREIGN KEY (totem)
    REFERENCES totem (idtotem));


CREATE TABLE discoRegistro (
  iddiscoRegistro INT auto_increment,
  valor DOUBLE,
  horario DATETIME default current_timestamp,
  disco INT,
  totem INT,
  PRIMARY KEY (iddiscoRegistro, disco, totem),
  CONSTRAINT fk_discoRegistro_disco
    FOREIGN KEY (disco, totem)
    REFERENCES disco (iddisco , totem));


CREATE TABLE visualizacao (
  idvisualizacao INT primary key AUTO_INCREMENT,
  cpu INT,
  memoria INT,
  disco INT,
  rede INT,
  totem INT,
  CONSTRAINT fk_componente_totem
    FOREIGN KEY (totem)
    REFERENCES totem (idtotem));


CREATE TABLE memoriaRegistro (
  idmemoriaRegistro INT auto_increment,
  valor DOUBLE,
  horario DATETIME default current_timestamp,
  memoria INT,
  totem INT,
  PRIMARY KEY (idmemoriaRegistro, memoria, totem),
  CONSTRAINT fk_memoriaRegistro_memoria
    FOREIGN KEY (memoria, totem)
    REFERENCES memoria (idmemoria, totem));


-- INSERTS

INSERT INTO endereco (logradouro, bairro, numero, cep, complemento)
VALUES ('Rua das Flores', 'Centro', 123, '12345678', 'Bloco A');

INSERT INTO contrato (codigo, contasContratadas, dtInicio, dtFinal)
VALUES ('C12345678', 50, '2024-05-01', '2025-04-30');

INSERT INTO empresa (nome, codigoAcesso, endereco, assinatura, razaoSocial, nomeFantasia, cnpj)
VALUES ('MC Donalds', 'ABC456', 1, 1, 'Mec', 'Mec', '12345678901234');

INSERT INTO tipo (descricao)
VALUES ('Funcionários'), ('Gerente');

INSERT INTO usuario (nome, email, senha, empresa, tipo)
VALUES ('Gabriel', 'gabriel.amaral@sptech.school', '123', 1, 2), 
('João Silva', 'joao.silva@empresa.com', 'senha123', 1, 1),
('Tallyon Lima', 'tallyon.lima@sptech.school', '123456', 1, 2);

INSERT INTO totem (nome, login, senha, sistemaOperacional, empresa) VALUES
('Totem 1', 'login1', 'senha123', 'Windows', 1),
('Totem 2', 'login2', 'senha123', 'Linux', 1),
('Totem 3', 'login3', 'senha123', 'Windows', 1),
('Totem 4', 'login4', 'senha123', 'Linux', 1),
('Totem 5', 'login5', 'senha123', 'Windows', 1),
('Totem 6', 'login6', 'senha123', 'Linux', 1),
('Totem 7', 'login7', 'senha123', 'Windows', 1),
('Totem 8', 'login8', 'senha123', 'Linux', 1),
('Totem 9', 'login9', 'senha123', 'Windows', 1),
('Totem 10', 'login10', 'senha123', 'Linux', 1);


INSERT INTO interrupcoes (horario, motivo, totem)
VALUES ('2024-04-20 10:30:00', 'Memória RAM', 1);

INSERT INTO cpu (idcpu, medidaVelocidade, velocidadeBase, totem)
VALUES (1, 'GHz', '3.2', 1);

INSERT INTO memoria (total, medida, totem)
VALUES 
    (16.0, 'GB', 1),
    (16, 'GB', 2),
    (32, 'GB', 3),
    (4, 'GB', 4),
    (8, 'GB', 5),
    (8, 'GB', 6),
    (12, 'GB', 7),
    (16, 'GB', 8),
    (8, 'GB', 9),
    (8, 'GB', 10);

-- INSERT INTO disco (tipo, total, medida, totem)
-- VALUES 
--     ('SSD', 512, 'GB', 1),
--     ('HDD', 2000, 'GB', 1),
--     ('SSD', 256, 'GB', 2),
--    ('SSD', 512, 'GB', 3),
--    ('HDD', 4000, 'GB', 3),
--    ('SSD', 256, 'GB', 4),
--    ('SSD', 512, 'GB', 5),
--    ('HDD', 3000, 'GB', 5),
--    ('SSD', 256, 'GB', 6),
--    ('SSD', 512, 'GB', 7),
--    ('HDD', 2000, 'GB', 7),
--    ('SSD', 256, 'GB', 8),
--    ('SSD', 512, 'GB', 9),
--    ('HDD', 2000, 'GB', 9),
--    ('HDD', 3000, 'GB', 10);

-- INSERT INTO discoRegistro (valor, horario, disco, totem)
-- VALUES (180.0, '2024-04-20 12:00:00', 1, 1);

INSERT INTO visualizacao (cpu, memoria, disco, rede, totem)
VALUES 
    (1, 1, 1, 1, 1),
    (0, 1, 0, 1, 2),
    (1, 0, 1, 1, 3),
    (0, 1, 0, 1, 4),
    (1, 1, 1, 0, 5),
    (1, 0, 1, 1, 6),
    (1, 1, 0, 0, 7),
    (0, 0, 1, 1, 8),
    (1, 1, 1, 1, 9),
    (0, 0, 0, 1, 10);

INSERT INTO memoriaRegistro (valor, horario, memoria, totem)
VALUES (65.6, '2024-04-20 12:30:00', 1, 1);

-- SELECTS DE TESTE
select * from empresa;
select * from usuario;
select * from totem;
select * from cpu;
select * from memoria;
select * from disco;	
select * from interrupcoes;
select * from visualizacao;


DELIMITER $$
CREATE PROCEDURE excluirTudoTotem (iddTotem int)
BEGIN 
DELETE FROM visualizacao WHERE totem = iddTotem;

DELETE FROM memoria WHERE totem = iddTotem;

DELETE FROM disco WHERE totem = iddTotem;

DELETE FROM totem WHERE idtotem  = iddTotem;
END$$
DELIMITER 

select * from disco;

 select * from discoRegistro;
-- select * from memoria;
-- select * from memoriaRegistro;
-- select * from redeRegistro;
-- select * from cpu;
-- select * from cpuRegistro;
