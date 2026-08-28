
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


-- 1. Display all departments.
select * from departments;

-- 2. Display all employees.
select * from join_employees;

-- 3. Display all projects.
select * from projects;

-- 4. Find the department_id of the IT department.
select department_id from departments
where department_name='IT';

-- 5. Find all employees whose department_id is 1.
select * from join_employees
where department_id=1;

-- 6. Find all projects belonging to department_id 2.
select * from projects
where department_id=2;

-- 7. Display department names and their IDs.
select department_name,department_id from departments;


--inner join
-- 8. Display each employee's name along with
--    their department name.
select e.employee_name,d.department_name from join_employees e join departments d
on d.department_id = e.department_id;

-- 9. Display employee name, salary,
--    and department name.
select e.employee_name,e.salary ,d.department_name from join_employees e join departments d
on d.department_id = e.department_id;

-- 10. Display employee name and department location.
select e.employee_name,d.location from join_employees e join departments d
on d.department_id = e.department_id;

-- 11. Display employee name, department name,
--     and salary for employees earning more than 60000.
select e.employee_name,d.department_name ,e.salary from join_employees e join departments d
on d.department_id = e.department_id
where e.salary>60000;

-- 12. Display all employees working in the IT department.
select e.employee_id ,e.employee_name,e.salary from join_employees e join departments d
on d.department_id = e.department_id
where d.department_name='IT';

-- 13. Display employee name and department name,
--     ordered by salary from highest to lowest.
select e.employee_name,d.department_name ,e.salary from join_employees e join departments d
on d.department_id = e.department_id
order by e.salary desc;

-- 14. Display the employee name, department name,
--     and project name for employees whose department
--     has a project.
select e.employee_name,d.department_name,p.project_name from join_employees e join departments d
on d.department_id = e.department_id 
join projects p on p.department_id = d.department_id;

-- 15. Display employee name, department name,
--     project name, and salary for employees
--     earning more than 60000.
select e.employee_name,d.department_name,p.project_name ,e.salary from join_employees e join departments d
on d.department_id = e.department_id 
join projects p on p.department_id = d.department_id
where e.salary >60000;

-- 16. Display each department name and the
--     number of employees working in that department.
select count(e.employee_id) as number_of_employees,d.department_name from join_employees e join departments d
on d.department_id = e.department_id 
group by d.department_name;

--left join

-- 17. Display every department and the number
--     of employees working in it.
--
--     Include departments even if they have
--     no employees.
select d.department_name ,count(e.employee_id) as number_of_employees from departments d left join  join_employees e
on d.department_id = e.department_id 
group by d.department_name;

-- 18. Display all departments and their projects.
--
--     Include departments even if they don't
--     have any projects.
select d.department_name ,p.project_id,p.project_name from departments d left join  projects p
on d.department_id = p.department_id ;

-- 19. Display each department name and
--     the total salary paid to employees
--     in that department.
select d.department_name ,sum(e.salary) as total_salary_paid_to_employees from departments d left join  join_employees e
on d.department_id = e.department_id 
group by d.department_name;

-- 20. Display each department name,
--     number of employees,
--     average salary,
--     and total salary.
--
--     Include departments even if they
--     have no employees.
select d.department_name ,count(e.employee_id) as number_of_employees,avg(e.salary)as average_salary,sum(e.salary) as total_salary_paid_to_employees from departments d left join  join_employees e
on d.department_id = e.department_id 
group by d.department_name;


--for many to many lets create the relationship table
CREATE TABLE employee_projects (
    employee_id INT,
    project_id INT,
    PRIMARY KEY (employee_id, project_id),
    FOREIGN KEY (employee_id)
        REFERENCES join_employees(employee_id),
    FOREIGN KEY (project_id)
        REFERENCES projects(project_id)
); -- junction/bridge table

INSERT INTO employee_projects (employee_id, project_id)
VALUES
(1, 1),
(1, 5),
(2, 3),
(3, 2),
(3, 5),
(4, 1),
(5, 4),
(6, 2),
(7, 1),
(7, 5),
(8, 3),
(9, 5),
(10, 4),
(11, 1),
(12, 2);

-- 21. Display employee names and the projects
--     they are working on.
select employee_name,project_name from join_employees je join employee_projects ep
on je.employee_id = ep.employee_id 
join projects p 
on p.project_id = ep.project_id;

-- 22. Display each project name and the names
--     of all employees working on that project and How many employees work on each project? ,Who are all the employees working on each project?.
select p.project_name, count(je.employee_id) as employee_count ,STRING_AGG(je.employee_name, ', ') AS employees from join_employees je join employee_projects ep
on je.employee_id = ep.employee_id 
join projects p 
on p.project_id = ep.project_id
group by p.project_name;

-- 23. Display every employee and the projects
--     they are working on.
--
--     Include employees even if they are not
--     assigned to any project.
select je.employee_name,p.project_name from join_employees je left join employee_projects ep
on je.employee_id = ep.employee_id 
left join projects p 
on p.project_id = ep.project_id;

-- 24. Display every project and the employees
--     working on it.
--
--     Include projects even if no employee
--     is assigned to them.
select p.project_name , je.employee_name from projects p left join employee_projects ep 
on p.project_id=ep.project_id 
left join join_employees je
on je.employee_id=ep.employee_id;

-- 25. Display each employee's name and
--     the number of projects they are working on.
--
--     Include employees who are not assigned
--     to any project.
select je.employee_name,count(p.project_name) as project_count from join_employees je left join employee_projects ep
on je.employee_id = ep.employee_id 
left join projects p 
on p.project_id = ep.project_id
group by je.employee_name;

-- 26. Display each project name and the total
--     salary of all employees working on that project.
--
--     Include projects even if no employees
--     are assigned to them.
select p.project_name , sum(je.salary) as total_investment from projects p left join employee_projects ep 
on p.project_id=ep.project_id 
left join join_employees je
on je.employee_id=ep.employee_id
group by p.project_name;

-- 27. Display each project name,
--     number of employees,
--     and total salary paid to those employees.
--
--     Include projects even if no employees
--     are assigned to them.
select p.project_name ,count(je.employee_id)as total_employee, sum(je.salary) as total_investment from projects p left join employee_projects ep 
on p.project_id=ep.project_id 
left join join_employees je
on je.employee_id=ep.employee_id
group by p.project_name;

-- 28. Display projects that have more than
--     2 employees working on them.
--
--     Show the project name and employee count.
select p.project_name , count(je.employee_id) as employees from projects p left join employee_projects ep 
on p.project_id=ep.project_id 
left join join_employees je
on je.employee_id=ep.employee_id
group by p.project_name
having count(je.employee_id) > 2 ;

-- 29. Display projects where the total salary
--     of all employees working on the project
--     is greater than 200000.
--
--     Show project name and total salary.
select p.project_name , sum(je.salary) as total_salary from projects p left join employee_projects ep 
on p.project_id=ep.project_id 
left join join_employees je
on je.employee_id=ep.employee_id
group by p.project_name
having sum(je.salary) > 200000 ;

-- 30. Display each employee's name,
--     the number of projects they work on,
--     and the total salary of their projects.
--
--     Include employees who are not assigned
--     to any project.
select je.employee_name,count(p.project_name) as project_count,sum(je.salary) as total_salary from join_employees je
left join employee_projects ep
on je.employee_id=ep.employee_id
left join projects p
on p.project_id = ep.project_id
group by je.employee_name;