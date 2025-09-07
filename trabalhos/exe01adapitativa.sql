--aqui eu crio as tabelas ensalamento,salas,professores,cursos_disciplinas e aluno

CREATE TABLE salas(
	id_sala SERIAL PRIMARY KEY,
    numero_sala VARCHAR(100) NOT NULL,
    capacidade INT NOT NULL,
    localizacao VARCHAR(100) NOT NULL
	
);

CREATE TABLE professores(
	id_professor SERIAL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    departamento VARCHAR(100) NOT NULL
);

CREATE TABLE cursos_disciplinas(
    id_curso SERIAL PRIMARY KEY,
    id_professor INT NOT NULL,
    nome_curso VARCHAR(100) NOT NULL,
    codigo VARCHAR(10) NOT NULL,
    disciplina VARCHAR(100) NOT NULL,
    periodo VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_professor) REFERENCES professores(id_professor)
);

CREATE TABLE aluno(
    id_aluno SERIAL PRIMARY KEY,
    id_curso INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    matricula VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_curso) REFERENCES cursos_disciplinas(id_curso)

);

CREATE TABLE ensalamento(
	id_ensalamento SERIAL PRIMARY KEY,
	id_curso INT NOT NULL,
    id_sala INT NOT NULL,
    id_professor INT NOT NULL,
    data_hora datetime NOT NULL,
    FOREIGN KEY (id_curso) REFERENCES cursos_disciplinas(id_curso),
    FOREIGN KEY (id_professor) REFERENCES professores(id_professor),
    FOREIGN KEY (id_sala) REFERENCES salas(id_sala)
);