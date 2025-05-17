CREATE TABLE users( 
	id SERIAL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	idade int CHECK (idade >= 0) NOT NULL,
	email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE funcionarios(
	id SERIAL PRIMARY KEY,
	cargo VARCHAR(100) NOT NULL,
	salario NUMERIC(10,2) NOT NULL,
	user_id INT NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE log_funcionarios (
	id SERIAL PRIMARY KEY,
	operacao VARCHAR(10) NOT NULL,
	funcionario_id INT,
	cargo VARCHAR(100),
	salario NUMERIC(10,2),
	user_id INT,
	username VARCHAR DEFAULT CURRENT_USER,
	data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_funcionario()
RETURNS TRIGGER AS $$
BEGIN 
	IF	(TG_OP = 'INSERT') THEN
		INSERT INTO log_funcionarios (operacao, funcionario_id, cargo, salario, user_id)
		VALUES('INSERT', NEW.id, NEW.cargo, NEW.salario, NEW.user_id);
		RETURN NEW;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO log_funcionarios (operacao, funcionario_id, cargo, salario, user_id)
		VALUES('UPDATE', NEW.id, NEW.cargo, NEW.salario, NEW.user_id);
		RETURN NEW;
	ELSIF (TG_OP = 'DELETE') THEN
		INSERT INTO log_funcionarios (operacao, funcionario_id, cargo, salario, user_id)
		VALUES('DELETE', OLD.id, OLD.cargo, OLD.salario, OLD.user_id);
		RETURN OLD;
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_log_funcionario
AFTER INSERT OR UPDATE OR DELETE ON funcionarios
FOR EACH ROW
EXECUTE FUNCTION log_funcionario(); 
	
INSERT INTO users VALUES('1', 'vinicius silva','28','vinicius@gmail.com');
INSERT INTO users VALUES('2', 'andreza azevedo','27','andreza@gmail.com');
INSERT INTO users VALUES('3', 'celma silva','39','celma@gmail.com');
INSERT INTO users VALUES('4', 'rodrigo gomes','50','rodrigo@gmail.com');
INSERT INTO users VALUES('5', 'ruan silva','38','ruan@gmail.com');
INSERT INTO users VALUES('6', 'luis eduardo','29','luis@gmail.com');

insert into funcionarios values
('1', 'engenheiro de software', '20000.00', (select id FROM users WHERE nome = 'vinicius silva'));
insert into funcionarios values
('2', 'biomedica', '10000.00', (select id FROM users WHERE nome = 'andreza azevedo'));
insert into funcionarios values
('3', 'RH', '5000.00', (select id FROM users WHERE nome = 'celma silva'));
insert into funcionarios values
('4', 'tecnico de redes', '3500.00', (select id FROM users WHERE nome = 'rodrigo gomes'));
insert into funcionarios values
('5', 'tecnico de redes', '3500.00', (select id FROM users WHERE nome = 'ruan silva'));
insert into funcionarios values
('6', 'tecinico de redes', '3500.00', (select id FROM users WHERE nome = 'luis eduardo'));
-- Materialized view adaptada para as tabelas existentes
CREATE MATERIALIZED VIEW view_funcionarios 
AS
-- aqui seleciona a tabela users e as colunas cargo e salario
SELECT us.nome AS nome_funcionario,fu.cargo,fu.salario
FROM funcionarios fu
INNER JOIN users us
ON fu.user_id = us.id
ORDER BY us.nome
WITH NO DATA;

--carrega dados na view
REFRESH MATERIALIZED VIEW view_funcionarios;

--carrega dados da view
SELECT * FROM view_funcionarios;

--Parte que cria o usuario e suas permissoes específicas
-- cria um novo usuário e senha
CREATE USER aluno WITH PASSWORD 'aluno';
CREATE USER teste1 WITH PASSWORD 'teste';

--permite acesso ao banco de dados.
GRANT CONNECT ON DATABASE postgres TO teste1;

-- concede permissões de INSERT,UPDATE e DELETE em tabelas específicas.
GRANT INSERT, UPDATE, DELETE ON TABLE funcionarios TO teste1;

-- superuser acesso total ao usuário.
ALTER USER aluno WITH SUPERUSER;

-- Permite criar bancos de dados.
ALTER USER teste1 WITH CREATEDB;


-- parte que concede Permissões de leitura e escrita
-- permissões de leitura
GRANT SELECT ON ALL TABLES IN SCHEMA public TO aluno;

--permissões de escrita
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO aluno;


-- parte que revoga permissões(acesso limitado a tabela)

--revoga permissões fora do postgreSQL
REVOKE INSERT, UPDATE, DELETE ON TABLE funcionarios FROM teste1;

