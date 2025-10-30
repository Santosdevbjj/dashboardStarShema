-- Exemplo de ETL (Extração, Transformação e Carga)
INSERT INTO dim_professor VALUES
(1, 'João Silva', 'Engenharia', 'Doutor', 8),
(2, 'Maria Lima', 'Administração', 'Mestre', 5);

INSERT INTO dim_curso VALUES
(1, 'Engenharia de Software', 'Graduação', 'Presencial', 3600),
(2, 'Gestão de Negócios', 'Pós-Graduação', 'EAD', 480);

INSERT INTO dim_departamento VALUES
(1, 'Ciências Exatas', 'Engenharia', 'Carlos Rocha'),
(2, 'Gestão e Negócios', 'Administração', 'Luciana Ribeiro');

INSERT INTO dim_tempo VALUES
(1, '2024-03-01', 2024, 3, 1, 1),
(2, '2024-08-01', 2024, 8, 3, 2);

INSERT INTO fato_professor_curso VALUES
(1, 1, 1, 1, 1, 120.0, 1500.00, 4),
(2, 2, 2, 2, 2, 80.0, 1200.00, 3);
