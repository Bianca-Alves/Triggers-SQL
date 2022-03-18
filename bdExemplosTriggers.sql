----- Criação do banco de dados -----

CREATE DATABASE bdExemplosTriggers
USE bdExemplosTriggers

-- Exemplo 1 --

----- Criação das tabelas -----

CREATE TABLE tbl_clientes (
	codigo INT PRIMARY KEY IDENTITY(1,1),
	nome VARCHAR(100) NOT NULL,
	dataNascimento DATE NOT NULL
);

CREATE TABLE tbl_telefones (
	fone  VARCHAR(15) NOT NULL,
	tipo VARCHAR(20) NOT NULL,
	codigo INT FOREIGN KEY REFERENCES tbl_clientes(codigo)
);

----- Inserção de dados -----

INSERT INTO tbl_clientes (nome, dataNascimento) 
VALUES ('Marcio','1/6/1975'),
	   ('Marlos', '5/8/1980'),
	   ('Luciane', '10/05/1970'),
	   ('Telefones', '12/03/1974')

INSERT INTO tbl_telefones (codigo, fone, tipo) 
VALUES (1, '22548954','Residencial'),
	   (1, '88512547','Celular'),
	   (3, '89665485','Celular'),
	   (4, '26539955','Residencial')

----- Criação das triggers -----

CREATE TRIGGER trg_modifica_clientes
ON tbl_clientes
INSTEAD OF UPDATE, INSERT, DELETE
AS
BEGIN
	PRINT 'Somente pessoal autorizado pode modificar os dados da tabela clientes.'
END


CREATE TRIGGER depois_de_editar
ON tbl_clientes 
AFTER UPDATE, INSERT, DELETE
AS 
BEGIN
	Print 'Dados atualizados com sucesso.'
	SELECT * FROM tbl_clientes
END


CREATE TRIGGER trg_inserir_telefones
on tbl_telefones
INSTEAD OF INSERT
AS 
BEGIN
	PRINT 'Operação de inclusão não autorizada.'
END


-- Exemplo 2 --

----- Criação das tabelas -----

CREATE TABLE tbl_registros (
	id_registro INT PRIMARY KEY IDENTITY(1,1),
	nome_responsavel VARCHAR(100) NOT NULL,
	cpf_responsavel  VARCHAR(15) NOT NULL,
	data_modificacao DATE NOT NULL,
	operacao_realizada VARCHAR(20) NOT NULL
);

CREATE TABLE tbl_autorizados (
	nome VARCHAR(100) NOT NULL,
	senha VARCHAR(5) NOT NULL,
	cpf VARCHAR(15) PRIMARY KEY NOT NULL
);

----- Inserção de dados -----

INSERT INTO tbl_autorizados
VALUES ('Clederson','123456','36620426632'),
	   ('Rosenildo','246810','36625526632'),
	   ('Mario','974346','40412268955'),
	   ('Thayane','489131','40412268855')

----- Utilizando a trigger em uma procedure -----

CREATE PROCEDURE permite_modificacao (@senha VARCHAR(5), @operacao VARCHAR(10), @nome_mudar VARCHAR(100), @codigo INT)
AS
BEGIN
	DECLARE @nome VARCHAR(100), @cpf VARCHAR(15)
	SET @nome = (SELECT nome FROM tbl_autorizados WHERE senha = @senha)
		
	IF @nome != ''
		BEGIN
			SET @cpf = (SELECT cpf FROM tbl_autorizados WHERE senha = @senha)
			
			-- Desliga a trigger
			ALTER TABLE tbl_clientes DISABLE TRIGGER trg_modifica_clientes
				
			-- Atualiza a tabela de clientes
			UPDATE tbl_clientes SET nome = @nome_mudar WHERE codigo = @codigo
				
			-- Insere o registro de quem editou a tabela		
			INSERT INTO tbl_registros VALUES (@nome, @cpf, GETDATE(),@operacao)
				
			-- Liga a trigger
			ALTER TABLE tbl_clientes ENABLE TRIGGER trg_modifica_clientes
		END
	ELSE
		PRINT 'Edição não autorizada.'
END

EXEC permite_modificacao '12345', 'UPDATE', 'Maria Joana', 2