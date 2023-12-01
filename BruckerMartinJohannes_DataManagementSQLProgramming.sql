/*
Portfolio Examination - SQL Programming
Winter Semester 2023/2024
Prof. Dr. Michael Prange

Starting: Monday 8:30 2023-11-13
Closing: Monday 10:00 2023-11-13

Author: Martin Johannes Brucker
Student number: 942815
*/


-- 1 Create the database ProjectManagement

CREATE DATABASE ProjectManagement; 

USE ProjectManagement; 


-- 2 Create the tables Employee, Collaboration and Project with the corresponding columns, data types keys and references

CREATE TABLE Employee (
ENr INT PRIMARY KEY, 
EName VARCHAR(100)
); 

CREATE TABLE Project (
Project VARCHAR(100) PRIMARY KEY, 
Title VARCHAR(100),
Customer VARCHAR(100)
); 
 
CREATE TABLE Collaboration (
ENr INT REFERENCES Employee(Enr), 
Project VARCHAR(100) REFERENCES Project(Project),
Hours INT,
PRIMARY KEY (ENr, Project)
);


-- 3 Insert the above data sets into the tables

INSERT INTO Employee(Enr, EName) 
VALUES 
(123, 'Albert'),
(234, 'Barbara'),
(345, 'Charlotte'),
(456, 'Daniel'); 

INSERT INTO Project(Project, Title, Customer) 
VALUES
('DM', 'Data Management', 'IBM'),
('CC', 'Cloud Computing', 'IBM'),
('BDT', 'Big Data','Microsoft'),
('IOT', 'Internet of Things', 'Microsoft'),
('VA', 'Visual Analytics','SAP');

INSERT INTO Collaboration (Enr, Project, Hours) 
VALUES 
(123, 'DM',17),
(123,'CC', 23),
(123,'VA',5),
(234,'BDT',28),
(234, 'VA', 12),
(345, 'DM',21),
(345, 'IOT',9),
(456, 'VA',15);


-- 4 Display the names of the employees who already worked in the project DM
SELECT EName
FROM Employee 
JOIN Collaboration ON  Employee.ENr = Collaboration.ENr 
WHERE Collaboration.Project = "DM";

/* Results:
Albert
Charlotte
*/


-- 5 Display the title of the projects and the corresponding working hours for all projects that Albert has worked in
SELECT Title, Hours 
FROM Project 
JOIN Collaboration ON Project.Project = Collaboration.Project 
WHERE Collaboration.ENr = (SELECT ENr FROM Employee WHERE EName = 'Albert');

/* Results:
Cloud Computing	23
Data Management	17
Visual Analytics	5
*/


-- 6 Update the working hours of Daniel
UPDATE Collaboration
SET Hours = 20
WHERE Collaboration.Project = "VA" AND (SELECT ENr FROM Employee WHERE EName = "Daniel");


-- 7 Display a list of all project titles with the performed hours in the projects so far
SELECT Title, SUM(Hours) 
FROM Project 
JOIN Collaboration ON Project.Project = Collaboration.Project
GROUP BY Title;

/* Results:
Big Data	28
Cloud Computing	23
Data Management	38
Internet of Things	9
Visual Analytics	60
*/


-- 8 Insert 10 working hours of Daniel for the project IOT
INSERT INTO Collaboration (ENr, Project, Hours)
VALUES (
(SELECT ENr FROM Employee WHERE EName = 'Daniel'), 'IOT', 10);


-- 9 Display the number of employees who have already worked in project VA
SELECT COUNT(ENr) AS EmployeeCountVA
FROM Collaboration
WHERE Collaboration.Project = "VA";

/* Results:
3
*/


-- 10 Delete the working hours of Charlotte for the project IOT
DELETE FROM Collaboration  
WHERE Collaboration.Project = 'IOT' AND Collaboration.Enr = (SELECT ENr FROM Employee WHERE EName = 'Charlotte'); 


-- 11 Display the names of all customers who ordered at least two projects
SELECT Project.Customer 
FROM Project 
JOIN Collaboration ON Collaboration.Project = Project.Project 
GROUP BY Project.Project HAVING COUNT(Customer) > 1;

/* Results:
IBM
SAP
*/


-- 12 Display the average working hours of over all projects ordered by microsoft
SELECT AVG(Collaboration.Hours)
FROM Collaboration
JOIN Project ON Collaboration.Project = Project.Project 
WHERE Project.Customer = 'Microsoft';

/* Results:
19.0000
*/


-- 13 Display the names of all employees who worked at lease as much in project VA as Albert, but who are not Albert
SELECT DISTINCT Employee.EName
FROM Collaboration, Employee, Project
WHERE Collaboration.ENr = Employee.ENr
AND Collaboration.Project = Project.Project
AND Employee.EName != 'Albert'
AND Project.Project = 'VA'
AND Collaboration.Hours >= (SELECT Collaboration.Hours
                              FROM Collaboration, Employee, Project
                              WHERE Collaboration.ENr = Employee.ENr
                                AND Collaboration.Project = Project.Project
                                AND Employee.EName = 'Albert'
                                AND Project.Project = 'VA');

/* Result:
Barbara
Daniel
*/


-- 14 Display the names of employees who have worked at least in one of Mricosofts projects
SELECT Employee.EName 
FROM Employee 
JOIN Collaboration ON Employee.ENr = Collaboration.Enr
JOIN Project ON Project.Project = Collaboration.Project
WHERE Project.Customer = 'Microsoft'; 

/* Results
Barbara
Daniel
*/


-- 15 Display a list of all project titles with the average working hours in the coreesponding projects
SELECT Project.Title, AVG(Collaboration.Hours)
FROM Project 
JOIN Collaboration ON Collaboration.Project = Project.Project 
GROUP BY Project.Project;

/* Results:
Big Data	28.0000
Cloud Computing	23.0000
Data Management	19.0000
Internet of Things 10.0000
Visual Analytics	20.0000
*/


-- 16 Display a list with the names of all customers and the number of employees that have been working in a customers project so far
SELECT Project.Customer, COUNT(Collaboration.Project) 
FROM Project
JOIN Collaboration ON Collaboration.Project = Project.Project
GROUP BY Customer;

/* Results:
IBM 3
Microsoft 2
SAP 3
*/


-- 17 Display the names of all employees whose average working hours in the projects is greater than 20
SELECT Employee.EName 
FROM Employee 
JOIN Collaboration ON Employee.ENr = Collaboration.ENr
GROUP BY Employee.ENr
HAVING AVG(Collaboration.Hours) > 20; 

/* Results:
Barbara
Charlotte
*/


-- 18 For each project title, display the lowest number of working hours performed in the project
SELECT Project.Title, MIN(Hours)
FROM Project 
JOIN Collaboration ON Project.Project = Collaboration.Project 
GROUP BY Project.Project;

/*
Big Data	28
Cloud Computing	23
Data Management	17
Internet of Things 10
Visual Analytics	20
*/


