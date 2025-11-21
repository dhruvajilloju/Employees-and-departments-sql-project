use prac;
#create table employees
CREATE TABLE employees ( 
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE
);
show tables;
drop table employee;
#insert into employees;
INSERT INTO employees (first_name, last_name, email, department, salary, hire_date)
VALUES
('Alice', 'Johnson', 'alice.johnson@example.com', 'Engineering', 85000.00, '2021-03-15'),
('Bob', 'Martinez', 'bob.martinez@example.com', 'Marketing', 62000.00, '2020-11-20'),
('Carla', 'Smith', 'carla.smith@example.com', 'Finance', 78000.00, '2022-01-05'),
('David', 'Brown', 'david.brown@example.com', 'Engineering', 91000.00, '2019-08-12'),
('Emma', 'Taylor', 'emma.taylor@example.com', 'HR', 54000.00, '2023-06-30');

#task 1: get all employees
select *from employees;

#task2 : Get highest-paid employee
select *from employees order by salary desc limit 1;

#task 3: Find engineering employees
select *from employees where department="Engineering";

#task 4: Raise salary by 10% for marketing department
update employees set salary=salary*1.10 where department ="Marketing";

#task 5:Get all first + last names together
select concat(first_name,' ',last_name) as full_name from employees;

#task 6: Get employees earning more than 70k
select *from employees where salary>70000;

#task 7: Sort employees by hire date (newest first)
select *from employees order by hire_date desc;

#AGGREGATE FUNCTIONS-- 

#task8: . Count employees by department
select department,count(*) as total_employees
from employees 
group by department;

#task 9: Average salary in Engineering
select avg(salary) as average_salary from employees where department = "Engineering";

#task 10: Highest & lowest salary
select max(salary) as highest,min(salary) as minimum  from employees;

#task 11:Find employees hired in 2021
select *from employees where year(hire_date)= 2021;

#task 12: Get employees whose name starts with "A"
select *from employees where first_name like "A%";

#task 13: Show salary + tax (15%) + net salary
select
first_name, salary, salary * 0.15 as tax,
salary - (salary *0.15) as net_salary from employees;

#task 14: Move all HR employees to Admin
update employees
set department = "Admin" where department = "HR"; #not executing because it is in safe mode
#(or)
SET SQL_SAFE_UPDATES = 0;  
UPDATE employees
SET department = 'Admin'
WHERE department = 'HR';
#to disable the safemode    syntax:  SET SQL_SAFE_UPDATES = 0;
#to turn on safe mode SET SQL_SAFE_UPDATES = 1;
#to view the above result hr is moved to another department name admin if we check for hr we get null values
select *from employees where department = "Admin";

#JOIN PRACTICE (New Table Included!)
#departments table: 
CREATE TABLE departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

INSERT INTO departments (dept_name, location) VALUES
('Engineering', 'Building A'),
('Marketing', 'Building B'),
('Finance', 'Building C'),
('HR', 'Building D'),
('Admin', 'Building D');

#task 15: . Inner join employees + departments
SELECT 
    e.first_name,
    e.department,
    d.location
FROM employees e
JOIN departments d
    ON e.department = d.dept_name;
    
    #task 15: Employees working in "Building D"
SELECT e.*
FROM employees e
JOIN departments d
    ON e.department = d.dept_name
WHERE d.location = 'Building D';

#task 16: Second Highest Salary
#method 1: using limit
SELECT DISTINCT salary  #This gets all unique salaries — removes duplicates.
FROM employees
ORDER BY salary DESC  #Sorts salaries from highest → lowest:
LIMIT 1 OFFSET 1;  
#OFFSET 1 → skip the FIRST row (the highest salary)
#LIMIT 1 → return the NEXT row (the second highest)

#Method 2 — Using subquery
SELECT MAX(salary) AS second_highest
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

#task 17:3rd highest salary
SELECT DISTINCT salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 2;

#task 18: Find Employees With the Highest Salary in Each Department
   #We only return employees whose salary = max salary
#what the query gives is: It returns the employee(s) with the highest salary in each department.
#So if "Engineering" has 5 employees, it picks the one with the highest salary.
#If two people tie with the highest salary in a department, it returns both.

# task 19: Count Employees in Each Department
SELECT department, COUNT(*) AS total
FROM employees
GROUP BY department;

#task 20: . Get the 3 Highest Salaries (Top N)
SELECT DISTINCT salary
FROM employees
ORDER BY salary DESC
LIMIT 3;

#task 21: Display Full Name + Email (STRING FUNCTIONS)
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    LOWER(email) AS email_lowercase
FROM employees;

#task 22: Difference Between Highest & Lowest Salary
SELECT MAX(salary) - MIN(salary) AS salary_range
FROM employees;

#task 23: List Employees Ordered by Salary, Then Name
SELECT *
FROM employees
ORDER BY salary DESC, first_name ASC;
 
 #task 24 Find salaries that multiple employees share.”/“Find employees with the same salary”:
SELECT salary, COUNT(*)
FROM employees
GROUP BY salary;  #here no duplicates no common salary

#actual code  for the question to find the similar salaries
SELECT salary, COUNT(*)
FROM employees
GROUP BY salary  #This groups all employees by their salary.
HAVING COUNT(*) > 1;   #This counts how many employees are in each salary group
#The HAVING clause filters GROUPS (not rows).
#This line means: “Only show salaries where more than 1 employee has it
#we get output nothing because there are no duplicates in our table

#task 25 : Get employees who joined on a weekend
SELECT *
FROM employees
WHERE DAYOFWEEK(hire_date) IN (1, 7);


#task 25: Get employees whose email domain is ‘gmail.com’
SELECT *
FROM employees
WHERE email LIKE '%@gmail.com';

#TASK 26': Show all employees but replace NULL department with 'Unassigned'
SELECT 
    first_name,
    last_name,
    IFNULL(department, 'Unassigned') AS department
FROM employees;

#TASK 27: Find employees hired in the same month (same joining month groups)
select month(hire_date) as join_month, count(*) as total from employees
group by month(hire_date);

#TASK 28: Find employees who have the same first name
SELECT first_name, COUNT(*)
FROM employees
GROUP BY first_name
HAVING COUNT(*) > 1;

#task 28: Find the most common hiring year
SELECT YEAR(hire_date), COUNT(*)
FROM employees
GROUP BY YEAR(hire_date)
ORDER BY COUNT(*) DESC
LIMIT 1;

#task 29:Find employees whose names contain repeating letters
SELECT *
FROM employees
WHERE first_name REGEXP '(.)\\1';


#task 30: Convert first name to initials
SELECT 
    CONCAT(LEFT(first_name,1), '.', LEFT(last_name,1), '.') AS initials
FROM employees;

#task 31: Show the longest employee name
SELECT *, LENGTH(CONCAT(first_name, last_name)) AS name_length
FROM employees
ORDER BY name_length DESC
LIMIT 1;

#task 32: 











 







































 





