
--department table 
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

--employees table 
CREATE TABLE join_employees (
    employee_id SERIAL PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    department_id INT,
    salary NUMERIC,
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

--projects table
CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

departments
     │
     │ department_id
     │
     ├──────────────► join_employees
     │
     └──────────────► projects


--insert the data into tables
INSERT INTO departments (department_name, location)
VALUES
('IT', 'Delhi'),
('Finance', 'Mumbai'),
('HR', 'Bangalore'),
('Marketing', 'Kolkata'),
('Sales', 'Pune');


INSERT INTO join_employees
(employee_name, department_id, salary)
VALUES
('Rahul Sharma', 1, 65000),
('Priya Singh', 3, 48000),
('Amit Kumar', 2, 72000),
('Neha Verma', 1, 55000),
('Rohit Das', 4, 45000),
('Anjali Gupta', 2, 68000),
('Vikash Kumar', 1, 82000),
('Sneha Roy', 3, 52000),
('Arjun Mehta', 5, 47000),
('Pooja Sharma', 4, 59000),
('Karan Singh', 1, 61000),
('Riya Das', 2, 75000);


INSERT INTO projects
(project_name, department_id)
VALUES
('Website Development', 1),
('Financial Analysis', 2),
('Recruitment System', 3),
('Social Media Campaign', 4),
('Sales Dashboard', 5);



select * from departments;

select * from join_employees;

select * from projects;

-- 1. Find employees whose salary is greater than
--    the average salary of all employees.
select employee_name,salary  from join_employees
where salary > (select avg(salary) from join_employees);

-- 2. Find employees who earn the
--    highest salary in the company.
select employee_name,salary from join_employees
where salary=(select max(salary )from join_employees);

-- 3. Find employees who earn less than
--    the average salary of all employees.
select employee_name,salary from join_employees
where salary < (select avg(salary) from join_employees);

-- 4. Find employees who earn the same salary
--    as at least one other employee.
select employee_name,salary from join_employees
where salary in ( select salary from join_employees
group by salary
having count(*)>1);

-- 5. Find employees who earn more than
--    the average salary of their department.
select je.employee_name,je.salary ,d.department_name from join_employees je join departments d
on je.department_id = d.department_id
where salary >(select avg(e2.salary) from join_employees e2
where e2.department_id=je.department_id)
;

-- 6. Find employees who earn more than
--    the average salary of the IT department.
select je.employee_name,je.salary ,d.department_name from join_employees je join departments d
on je.department_id = d.department_id
where salary >(select avg(e2.salary) from join_employees e2
JOIN departments d2
        ON e2.department_id = d2.department_id
    WHERE d2.department_name = 'IT') and department_name='IT'
;

-- 7. Find employees who work in a department
--    where the average salary is greater than 60000.
SELECT je.employee_name,
       je.salary,
       d.department_name
FROM join_employees je
JOIN departments d
    ON je.department_id = d.department_id
WHERE je.department_id IN (
    SELECT department_id
    FROM join_employees
    GROUP BY department_id
    HAVING AVG(salary) > 60000
);

-- 8. Find employees who do NOT work
--    in the IT department.
--
--    Use a subquery with NOT IN.
SELECT je.employee_name,
       je.salary,
       d.department_name
FROM join_employees je
JOIN departments d
    ON je.department_id = d.department_id
WHERE je.department_id not IN (
    select d2.department_id from departments d2 
where d2.department_name='IT')
;

-- 9. Find employees who are assigned
--    to at least one project.
--
--    Use EXISTS.
SELECT je.employee_name,
       je.salary,
       d.department_name
FROM join_employees je
JOIN departments d
    ON je.department_id = d.department_id
WHERE exists (
    select 1 from employee_projects ep
	where ep.employee_id= je.employee_id
	
 )
;

-- 10. Find employees who are NOT assigned
--     to any project.
--
--     Use NOT EXISTS.
SELECT je.employee_name,
       je.salary,
       d.department_name
FROM join_employees je
JOIN departments d
    ON je.department_id = d.department_id
WHERE not exists (
    select 1 from employee_projects ep
	where ep.employee_id= je.employee_id
	
 )
;

-- 11. Find the employee(s) who earn the
--     second-highest salary in the company.
SELECT employee_name, salary
FROM join_employees
WHERE salary = (
    SELECT MAX(salary)
    FROM join_employees
    WHERE salary < (
        SELECT MAX(salary)
        FROM join_employees
    )
);


-- 1. Create a CTE that calculates the
--    average salary for each department.
--
--    Then display:
--    department_id
--    average_salary
with department_average as(
select department_id,avg(salary) as avarage_salary from
join_employees
group by department_id
)
select * from department_average;

-- 2. Find departments whose average salary
--    is greater than 60000.
--
--    Display:
--    department_id
--    average_salary
with department as (
select department_id,avg(salary) as average_salary 
from join_employees
group by department_id
having avg(salary) > 60000
)
select * from department;

-- second method
WITH department AS (
    SELECT department_id,
           AVG(salary) AS average_salary
    FROM join_employees
    GROUP BY department_id
)
SELECT *
FROM department
WHERE average_salary > 60000;

-- 3. Display each department name
--    and its average salary.
--
--    Use a CTE to calculate the average salary
--    for each department, then JOIN it with
--    the departments table.
with average_salary as (
select department_id, avg(salary) as avg_salary from join_employees
group by department_id
)
select d.department_name,a_s.avg_salary from departments d 
join average_salary a_s 
on d.department_id = a_s.department_id;

-- 4. Display the department name,
--    average salary, and employee count
--    for departments whose average salary
--    is greater than 60000.
--
--    Use a CTE.
with high_salary as (
select department_id ,avg(salary) as average_salary , count(employee_id) as employee_count
from join_employees
group by department_id
)
select d.department_name,hs.average_salary,hs.employee_count 
from departments d join high_salary hs
on d.department_id = hs.department_id
where average_salary > 60000;

-- 5. Find the employee(s) who earn more than
--    their department's average salary.
--
--    Use a CTE.
--
--    Display:
--    employee_name
--    salary
--    department_name
--    department_average_salary
with department_averege as (
select department_id,avg(salary) as avg_department from 
join_employees
group by department_id
)
select je.employee_name,je.salary ,d.department_name,da.avg_department
from join_employees je join departments d
on je.department_id = d.department_id
join department_averege da
on je.department_id = da.department_id
where je.salary>da.avg_department;

-- 6. Find the department with the highest
--    total salary.
--
--    Display:
--    department_name
--    total_salary
--
--    Use a CTE.
with high_salary as (
select department_id ,sum(salary) as total_salary
from join_employees
group by department_id

)

select d.department_name,hs.total_salary from departments d
join high_salary hs
on d.department_id=hs.department_id
order by hs.total_salary desc
limit 1
;

-- 7. Display every department with:
--    department name
--    employee count
--    average salary
--    total salary
--
--    Include departments that have
--    no employees.
--
--    Use a CTE.
with department_info as(
select department_id,count(*) as employee_count,avg(salary) as average_salary ,
sum(salary) as total_salary
from join_employees
group by department_id
)
select d.department_name,di.employee_count,di.average_salary,di.total_salary
from departments d left join department_info di
on d.department_id = di.department_id;

-- 8. Find the top 2 departments based on
--    average employee salary.
--
--    Display:
--    department_name
--    average_salary
--
--    Use a CTE.
with average_salary_department as(
select department_id,avg(salary) as average_salary from join_employees
group by department_id
)
select d.department_name,asd.average_salary from departments d 
join average_salary_department asd
on d.department_id=asd.department_id
order by asd.average_salary desc
limit 2;

-- 9. Find departments where:
--    1. More than 2 employees work there
--    2. Average salary is greater than 60000
--
--    Display:
--    department_name
--    employee_count
--    average_salary
--
--    Use a CTE.

with department_info as(
select department_id,count(employee_id) as employee_count,avg(salary) as average_salary
from join_employees
group by department_id
)
select d.department_name,di.employee_count,di.average_salary from departments d
join department_info di
on d.department_id = di.department_id
where di.employee_count>2 and average_salary > 60000;


-- 10. Find the top 2 departments by total salary,
--     but only consider departments having
--     at least 2 employees.
--
--     Display:
--     department_name
--     employee_count
--     total_salary
--
--     Use a CTE.

with department_info as(
select department_id,sum(salary) as total_salary,count(employee_id) as employee_count
from join_employees
group by department_id
having count(employee_id) >= 2
)
select d.department_name,di.employee_Count,di.total_salary
from departments d
join department_info di
on d.department_id=di.department_id
order by di.total_salary desc
limit 2;

-- 11. Calculate a running total of salaries
--     ordered from highest salary to lowest.
--
--     Display:
--     employee_name
--     salary
--     running_total
--
--     Use SUM() as a window function.
SELECT employee_name,
       salary,
       SUM(salary) OVER(ORDER BY salary DESC) AS running_total
FROM join_employees;

-- 12. Calculate a running total of salaries
--     separately for each department.
--     Within each department, order employees
--     from highest salary to lowest.
--
--     Display:
--     employee_name
--     department_id
--     salary
--     department_running_total
--
--     Use SUM() as a window function,
--     PARTITION BY, and ORDER BY.
SELECT employee_name,
       department_id,
       salary,
       SUM(salary) OVER(
           PARTITION BY department_id
           ORDER BY salary DESC
       ) AS department_running_total
FROM join_employees;

-- 13. Display every employee along with
--     the average salary of their department.
--
--     Display:
--     employee_name
--     department_id
--     salary
--     department_average_salary
--
--     Use AVG() as a window function
--     and PARTITION BY.
SELECT employee_name,
       department_id,
       salary,
       AVG(salary) OVER(
           PARTITION BY department_id
       ) AS department_average_salary
FROM join_employees;

-- 14. Display every employee along with
--     their department's average salary.
--
--     Also calculate the difference between
--     the employee's salary and the department average.
--
--     Display:
--     employee_name
--     department_id
--     salary
--     department_average_salary
--     salary_difference
--
--     Use AVG() as a window function
--     and PARTITION BY.
WITH employee_about AS (
    SELECT employee_name,
           department_id,
           salary,
           AVG(salary) OVER(
               PARTITION BY department_id
           ) AS department_average_salary
    FROM join_employees
)
SELECT employee_name,
       department_id,
       salary,
       department_average_salary,
       (salary - department_average_salary) AS salary_difference
FROM employee_about;

-- 15. Find employees whose salary is greater than
--     their department's average salary.
--
--     Display:
--     employee_name
--     department_id
--     salary
--     department_average_salary
--     salary_difference
--
--     Use AVG() as a window function,
--     PARTITION BY, and a CTE.

WITH employee_about AS (
    SELECT employee_name,
           department_id,
           salary,
           AVG(salary) OVER(
               PARTITION BY department_id
           ) AS department_average_salary
    FROM join_employees
)
SELECT employee_name,
       department_id,
       salary,
       department_average_salary,
       (salary - department_average_salary) AS salary_difference
FROM employee_about
WHERE salary > department_average_salary;

-- 16. For each employee, display their salary
--     and the salary of the employee immediately
--     above them when employees are ordered
--     by salary from highest to lowest.
--
--     Display:
--     employee_name
--     salary
--     previous_salary
--
--     Use LAG() and ORDER BY.

SELECT employee_name,
       salary,
       LAG(salary) OVER(ORDER BY salary DESC) AS previous_salary
FROM join_employees;

-- 17. For each employee, display their salary
--     and the salary of the employee immediately
--     below them when employees are ordered
--     by salary from highest to lowest.
--
--     Display:
--     employee_name
--     salary
--     next_salary
--
--     Use LEAD() and ORDER BY.

SELECT employee_name,
       salary,
       LEAD(salary) OVER(ORDER BY salary DESC) AS next_salary
FROM join_employees;

-- 18. For each employee, display:
--     employee_name
--     salary
--     previous_salary
--     salary_difference
--
--     salary_difference should show how much
--     lower the employee's salary is compared
--     to the employee immediately above them.
--
--     Order employees by salary from highest to lowest.
--     Use LAG().
WITH employee_info AS (
    SELECT employee_name,
           salary,
           LAG(salary) OVER(ORDER BY salary DESC) AS previous_salary
    FROM join_employees
)
SELECT employee_name,
       salary,
       previous_salary,
       (salary - previous_salary) AS salary_difference
FROM employee_info;

-- 19. For each employee, display:
--     employee_name
--     department_id
--     salary
--     previous_salary
--
--     previous_salary should be the salary of the
--     employee immediately above them WITHIN THEIR DEPARTMENT.
--
--     Order salaries from highest to lowest within each department.
--
--     Use LAG() and PARTITION BY.
SELECT employee_name,
       department_id,
       salary,
       LAG(salary) OVER(
           PARTITION BY department_id
           ORDER BY salary DESC
       ) AS previous_salary
FROM join_employees;

-- 20. For each employee, display:
--     employee_name
--     department_id
--     salary
--     previous_salary
--     salary_difference
--
--     salary_difference should show the difference between
--     the employee's salary and the salary immediately above
--     them within their department.
--
--     Order salaries from highest to lowest within each department.
--
--     Use LAG() and PARTITION BY.
WITH employee_info AS (
    SELECT employee_name,
           department_id,
           salary,
           LAG(salary) OVER(
               PARTITION BY department_id
               ORDER BY salary DESC
           ) AS previous_salary
    FROM join_employees
)
SELECT employee_name,
       department_id,
       salary,
       previous_salary,
       (salary - previous_salary) AS salary_diffrence
FROM employee_info;

-- 21. For each employee, display:
--     employee_name
--     department_id
--     salary
--     next_salary
--
--     next_salary should be the salary of the
--     employee immediately below them WITHIN THEIR DEPARTMENT.
--
--     Order salaries from highest to lowest within each department.
--
--     Use LEAD() and PARTITION BY.

SELECT employee_name,
       department_id,
       salary,
       LEAD(salary) OVER(
           PARTITION BY department_id
           ORDER BY salary DESC
       ) AS next_salary
FROM join_employees;

-- 22. For each employee, display:
--     employee_name
--     department_id
--     salary
--     running_total
--
--     running_total should show the cumulative salary
--     within each department.
--
--     Order employees by salary from highest to lowest
--     within each department.
--
--     Use SUM(), PARTITION BY, and ORDER BY.

SELECT employee_name,
       department_id,
       salary,
       SUM(salary) OVER(
           PARTITION BY department_id
           ORDER BY salary DESC
       ) AS running_total
FROM join_employees;

-- 23. For each employee, display:
--     employee_name
--     department_id
--     salary
--     department_total_salary
--     salary_percentage
--
--     salary_percentage should show what percentage
--     of the department's total salary is earned
--     by each employee.
--
--     Use SUM() OVER() and PARTITION BY.

with employee_info as(select employee_name,
       department_id,
	   salary,
	   sum(salary) over(partition by department_id) as department_total_salary
	   
	   from join_employees)
	select employee_name,
       department_id,
	   salary,
	   department_total_salary,
	   (salary * 100.0/department_total_salary) as salary_percentage
	   from employee_info;

-- 24. For each employee, display:
--     employee_name
--     department_id
--     salary
--     department_average_salary
--     salary_rank
--
--     salary_rank should rank employees within
--     their department based on salary from highest to lowest.
--
--     Use:
--     AVG() OVER()
--     DENSE_RANK()
--     PARTITION BY
--     ORDER BY
select employee_name,
    department_id,
    salary,
    avg(salary) over(partition by department_id)as department_average_salary,
    dense_rank() over(partition by department_id order by salary desc) salary_rank
	from join_employees;

-- 25. For each employee, display:
--     employee_name
--     department_id
--     salary
--     department_average_salary
--     salary_rank
--     salary_difference
--
--     salary_rank = employee's salary rank within
--     their department (highest salary = rank 1).
--
--     salary_difference = employee salary minus
--     their department's average salary.
--
--     Return ONLY employees whose salary is
--     ABOVE their department average.
--
--     Use:
--     AVG() OVER()
--     DENSE_RANK()
--     PARTITION BY
--     ORDER BY
--     CTE

with employee_info as(select 
    employee_name,
    department_id,
    salary,
    avg(salary) over(partition by department_id) department_average_salary,
    dense_rank() over(partition by department_id order by salary desc)as salary_rank
	from join_employees)

select 
    employee_name,
    department_id,
    salary,
	department_average_salary,
	salary_rank,
	(salary - department_average_salary) as salary_difference
	from employee_info
	where salary>department_average_salary;