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
  idusuario INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45),
  email VARCHAR(70) UNIQUE,
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
	idtotem INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45),
    login VARCHAR(45) UNIQUE,
    senha VARCHAR(45),
    sistemaOperacional VARCHAR(45),
    empresa INT,
    CONSTRAINT fk_totem_empresa
        FOREIGN KEY (empresa)
        REFERENCES empresa(idEmpresa)
);


CREATE TABLE tipoComponente (
    idtipoComponente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45)
);


CREATE TABLE componente (
    idcomponente INT AUTO_INCREMENT,
    totem INT,
    nome VARCHAR(45),
    tipo INT,
    CONSTRAINT fk_componente_tipo
        FOREIGN KEY (tipo)
        REFERENCES tipoComponente(idtipoComponente),
    CONSTRAINT fk_componente_totem
        FOREIGN KEY (totem)
        REFERENCES totem(idtotem),
    PRIMARY KEY (idcomponente)
);


CREATE TABLE especificacao (
    idespecificacao INT AUTO_INCREMENT,
    nome VARCHAR(45),
    valor VARCHAR(45),
    unidadeMedida VARCHAR(45),
    componente INT,
    tipo INT,
    CONSTRAINT fk_especificacao_componente
        FOREIGN KEY (componente)
        REFERENCES componente(idcomponente),
    CONSTRAINT fk_especificacao_tipo
        FOREIGN KEY (tipo)
        REFERENCES tipoComponente(idtipoComponente),
    PRIMARY KEY (idespecificacao)
);

    
CREATE TABLE registro (
    idregistro INT AUTO_INCREMENT,
    valor VARCHAR(45),
    horario DATETIME DEFAULT CURRENT_TIMESTAMP,
    componente INT,
    CONSTRAINT fk_registros_componente
        FOREIGN KEY (componente)
        REFERENCES componente(idcomponente),
    PRIMARY KEY (idregistro)
);

CREATE TABLE interrupcoes (
	idinterrupcoes INT AUTO_INCREMENT PRIMARY KEY,
	horario DATETIME DEFAULT CURRENT_TIMESTAMP,
	motivo VARCHAR(45),
	totem INT,
  CONSTRAINT fk_interrupcoes_totem
    FOREIGN KEY (totem)
    REFERENCES totem (idtotem));


CREATE TABLE visualizacao (
    idvisualizacao INT AUTO_INCREMENT PRIMARY KEY,
    cpu INT,
    memoria INT,
    disco INT,
    rede INT,
    totem INT,
    CONSTRAINT fk_visualizacao_totem
        FOREIGN KEY (totem)
        REFERENCES totem(idtotem)
);


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

INSERT INTO interrupcoes (motivo, totem)
VALUES ('Memória RAM', 1);

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

INSERT INTO tipoComponente (nome) VALUES
	('CPU'),
	('RAM'),
	('HDD'),
  ('Rede');

INSERT INTO componente (totem, tipo, nome) VALUES
	(1, 1, 'Intel i7'),  
	(2, 2, 'Corsair 16GB'),  
	(3, 3, 'Seagate 1TB'),
  (5, 5, 'Ethernet Adapter'),;  

INSERT INTO especificacao (nome, valor, unidadeMedida, componente, tipo) VALUES
	('Frequência', '3.4', 'GHz', 1, 1),  
	('Capacidade', '16', 'GB', 2, 2), 
  ('Velocidade', '1', 'Gbps', 5, 5), 
	('Armazenamento', '1024', 'GB', 3, 3); 

INSERT INTO registro (valor, componente) VALUES
	('2.5', 1),
	('8', 2),
  ('0.9', 5),
	('500', 3);

-- SELECT TESTS
SELECT * FROM empresa;
SELECT * FROM usuario;
SELECT * FROM totem;
SELECT * FROM tipoComponente;
SELECT * FROM interrupcoes;
SELECT * FROM visualizacao;