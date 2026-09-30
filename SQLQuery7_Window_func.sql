-- Create the Employees table
drop table Employees
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(50),
    Department VARCHAR(50),
	city varchar(50),
    Salary INT
);

-- Insert the records
INSERT INTO Employees (EmployeeID, EmployeeName, Department, city, Salary) VALUES
(1, 'Ali', 'IT','Lahore', 80000),
(2, 'Sara', 'IT','Lahore', 100000),
(3, 'Ahmed', 'HR','Karachi', 60000),
(4, 'Ayesha', 'HR','Lahore', 90000),
(5, 'Usman', 'IT','Lahore', 120000);

select * , row_number()over( partition by Department order by Department), sum(Salary) over( partition by Department order by Department) from Employees

select * , row_number()over( partition by Salary order by Salary) from Employees
select * , sum(salary) over(order by salary ) from Employees

select * , AVG(salary) over() as Avgrage ,
salary - AVG(salary) over()  as differnetiate
from Employees

SELECT
    EmployeeName,
    Salary,
    SUM(Salary) OVER () AS TotalSalary,
    AVG(Salary) OVER () AS AverageSalary,
    MIN(Salary) OVER () AS MinimumSalary,
    MAX(Salary) OVER () AS MaximumSalary,
    COUNT(*) OVER () AS TotalEmployees
FROM Employees;

/*
The distinction is:
GROUP BY Department
means:
Combine the employees into one result row per department.

Whereas:
OVER (PARTITION BY Department)
means:
Keep every employee, but calculate separately for each department.

*/
SELECT
    EmployeeName,
    Department,
    Salary,
    MAX(Salary) OVER (
        PARTITION BY Department
    ) AS HighestDepartmentSalary
FROM Employees;

SELECT
    EmployeeName,
    Department,
    City,
    Salary,
    SUM(Salary) OVER (
        PARTITION BY Department, City
    ) AS DepartmentCityTotal
FROM Employees;

SELECT
    EmployeeName,
    Department,
    Salary,
    ROW_NUMBER() OVER (
        PARTITION BY Department
        ORDER BY Salary DESC
    ) AS Position
FROM Employees
--ORDER BY EmployeeName;
create procedure nth_salary
	@nth int
as 
begin 
with nth_sal as (
SELECT
    EmployeeName,
    Department,
    Salary,
    ROW_NUMBER() OVER (
        ORDER BY Salary DESC
    ) AS Position
FROM Employees
)

select * from nth_sal where Position = @nth
end

exec nth_salary  @nth = 2
drop table Students
-- Re-create or use the Students table
CREATE TABLE Students4 (
    StudentID INT ,
    StudentName VARCHAR(50),
    Class VARCHAR(10), 
    Marks INT,
    City VARCHAR(50)
);

INSERT INTO Students4 (StudentID, StudentName, Class, Marks, City) VALUES
(1, 'Zainab', 'Class A', 85, 'Lahore'),
(2, 'Hamza', 'Class B', 92, 'Karachi'),
(3, 'Fatima', 'Class A', 78, 'Islamabad'),
(3, 'Bilal', 'Class B', 64, 'Peshawar'),
(4, 'Amina', 'Class A', 95, 'Quetta'),
(4, 'Omar', 'Class B', 81, 'Faisalabad'),
(1, 'Sana', 'Class A', 73, 'Multan'),
(2, 'Ali', 'Class B', 88, 'Rawalpindi'),
(9, 'Mary m', 'Class A', 90, 'Sialkot'),
(10, 'Usman', 'Class B', 67, 'Gujranwala');

select *, row_number() over (partition by class order by Marks desc ) from Students4

select *, rank() over ( order by StudentID ) from Students4
select *, rank() over (partition by class order by StudentID ) from Students4

select *, dense_rank() over ( order by StudentID ) from Students4
select *, dense_rank() over (partition by class order by StudentID ) from Students4


