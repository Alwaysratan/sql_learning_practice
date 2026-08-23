-- 
-- SQL AGGREGATE FUNCTIONS
-- 

-- Table: employees
-- Columns:
-- employee_id
-- name
-- department
-- salary
-- age
-- city

--COUNT()

-- 1. Find the total number of employees.
select count(*) from employees;


-- 2. Find the number of employees in the IT department.
select count(*) from employees
where department ='IT';

-- 3. Find the number of employees in the Finance department.
select count(*) from employees
where department='Finance';


--SUM()

-- 4. Find the total salary of all employees.
select sum(salary) from employees;

-- 5. Find the total salary paid to employees
--    in the IT department.
select sum(salary) from employees
where department='IT';

--AVG()

-- 6. Find the average salary of all employees.
select avg(salary) from employees;

-- 7. Find the average salary of employees
--    in the Finance department.
select avg(salary) from employees
where department ='Finance';

-- 8. Find the average age of all employees.
select avg(age) from employees;

--MIN() AND MAX()

-- 9. Find the lowest salary.
select min(salary) from employees;

-- 10. Find the highest salary.
select max(salary) from employees;

-- 11. Find the youngest employee's age.
select min(age) from employees;

-- 12. Find the oldest employee's age.
select max(age) from employees;

--GROUP BY

-- 13. Find the number of employees in each department.
select count(*) as number_of_employees,department from employees
group by department;

-- 14. Find the average salary for each department.
select avg(salary) as average_salary,department from employees
group by department;

-- 15. Find the total salary paid by each department.
select sum(salary) as total_salary_paid ,department from employees
group by department;

-- 16. Find the highest salary in each department.
select max(salary) as highest_salary ,department from employees
group by department;

-- 17. Find the lowest salary in each department.
select min(salary) as lowest_salary ,department from employees
group by department;

-- 18. Find the average age of employees in each department.
select avg(age) as average_age,department from employees
group by department;

--GROUP BY WITH MULTIPLE COLUMNS

-- 19. Find the number of employees in each city.
select count(*) as number_of_employees,city from employees
group by city;

-- 20. Find the average salary for each city.
select avg(salary) as average_salary,city from employees
group by city;

--challenge

-- 21. Find the department with the highest average salary.
select avg(salary) as average_salary ,department from employees
group by department
order by average_salary desc
limit 1 ;


-- 22. Find the department with the lowest average salary.
select avg(salary) as average_salary ,department from employees
group by department
order by average_salary asc
limit 1 ;


-- 23. Find departments where the average salary
--     is greater than 60,000.
select avg(salary) as average_salary,department from employees
group by department
having avg(salary) >60000;

-- 24. Find cities having more than 2 employees.
select count(*) as number_of_employees,city from employees
group by city
having count(*) >2;

-- 25. Find the department with the highest total salary.
select sum(salary) as total_salary,department from employees
group by department
order by total_salary desc
limit 1;