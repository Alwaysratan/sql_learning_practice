-- 
-- ALTER TABLE & CASE
-- 

-- Table: employees
-- Columns:
-- employee_id
-- name
-- department
-- salary
-- age
-- city

--ALTER TABLE
--ADD COLUMN
-- 1. Add a new column called email
--    to the employees table.
alter table employees
add column email varchar(100);

--add another column
-- 2. Add a column called joining_date
--    with the DATE data type.
alter table employees
add column joining_date date;

--RENAME A COLUMN
-- 3. Rename the column 'name' to 'employee_name'.
alter table employees
rename column name to employee_name;

--change column data type
-- 4. Change the salary column from INT
--    to NUMERIC.
alter table employees
alter column salary type numeric;

--rename the table
-- 5. Rename the employees table to employee_details.
alter table employees
rename  to employee_details;

--add a default value
-- 6. Add a column called status
--    with a default value of 'Active'.
alter table employee_details
add column status text default 'Active';

--drop column
-- 7. Remove the email column from the table.
alter table employee_details
drop column email;

--CASE
-- 8. Create a column called salary_category
--    using CASE:
--
--    salary >= 70000 → 'High'
--    salary >= 50000 → 'Medium'
--    otherwise        → 'Low'
alter table employee_details
add column salary_category text;

update employee_details
set salary_category=
case when salary >= 70000 then 'High'
     when salary >= 50000 then 'Medium'
	 else 'Low'
end;

select * from employee_details;

-- 9. Categorize employees based on age:
--
--    age < 25          → 'Young'
--    age between 25-30 → 'Adult'
--    age > 30          → 'Senior'
select employee_name , age,
case when age < 25    then 'Young'
     when age between 25 and 30 then 'Adult'
     when age > 30   then 'Senior'
end as age_category from employee_details;
-- 10. Display employee name and create a new
--     column called employee_type:
--
--     IT → 'Technical'
--     otherwise → 'Non-Technical'
select employee_name ,
case when department='IT' then 'Technical'
     else 'Non-Technical'
end as employee_type from employee_details

-- 11. Create a column called revised_salary:
--
--     salary >= 70000 → salary + 5000
--     salary >= 50000 → salary + 3000
--     otherwise        → salary + 2000
alter table employee_details
add column revised_salary numeric;

select * from employee_details;

update employee_details
set revised_salary =
case when salary >= 70000 then salary + 5000
     when salary >= 50000 then salary + 3000
	 else salary + 2000
end;

-- 12. Classify departments:
--
--     IT       → 'Technology'
--     Finance  → 'Business'
--     HR       → 'People'
--     otherwise → 'Other'

select employee_name,department, 
case when department='IT' then 'Technology'
     when department='Finance' then 'Business'
	 when department='HR' then  'People'
	 else 'Other'
end as department_category from employee_details;

-- 13. Display employees whose salary category
--     is 'High'.
--
--     Use CASE to determine the category.
select employee_name,salary_category from employee_details
where salary_category='High';

-- i already made column name salary_category using case in question no 8 so,

-- 14. Display employees and classify their salary
--     as High, Medium, or Low.
--
--     Sort the results by salary from highest to lowest.

select * ,
case when salary >= 70000 then 'High'
     when salary >= 50000 then 'Medium'
	 else 'Low'
end as salary_category from employee_details
order by salary desc;

-- 15. Create a performance_category:
--
--     salary >= 80000 AND age <= 35 → 'Excellent'
--     salary >= 60000               → 'Good'
--     otherwise                     → 'Average'

select * ,
case when salary >= 80000 and  age <= 35 then 'Excellent'
     when salary >= 60000 then 'Good'
	 else 'Average'
end as performance_category from employee_details;

-- 16. Display employee name, salary and a bonus:
--
--     salary >= 80000 → 10% bonus
--     salary >= 60000 → 7% bonus
--     otherwise       → 5% bonus

select employee_name,salary,
case when salary >= 80000 then '10%'
     when salary >= 60000 then '7%'
	 else '5%'
end as bonus from employee_details;

-- 17. Display employee name and salary_status:
--
--     salary >= 70000 → 'Above Average'
--     salary < 70000  → 'Below Average'

select employee_name,
case when salary >= 70000 then 'Above Average'
     when salary < 70000 then 'Below Average'
end as salary_status from employee_details;

-- 18. Count how many employees belong to each
--     salary category (High, Medium, Low)
select salary_category,count(*) as employee_count from employee_details
group by salary_category;

-- 19. Find the total salary of employees in each
--     salary category.
select salary_category,sum(salary) from employee_details
group by salary_category;

-- 20. Create a report containing:
--
--     employee name
--     department
--     salary
--     salary category
--     age category
--     bonus percentage
--
--     Use CASE expressions to create
--     the three calculated categories.

select employee_name,department,salary,
case when salary >= 70000 then 'High'
     when salary >= 50000 then 'Medium'
	 else 'Low'
end as salary_category,
case when age < 25    then 'Young'
     when age between 25 and 30 then 'Adult'
     when age > 30   then 'Senior'
end as age_category,
case when salary >= 80000 then '10%'
     when salary >= 60000 then '7%'
	 else '5%'
end as bonus_percentage from employee_details;