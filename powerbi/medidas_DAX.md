### 💡 Principais Medidas DAX

**Total Cursos =**
```DAX
COUNTROWS(fato_professor_curso)

Receita Total =

SUM(fato_professor_curso[valor_curso])

Média Carga Horária =

AVERAGE(fato_professor_curso[carga_horaria])

Receita por Professor =

DIVIDE(SUM(fato_professor_curso[valor_curso]), COUNTROWS(DISTINCT(dim_professor[id_professor])))

---

## **/powerbi/integracao_mysql_azure.md**

```markdown
# Integração Power BI + Azure MySQL

1. Crie uma instância de **Azure Database for MySQL**.
2. Configure as tabelas com base nos scripts SQL.
3. No Power BI, clique em **Obter Dados → Banco de Dados MySQL**.
4. Insira as credenciais e conecte-se ao banco.
5. Configure a atualização agendada no Power BI Service.
