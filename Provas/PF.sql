--questao 1 
CREATE TABLE clientes(
    id_cliente SERIAL PRIMARY KEY,
    nome_cliente VARCHAR(100) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
);

CREATE TABLE jogos(
    id_jogo SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL REFERENCES clientes(clientes.id_cliente),
    nome_jogo VARCHAR(100) NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    quantidade_estoque INT NOT NULL
);

CREATE TABLE pedidos(
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL REFERENCES clientes(clientes.id_cliente),
    id_jogo INT NOT NULL REFERENCES jogos(jogos.id_jogo),
    data_pedido DATE NOT NULL,
    forma_pagamento VARCHAR(50) NOT NULL,
    quantidade INT NOT NULL
);

CREATE TABLE log_pedidos(
    id_pedido_log  SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL REFERENCES pedidos(pedidos.id_pedido),
    id_cliente INT NOT NULL REFERENCES clientes(clientes.id_cliente),
    id_jogo INT NOT NULL REFERENCES jogos(jogos.id_jogo),
    data_pedido DATE NOT NULL,
    tipo_operacao VARCHAR(50) NOT NULL

);

