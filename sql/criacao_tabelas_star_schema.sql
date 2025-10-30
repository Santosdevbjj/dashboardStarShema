CREATE TABLE dim_professor (
    id_professor INT PRIMARY KEY,
    nome VARCHAR(100),
    formacao VARCHAR(80),
    titulacao VARCHAR(80),
    tempo_casa INT
);

CREATE TABLE dim_curso (
    id_curso INT PRIMARY KEY,
    nome_curso VARCHAR(100),
    tipo VARCHAR(50),
    modalidade VARCHAR(50),
    carga_horaria_total INT
);

CREATE TABLE dim_departamento (
    id_departamento INT PRIMARY KEY,
    nome_departamento VARCHAR(100),
    area VARCHAR(100),
    coordenador VARCHAR(100)
);

CREATE TABLE dim_tempo (
    id_tempo INT PRIMARY KEY,
    data_oferta DATE,
    ano INT,
    mes INT,
    trimestre INT,
    semestre INT
);

CREATE TABLE fato_professor_curso (
    id_fato INT PRIMARY KEY,
    id_professor INT,
    id_curso INT,
    id_departamento INT,
    id_tempo INT,
    carga_horaria DECIMAL(10,2),
    valor_curso DECIMAL(10,2),
    qtd_disciplinas INT,
    FOREIGN KEY (id_professor) REFERENCES dim_professor(id_professor),
    FOREIGN KEY (id_curso) REFERENCES dim_curso(id_curso),
    FOREIGN KEY (id_departamento) REFERENCES dim_departamento(id_departamento),
    FOREIGN KEY (id_tempo) REFERENCES dim_tempo(id_tempo)
);
