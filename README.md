# 📊 Dashboard de Vendas Acadêmicas — Star Schema + Power BI + SQL Server

![Klabin003](https://github.com/user-attachments/assets/f3b7de26-5d6b-4247-aa9b-59a143e3988e)

**Bootcamp NTT DATA — Modelagem Dimensional com Power BI e SQL Server**

---

## 1. Problema de Negócio

Instituições de ensino acumulam dados operacionais sobre professores, cursos e departamentos em sistemas transacionais projetados para registrar — não para analisar. Um banco relacional normalizado responde bem a perguntas como "qual professor ministra qual curso?", mas falha quando a pergunta muda para **"qual departamento gera mais receita por hora de curso? Quais professores têm maior produtividade em relação à sua carga horária? Como a oferta de cursos EAD evoluiu trimestre a trimestre?"**

Essas perguntas exigem um modelo diferente. Um modelo relacional normalizado, pensado para integridade de escrita, torna consultas analíticas lentas, complexas e difíceis de manter. **A cada nova pergunta de negócio, uma nova query complicada com múltiplos JOINs.**

O desafio deste projeto foi transformar um modelo transacional de gestão acadêmica em uma estrutura dimensional otimizada para análise — onde qualquer pergunta sobre professores, cursos, departamentos e tempo possa ser respondida com velocidade, sem que o analista precise escrever SQL complexo toda vez.

---

## 2. Contexto

Este projeto foi desenvolvido como parte do **Bootcamp NTT DATA**, com foco em modelagem dimensional aplicada ao domínio de gestão educacional.

O cenário representa uma instituição de ensino com múltiplos departamentos, oferta de cursos presenciais e EAD, corpo docente com diferentes formações e titulações, e necessidade de monitorar indicadores como receita por curso, carga horária por professor e distribuição de disciplinas por área do conhecimento.

Os dados de origem estão armazenados em um **Microsoft SQL Server** — um modelo relacional transacional típico de sistemas ERP acadêmicos. O objetivo foi extrair esse modelo, reestruturá-lo em um **Star Schema (Esquema em Estrela)** e construir um **dashboard analítico no Power BI** que permita à gestão institucional responder perguntas estratégicas sem depender da equipe de TI para cada consulta.

---

## 3. Premissas da Modelagem

Para a construção do modelo dimensional, as seguintes premissas foram adotadas:

- **A tabela fato registra eventos mensuráveis, não entidades.** `fato_professor_curso` representa cada oferta de curso por professor — com suas métricas associadas (carga horária, valor, número de disciplinas). Dados descritivos pertencem exclusivamente às dimensões.
- **Granularidade definida antes do modelo.** O grão da tabela fato é **uma oferta de curso por professor por período** — essa decisão foi tomada antes de qualquer tabela ser criada, pois ela define quais métricas fazem sentido na fato e quais são atributos das dimensões.
- **`dim_tempo` criada como dimensão explícita, não como campo de data.** Armazenar apenas uma coluna `DATE` na fato impediria análises por trimestre, semestre ou ano sem processamento adicional. A dimensão de tempo pré-calculada elimina esse custo em tempo de consulta.
- **Chaves substitutas (surrogate keys) em todas as dimensões.** Os IDs das dimensões são gerados no modelo dimensional — não herdados do sistema de origem. Isso protege o modelo de mudanças no sistema transacional e garante estabilidade dos relacionamentos.
- **Modalidade e tipo de curso como atributos de `dim_curso`.** A separação entre Graduação/Pós/Extensão e Presencial/EAD em `dim_curso` permite que o Power BI filtre por qualquer combinação dessas dimensões sem medidas condicionais.

---

## 4. Estratégia da Solução

A construção seguiu o pipeline clássico de modelagem dimensional em quatro etapas:

**Etapa 1 — Identificação das perguntas de negócio**
Antes de qualquer linha de SQL, foram mapeadas as perguntas que o dashboard precisava responder: Qual o total de cursos ministrados por departamento? Qual professor acumula mais carga horária? Qual a receita por modalidade (EAD vs. Presencial)? Como as ofertas evoluem ao longo do tempo? Essas perguntas definiram as dimensões necessárias e as métricas da tabela fato.

**Etapa 2 — Modelagem dimensional (Star Schema)**
Definição da tabela fato `fato_professor_curso` com quatro chaves estrangeiras (professor, curso, departamento, tempo) e três métricas (carga horária, valor do curso, quantidade de disciplinas). Criação das quatro dimensões: `dim_professor`, `dim_curso`, `dim_departamento` e `dim_tempo` — cada uma com atributos descritivos que viabilizam análises cruzadas no Power BI.

**Etapa 3 — Extração e carga no SQL Server**
Scripts SQL para criação do schema dimensional, populamento das tabelas dimensão a partir do modelo transacional de origem e geração da tabela fato por cruzamento das entidades. Azure Data Studio utilizado para validação das queries e verificação de integridade referencial entre fato e dimensões.

**Etapa 4 — Integração com Power BI e construção do dashboard**
Conexão Power BI → SQL Server via conector nativo. Relacionamentos definidos entre `fato_professor_curso` e cada dimensão com cardinalidade 1:N e direção de filtro dimensão → fato. Criação das medidas DAX para os KPIs principais. Dashboard construído com cinco visões analíticas cobrindo cursos, receita, carga horária, modalidade e evolução temporal.

---

## 5. Decisões Técnicas

**Por que Star Schema e não o modelo relacional diretamente no Power BI?**
O modelo relacional transacional tem tabelas normalizadas até a 3ª Forma Normal — excelente para integridade de escrita, terrível para leitura analítica. Carregar esse modelo diretamente no Power BI produziria medidas DAX com múltiplos `RELATED()` aninhados, filtros que se propagam em direções inesperadas e performance degradada. O Star Schema resolve tudo isso na camada de dados: o Power BI recebe um modelo otimizado para leitura, e as medidas DAX ficam simples e previsíveis.

**Por que `dim_tempo` explícita em vez de apenas uma coluna `DATE` na fato?**
Uma coluna `DATE` na fato permite agrupar por data. Uma `dim_tempo` com `ano`, `mes`, `trimestre` e `semestre` pré-calculados permite filtrar, agrupar e comparar por qualquer granularidade temporal sem que o Power BI precise calcular essas decomposições em tempo de execução. Em dashboards com alto volume de dados, isso tem impacto direto na velocidade de renderização dos visuais.

**Por que separar `dim_curso` de `dim_departamento`?**
Cursos e departamentos têm ciclos de vida independentes: um departamento pode existir sem cursos ativos, e um curso pode mudar de departamento ao longo do tempo. Manter essas entidades em dimensões separadas garante que filtrar por "área de conhecimento" não interfira nos filtros por "tipo de curso" — cada dimensão mantém sua independência analítica.

**Por que Azure Data Studio para validação?**
O Azure Data Studio foi usado para inspecionar as queries de populamento do modelo dimensional e validar a integridade referencial antes de conectar ao Power BI. Identificar um problema de cardinalidade no SQL é significativamente mais rápido do que depurá-lo depois que o modelo já está carregado no Power BI Desktop.

**O que eu faria diferente hoje?**
Implementaria **Slowly Changing Dimensions (SCD Tipo 2)** na `dim_professor` para rastrear mudanças de titulação ao longo do tempo — permitindo analisar se a evolução da titulação do corpo docente impacta a receita ou a carga horária dos departamentos. Também adicionaria uma camada de staging no SQL Server para separar a extração do modelo transacional da carga no modelo dimensional.

---

## 6. Insights do Desenvolvimento

Durante a construção do projeto, três aprendizados foram determinantes:

- **Definir o grão antes de criar a fato é inegociável.** Na primeira versão do modelo, a tabela fato misturava granularidades — algumas linhas representavam ofertas individuais, outras eram agregados por professor. O resultado foram métricas inconsistentes no dashboard. Redefinir o grão como "uma oferta por professor por período" e recriar a fato do zero resolveu o problema — e ensinou que essa decisão precede qualquer outra no design dimensional.
- **Chaves substitutas evitam dores de cabeça futuras.** Durante o desenvolvimento, os IDs do sistema de origem foram alterados em uma das tabelas transacionais. Como o modelo dimensional usava surrogate keys próprias, nenhum relacionamento no Power BI quebrou — bastou atualizar o script de carga. Com IDs herdados do sistema de origem, o impacto teria sido muito maior.
- **O Star Schema simplifica o DAX drasticamente.** As medidas `Total Cursos`, `Receita Total`, `Média Carga Horária` e `Receita por Professor` foram implementadas com funções simples (`SUM`, `AVERAGE`, `DIVIDE`) porque o modelo já estava estruturado corretamente. Em um modelo desnormalizado, essas mesmas métricas exigiriam `CALCULATE` com múltiplos filtros para compensar a falta de dimensões claras.

---

## 7. Resultados

Com o modelo dimensional e o dashboard implementados, o projeto entrega:

- ✅ **Star Schema completo** com 1 tabela fato e 4 dimensões totalmente relacionadas e documentadas
- ✅ **5 visões analíticas** no dashboard: total de cursos por departamento, carga horária por professor, receita por área, distribuição por modalidade (EAD/Presencial) e evolução temporal das ofertas
- ✅ **4 medidas DAX** — Total Cursos, Receita Total, Média Carga Horária, Receita por Professor — simples e performáticas graças ao modelo bem estruturado
- ✅ **Scripts SQL documentados** para criação e populamento do schema dimensional no SQL Server
- ✅ **Modelo reutilizável** — qualquer nova dimensão (ex: `dim_aluno`, `dim_turno`) pode ser adicionada sem alterar a tabela fato existente

---

## 8. Próximos Passos

- [ ] Implementar **SCD Tipo 2** em `dim_professor` para rastrear evolução de titulação e formação ao longo do tempo
- [ ] Adicionar `dim_aluno` e métricas de matrícula para ampliar o escopo analítico para gestão de alunos
- [ ] Criar camada de **staging no SQL Server** para separar extração, transformação e carga (padrão ETL)
- [ ] Publicar no **Power BI Service** com atualização agendada e RLS por departamento
- [ ] Adicionar medidas de **análise de rentabilidade por professor** — receita gerada ÷ custo salarial estimado

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia | Finalidade |
|---|---|
| Power BI Desktop | Modelagem de relacionamentos, DAX e design do dashboard |
| Microsoft SQL Server | Armazenamento do modelo dimensional |
| Azure Data Studio | Desenvolvimento e validação dos scripts SQL |
| Power Query (M) | Transformações adicionais na camada de importação |
| DAX | Medidas e KPIs dinâmicos |
| Excel / CSV | Fontes auxiliares para populamento inicial |
| Git + GitHub | Versionamento e documentação do projeto |

---

## 🧮 Modelo Dimensional — Star Schema

```
         dim_professor
               │
  dim_tempo ───┤
               ├──── fato_professor_curso
  dim_curso ───┤       carga_horaria
               │       valor_curso
  dim_depto  ──┘       qtd_disciplinas
```

### Tabela Fato: `fato_professor_curso`

| Campo | Tipo | Descrição |
|---|---|---|
| id_fato | INT | Identificador da oferta |
| id_professor | INT | FK → dim_professor |
| id_curso | INT | FK → dim_curso |
| id_departamento | INT | FK → dim_departamento |
| id_tempo | INT | FK → dim_tempo |
| carga_horaria | DECIMAL | Carga horária do curso ministrado |
| valor_curso | DECIMAL | Receita gerada pelo curso |
| qtd_disciplinas | INT | Número de disciplinas ministradas |

### Dimensões

**`dim_professor`** — nome, formação, titulação, tempo de casa
**`dim_curso`** — nome, tipo (Graduação/Pós/Extensão), modalidade (Presencial/EAD), carga horária total
**`dim_departamento`** — nome, área de conhecimento, coordenador
**`dim_tempo`** — data de oferta, ano, mês, trimestre, semestre

---

## 📐 Medidas DAX

```dax
Total Cursos = COUNTROWS(fato_professor_curso)

Receita Total = SUM(fato_professor_curso[valor_curso])

Média Carga Horária = AVERAGE(fato_professor_curso[carga_horaria])

Receita por Professor =
DIVIDE([Receita Total], DISTINCTCOUNT(fato_professor_curso[id_professor]), 0)
```

> Documentação completa em [`/powerbi/medidas_DAX.md`](powerbi/medidas_DAX.md)

---

## 📂 Estrutura do Repositório

<img width="823" height="527" alt="Screenshot_20251030-192354" src="https://github.com/user-attachments/assets/c5dc46c1-d8b7-49b5-bf2f-15fa1eb5bdf7" />

```
dashboardStarShema/
├── sql/
│   ├── create_schema.sql             # DDL: criação das tabelas dimensão e fato
│   └── populate_tables.sql           # DML: populamento do modelo dimensional
├── powerbi/
│   ├── dashboard_vendas.pbix         # Arquivo Power BI com modelo e dashboard
│   └── medidas_DAX.md                # Medidas DAX documentadas e comentadas
├── data/
│   └── *.csv                         # Arquivos de dados de origem
└── README.md
```

---

## ▶️ Como Executar o Projeto

**Pré-requisitos:** Power BI Desktop 2023+, SQL Server (ou SQL Server Express), Azure Data Studio ou SSMS, Git

```bash
# Clone o repositório
git clone https://github.com/Santosdevbjj/dashboardStarShema
```

1. Execute `sql/create_schema.sql` no SQL Server para criar as tabelas dimensão e fato
2. Execute `sql/populate_tables.sql` para popular o modelo com os dados de origem
3. Abra `powerbi/dashboard_vendas.pbix` no Power BI Desktop
4. Atualize a string de conexão apontando para o seu servidor SQL
5. Clique em **Atualizar** e explore o dashboard

**Sem SQL Server?** Importe os arquivos `data/*.csv` diretamente no Power BI via Obter Dados → Texto/CSV, crie os relacionamentos manualmente entre as dimensões e a fato, e aplique as medidas documentadas em `/powerbi/medidas_DAX.md`.

---

## 📄 Licença

Este projeto está licenciado sob a **MIT License** — consulte o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## Autor

**Sergio Santos**

[![Portfólio](https://img.shields.io/badge/Portfólio-Sérgio_Santos-111827?style=for-the-badge&logo=githubpages&logoColor=00eaff)](https://portfoliosantossergio.vercel.app)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Sérgio_Santos-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/santossergioluiz)
