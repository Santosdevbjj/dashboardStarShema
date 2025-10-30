-- Total de cursos por professor
SELECT p.nome, COUNT(f.id_curso) AS total_cursos
FROM fato_professor_curso f
JOIN dim_professor p ON f.id_professor = p.id_professor
GROUP BY p.nome;

-- Receita total por departamento
SELECT d.nome_departamento, SUM(f.valor_curso) AS receita_total
FROM fato_professor_curso f
JOIN dim_departamento d ON f.id_departamento = d.id_departamento
GROUP BY d.nome_departamento;

-- Carga horária média por curso
SELECT c.nome_curso, AVG(f.carga_horaria) AS media_horas
FROM fato_professor_curso f
JOIN dim_curso c ON f.id_curso = c.id_curso
GROUP BY c.nome_curso;
