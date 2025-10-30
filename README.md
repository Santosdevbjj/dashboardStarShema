## Dashboard de Vendas com Power BI utilizando Star Schema


---

![Klabin003](https://github.com/user-attachments/assets/f3b7de26-5d6b-4247-aa9b-59a143e3988e)


---

# 📊 Dashboard de Vendas com Power BI utilizando Star Schema

Este projeto tem como objetivo a **criação de um modelo dimensional (Star Schema)** e o desenvolvimento de um **dashboard analítico no Power BI**, com foco em **análises relacionadas aos professores, cursos e departamentos**.

---

## 🎯 Objetivo
Transformar o modelo relacional original em um **modelo dimensional otimizado** para análise no Power BI, com base no conceito de **Esquema em Estrela (Star Schema)**.

---

## 🧩 Estrutura do Modelo Dimensional

### 🧱 Tabela Fato: `fato_professor_curso`
Contém os dados principais para análise:
| Campo | Tipo | Descrição |
|--------|------|------------|
| id_fato | INT | Identificador da transação |
| id_professor | INT | Chave estrangeira da dimensão professor |
| id_curso | INT | Chave estrangeira da dimensão curso |
| id_departamento | INT | Chave estrangeira da dimensão departamento |
| id_tempo | INT | Chave estrangeira da dimensão tempo |
| carga_horaria | DECIMAL | Carga horária do curso ministrado |
| valor_curso | DECIMAL | Valor do curso |
| qtd_disciplinas | INT | Número de disciplinas ministradas |

---

### 🧩 Tabelas Dimensão

#### `dim_professor`
| Campo | Tipo | Descrição |
|--------|------|------------|
| id_professor | INT | Identificador único |
| nome | VARCHAR(100) | Nome completo |
| formacao | VARCHAR(80) | Formação acadêmica |
| titulacao | VARCHAR(80) | Nível de titulação |
| tempo_casa | INT | Tempo de vínculo em anos |

#### `dim_curso`
| Campo | Tipo | Descrição |
|--------|------|------------|
| id_curso | INT | Identificador |
| nome_curso | VARCHAR(100) | Nome do curso |
| tipo | VARCHAR(50) | Graduação, Pós, Extensão |
| modalidade | VARCHAR(50) | Presencial, EAD |
| carga_horaria_total | INT | Total de horas do curso |

#### `dim_departamento`
| Campo | Tipo | Descrição |
|--------|------|------------|
| id_departamento | INT | Identificador |
| nome_departamento | VARCHAR(100) | Nome do departamento |
| area | VARCHAR(100) | Área de conhecimento |
| coordenador | VARCHAR(100) | Nome do coordenador |

#### `dim_tempo`
| Campo | Tipo | Descrição |
|--------|------|------------|
| id_tempo | INT | Identificador |
| data_oferta | DATE | Data da oferta do curso |
| ano | INT | Ano |
| mes | INT | Mês |
| trimestre | INT | Trimestre |
| semestre | INT | Semestre |

---

## ⚙️ Ferramentas Utilizadas
- **Power BI Desktop**
- **Microsoft SQL Server**
- **Power Query**
- **Excel / CSV**
- **DAX**
- **Azure Data Studio**

---

## 📈 Dashboard Power BI
O dashboard apresenta:
- Total de cursos ministrados
- Carga horária total por professor
- Receita total por departamento
- Distribuição de cursos por modalidade
- Evolução temporal das ofertas

---

## 🔗 Estrutura de Pastas 



📦 dashboardStarShema ├── 📁 data ├── 📁 modelagem ├── 📁 powerbi ├── 📁 sql ├── 📁 docs └── 📁 images 


---


