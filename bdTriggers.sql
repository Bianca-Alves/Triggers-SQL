----- Criação do banco de dados -----

CREATE DATABASE bdTriggers
USE bdTriggers

-- Exercício 1 --

----- Criação das tabelas -----

CREATE TABLE tbl_bancos (
	id INT PRIMARY KEY IDENTITY(1,1),
	Codigo INT NOT NULL,
	Nome VARCHAR(15) NOT NULL
);

CREATE TABLE tbl_pessoas (
	id INT PRIMARY KEY IDENTITY(1,1),
	CPF INT NOT NULL,
	Nome VARCHAR(20) NOT NULL
);

CREATE TABLE tbl_conta_corrente (
	id INT PRIMARY KEY IDENTITY(1,1),
	Banco INT NOT NULL,
	Pessoa CHAR(14) NOT NULL,
	Numero INT NOT NULL
);

----- Inserção de dados -----

INSERT INTO tbl_bancos
VALUES (001, 'Banco do Brasil'),
       (033, 'Santander'),
	   (237, 'Bradesco'),
	   (341, 'Itaú')

INSERT INTO tbl_pessoas
VALUES (862776356, 'José da Silva'),
       (882088118, 'Manoel da Silva'),
	   (665167647, 'Maria dos Santos')

INSERT INTO tbl_conta_corrente
VALUES (033, '862.776.356-55', 98876788),
       (237, '862.776.356-55', 96645727),
	   (341, '665.167.647-45', 9102947),
	   (001, '882.088.118-12', 8120938)


-- Exercício 2 --

----- Criação das triggers -----

CREATE TRIGGER trg_modifica_tbl_bancos
ON tbl_bancos
INSTEAD OF UPDATE, INSERT, DELETE
AS
BEGIN
	PRINT 'Somente pessoal autorizado pode ter acesso a essa tabela.'
END


CREATE TRIGGER trg_modifica_tbl_pessoas
ON tbl_pessoas
INSTEAD OF UPDATE, INSERT, DELETE
AS
BEGIN
	PRINT 'Somente pessoal autorizado pode ter acesso a essa tabela.'
END


CREATE TRIGGER trg_modifica_tbl_conta_corrente
ON tbl_conta_corrente
INSTEAD OF UPDATE, INSERT, DELETE
AS
BEGIN
	PRINT 'Somente pessoal autorizado pode ter acesso a essa tabela.'
END


-- Exercício 3 --

----- Criação da tabela -----

CREATE TABLE tbl_funcionarios_autorizados (
	Nome VARCHAR(20) NOT NULL,
	CPF CHAR(14) NOT NULL,
	Senha NCHAR(08) NOT NULL
);

----- Inserção de dados -----

INSERT INTO tbl_funcionarios_autorizados
VALUES ('Fernando de Souza', '111.111.111-11', 'nando@34'),
       ('Carolina Santos', '222.222.222-22', 'carol@23'),
	   ('Mariana Silva', '333.333.333-33', 'maria@45'),
	   ('Emily Pinheiro', '444.444.444-44', 'miily@30')


-- Exercício 4 --

----- Criação da tabela -----

CREATE TABLE tbl_registros (
	nome_funcionario VARCHAR(20) NOT NULL,
	cpf_funcionario CHAR(14) NOT NULL,
	operacao_realizada CHAR(06) NOT NULL,
	data_operacao DATE NOT NULL
);


-- Exercício 5 --

----- Criação da procedure (tbl_bancos) -----

CREATE PROCEDURE permite_modificacao_tbl_bancos (@nome VARCHAR(20), @senha NCHAR(08), @cpf CHAR(14), @operacao CHAR(06), @id INT)
AS
BEGIN
	SET @nome = (SELECT Nome FROM tbl_funcionarios_autorizados WHERE Senha = @senha)
		
	IF @nome != ''
		BEGIN
			SET @cpf = (SELECT CPF FROM tbl_funcionarios_autorizados WHERE Senha = @senha)
			
			-- Desliga a trigger
			ALTER TABLE tbl_bancos DISABLE TRIGGER trg_modifica_tbl_bancos

			-- Altera a tbl_bancos
			IF @operacao = 'insert'
				BEGIN
					INSERT INTO tbl_bancos VALUES (035, 'Nubank')
					SELECT * FROM tbl_bancos
				END
			ELSE IF @operacao = 'update'
				BEGIN
					UPDATE tbl_bancos SET Codigo = 165 WHERE id = @id
					SELECT * FROM tbl_bancos
				END
			ELSE
				BEGIN
					DELETE FROM tbl_bancos WHERE id = @id
					SELECT * FROM tbl_bancos
				END

			-- Insere o registro de quem editou a tabela	
			INSERT INTO tbl_registros VALUES (@nome, @cpf, @operacao, GETDATE())

			-- Liga a trigger
			ALTER TABLE tbl_bancos ENABLE TRIGGER trg_modifica_tbl_bancos
		END
	ELSE
		PRINT 'Edição não autorizada.'
END

EXECUTE permite_modificacao_tbl_bancos 'Carolina Santos', 'carol@23', '222.222.222-22', 'update', 3


----- Criação da procedure (tbl_pessoas) -----

CREATE PROCEDURE permite_modificacao_tbl_pessoas (@nome VARCHAR(20), @senha NCHAR(08), @cpf CHAR(14), @operacao CHAR(06), @id INT)
AS
BEGIN
	SET @nome = (SELECT Nome FROM tbl_funcionarios_autorizados WHERE Senha = @senha)
		
	IF @nome != ''
		BEGIN
			SET @cpf = (SELECT CPF FROM tbl_funcionarios_autorizados WHERE Senha = @senha)
			
			-- Desliga a trigger
			ALTER TABLE tbl_pessoas DISABLE TRIGGER trg_modifica_tbl_pessoas

			-- Altera a tbl_pessoas
			IF @operacao = 'insert'
				BEGIN
					INSERT INTO tbl_pessoas VALUES ('555.555.555-55', 'Lucas Ferreira')
					SELECT * FROM tbl_pessoas
				END
			ELSE IF @operacao = 'update'
				BEGIN
					UPDATE tbl_pessoas SET Nome = 'Manuel Carvalho' WHERE id = @id
					SELECT * FROM tbl_pessoas
				END
			ELSE
				BEGIN
					DELETE FROM tbl_pessoas WHERE id = @id
					SELECT * FROM tbl_pessoas
				END

			-- Insere o registro de quem editou a tabela	
			INSERT INTO tbl_registros VALUES (@nome, @cpf, @operacao, GETDATE())

			-- Liga a trigger
			ALTER TABLE tbl_pessoas ENABLE TRIGGER trg_modifica_tbl_pessoas
		END
	ELSE
		PRINT 'Edição não autorizada.'
END

EXECUTE permite_modificacao_tbl_pessoas 'Fernando de Souza', 'nando@34', '111.111.111-11', 'update', 2


----- Criação da procedure (tbl_conta_corrente) -----

CREATE PROCEDURE permite_modificacao_tbl_conta_corrente (@nome VARCHAR(20), @senha NCHAR(08), @cpf CHAR(14), @operacao CHAR(06), @id INT)
AS
BEGIN
	SET @nome = (SELECT Nome FROM tbl_funcionarios_autorizados WHERE Senha = @senha)
		
	IF @nome != ''
		BEGIN
			SET @cpf = (SELECT CPF FROM tbl_funcionarios_autorizados WHERE Senha = @senha)
			
			-- Desliga a trigger
			ALTER TABLE tbl_conta_corrente DISABLE TRIGGER trg_modifica_tbl_conta_corrente

			-- Altera a tbl_conta_corrente
			IF @operacao = 'insert'
				BEGIN
					INSERT INTO tbl_conta_corrente VALUES (156, '666.666.666-66', 98421513)
					SELECT * FROM tbl_conta_corrente
				END
			ELSE IF @operacao = 'update'
				BEGIN
					UPDATE tbl_conta_corrente SET Numero = 96148230 WHERE id = @id
					SELECT * FROM tbl_conta_corrente
				END
			ELSE
				BEGIN
					DELETE FROM tbl_conta_corrente WHERE id = @id
					SELECT * FROM tbl_conta_corrente
				END

			-- Insere o registro de quem editou a tabela	
			INSERT INTO tbl_registros VALUES (@nome, @cpf, @operacao, GETDATE())

			-- Liga a trigger
			ALTER TABLE tbl_conta_corrente ENABLE TRIGGER trg_modifica_tbl_conta_corrente
		END
	ELSE
		PRINT 'Edição não autorizada.'
END

EXECUTE permite_modificacao_tbl_conta_corrente 'Mariana Silva', 'maria@45', '333.333.333-33', 'update', 4