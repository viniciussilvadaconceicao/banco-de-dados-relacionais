--questão 1 criando tabelas 

CREATE TABLE clientes(
    id_cliente SERIAL PRIMARY KEY,
    nome_cliente VARCHAR(100) NOT NULL,
    telefone VARCHAR(15) NOT NULL
);


CREATE TABLE jogos(
    id_jogo SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL REFERENCES clientes(id_cliente),
    nome_jogo VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL

);

CREATE TABLE pedidos(
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL REFERENCES clientes(id_cliente),
    id_jogo INT NOT NULL REFERENCES jogos(id_jogo),
    quantidade_pedido INT NOT NULL,
    data_pedido DATE NOT NULL ,
    pagamento VARCHAR(100) NOT NULL
);

CREATE TABLE log_pedidos(
    id_log SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL REFERENCES pedidos(id_pedido),
    id_cliente INT NOT NULL REFERENCES clientes(id_cliente),
    id_jogo INT NOT NULL REFERENCES jogos(id_jogo),
    data_pedido DATE NOT NULL ,
    quantidade_pedido INT NOT NULL,
    operacao VARCHAR(20) NOT NULL


);

-- questão 2 criando a trigger]

CREATE OR REPLACE FUNCTION preencher_log_tabela()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_pedidos(id_pedido,id_cliente,id_jogo,data_pedido,quantidade_pedido, operacao)
    VALUES(NEW.id_pedido, NEW.id_cliente, NEW.id_jogo, NEW.data_pedido, NEW.quantidade_pedido,'INSERT');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_preencher_log_tabela
AFTER INSERT ON pedidos
FOR EACH ROW
EXECUTE FUNCTION preencher_log_tabela();

-- questão 3 realizar os insert into

INSERT INTO clientes(nome_cliente, telefone)VALUES
('lucas pereira', '(11)9876-1234'),
('mariana oliveira', '(21)1234-5678'),
('joao silva', '(31)1111-2222'),
('vinicius silva da conceicao', '(22)9999-2222');

INSERT INTO jogos(id_cliente,nome_jogo,categoria,preco,estoque)VALUES
(1,'THE WITCHER 3','RPG',200, 10),
(2,'FIFA 24','esporte', 250, 15),
(1,'cyberpunk 2077','RPG',220, 8),
(3,'the last of us','aventura', 300, 15),
(4, 'fortnite', 'tiro', 100, 10);

INSERT INTO pedidos(id_cliente,id_jogo,quantidade_pedido,data_pedido,pagamento)VALUES
(1,1,1,'2024-09-10','cartão de credito'),
(2,2,1,'2024-09-12','pix'),
(1,3,1,'2024-09-10','cartao de credito'),
(3,4,1,'2024-09-15','boleto'),
(4,5,1,'2025-06-30','dinheiro');

--questão 4 views
--primeira
CREATE VIEW view_pedidos AS
SELECT 
    clientes.id_cliente,
    clientes.nome_cliente,
    jogos.nome_jogo,
    log_pedidos.data_pedido

FROM 
log_pedidos

JOIN clientes ON log_pedidos.id_cliente = clientes.id_cliente
JOIN jogos ON log_pedidos.id_jogo = jogos.id_jogo;

-- segunda view

CREATE VIEW quantidade_total_jogo AS
SELECT
    clientes.id_cliente,
    clientes.nome_cliente,
    SUM(log_pedidos.quantidade_pedido)
FROM
    log_pedidos
JOIN clientes ON log_pedidos.id_cliente = clientes.id_cliente

GROUP BY
    clientes.id_cliente,
    clientes.nome_cliente

ORDER BY
    clientes.nome_cliente;