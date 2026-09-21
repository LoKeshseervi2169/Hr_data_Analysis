# 📊 HR Analytics SQL Project

Analyzing employee, department, salary and management data with **MySQL** to answer real HR business questions.

---

## 📌 Project Overview

This project analyzes an HR database using MySQL. The goal is to explore employee information, departments, salaries, job titles, managers and employee history, and turn them into meaningful business insights.

The project contains **50 SQL queries**, starting from basic data retrieval and moving up to joins, subqueries and window functions.

---

## 🎯 Objectives

- Analyze employee demographics and hiring trends
- Analyze how employees are distributed across departments
- Calculate salary statistics and rankings
- Identify top-paid employees and departments
- Analyze job titles and the management structure
- Track how employees' departments and salaries changed over time

---

## 🗂️ Dataset Information

**Database name:** `hr_db`

**Source:** [add the link to your dataset here]

The database has 6 related tables:

| Table | Description |
|-------|-------------|
| `employees` | Personal and employment details of each employee |
| `departments` | List of departments |
| `dept_emp` | Which employee works in which department (history) |
| `dept_manager` | Which employee manages which department (history) |
| `titles` | Job title history of each employee |
| `salary` | Salary history of each employee |

**How the tables are connected:**

- `dept_emp`, `dept_manager`, `titles` and `salary` link to `employees` through `emp_no`
- `dept_emp` and `dept_manager` link to `departments` through `dept_no`

### Assumptions

- `dept_emp`, `dept_manager`, `titles` and `salary` are **history tables**. Each row has a `from_date` and a `to_date`, so one employee can have many rows.
- A `to_date` of `9999-01-01` means the record is still active (current).

---

## 🛠️ Tools & Technologies

- MySQL 8.0 (window functions need version 8.0 or higher)
- MySQL Workbench
- GitHub

---

## 🧠 SQL Concepts Used

- `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`
- `GROUP BY` and `HAVING`
- Aggregate functions (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`)
- `INNER JOIN` and `LEFT JOIN`
- Subqueries
- `CASE` statements
- Date functions
- `ROW_NUMBER()` and `DENSE_RANK()`
- `PARTITION BY`

---

## 📋 Analysis Areas

The 50 queries are grouped into 5 sections in `hr_data_analysis.sql`:

| Section | Queries | What it covers |
|---------|---------|----------------|
| 1. Basic Employee Analysis | Q1 – Q10 | Headcount, gender split, hiring trends |
| 2. Department Analysis | Q11 – Q20 | Department sizes, tenure, titles |
| 3. Salary Analysis | Q21 – Q30 | Salary statistics, rankings, top earners |
| 4. Employee & Department Details | Q31 – Q34 | Joining employees with departments, titles and salaries |
| 5. Manager & History Analysis | Q35 – Q50 | Managers, history tracking, above/below-average salaries |

---

## 💡 Key Business Questions

- Which department has the most employees?
- Which year had the highest number of hires?
- Which departments pay above the company average?
- Who are the top 3 highest-paid employees in each department?
- Who manages each department?
- Which employees have held more than one title?
- How have employees' salaries and departments changed over time?

---

## 🔍 Key Insights

<!-- Run the queries, then replace every [bracket] below with your real results. -->

| Question | Finding |
|----------|---------|
| Total employees | [number] |
| Largest department | [department name] with [number] employees |
| Year with the most hires | [year] with [number] hires |
| Company average salary | [amount] |
| Highest-paying department (average) | [department name] |
| Highest salary in the company | [amount] |

---

## 🧪 Sample Queries

**Employees hired in each year** (Q9)

```sql
SELECT YEAR(hire_date) AS hire_year,
       COUNT(emp_no)   AS employees_hired
FROM employees
GROUP BY YEAR(hire_date)
ORDER BY hire_year;
```

**Current employees in each department** (Q17)

```sql
SELECT d.dept_no,
       d.dept_name,
       COUNT(de.emp_no) AS current_employees_count
FROM dept_emp AS de
JOIN departments AS d ON de.dept_no = d.dept_no
WHERE de.to_date = '9999-01-01'
GROUP BY d.dept_no, d.dept_name
ORDER BY current_employees_count DESC;
```

---

## ▶️ How to Run

1. Install MySQL 8.0+ and MySQL Workbench.
2. Open `hr_data_analysis.sql` in Workbench and run the database and table creation part at the top.
3. Import the CSV files from the `data/` folder using the **Table Data Import Wizard**, in this order:
   `employees` → `departments` → `dept_emp` → `dept_manager` → `salary` → `titles`
   (Order matters because of the foreign keys.)
4. Run the queries one section at a time and check the results.

---

## 📁 Repository Structure

```text
HR-Analytics-SQL/
│
├── README.md
├── hr_data_analysis.sql
│
└── data/
    ├── employees.csv
    ├── departments.csv
    ├── dept_emp.csv
    ├── dept_manager.csv
    ├── salary.csv
    └── titles.csv
```

---

## 🚀 Skills Demonstrated

- Writing SQL queries from basic to intermediate level
- Relational database analysis
- Data aggregation and grouping
- Joining multiple tables
- Subqueries and window functions
- Salary analysis and HR analytics

---

## 👤 Author

**Lokesh**

Interests: Data Analytics | SQL | Excel | Power BI | Business Analytics

- LinkedIn: [your LinkedIn link]
- GitHub: [your GitHub link]
