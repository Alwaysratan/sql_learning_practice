
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

-- Business SQL #1
--
-- A company wants to identify the highest-paid employee
-- in each department.
--
-- Using the join_employees table, return:
-- employee_name
-- department_id
-- salary
--
-- If two employees in the same department have the
-- same highest salary, return BOTH employees.
--
-- Write the SQL query.

with high_paid as( select 
        department_id,
		max(salary)  as highest_paid
		from join_employees
		group by department_id)
	select je.employee_name,
	       hp.department_id,
		   je.salary
		  
		   from high_paid hp
		   left join join_employees je
		   on je.department_id=hp.department_id
		   and je.salary = hp.highest_paid;

-- Business SQL #2
--
-- Find the departments where the average salary
-- is higher than the company's overall average salary.
--
-- Return:
-- department_id
-- average_department_salary
--
-- Sort the result by average_department_salary
-- from highest to lowest.
--
-- Write the SQL query.
with employee_info as(select department_id,
       avg(salary)  as department_average_salary
	   
	   from join_employees
	   group by department_id),
     employee_info2 as(select 
       avg(salary)  as overall_average_salary
	   
	   from join_employees
	   )
	   select department_id,
	        department_average_salary,
			overall_average_salary
			from employee_info ,employee_info2
			
			where( department_average_salary>overall_average_salary) 
			order by  department_average_salary desc;
	   


-- Business SQL #3
--
-- Find the top 3 highest-paid employees in the company.
--
-- Return:
-- employee_name
-- department_id
-- salary
--
-- If multiple employees have the same salary,
-- they should receive the same rank.
--
-- Do NOT simply use LIMIT 3.
--
-- Write the SQL query.
with employee_info as(select employee_name,
        department_id,
		salary,
		dense_rank() over(order by salary desc) as salary_rank
		from join_employees)

select employee_name,
       department_id,
	   salary
	   from employee_info
	   where salary_rank <=3;

-- Business SQL #4
--
-- Find the second-highest-paid employee(s)
-- in each department.
--
-- If multiple employees have the same
-- second-highest salary, return ALL of them.
--
-- Return:
-- employee_name
-- department_id
-- salary
--
-- Write the SQL query.
WITH employee_rank AS (
    SELECT employee_name,
           department_id,
           salary,
           DENSE_RANK() OVER(
               PARTITION BY department_id
               ORDER BY salary DESC
           ) AS salary_rank
    FROM join_employees
)
SELECT employee_name,
       department_id,
       salary
FROM employee_rank
WHERE salary_rank = 2;

-- Business SQL #5
--
-- Find employees who earn more than the average
-- salary of their own department.
--
-- Return:
-- employee_name
-- department_id
-- salary
-- department_average_salary
--
-- Sort the result by department_id and then
-- salary from highest to lowest.
--
-- Write the SQL query.
with employee_info as( select department_id,
         
        avg(salary) as department_average_salary
		from join_employees
		group by department_id) 
		select employee_name,
		je.department_id,
		salary,
		department_average_salary
		from employee_info ei
		join join_employees je
		on ei.department_id=je.department_id
		where salary>department_average_salary
		order by je.department_id,salary desc;

-- Business SQL #6
--
-- Find the department with the highest total salary.
--
-- Return:
-- department_id
-- total_salary
--
-- If two departments have the same total salary,
-- return both departments.
--
-- Write the SQL query.
with employee_info as (select department_id,
sum(salary) as total_salary
from join_employees
group by department_id),
employee_info2 as(
select department_id,total_salary,
dense_rank() over( order by total_salary desc) as salary_rank
from employee_info)
select department_id,total_salary from employee_info2
where salary_rank=1
;

-- Business SQL #7
--
-- Find the employees who have the highest salary
-- in the entire company.
--
-- If multiple employees have the same highest salary,
-- return ALL of them.
--
-- Return:
-- employee_name
-- department_id
-- salary
--
-- Write the SQL query.
with employee_info as(
select employee_id,
employee_name,
department_id,
salary,
dense_rank() over(order by salary desc) as salary_rank
from join_employees)
select employee_name,
department_id,
salary
from employee_info
where salary_rank =1;

-- Business SQL #8
--
-- Find the employees who are in the top 2 salary levels
-- within their own department.
--
-- If multiple employees have the same salary,
-- they should receive the same rank.
--
-- Return:
-- employee_name
-- department_id
-- salary
-- salary_rank
--
-- Write the SQL query.

with employee_info as(
select employee_id,
employee_name,
department_id,
salary,
dense_rank() over(partition by department_id order by salary desc) as salary_rank
from join_employees)
select employee_name,
department_id,
salary,
salary_rank
from employee_info
where salary_rank <=2;

-- Business SQL #9
--
-- Find the employees whose salary is higher than
-- the average salary of their own department.
--
-- Return:
-- employee_name
-- department_id
-- salary
-- department_average_salary
-- salary_difference
--
-- salary_difference should show how much more
-- the employee earns than their department average.
--
-- Write the SQL query.

with employee_info as(
select employee_id,
employee_name,
department_id,
salary,
avg(salary) over(partition by department_id ) as department_average_salary
from join_employees)
select employee_name,
department_id,
salary,
department_average_salary,
(salary - department_average_salary) as salary_difference
from employee_info
where salary > department_average_salary;

-- Business SQL #10
--
-- Find the department(s) with the highest average salary.
--
-- If multiple departments have the same average salary,
-- return ALL of them.
--
-- Return:
-- department_id
-- department_average_salary
--
-- Write the SQL query.

with employee_info as(
select distinct
department_id,
salary,
avg(salary) over(partition by department_id ) as department_average_salary
from join_employees),
employee_info2 as (
select distinct department_id,
department_average_salary,
dense_rank() over(order by department_average_salary desc) as salary_rank
from employee_info)
select distinct
department_id,
department_average_salary
from employee_info2
where salary_rank =1;

-- Business SQL #11
--
-- Find the employees who earn more than the
-- highest-paid employee in the IT department.
--
-- Return:
-- employee_name
-- department_id
-- salary
--
-- Write the SQL query.
with employee_info as( select 
je.department_id,
max(salary)  as highest_salary
from join_employees je join departments d
on d.department_id=je.department_id
where department_name='IT'
group by je.department_id
)
select je.employee_name,
je.department_id,
je.salary 
from join_employees je join employee_info ei
on je.department_id=ei.department_id
where je.salary>ei.highest_salary;

-- Business SQL #12
--
-- Find the department(s) where the total salary
-- is higher than the average total salary of all departments.
--
-- If multiple departments qualify, return ALL of them.
--
-- Return:
-- department_id
-- total_salary
-- average_department_total_salary
--
-- Write the SQL query.

with employee_info as (select department_id,
sum(salary) as total_salary
from join_employees
group by department_id),

employee_info2 as(select department_id,
total_salary,
avg(total_salary) over() as average_department_total_salary
from employee_info)
select department_id,
total_salary,
average_department_total_salary
from employee_info2
where total_salary > average_department_total_salary;

-- Business SQL #13
--
-- Find the department(s) with the lowest average salary.
--
-- If multiple departments have the same average salary,
-- return ALL of them.
--
-- Return:
-- department_id
-- department_average_salary
--
-- Write the SQL query.

with employee_info as (select department_id,
avg(salary) as department_average_salary
from join_employees
group by department_id),
employee_info2 as(
select department_id,
department_average_salary,
dense_rank() over(order by department_average_salary asc) as salary_rank
from employee_info)
select department_id,
department_average_salary
from employee_info2
where salary_rank = 1;

-- Business SQL #14
--
-- Find the employees who are NOT assigned to any project.
--
-- Return:
-- employee_name
-- department_id
-- salary
--
-- Write the SQL query.
SELECT je.employee_name,
       je.department_id,
       je.salary
FROM join_employees je
WHERE NOT EXISTS (
    SELECT 1
    FROM employee_projects ep
    WHERE ep.employee_id = je.employee_id
);

--or using cte
 
WITH assigned_employees AS (
    SELECT DISTINCT employee_id
    FROM employee_projects
)
SELECT je.employee_name,
       je.department_id,
       je.salary
FROM join_employees je
LEFT JOIN assigned_employees ae
    ON je.employee_id = ae.employee_id
WHERE ae.employee_id IS NULL;

-- Business SQL #15
--
-- Find the department(s) with the highest number of employees.
--
-- If multiple departments have the same number of employees,
-- return ALL of them.
--
-- Return:
-- department_id
-- employee_count
--
-- Write the SQL query.
with employee_info as(select distinct department_id,
count(employee_id) over(partition by department_id) as employee_count
from join_employees),
employee_info2 as(
select distinct department_id,
employee_count,
dense_rank() over(order by employee_count desc) as department_rank
from employee_info)
select distinct department_id,
employee_count 
from employee_info2
where department_rank =1;


-- Business SQL #16
--
-- Find the employee(s) with the highest salary
-- in each department.
--
-- If multiple employees have the same highest salary,
-- return ALL of them.
--
-- Return:
-- employee_name
-- department_id
-- salary
--
-- Write the SQL query.

with employee_info as(select distinct department_id,
employee_name,
salary,
dense_rank() over(partition by department_id order by salary desc)  as salary_rank
from join_employees
)
select 
employee_name,
department_id,
salary
from employee_info 
where salary_rank = 1

-- Business SQL #17
--
-- Find the departments where at least 3 employees
-- earn more than 60,000.
--
-- Return:
-- department_id
-- employees_above_60000
--
-- Write the SQL query.

with employee_info as(select department_id,
count(employee_id)  as employee_above_60000
from join_employees
where salary >60000
group by department_id
)
select department_id,
employee_above_60000
from employee_info
where employee_above_60000>=3;

-- Business SQL #18
--
-- Find the department(s) where the salary gap between
-- the highest-paid and lowest-paid employee is the largest.
--
-- If multiple departments have the same salary gap,
-- return ALL of them.
--
-- Return:
-- department_id
-- highest_salary
-- lowest_salary
-- salary_gap
--
-- Write the SQL query.
with employee_info as(select distinct department_id,
employee_id,
salary,
dense_rank() over(partition by department_id order by salary desc)  as high_salary_rank,
dense_rank() over(partition by department_id order by salary asc)  as low_salary_rank
from join_employees
),

highest_info as(select 
department_id,
employee_id,
salary as highest_salary
from employee_info 
where  high_salary_rank = 1),

lowest_info as(
select 
department_id,
employee_id,
salary as lowest_salary
from employee_info 
where  low_salary_rank = 1
),

gap_info as(select li.department_id,
li.employee_id,
highest_salary,
lowest_salary,
(highest_salary - lowest_salary) as salary_gap
from lowest_info li join highest_info hi
on li.department_id=hi.department_id),

rank_info as(select department_id,
employee_id,
highest_salary,
lowest_salary,
salary_gap,
dense_rank() over(order by salary_gap desc) as salary_rank
from gap_info)
select department_id,
highest_salary,
lowest_salary,
salary_gap
from rank_info
where salary_rank  = 1;

-- Business SQL #19
--
-- Find the employees who have the SECOND-HIGHEST
-- salary in their department.
--
-- If multiple employees have the same second-highest
-- salary, return ALL of them.
--
-- Return:
-- employee_name
-- department_id
-- salary
--
-- Write the SQL query.

with employee_info as(select employee_id,
department_id,
salary,
employee_name,
dense_rank() over(partition by department_id order by salary desc) as salary_rank
from join_employees)
select employee_name,
department_id,
salary from employee_info
where salary_rank = 2;

-- Business SQL #20
--
-- Find the department(s) with the highest average salary
-- among departments that have at least 3 employees.
--
-- If multiple departments have the same average salary,
-- return ALL of them.
--
-- Return:
-- department_id
-- employee_count
-- department_average_salary
--
-- Write the SQL query.

with employee_info as(select distinct department_id,
employee_id,
salary,
count(employee_id) over(partition by department_id)as employee_count,
avg(salary) over(partition by department_id) as department_average_salary
from join_employees
),
employee_info2 as(
select distinct department_id,
employee_id,
salary,
employee_count,
department_average_salary
from employee_info
where employee_count>=3
),
 employee_info3 as(
select distinct department_id,
employee_id,
salary,
employee_count,
department_average_salary,
dense_rank() over(order by department_average_salary desc) as salary_rank
from employee_info2

)
select distinct department_id,
employee_count,
department_average_salary
from employee_info3
where salary_rank = 1;
