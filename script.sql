CREATE USER if not exists 'totemMaster'@'localhost' IDENTIFIED BY '12345';
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
  tipo VARCHAR(45),
  limiteUsuarios INT,
  limiteTotens INT,
  dtInicio DATE,
  dtFinal DATE);


CREATE TABLE empresa (
  idEmpresa INT primary key auto_increment,
  nome VARCHAR(45),
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
    
CREATE TABLE componentes (
	idcomponente INT auto_increment,
    totem int,
    tipo VARCHAR(45),
    nome VARCHAR(45),
    total Double,
    minimo Double,
    maximo Double,
    CONSTRAINT fk_componente_totem
		FOREIGN KEY (totem)
        REFERENCES totem (idtotem),
	primary key (idcomponente, totem));
    
CREATE TABLE registros(
	idregistro INT auto_increment,
    valor VARCHAR(45),
    unidadeDeMedida VARCHAR(45),
    horario DATETIME default current_timestamp,
    componente INT,
    CONSTRAINT fk_registro_componente
		FOREIGN KEY (componente)
        REFERENCES componentes (idcomponente),
	primary key (idregistro, componente));


CREATE TABLE interrupcoes (
  idinterrupcoes INT primary key AUTO_INCREMENT,
  horario DATETIME default current_timestamp,
  motivo VARCHAR(45),
  totem INT,
  CONSTRAINT fk_interrupcoes_totem
    FOREIGN KEY (totem)
    REFERENCES totem (idtotem));


CREATE TABLE visualizacao (
  idvisualizacao INT primary key AUTO_INCREMENT,
  cpu INT,
  memoria INT,
  disco INT,
  rede INT,
  totem INT,
  CONSTRAINT fk_visualizacao_totem
    FOREIGN KEY (totem)
    REFERENCES totem (idtotem));

-- PROCEDURES

DELIMITER $$
CREATE PROCEDURE excluirTudoTotem (iddTotem int)
BEGIN 
DELETE FROM visualizacao WHERE totem = iddTotem;

DELETE FROM memoria WHERE totem = iddTotem;

DELETE FROM disco WHERE totem = iddTotem;

DELETE FROM totem WHERE idtotem  = iddTotem;
END$$
DELIMITER 

-- INSERTS

INSERT INTO contrato (tipo, limiteUsuarios, limiteTotens, dtInicio, dtFinal) VALUES 
	('Básico', 10, 5, '2024-01-01', '2024-12-31'),
	('Premium', 50, 25, '2024-01-01', '2024-12-31');

INSERT INTO endereco (logradouro, bairro, numero, cep, complemento) VALUES 
	('Rua das Flores', 'Centro', 123, '12345678', 'Bloco A');

INSERT INTO tipo (descricao) VALUES
	('Funcionários'),
	('Gerente');

INSERT INTO empresa (nome, endereco, assinatura, razaoSocial, nomeFantasia, cnpj) VALUES
	('MC Donalds', 1, 1, 'Mec', 'Mec', '12345678901234');

INSERT INTO usuario (nome, email, senha, empresa, tipo) VALUES
	('Gabriel', 'gabriel.amaral@sptech.school', '123', 1, 2), 
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
    
INSERT INTO componentes (totem, tipo, nome, total, minimo, maximo) VALUES
	(1, 'CPU', 'Intel i7', 3.4, 1.0, 4.0),
	(2, 'RAM', 'Corsair 16GB', 16.0, 2.0, 32.0),
	(3, 'HDD', 'Seagate 1TB', 1024.0, 100.0, 2000.0);
    
INSERT INTO registros (valor, unidadeDeMedida, componente) VALUES
	('2.5', 'GHz', 1),
	('8', 'GB', 2),
	('500', 'GB', 3);

-- SELECTS DE TESTE
select * from empresa;
select * from usuario;
select * from totem;
select * from interrupcoes;
select * from visualizacao;
