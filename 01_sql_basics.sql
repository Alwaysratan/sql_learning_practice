-- 
-- SQL BASICS
-- 

-- Table: employees
-- Columns:
-- employee_id
-- name
-- department
-- salary
-- age
-- city
create table employees(
employee_id serial primary key,
name varchar(100) not null,
department varchar(100),
salary int,
age int,
city varchar(100)
);

-- inserting 20 rows in the employees table
INSERT INTO employees (name, department, salary, age, city)
VALUES
('Rahul Sharma', 'IT', 65000, 28, 'Delhi'),
('Priya Singh', 'HR', 48000, 26, 'Mumbai'),
('Amit Kumar', 'Finance', 72000, 32, 'Bangalore'),
('Neha Verma', 'IT', 55000, 24, 'Pune'),
('Rohit Das', 'Marketing', 45000, 29, 'Kolkata'),
('Anjali Gupta', 'Finance', 68000, 31, 'Delhi'),
('Vikash Kumar', 'IT', 82000, 35, 'Hyderabad'),
('Sneha Roy', 'HR', 52000, 27, 'Kolkata'),
('Arjun Mehta', 'Sales', 47000, 25, 'Mumbai'),
('Pooja Sharma', 'Marketing', 59000, 30, 'Pune'),
('Karan Singh', 'IT', 61000, 29, 'Chandigarh'),
('Riya Das', 'Finance', 75000, 34, 'Guwahati'),
('Sahil Khan', 'Sales', 43000, 23, 'Jaipur'),
('Kavya Nair', 'HR', 56000, 28, 'Bangalore'),
('Manish Yadav', 'IT', 90000, 38, 'Noida'),
('Simran Kaur', 'Marketing', 51000, 26, 'Chandigarh'),
('Deepak Verma', 'Finance', 63000, 30, 'Jaipur'),
('Nisha Patel', 'Sales', 49000, 27, 'Ahmedabad'),
('Aditya Roy', 'IT', 70000, 33, 'Kolkata'),
('Meena Kumari', 'HR', 46000, 25, 'Patna');


-- SELECT

-- 1. Display all columns from the employees table.
select * from employees;

-- 2. Display only the employee name and salary.
select name,salary from employees;

-- 3. Display employee name, department and city.
select name,department,city from employees;

--DISTINCT
-- 4. Find all unique departments.
select distinct department from employees;

-- 5. Find all unique cities.
select distinct city from employees;

--WHERE

-- 6. Find employees whose salary is greater than 50,000.
select * from employees 
where salary>50000;

-- 7. Find employees whose age is greater than 25.
select * from employees 
where age >25;

-- 8. Find employees who belong to the 'IT' department.
select *from employees
where department='IT';

--COMPARISION OPERATORS

-- 9. Find employees whose salary is less than 48,000.
select * from employees
where salary<48000;

-- 10. Find employees whose salary is equal to 65,000.
select * from employees
where salary=65000;

-- 11. Find employees whose age is greater than or equal to 30.
select * from employees 
where age >=30;

--AND/OR

-- 12. Find employees who work in IT
--     AND have a salary greater than 50,000.
select * from employees 
where department='IT' and salary>50000;

-- 13. Find employees who work in IT
--     OR Finance.
select * from employees;
--where department in ('IT','Finance')
where department ='IT' or department='Finance';

-- 14. Find employees who are older than 25
--     AND earn more than 40,000.
select * from employees
where age>25 and salary>40000;

--ORDER BY

-- 15. Display employees ordered by salary from lowest to highest.
select * from employees
order by salary asc;

-- 16. Display employees ordered by salary from highest to lowest.
select * from employees
order by salary desc;

-- 17. Display employees ordered by age from youngest to oldest.
select * from employees
order by age asc;

--LIMIT

-- 18. Display the first 5 employees.
select * from employees
limit 5;

-- 19. Display the 3 highest-paid employees.
select * from employees
order by salary desc
limit 3;

--ALIASES

-- 20. Display employee name and salary,
--     but rename salary as 'Monthly Salary'.
select name,salary as monthly_salary from employees;

-- 21. Display employee name and department,
--     and give meaningful aliases to both columns.
select name as employee_name , department as employee_department from employees;

--CHALLENGE QUESTIONS

-- 22. Find the employees from Delhi who earn
--     more than 50,000.
select * from employees
where city='Delhi' and salary>50000;

-- 23. Find the 5 highest-paid employees
--     from the IT department.
select * from employees
where department ='IT'
order by salary desc
limit 5;

-- 24. Find employees aged between 25 and 35.
select * from employees
where age between 25 and 35;

-- 25. Display unique departments in alphabetical order.
select distinct department from employees
order by department;

-- 26. Find employees whose salary is greater than 50,000
--     and age is less than 30.
select * from employees
where salary>50000 and age <30;
