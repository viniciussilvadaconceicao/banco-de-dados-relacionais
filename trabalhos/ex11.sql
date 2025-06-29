CREATE TABLE aluno(
	alunoID SERIAL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	idade INT NOT NULL,
	email VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE professor(
	professorID SERIAL PRIMARY KEY,
	nome_professor VARCHAR(100) NOT NULL,
	idade_professor INT NOT NULL,
	materia_professor VARCHAR(100) NOT NULL,
	salario_professor NUMERIC(10,2) NOT NULL
);

CREATE TABLE turma(
	turmaID INT PRIMARY KEY,
	periodo INT NOT NULL,
	alunoID INT NOT NULL,
	professorID INT NOT NULL,
	FOREIGN KEY (alunoID) REFERENCES aluno(alunoID),
	FOREIGN KEY (professorID) REFERENCES professor(professorID)	
);


CREATE MATERIALIZED VIEW vw_turma_detalhada AS
SELECT
aluno.nome,
aluno.idade,
professor.nome_professor,
professor.materia_professor,
professor.salario_professor


FROM
turma
JOIN aluno ON turma.alunoID = aluno.alunoID
JOIN professor ON turma.professorID = professor.professorID;


SELECT * FROM vw_turma_detalhada;
REFRESH MATERIALIZED VIEW vw_turma_detalhada;

SELECT * FROM aluno;
INSERT INTO aluno VALUES (1,'vinicius silva',28,'vinicius@gmail.com')
INSERT INTO aluno VALUES (2,'ze das coves', 34,'ze@gmail.com')

SELECT * FROM aluno;