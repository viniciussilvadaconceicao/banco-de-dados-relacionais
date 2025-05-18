--aqui eu crio as tabelas aluno,responsavel e desempenho
CREATE TABLE aluno(
	alunoID SERIAL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	idade INT CHECK(idade >=0) NOT NULL	
);

CREATE TABLE responsavel(
	responsavelID SERIAL PRIMARY KEY,
	nome VARCHAR(100)NOT NULL,
	idade INT CHECK(idade >= 0) NOT NULL
);

CREATE TABLE desempenho_aluno(
	desempenho_alunoID SERIAL PRIMARY KEY,
	alunoID INT NOT NULL,
	nota NUMERIC(3,1) NOT NULL,
	status VARCHAR(20) NOT NULL,
	periodo INT NOT NULL,
	responsavelID INT NOT NULL,
	FOREIGN KEY (responsavelID) REFERENCES responsavel(responsavelID),
	FOREIGN KEY (alunoID) REFERENCES aluno(alunoID)
);

-- ja aqui eu crio os insert
INSERT INTO aluno VALUES(1,'andre silva',25);
INSERT INTO aluno VALUES(2,'rodrigo almeida',23);
INSERT INTO aluno VALUES(3,'vinicius silva',28);
INSERT INTO aluno VALUES(4,'andreza azevedo',27);
INSERT INTO aluno VALUES(5,'alice azevedo',18);
INSERT INTO aluno VALUES(6,'joaquim gusman',30);
INSERT INTO responsavel VALUES(1,'abraao silva',45);
INSERT INTO responsavel VALUES(2,'gioavani almeida',48);
INSERT INTO responsavel VALUES(3,'nilton silva',58);
INSERT INTO responsavel VALUES(4,'irinete azevedo',57);
INSERT INTO responsavel VALUES(5,'vinicius conceicao',46);
INSERT INTO responsavel VALUES(6,'pablo gusman',55);
INSERT INTO desempenho_aluno VALUES(
1,(SELECT alunoID FROM aluno WHERE nome ='andre silva'),5.9,'REPROVADO',1,(SELECT responsavelID FROM responsavel WHERE nome ='abraao silva'));
INSERT INTO desempenho_aluno VALUES(
2,(SELECT alunoID FROM aluno WHERE nome='rodrigo almeida'),7,'APROVADO',2,(SELECT responsavelID FROM responsavel WHERE nome ='giovani almeida'));
INSERT INTO desempenho_aluno VALUES(
3,(SELECT alunoID FROM aluno WHERE nome='vinicius silva'),9,'APROVADO',4,(SELECT responsavelID FROM responsavel WHERE nome='nilton silva'));
INSERT INTO desempenho_aluno VALUES(
4,(SELECT alunoID FROM aluno WHERE nome='andreza azevedo'),10,'APROVADO',3,(SELECT responsavelID FROM responsavel WHERE nome='irinete azevedo'));
INSERT INTO desempenho_aluno VALUES(
5,(SELECT alunoID FROM aluno WHERE nome='alice azevedo'),9,'APROVADO',8,(SELECT responsavelID FROM responsavel WHERE nome='vinicius conceicao'));
INSERT INTO desempenho_aluno VALUES(
6,(SELECT alunoID FROM aluno WHERE nome='joaquim gusman'),5,'REPROVADO',5,(SELECT responsavelID FROM responsavel WHERE nome='pablo gusman'));

-- aqui eu crio uma atualizacao e dois delete
UPDATE aluno SET nome='alice azevedo da conceicao'WHERE alunoID = 1;

DELETE FROM desempenho_aluno WHERE alunoID = 6;
DELETE FROM aluno WHERE alunoID = 6;

-- aqui é a parte do join juntando as duas tabela aluno e responsavel
SELECT 
aluno.alunoID,
aluno.nome,
desempenho_aluno.nota,
desempenho_aluno.status,
desempenho_aluno.periodo,
responsavel.nome
FROM
desempenho_aluno
JOIN 
aluno ON desempenho_aluno.alunoID = aluno.alunoID
JOIN
responsavel ON desempenho_aluno.responsavelID = responsavel.responsavelID
ORDER BY
desempenho_aluno.desempenho_alunoID;