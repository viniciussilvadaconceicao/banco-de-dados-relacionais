CREATE TABLE venda(
	id_venda PRIMARY KEY NOT NULL,
	id_estoque INT NOT NULL,
	quantidade INT NOT NULL,
	valor_produto NUMERIC(10,2),
	valor_venda NUMERIC(10,2)
);

CREATE TABLE estoque(
	id_estoque PRIMARY KEY NOT NULL,
	produto VARCHAR(100) NOT NULL,
	quantidade INT NOT NULL,
	valor NUMERIC(10,2)
);

CREATE TABLE funcionario(
	id_funcionario PRIMARY KEY NOT NULL,
	endereco TXT NOT NULL,
	nome VARCHAR(100) NOT NULL
)

CREATE TABLE loja(
	id_loja PRIMARY KEY NOT NULL,
	endereco TXT NOT NULL,
	nome VARCHAR(100)
)

FOREIGN KEY (id_venda) REFERENCES vendas(id_venda),
FOREIGN KEY (id_estoque) REFERENCES estoque(id_estoque),
FOREIGN KEY (i_funci) REFERENCES estoque(id_estoque)


CREATE MATERIALIZED VIEW vendas_realizadas AS 

SELECT 
venda.quantidade
venda.valor_produto
venda.valor_vendas
produto.quantidade
FROM 
venda
JOIN
estoque ON 