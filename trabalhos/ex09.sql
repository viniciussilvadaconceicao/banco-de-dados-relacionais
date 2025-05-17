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