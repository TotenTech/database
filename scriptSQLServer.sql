-- CREATE USER and DATABASE
IF NOT EXISTS (SELECT * FROM sys.sql_logins WHERE name = N'totemMaster')
BEGIN
    CREATE LOGIN totemMaster WITH PASSWORD = '12345';
    CREATE USER totemMaster FOR LOGIN totemMaster;
    EXEC sp_addsrvrolemember 'totemMaster', 'sysadmin';
END;
GO

DROP DATABASE totemTech;
GO

CREATE DATABASE totemTech;
GO

USE totemTech;
GO


IF OBJECT_ID('dbo.InsertComponenteEspecificacaoDisco', 'P') IS NOT NULL
    DROP PROCEDURE dbo.InsertComponenteEspecificacao;
GO
IF OBJECT_ID('dbo.InsertComponenteEspecificacao2', 'P') IS NOT NULL
    DROP PROCEDURE dbo.InsertComponenteEspecificacao;
GO
IF OBJECT_ID('dbo.InsertTotalDisco', 'P') IS NOT NULL
    DROP PROCEDURE dbo.InsertTotalDisco;
GO
IF OBJECT_ID('dbo.DeleteTotem', 'P') IS NOT NULL
    DROP PROCEDURE dbo.DeleteTotem;
GO
IF OBJECT_ID('dbo.UpdateComponenteEspecificacao', 'P') IS NOT NULL
    DROP PROCEDURE dbo.InsertComponenteEspecificacao;
GO



IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'totemTech')
BEGIN
    CREATE DATABASE totemTech;
END

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

CREATE TABLE tipoComponente (
		idtipoComponente INT IDENTITY PRIMARY KEY,
		nome VARCHAR(45)
);

CREATE TABLE componente (
    idcomponente INT IDENTITY PRIMARY KEY,
    totem INT,
    nome VARCHAR(45),
    tipo INT,
    CONSTRAINT fk_componente_tipo
        FOREIGN KEY (tipo)
        REFERENCES tipoComponente(idtipoComponente),
    CONSTRAINT fk_componente_totem
        FOREIGN KEY (totem)
        REFERENCES totem(idtotem)
);

CREATE TABLE especificacao (
    idespecificacao INT IDENTITY PRIMARY KEY,
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
        REFERENCES tipoComponente(idtipoComponente)
);

CREATE TABLE registro (
    idregistro INT IDENTITY PRIMARY KEY,
    valor VARCHAR(45),
    horario DATETIME DEFAULT GETDATE(),
    componente INT,
    CONSTRAINT fk_registro_componente
        FOREIGN KEY (componente)
        REFERENCES componente(idcomponente)
);

CREATE TABLE interrupcoes (
    idinterrupcoes INT IDENTITY PRIMARY KEY,
    horario DATETIME DEFAULT GETDATE(),
    motivo VARCHAR(45),
    totem INT,
    CONSTRAINT fk_interrupcoes_totem
        FOREIGN KEY (totem)
        REFERENCES totem(idtotem)
);

CREATE TABLE visualizacao (
    idvisualizacao INT IDENTITY PRIMARY KEY,
    cpu INT,
    memoria INT,
    disco INT,
    rede INT,
    totem INT,
    CONSTRAINT fk_visualizacao_totem
        FOREIGN KEY (totem)
        REFERENCES totem(idtotem)
);


GO
-- PROCEDURES

CREATE PROCEDURE InsertComponenteEspecificacao2
    @nomeComponente VARCHAR(45),
    @nomeEspecificacao1 VARCHAR(45),
    @valorEspecificacao1 VARCHAR(45),
    @unidadeMedidaEspecificacao1 VARCHAR(45),
    @nomeEspecificacao2 VARCHAR(45),
    @valorEspecificacao2 VARCHAR(45),
    @unidadeMedidaEspecificacao2 VARCHAR(45),
    @nomeComponenteCPU VARCHAR(45),
    @valorCPU VARCHAR(45),
    @unidadeMedidaCPU VARCHAR(45),
    @nomeComponenteRede VARCHAR(45),
    @nomeEspecificacao1Rede VARCHAR(45),
    @valorEspecificacao1Rede VARCHAR(45),
    @unidadeMedidaEspecificacao1Rede VARCHAR(45),
    @nomeEspecificacao2Rede VARCHAR(45),
    @valorEspecificacao2Rede VARCHAR(45),
    @unidadeMedidaEspecificacao2Rede VARCHAR(45)
AS
BEGIN

    INSERT INTO componente (totem, tipo, nome)
    VALUES ((SELECT MAX(idtotem) FROM totem), 1, @nomeComponenteCPU);

    DECLARE @idComponenteCpu INT;
    SET @idComponenteCpu = SCOPE_IDENTITY();

    INSERT INTO especificacao (nome, valor, unidadeMedida, componente, tipo)
    VALUES (@nomeEspecificacao1, @valorCPU, @unidadeMedidaCPU, @idComponenteCpu, 1);

    INSERT INTO componente (totem, tipo, nome)
    VALUES ((SELECT MAX(idtotem) FROM totem), 2, @nomeComponente);

    DECLARE @idComponente INT;
    SET @idComponente = SCOPE_IDENTITY();

    INSERT INTO especificacao (nome, valor, unidadeMedida, componente, tipo)
    VALUES (@nomeEspecificacao1, @valorEspecificacao1, @unidadeMedidaEspecificacao1, @idComponente, 2),
           (@nomeEspecificacao2, @valorEspecificacao2, @unidadeMedidaEspecificacao2, @idComponente, 2);

    INSERT INTO componente (totem, tipo, nome)
    VALUES ((SELECT MAX(idtotem) FROM totem), 4, @nomeComponenteRede);

    DECLARE @idComponenteRede INT;
    SET @idComponenteRede = SCOPE_IDENTITY();

    INSERT INTO especificacao (nome, valor, unidadeMedida, componente, tipo)
    VALUES (@nomeEspecificacao1Rede, @valorEspecificacao1Rede, @unidadeMedidaEspecificacao1Rede, @idComponenteRede, 4),
           (@nomeEspecificacao2Rede, @valorEspecificacao2Rede, @unidadeMedidaEspecificacao2Rede, @idComponenteRede, 4);
END;
GO




CREATE PROCEDURE InsertComponenteEspecificacaoDisco
    @nomeComponente VARCHAR(45),
    @nomeEspecificacao1 VARCHAR(45),
    @valorEspecificacao1 VARCHAR(45),
    @unidadeMedidaEspecificacao1 VARCHAR(45),
    @nomeEspecificacao2 VARCHAR(45),
    @valorEspecificacao2 VARCHAR(45),
    @unidadeMedidaEspecificacao2 VARCHAR(45)
AS
BEGIN
 
    INSERT INTO componente (totem, tipo, nome)
    VALUES ((SELECT MAX(idtotem) FROM totem), 3, @nomeComponente);

    DECLARE @idComponente INT;
    SET @idComponente = SCOPE_IDENTITY();

    INSERT INTO especificacao (nome, valor, unidadeMedida, componente, tipo)
    VALUES 
	(@nomeEspecificacao1, @valorEspecificacao1, @unidadeMedidaEspecificacao1, @idComponente, 3),
	(@nomeEspecificacao2, @valorEspecificacao2, @unidadeMedidaEspecificacao2, @idComponente, 3);
END;

GO


CREATE PROCEDURE InsertTotalDisco
    @totalDisco VARCHAR(45)
AS
BEGIN
 
    INSERT INTO componente (totem, tipo, nome)
    VALUES ((SELECT MAX(idtotem) FROM totem), 5, 'Todal Disco');

    DECLARE @idComponente INT;
    SET @idComponente = SCOPE_IDENTITY();

    INSERT INTO especificacao (nome, valor, unidadeMedida, componente, tipo)
    VALUES 
	('total', @totalDisco, 'GB',  @idComponente, 5);
END;

GO


CREATE PROCEDURE DeleteTotem
    @idTotem INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM totem WHERE idtotem = @idTotem)
    BEGIN
        
        DELETE e
        FROM especificacao e
        INNER JOIN componente c ON e.componente = c.idcomponente
        WHERE c.totem = @idTotem;

        DELETE r
        FROM registro r
        INNER JOIN componente c ON r.componente = c.idcomponente
        WHERE c.totem = @idTotem;

        DELETE FROM componente WHERE totem = @idTotem;

        DELETE FROM interrupcoes WHERE totem = @idTotem;

        DELETE FROM visualizacao WHERE totem = @idTotem;

        DELETE FROM totem WHERE idtotem = @idTotem;

    END
END;
GO


CREATE PROCEDURE dbo.UpdateComponenteEspecificacao
    @idComponente int,
	@nomeComponente VARCHAR(45),
	@idespecificacao int,
	@valorEspecificacao VARCHAR(45)
AS
BEGIN
    SET NOCOUNT ON;

	UPDATE componente SET nome = @nomeComponente WHERE idcomponente = @idComponente;
	UPDATE especificacao SET valor = @valorEspecificacao WHERE idespecificacao  =@idespecificacao;

    SET NOCOUNT OFF;
END;
GO




-- INSERTS

INSERT INTO tipo (descricao) VALUES
    ('Funcionários'),
    ('Gerente');
    
INSERT INTO contrato (tipo, limiteUsuarios, limiteTotens, dtInicio, dtFinal) VALUES 
    ('Básico', 10, 5, '2024-01-01', '2024-12-31'),
    ('Premium', 50, 25, '2024-01-01', '2024-12-31');

INSERT INTO endereco (logradouro, bairro, numero, cep, complemento) VALUES 
    ('Rua das Flores', 'Centro', 123, '12345678', 'Bloco A');

INSERT INTO empresa (nome, endereco, assinatura, razaoSocial, nomeFantasia, cnpj) VALUES
    ('Totem Tech', 1, 1, 'Totem Tech', 'Totem Tech', '12345678901234');

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
	('Memoria'),
	('Disco'),
	('Rede'),
    ('Total');

INSERT INTO componente (totem, tipo, nome) VALUES
	(1, 1, 'Intel i7'),  
	(1, 2, 'Corsair 16GB'),  
	(1, 3, 'Seagate 1TB'),
	(1, 4, 'Net Claro'),
    (1, 5, 'Total Discos'),

	(2, 1, 'Intel i7'), 
    (2, 2, 'Kingston 8GB'), 
    (2, 3, 'Western Digital 500GB'), 
    (2, 3, 'Samsung SSD 250GB'),
    (2, 4, 'Net Claro'),
    (2, 5, 'Total Discos'),

    (3, 1, 'Intel i7'), 
    (3, 2, 'Crucial 4GB'), 
    (3, 3, 'Samsung SSD 250GB'), 
    (3, 4, 'Net Claro'),
    (3, 5, 'Total Discos'),

    (4, 1, 'Intel i7'), 
    (4, 2, 'G.Skill 32GB'), 
    (4, 3, 'Toshiba 2TB'), 
    (4, 3, 'Hitachi 1TB'),  
    (4, 4, 'Net Claro'),
    (4, 5, 'Total Discos'),

    (5, 1, 'Intel i7'), 
    (5, 2, 'HyperX 16GB'), 
    (5, 3, 'Hitachi 1TB'), 
    (5, 4, 'Net Claro'),
    (5, 5, 'Total Discos'),

    (6, 1, 'Intel i7'), 
    (6, 2, 'Corsair 32GB'), 
    (6, 3, 'Seagate 2TB'), 
    (6, 4, 'Net Claro'),
    (6, 5, 'Total Discos'),

    (7, 1, 'Intel i7'), 
    (7, 2, 'Kingston 16GB'), 
    (7, 3, 'Western Digital 1TB'), 
    (7, 3, 'Samsung SSD 500GB'),  -- Segundo disco para totem 7
    (7, 4, 'Net Claro'),
    (7, 5, 'Total Discos'),

    (8, 1, 'Intel i7'), 
    (8, 2, 'Crucial 8GB'), 
    (8, 3, 'Samsung SSD 500GB'), 
    (8, 3, 'Toshiba 1TB'), 
    (8, 4, 'Net Claro'),
    (8, 5, 'Total Discos'),

    (9, 1, 'Intel i7'), 
    (9, 2, 'G.Skill 4GB'), 
    (9, 3, 'Toshiba 1TB'), 
    (9, 3, 'Western Digital 500GB'),  
    (9, 4, 'Net Claro'),
    (9, 5, 'Total Discos'),

    (10, 1, 'Intel i7'), 
    (10, 2, 'HyperX 2GB'), 
    (10, 3, 'Hitachi 500GB'), 
    (10, 3, 'Samsung SSD 250GB'), 
    (10, 4, 'Net Claro'),
    (10, 5, 'Total Discos');

INSERT INTO especificacao (nome, valor, unidadeMedida, componente, tipo) VALUES 
    ('maximo', '90.0', '%', 1, 1),
	('total', '16.0', 'GB', 2, 2),
	('maximo', '89.0', '%', 2, 2),
	('total', '1000.0', 'GB', 3, 3),
	('maximo', '90.0', '%', 3, 3),
	('minimo', '5.0', 'MB/s', 4, 4),
	('ideal', '10.0', 'MB/s', 4, 4),
    ('total', '1000.0', 'GB', 5, 5),

    ('maximo', '90.0', '%', 6, 1), 
    ('total', '8.0', 'GB', 7, 2), 
    ('maximo', '89.0', '%', 7, 2), 
    ('total', '500.0', 'GB', 8, 3),
    ('maximo', '90.0', '%', 8, 3), 
    ('total', '250.0', 'GB', 9, 3), 
	('maximo', '90.0', '%', 9, 3),
    ('minimo', '5.0', 'MB/s', 10, 4), 
    ('ideal', '10.0', 'MB/s', 10, 4),
    ('total', '750.0', 'GB', 11, 5),

    ('maximo', '90.0', '%', 12, 1), 
    ('total', '4.0', 'GB', 13, 2), 
    ('maximo', '89.0', '%', 13, 2), 
    ('total', '250.0', 'GB', 14, 3), 
    ('maximo', '90.0', '%', 14, 3),
    ('minimo', '5.0', 'MB/s', 15, 4), 
    ('ideal', '10.0', 'MB/s', 15, 4),
    ('total', '250.0', 'GB', 16, 5),

    ('maximo', '90.0', '%', 17, 1), 
    ('total', '32.0', 'GB', 18, 2), 
    ('maximo', '89.0', '%', 18, 2), 
    ('total', '2000.0', 'GB', 19, 3), 
    ('maximo', '90.0', '%', 19, 3), 
    ('total', '1000.0', 'GB', 20, 3),
	('maximo', '90.0', '%', 20, 3),
    ('minimo', '5.0', 'MB/s', 21, 4), 
    ('ideal', '10.0', 'MB/s', 21, 4),
    ('total', '3000.0', 'GB', 22, 5),

    ('maximo', '90.0', '%', 23, 1), 
    ('total', '16.0', 'GB', 24, 2), 
    ('maximo', '89.0', '%', 24, 2), 
    ('total', '1000.0', 'GB', 25, 3),
	('maximo', '90.0', '%', 25, 3),
    ('minimo', '5.0', 'MB/s', 26, 4), 
    ('ideal', '10.0', 'MB/s', 26, 4),
    ('total', '1000.0', 'GB', 27, 5),

    ('maximo', '90.0', '%', 28, 1), 
    ('total', '32.0', 'GB', 29, 2), 
    ('maximo', '89.0', '%', 29, 2), 
    ('total', '2000.0', 'GB', 30, 3), 
    ('maximo', '90.0', '%', 30, 3),
    ('minimo', '5.0', 'MB/s', 31, 4), 
    ('ideal', '10.0', 'MB/s', 31, 4),
    ('total', '2000.0', 'GB', 32, 5),

    ('maximo', '90.0', '%', 33, 1), 
    ('total', '16.0', 'GB', 34, 2), 
    ('maximo', '89.0', '%', 34, 2), 
    ('total', '1000.0', 'GB', 35, 3), 
    ('maximo', '90.0', '%', 35, 3), 
    ('total', '500.0', 'GB', 36, 3),
	('maximo', '90.0', '%', 36, 3),
    ('minimo', '5.0', 'MB/s', 37, 4), 
    ('ideal', '10.0', 'MB/s', 37, 4),
    ('total', '1500.0', 'GB', 38, 5),

    ('maximo', '90.0', '%', 39, 1), 
    ('total', '8.0', 'GB', 40, 2), 
    ('maximo', '89.0', '%', 40, 2), 
    ('total', '500.0', 'GB', 41, 3), 
    ('maximo', '500.0', '%', 41, 3), 
    ('total', '1000.0', 'GB', 42, 3),
	('maximo', '90.0', '%', 42, 3),
    ('minimo', '5.0', 'MB/s', 43, 4), 
    ('ideal', '10.0', 'MB/s', 43, 4),
    ('total', '1500.0', 'GB', 44, 5),

	('maximo', '90.0', '%', 45, 1), 
    ('total', '4.0', 'GB', 46, 2), 
    ('maximo', '89.0', '%', 46, 2), 
    ('total', '500.0', 'GB', 47, 3), 
    ('maximo', '1000.0', '%', 47, 3), 
    ('total', '250.0', 'GB', 48, 3),
	('maximo', '500.0', '%', 48, 3),
    ('minimo', '5.0', 'MB/s', 49, 4), 
    ('ideal', '10.0', 'MB/s', 49, 4),
    ('total', '1500.0', 'GB', 50, 5),

	('maximo', '90.0', '%', 51, 1), 
    ('total', '2.0', 'GB', 52, 2), 
    ('maximo', '89.0', '%', 52, 2), 
    ('total', '500.0', 'GB', 53, 3), 
    ('maximo', '90.0', '%', 53, 3), 
    ('total', '250.0', 'GB', 54, 3),
	('maximo', '90.0', '%', 54, 3),
    ('minimo', '5.0', 'MB/s', 55, 4), 
    ('ideal', '10.0', 'MB/s', 55, 4),
    ('total', '750.0', 'GB', 56, 5);


INSERT INTO registro (valor, componente) VALUES
	('2.5', 1),
	('8', 2),
	('500', 3),
	('0.9', 4);