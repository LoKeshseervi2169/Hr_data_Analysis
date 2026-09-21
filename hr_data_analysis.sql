-- ================================================
-- HR DATABASE ANALYSIS | MySQL Portfolio Project
-- ================================================


-- ========================
-- Creation of Database
-- ========================
Create database if not exists hr_db;
use hr_db;

-- ========================
-- Schemas for the Tables
-- ========================

create table if not exists employees (
    emp_no INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(1) DEFAULT NULL,
    birth_date DATE NOT NULL,
    hire_date DATE NOT NULL,
    PRIMARY KEY (emp_no));


Create table if not exists departments (
    dept_no VARCHAR(50) NOT NULL,
    dept_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE (dept_name));


Create table if not exists dept_emp(
    emp_no INT NOT NULL,
    dept_no VARCHAR(10) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    PRIMARY KEY (emp_no, dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no));


Create table if not exists dept_manager (
    emp_no INT NOT NULL,
    dept_no VARCHAR(10) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    PRIMARY KEY (emp_no, dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no));


Create table if not exists salary (
    emp_no INT NOT NULL,
    salary INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    PRIMARY KEY (emp_no, from_date),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no));


Create table if not exists titles (
    emp_no INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    PRIMARY KEY (emp_no, title, from_date),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no));


-- =====================================
-- SECTION 1: BASIC EMPLOYEE ANALYSIS
-- =====================================

-- Q1.Find the total number of employees

select count(emp_no) as Total_employees 
from employees;


-- Q2. Find the total number of departments.

select count(*) as Total_Departments 
from departments;


-- Q3. Find the count of male and female employees.

select gender ,
       count(gender) as employees_count 
from employees 
group by gender 
order by employees_count;


-- Q4. Display employees in alphabetical order by first name.

select * 
from employees 
order by first_name asc;


-- Q5. Display the first name, last name, and gender of employees.

select first_name,
       last_name,
       gender
 from employees;


-- Q6.Find employees hired after 2010.
 
 select * from employees 
 where hire_date>'2010-12-31'
 order by hire_date;


-- Q7. Find employees whose last name ends with the letter n.

select * 
from employees 
where last_name like '%n';


-- Q8. Find female employees hired after 2009.

select * 
from employees 
where hire_date>'2009-12-31' and gender='f' 
order by hire_date asc;


-- Q9. Find how many employees were hired in each year.

select 
year(hire_date)as Year,
count(emp_no) as employees_hired 
from employees 
group by year(hire_date) 
order by year(hire_date)asc;


-- Q10. Find the hire year in which the highest number of employees were hired.

select 
year(hire_date) as Year,
count(emp_no) as employees_hired 
from employees 
group by year(hire_date) 
order by employees_hired desc limit 1;


-- ===================================
-- SECTION 2: DEPARTMENT ANALYSIS
-- ===================================


-- Q11. Find the number of employees in each department.

select d.dept_no,
       d.dept_name,
       count(e.emp_no)as employees_count 
from departments as d 
left join dept_emp as de on d.dept_no=de.dept_no 
left join employees as e on de.emp_no=e.emp_no
group by d.dept_no,d.dept_name 
order by employees_count desc;


-- Q12. Find the department with the highest number of employees.

select d.dept_no,
       d.dept_name,
       count(e.emp_no)as employees_count 
from departments as d 
left join dept_emp as de on d.dept_no=de.dept_no 
left join employees as e on de.emp_no=e.emp_no
group by d.dept_no,d.dept_name 
order by employees_count desc limit 1;


-- Q.13 Find the department with the lowest number of employees.

select d.dept_no,
       d.dept_name,
       count(e.emp_no)as employees_count 
from departments as d 
left join dept_emp as de on d.dept_no=de.dept_no 
left join employees as e on de.emp_no=e.emp_no
group by d.dept_no,d.dept_name 
order by employees_count asc limit 1;


-- Q.14 Find the count of male and female employees in each department.

select d.dept_name,
       e.gender,
       count(e.emp_no)as employees_count 
from departments as d 
left join dept_emp as de on d.dept_no=de.dept_no 
left join employees as e on de.emp_no=e.emp_no
group by d.dept_no,d.dept_name,e.gender 
order by dept_name,e.gender asc;	


-- Q.15 Find departments that have more than 10 employees.

select d.dept_no,
       d.dept_name,
       count(e.emp_no)as employees_count 
from departments as d 
left join dept_emp as de on d.dept_no=de.dept_no left join employees as e on de.emp_no=e.emp_no
group by d.dept_no,d.dept_name having employees_count >10 order by dept_no,dept_name asc;


-- Q.16 Calculate the average employee tenure in each department.

select d.dept_no,
       d.dept_name,
       round(avg(datediff(case when de.to_date='9999-01-01' 
       then curdate()
       else de.to_date
       end,de.from_date))/365,2)as avg_tenure_years 
from dept_emp as de 
join departments as d on de.dept_no=d.dept_no
group by d.dept_no,d.dept_name 
order by avg_tenure_years desc;


-- Q.17 Count current employees according to their department.

select d.dept_no,
       d.dept_name,
       count(de.emp_no)as current_employees_count 
from dept_emp as de 
join departments as d on de.dept_no=d.dept_no
where de.to_date='9999-01-01' 
group by d.dept_no,d.dept_name
order by current_employees_count desc;


-- Q.18 Find departments whose employees have an average hire year after 2005.

select d.dept_no,
       d.dept_name,
       round(avg(year(hire_date)),2)as avg_hire_year 
from employees as e 
join dept_emp as de
on e.emp_no=de.emp_no
join departments as d
on de.dept_no=d.dept_no
group by d.dept_no,d.dept_name
having avg(year(hire_date))>2005
order by avg_hire_year desc;


-- Q.19  Find the oldest employee in each department.

select d.dept_no,
       d.dept_name,
       e.emp_no,
       e.first_name,
       e.last_name,
       e.hire_date
from employees as e 
join dept_emp as de 
on e.emp_no=de.emp_no
join departments as d
on de.dept_no=d.dept_no
where e.hire_date =
(select  min(e2.hire_date)
from employees as e2
join dept_emp as de2
on e2.emp_no=de2.emp_no
where de2.dept_no=de.dept_no);


-- Q20. Find employees who have more than 1 title.

select e.emp_no,
       concat(e.first_name," ",e.last_name)as employee_name,
       count(distinct t.title) as title_count
from employees as e 
join titles as t
on e.emp_no=t.emp_no
group by e.emp_no,e.first_name,e.last_name
having count(distinct t.title)>1;


-- ===============================
-- SECTION 3: SALARY ANALYSIS
-- ===============================


-- Q21. Find the company's average salary.

select avg(salary) 
from salary;


-- Q22. Find the highest salary and lowest salary.

select 
max(salary)as highest_salary,
min(salary)as lowest_salary
from salary;


-- Q23. Find the top 10 highest-paid employees.

select e.emp_no,
       e.first_name,
       e.last_name,
       max(s.salary) as highest_salary
from employees as e
join salary as s
on e.emp_no=s.emp_no
group by e.emp_no,e.first_name,e.last_name
order by highest_salary desc limit 10;


-- Q24. Calculate the average salary for each department.

select d.dept_no,
       d.dept_name,
       round(avg(emp_salary),2) as average_salary
from departments as d
join dept_emp as de
on d.dept_no=de.dept_no
join
 (select emp_no,max(salary) as emp_salary
 from salary
 group by emp_no)as s
on de.emp_no=s.emp_no
group by d.dept_no,d.dept_name
order by average_salary desc;


-- Q25. Find the highest salary in each department.

select d.dept_no,
       d.dept_name,
       max(s.salary) as highest_salary
from departments as d
join dept_emp as de
on d.dept_no=de.dept_no
join salary as s
on de.emp_no=s.emp_no
group by d.dept_no,d.dept_name
order by highest_salary desc;


-- Q26. Find the lowest salary in each department.

select d.dept_no,
       d.dept_name,
       min(s.salary) as lowest_salary
from departments as d
join dept_emp as de
on d.dept_no=de.dept_no
join salary as s
on de.emp_no=s.emp_no
group by d.dept_no,d.dept_name
order by lowest_salary asc;


-- Q27. Find departments whose average salary is higher than the company average salary.

 select d.dept_no,
        d.dept_name,
        round(avg(s.salary),2)as avg_salary
 from departments as d
 join dept_emp as de
 on d.dept_no=de.dept_no
 join salary as s
 on de.emp_no=s.emp_no
 group by d.dept_no,d.dept_name
 having avg_salary >
 (select avg(salary) 
 from salary)
 order by avg_salary desc;
 
 
 -- Q28. Rank employees based on salary.
 
select e.emp_no,
	   e.first_name,
	   e.last_name,s.salary,
       dense_rank()
       over(order by s.salary desc) as salary_rank
from employees as e
join salary as s
on e.emp_no=s.emp_no
order by salary_rank;


-- Q29. Find the top 3 highest-paid employees in each department.

select dept_no,
       dept_name,
       emp_no,
       concat(first_name," ",last_name)as employee_name,
       salary
from
    (select d.dept_no,
            d.dept_name,
            e.emp_no,
            e.first_name,
            e.last_name,
            s.salary,
            row_number()
            over (partition by d.dept_no order by s.salary desc)as rn
from departments as d
join dept_emp as de
on d.dept_no=de.dept_no
join salary as s
on de.emp_no=s.emp_no
join employees as e
on s.emp_no=e.emp_no
)as ranked
where rn<=3
order by dept_no,salary desc;


-- Q30. Find the employee(s) with the second-highest salary.

select emp_no,
       concat(first_name," ",last_name)as employee_name,
       salary
from(
      select e.emp_no,
	         e.first_name,
	         e.last_name,s.salary,
             dense_rank() 
             over(order by s.salary desc)as salary_rank
      from salary as s
      join employees as e
      on s.emp_no=e.emp_no
      ) ranked
where salary_rank=2;


-- ============================================
-- SECTION 4: EMPLOYEE & DEPARTMENT DETAILS
-- ============================================


-- Q31. Display the employee's emp_no, full name, and department name.

select e.emp_no,
       concat(e.first_name," ",e.last_name)as employee_name,
       d.dept_name
from departments as d
join dept_emp as de
on d.dept_no=de.dept_no
join employees as e
on de.emp_no=e.emp_no;


-- 32. Display the employee's full name, department, and current title.

select concat(e.first_name," ",e.last_name)as employee_name,
       d.dept_name,
       t.title
from departments as d
join dept_emp as de
on d.dept_no=de.dept_no
join employees as e
on de.emp_no=e.emp_no
join titles as t
on e.emp_no=t.emp_no;


-- Q33.Display each employee's full name and highest salary received.

select concat(e.first_name," ",e.last_name)as full_name,
       max(s.salary)as highest_salary
from employees as e
join salary as s
on e.emp_no=s.emp_no
group by e.emp_no,e.first_name,e.last_name
order by highest_salary;


-- Q34. Display the employee's name, department name, and salary together.

select concat(e.first_name," ",e.last_name)as employee_name,
       d.dept_name,
       s.salary as employee_salary,
       s.from_date,
       s.to_date
from departments as d
join dept_emp as de
on d.dept_no=de.dept_no
join employees as e
on de.emp_no=e.emp_no
join salary as s
on e.emp_no=s.emp_no
order by e.emp_no,s.from_date;


-- ===========================================
-- SECTION 5: MANAGER & HISTORY ANALYSIS
-- ===========================================


-- Q35. Find the name of the manager of each department.

select dm.emp_no,
       d.dept_no,
       d.dept_name,
       concat(e.first_name," ",e.last_name)as manager_name
from departments as d
join dept_manager as dm
on d.dept_no=dm.dept_no
join employees as e
on dm.emp_no=e.emp_no
group by dm.emp_no,dm.dept_no,d.dept_name
order by manager_name;


-- Q36. Display each department's manager and their salary.

select dm.emp_no,
       d.dept_no,
       d.dept_name,
       concat(e.first_name," ",e.last_name)as manager_name,
       s.salary as manager_salary,s.from_date,s.to_date
from departments as d
join dept_manager as dm
on d.dept_no=dm.dept_no
join employees as e
on dm.emp_no=e.emp_no
join salary as s
on e.emp_no=s.emp_no
order by dm.emp_no,s.from_date;


-- Q37. Find employees who are also managers of a department.

select e.emp_no,
       concat(e.first_name, " ", e.last_name) as employee_name,
       d.dept_no,
       d.dept_name
from departments as d
join dept_emp as de
on d.dept_no=de.dept_no
join employees as e
on de.emp_no=e.emp_no
join dept_manager as dm
on e.emp_no = dm.emp_no;


-- Q38. Find employees who are not currently assigned to any department.

select e.emp_no,
       concat(e.first_name," ",e.last_name)as employee_name
from employees as e
left join dept_emp as de
on e.emp_no=de.emp_no
where de.emp_no is null;


-- Q39. Display each employee's department and title history.

select d.dept_no,
       d.dept_name,
       de.from_date as dept_from,de.to_date as dept_to,
       concat(e.first_name, " ",e.last_name)as employee_name,
       t.title,t.from_date as title_from,t.to_date as title_to
from departments as d
join dept_emp as de
on d.dept_no=de.dept_no
join titles as t
on de.emp_no=t.emp_no
join employees as e
on t.emp_no=e.emp_no
order by e.emp_no,de.from_date,t.from_date;


-- Q40. Combine and display each employee's salary history and department history.

select e.emp_no,d.dept_no,d.dept_name,de.from_date,de.to_date,
       concat(e.first_name," ",e.last_name)as employee_name,
	     s.salary,s.from_date,s.to_date
from departments as d
join dept_emp as de
on d.dept_no=de.dept_no
join employees as e
on de.emp_no=e.emp_no
join salary as s
on e.emp_no=s.emp_no
order by d.dept_name,de.from_date,s.salary,s.from_date;


-- Q41.Find employees who earn more than the company’s average salary.

select e.emp_no,
	     concat(e.first_name," ",e.last_name) as employee_name,
       round(avg(s.salary),2)as avg_salary
from employees as e
join salary as s
on e.emp_no=s.emp_no
group by e.emp_no,e.first_name,e.last_name,s.salary
having avg(s.salary) >
	   (select avg(salary)
	   from salary)
order by avg_salary desc;


-- Q42.Find employees who earn more than the average salary of their department.

select e.emp_no,
       concat(e.first_name," ",e.last_name)as employee_name,
       d.dept_name,
       s.salary
from employees as e
join salary as s
on e.emp_no=s.emp_no
join dept_emp as de
on s.emp_no=de.emp_no
join departments as d
on de.dept_no=d.dept_no
where s.salary > 
      (select avg(s2.salary)
      from salary as s2
      join dept_emp as de2
      on s2.emp_no-de2.emp_no
      where de2.dept_no=de.dept_no)
order by d.dept_name,s.salary desc;


-- Q43.Find the count of employees in each department who earn more than the company’s average salary.

select d.dept_name,
	   count(distinct e.emp_no) as employees_count
from employees as e
join salary as s
on e.emp_no=s.emp_no
join dept_emp as de
on s.emp_no=de.emp_no
join departments as d
on de.dept_no=d.dept_no
where s.salary >
      (select avg(salary) 
      from salary)
group by d.dept_no,d.dept_name
order by employees_count desc;


-- Q44.Find the highest-paid employee in each department.

select dept_no,
       dept_name,
       emp_no,
       concat(first_name," ",last_name)as employee_name,
       salary
from 
      (select d.dept_no,
			  d.dept_name,
              e.emp_no,
              e.first_name,
              e.last_name,
              s.salary,
              row_number()
              over (partition by d.dept_no
              order by s.salary desc)as rn
              from departments as d
              join dept_emp as de
              on d.dept_no=de.dept_no
              join employees as e
              on de.emp_no=e.emp_no
			  join salary as s
              on e.emp_no=s.emp_no)as ranked
              where rn <=1
              order by dept_no,salary;


-- Q45.Find the second-highest-paid employee in each department.

select dept_no,
       dept_name,
       emp_no,
       concat(first_name," ",last_name)as employee_name,
       salary
from 
      (select d.dept_no,
	          d.dept_name,
              e.emp_no,
              e.first_name,
              e.last_name,
              s.salary,
              dense_rank ()
              over(partition by d.dept_no 
				   order by s.salary desc)as salary_rank
              from departments as d
              join dept_emp as de
              on d.dept_no=de.dept_no
              join employees as e
              on de.emp_no=e.emp_no
			  join salary as s
              on e.emp_no=s.emp_no)as ranked_salary
              where salary_rank=2
              order by dept_no,salary desc;


-- Q46. Find employees whose salary is below their department’s average salary.

select e.emp_no,
       concat(e.first_name," ",e.last_name)as employee_name,
       d.dept_name,
       s.salary
from employees as e
join salary as s
on e.emp_no=s.emp_no
join dept_emp as de
on s.emp_no=de.emp_no
join departments as d
on de.dept_no=d.dept_no
where s.salary <
      (select avg(s2.salary)
      from salary as s2
      join dept_emp as de2
      on s2.emp_no-de2.emp_no
      where de2.dept_no=de.dept_no)
order by d.dept_name,s.salary desc;


-- Q47.Display the department and title of the company’s top 5 highest-paid employees.

select e.emp_no,
       concat(e.first_name," ",e.last_name),
       d.dept_no,
       d.dept_name,
       t.title,
       max(s.salary)as highest_salary
from departments as d
join dept_emp as de
on d.dept_no=de.dept_no
join employees as e
on de.emp_no=e.emp_no
join titles as t
on e.emp_no=t.emp_no
join salary as s
on t.emp_no=s.emp_no
group by e.emp_no,
         e.first_name,
         e.last_name,
         d.dept_no,
         d.dept_name,
	     t.title
order by highest_salary desc limit 5;


-- Q48.Find the employee who was hired earliest in the company for each department.

select e.emp_no,
       concat(e.first_name," ",e.last_name),
       e.hire_date,
       d.dept_no,
       d.dept_name
from employees as e
join dept_emp as de
on e.emp_no=de.emp_no
join departments as d
on de.dept_no=d.dept_no
where e.hire_date =
      (select min(e2.hire_date)
      from employees as e2
      join dept_emp as de2
      on e2.emp_no=de2.emp_no
      where de2.dept_no=de.dept_no);
      

-- Q49.Find the most recently hired employee in each department.

select e.emp_no,
	   concat(e.first_name," ",e.last_name),
       e.hire_date,
       d.dept_no,
       d.dept_name
from employees as e
join dept_emp as de
on e.emp_no=de.emp_no
join departments as d
on de.dept_no=d.dept_no
where e.hire_date=
      (select max(e2.hire_date)
      from employees as e2
      join dept_emp as de2
      on e2.emp_no=de2.emp_no
      where de2.dept_no=de.dept_no);
      

-- Q50.Find departments where the highest salary is greater than the company’s overall average salary.

select d.dept_no,
       d.dept_name,
       max(s.salary)as highest_salary
from departments as d
join dept_emp as de
on d.dept_no=de.dept_no
join salary as s
on de.emp_no=s.emp_no
group by d.dept_no,
         d.dept_name
having max(s.salary)>
       (select avg(salary) as overall_avg_salary
       from salary)
order by dept_name desc;
