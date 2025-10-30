# Modelagem Dimensional

O modelo foi estruturado no formato **Star Schema**, composto por:
- 1 Tabela Fato: `fato_professor_curso`
- 4 Tabelas Dimensão: `dim_professor`, `dim_curso`, `dim_departamento`, `dim_tempo`

Essa estrutura permite uma análise rápida e direta por meio de agregações e filtros.

