-- criação das tabelas 
CREATE TABLE medico (
    id_medico SERIAL PRIMARY KEY,
    nome_medico VARCHAR(100) NOT NULL,
    especialidade VARCHAR(100) NOT NULL
);

CREATE TABLE paciente (
    id_paciente SERIAL PRIMARY KEY,
    nome_paciente VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL
);

CREATE TABLE consulta (
    id_consulta SERIAL PRIMARY KEY,
    id_medico INT NOT NULL REFERENCES medico(id_medico),
    id_paciente INT NOT NULL REFERENCES paciente(id_paciente),
    data_consulta TIMESTAMP NOT NULL,
    valor NUMERIC(10, 2) NOT NULL
);

CREATE TABLE log_consulta (
    id_log SERIAL PRIMARY KEY,
    id_consulta INT NOT NULL REFERENCES consulta(id_consulta),
    data_hora_log TIMESTAMP NOT NULL
);

-- criação da view 
CREATE OR REPLACE VIEW consultas_realizadas AS
SELECT
    medico.nome_medico,
    paciente.nome_paciente,
    consulta.data_consulta,
    consulta.valor
FROM 
    consulta
JOIN medico ON consulta.id_medico = medico.id_medico
JOIN paciente ON consulta.id_paciente = paciente.id_paciente;

-- função de trigger
CREATE OR REPLACE FUNCTION log_consulta_funcao()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_consulta(id_consulta, data_hora_log)
    VALUES (NEW.id_consulta, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- CRIAÇÃO DA TRIGGER 
CREATE TRIGGER trigger_log_consulta
AFTER INSERT ON consulta
FOR EACH ROW
EXECUTE FUNCTION log_consulta_funcao();  

-- criação de superusuário
CREATE USER vinicius WITH PASSWORD '123456';
ALTER USER vinicius WITH SUPERUSER;
