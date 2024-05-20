-- CREATE USER and DATABASE
IF NOT EXISTS (SELECT * FROM sys.sql_logins WHERE name = N'totemMaster')
BEGIN
    CREATE LOGIN totemMaster WITH PASSWORD = '12345';
    CREATE USER totemMaster FOR LOGIN totemMaster;
    EXEC sp_addsrvrolemember 'totemMaster', 'sysadmin';
END;
GO

-- Remover restrições de chave estrangeira
IF OBJECT_ID('dbo.fk_empresa_endereco', 'F') IS NOT NULL ALTER TABLE dbo.empresa DROP CONSTRAINT fk_empresa_endereco;
IF OBJECT_ID('dbo.fk_empresa_assinatura', 'F') IS NOT NULL ALTER TABLE dbo.empresa DROP CONSTRAINT fk_empresa_assinatura;
IF OBJECT_ID('dbo.fk_usuario_empresa', 'F') IS NOT NULL ALTER TABLE dbo.usuario DROP CONSTRAINT fk_usuario_empresa;
IF OBJECT_ID('dbo.fk_usuario_tipo', 'F') IS NOT NULL ALTER TABLE dbo.usuario DROP CONSTRAINT fk_usuario_tipo;
IF OBJECT_ID('dbo.fk_totem_empresa', 'F') IS NOT NULL ALTER TABLE dbo.totem DROP CONSTRAINT fk_totem_empresa;
IF OBJECT_ID('dbo.fk_componente_totem', 'F') IS NOT NULL ALTER TABLE dbo.componentes DROP CONSTRAINT fk_componente_totem;
IF OBJECT_ID('dbo.fk_registro_componente', 'F') IS NOT NULL ALTER TABLE dbo.registros DROP CONSTRAINT fk_registro_componente;
IF OBJECT_ID('dbo.fk_interrupcoes_totem', 'F') IS NOT NULL ALTER TABLE dbo.interrupcoes DROP CONSTRAINT fk_interrupcoes_totem;
IF OBJECT_ID('dbo.fk_visualizacao_totem', 'F') IS NOT NULL ALTER TABLE dbo.visualizacao DROP CONSTRAINT fk_visualizacao_totem;
GO

IF OBJECT_ID('dbo.empresa', 'U') IS NOT NULL DROP TABLE dbo.empresa;
IF OBJECT_ID('dbo.endereco', 'U') IS NOT NULL DROP TABLE dbo.endereco;
IF OBJECT_ID('dbo.contrato', 'U') IS NOT NULL DROP TABLE dbo.contrato;
IF OBJECT_ID('dbo.tipo', 'U') IS NOT NULL DROP TABLE dbo.tipo;
IF OBJECT_ID('dbo.usuario', 'U') IS NOT NULL DROP TABLE dbo.usuario;
IF OBJECT_ID('dbo.totem', 'U') IS NOT NULL DROP TABLE dbo.totem;
IF OBJECT_ID('dbo.componentes', 'U') IS NOT NULL DROP TABLE dbo.componentes;
IF OBJECT_ID('dbo.registros', 'U') IS NOT NULL DROP TABLE dbo.registros;
IF OBJECT_ID('dbo.interrupcoes', 'U') IS NOT NULL DROP TABLE dbo.interrupcoes;
IF OBJECT_ID('dbo.visualizacao', 'U') IS NOT NULL DROP TABLE dbo.visualizacao;
IF OBJECT_ID('dbo.excluirTudoTotem', 'P') IS NOT NULL DROP PROCEDURE dbo.excluirTudoTotem;
GO

CREATE DATABASE totemTech;
GO

USE totemTech;
GO

-- CREATE TABLES

CREATE TABLE endereco (
  idEndereco INT PRIMARY KEY IDENTITY,
  logradouro VARCHAR(45),
  bairro VARCHAR(45),
  numero INT,
  cep CHAR(8),
  complemento VARCHAR(45)
);

CREATE TABLE contrato (
  idplano INT PRIMARY KEY IDENTITY,
  tipo VARCHAR(45),
  limiteUsuarios INT,
  limiteTotens INT,
  dtInicio DATE,
  dtFinal DATE
);

CREATE TABLE empresa (
  idEmpresa INT PRIMARY KEY IDENTITY,
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
    REFERENCES contrato (idplano)
);

CREATE TABLE tipo (
  idtipo INT PRIMARY KEY IDENTITY,
  descricao VARCHAR(45)
);

CREATE TABLE usuario (
  idusuario INT PRIMARY KEY IDENTITY,
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
    REFERENCES tipo (idtipo)
);

CREATE TABLE totem (
  idtotem INT PRIMARY KEY IDENTITY,
  nome VARCHAR(45),
  login VARCHAR(45) UNIQUE,
  senha VARCHAR(45),
  sistemaOperacional VARCHAR(45),
  empresa INT,
  CONSTRAINT fk_totem_empresa
    FOREIGN KEY (empresa)
    REFERENCES empresa (idEmpresa)
);

CREATE TABLE componentes (
  idcomponente INT PRIMARY KEY IDENTITY,
  totem INT,
  tipo VARCHAR(45),
  nome VARCHAR(45),
  total FLOAT,
  minimo FLOAT,
  maximo FLOAT,
  CONSTRAINT fk_componente_totem
    FOREIGN KEY (totem)
    REFERENCES totem (idtotem)
);

CREATE TABLE registros (
  idregistro INT PRIMARY KEY IDENTITY,
  valor VARCHAR(45),
  unidadeDeMedida VARCHAR(45),
  horario DATETIME DEFAULT CURRENT_TIMESTAMP,
  componente INT,
  CONSTRAINT fk_registro_componente
    FOREIGN KEY (componente)
    REFERENCES componentes (idcomponente)
);

CREATE TABLE interrupcoes (
  idinterrupcoes INT PRIMARY KEY IDENTITY,
  horario DATETIME DEFAULT CURRENT_TIMESTAMP,
  motivo VARCHAR(45),
  totem INT,
  CONSTRAINT fk_interrupcoes_totem
    FOREIGN KEY (totem)
    REFERENCES totem (idtotem)
);

CREATE TABLE visualizacao (
  idvisualizacao INT PRIMARY KEY IDENTITY,
  cpu INT,
  memoria INT,
  disco INT,
  rede INT,
  totem INT,
  CONSTRAINT fk_visualizacao_totem
    FOREIGN KEY (totem)
    REFERENCES totem (idtotem)
);

-- PROCEDURES

GO
CREATE PROCEDURE excluirTudoTotem (@iddTotem INT)
AS
BEGIN
    DELETE FROM visualizacao WHERE totem = @iddTotem;
    DELETE FROM componentes WHERE totem = @iddTotem;
    DELETE FROM totem WHERE idtotem = @iddTotem;
END;
GO

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
    
INSERT INTO componentes (totem, tipo, nome, total, minimo, maximo) VALUES
	(1, 'Cpu', 'Intel i7', 3.4, 1.0, 4.0),
	(1, 'Memoria', 'Corsair 16GB', 16.0, 2.0, 32.0),
	(1, 'Disco', 'Seagate 1TB', 1024.0, 100.0, 2000.0),
    (1, 'Rede', 'Net claro', 200.0, 5.0, null);

-- SELECT TESTS
SELECT * FROM empresa;
SELECT * FROM usuario;
SELECT * FROM totem;
SELECT * FROM interrupcoes;
SELECT * FROM visualizacao;