-- 
-- SQL STRING FUNCTIONS
-- 

-- Table: employees
-- Columns:
-- employee_id
-- name
-- department
-- salary
-- age
-- city


-- UPPER()
-- 1. Display all employee names in uppercase.
select upper(name) from employees;

--LOWER()
-- 2. Display all employee names in lowercase.
select LOWER(name) from employees;

--LENGTH()
-- 3. Find the length of each employee's name.
select length(name) from employees;

--concat()
-- 4. Display employee name and city together
--    in one column.
select concat(name,'-',city) from employees;

--concat_ws()
-- 5. Display employee name, department and city
--    together, separated by ' | '.

select concat_ws('|',name,department,city) from employees;

--LEFT()
-- 6. Display the first 3 characters of every employee name.
select left(name,3) from employees;

--RIGHT()
-- 7. Display the last 3 characters of every employee name.
select right(name,3) from employees;

--substring()
-- 8. Extract the first 5 characters from every employee name.
select substring(name,1,5) from employees;

--trim()
-- 9. Remove leading and trailing spaces from the city column.
select trim(city) from employees;

--REPLACE()
-- 10. Replace 'IT' with 'Information Technology'
--     when displaying the department.
select name,replace(department,'IT','information technology') from employees;

--POSITION()
-- 11. Find the position of the first space
--     in each employee's name.
select position(' ' in name) from employees;

--INITCAP()
-- 12. Display employee names with the first letter
--     of each word capitalized.
select initcap(name) from employees;

--string+alias
-- 13. Display the employee name in uppercase
--     and give the column the alias 'employee_name'.
select upper(name) as employee_name from employees;

--string + where
-- 14. Find employees whose name starts with 'A'.
select * from employees
where name like 'A%';

--string +length()
-- 15. Find employees whose name contains
--     more than 10 characters.
select * from employees
where length(name) > 10;

--string + upper()
-- 16. Find employees who live in 'Delhi',
--     regardless of how the city is stored
--     in terms of capitalization.
select * from employees
where upper(city)='DELHI';

--STRING+CONCAT()
-- 17. Create a sentence for each employee:

-- Example:
-- "Rahul Sharma works in IT"
select concat(name,' works in ',department) as about_employees from employees;

--challenge
-- 18. Display the first name of every employee.
--
-- Hint:
-- You can combine POSITION() and SUBSTRING().
select substring(name,1,position(' ' in name)-1) from employees;

-- 19. Display employee names in the following format:
--
-- "RAHUL SHARMA - DELHI"
--
-- Both name and city should be uppercase.
select upper(concat(name,' - ',city)) from employees;

-- 20. Display each employee in this format:
--
-- "Rahul Sharma | IT | Delhi | Salary: 65000"
--
-- Use string functions to construct the output.
 select concat_ws(' | ',name,department,city,concat('Salary: ',salary)) from employees;