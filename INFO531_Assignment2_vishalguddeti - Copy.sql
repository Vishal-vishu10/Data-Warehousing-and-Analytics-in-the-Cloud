-- Q1: Create the Worker Database
CREATE DATABASE Worker;
SHOW DATABASES;

-- Q2: Use Worker Database and Create Department Table
USE Worker;
CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL);
USE Worker;
INSERT INTO Department (DepartmentID, DepartmentName) VALUES
(2, 'Production'),
(3, 'IT Support'),
(4, 'Operations'),
(5, 'Customer Service'),
(6, 'Purchasing'),
(7, 'Sales & Marketing'),
(8, 'Human Resource Management'),
(9, 'Accounting and Finance'),
(10, 'Legal');
SELECT * FROM Department ORDER BY DepartmentID;
-
-- Q3:  Create the Employee table in the Worker database 
-- Step 1: Switch to Worker Database
USE Worker;

-- Create the Employee Table
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY NOT NULL,
    DepartmentID INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Address VARCHAR(50) ,
	PhoneNumber VARCHAR(15),
    HireDate DATE NOT NULL
   );
INSERT INTO Employee (EmployeeID, DepartmentID, FirstName, LastName, Address, PhoneNumber, HireDate) VALUES
(1, 2, 'Andy', 'Wong', '345 South Street', '(603) 555-6880', '2001-01-15'),
(2, 1, 'John', 'Wilson', 'John Wilson', '(518) 555-6690', '2017-03-19'),
(3, 3, 'Vivek', 'Pandey', '15 Mineral Drive', '(603) 555-4420', '2003-11-15'),
(4, 7, 'Nola', 'Davis', '15 Long Ave', '(478) 555-8822', '2016-03-23'),
(5, 8, 'Kathy', 'Cooper', '15 Hatter Drive', '(212) 555-9630', '2011-11-18'),
(6, 9, 'Tom', 'Harper', '64 Highland Street', '(212) 555-7755', '2010-04-11');
SELECT * FROM Employee  ORDER BY EmployeeID ;
-- Q4:  Create the Equipment table in the Worker databasee 
USE Worker;
CREATE TABLE Equipment (
    EquipmentID INTEGER NOT NULL,
    EquipmentName VARCHAR(30),
    EquipmentCostAmount DECIMAL(13,2),
    PRIMARY KEY (EquipmentID)
);
INSERT INTO Equipment (EquipmentID, EquipmentName,EquipmentCostAmount) VALUES
(1, 'Notebook Computers',300),
(2, 'Headsets',400),
(3, 'Computer Monitor',500),
(4, 'Multi-Function Printers',600),
(5, 'Projector or a Big Screen TV',700),
(6, 'Servers',800),
(7, 'Internet Modem',900),
(8, 'Cell Phone',10000);
SELECT * FROM Equipment  ORDER BY EquipmentID;
-- Q5: Create the EmployeeEquipment table in the Worker databasee
CREATE TABLE EmployeeEquipment (
    EmployeeID INTEGER NOT NULL,
    EquipmentID INTEGER,
    PRIMARY KEY (EmployeeID, EquipmentID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (EquipmentID) REFERENCES Equipment(EquipmentID)
);
INSERT INTO EmployeeEquipment (EmployeeID, EquipmentID) VALUES
(1, 1),
(2, 1),
(2, 3),
(3, 1),
(3, 2),
(3, 3),
(4, 1),
(4, 2),
(5, 1),
(5, 2),
(5, 3),
(6, 1),
(6, 3); 
SELECT * FROM EmployeeEquipment ORDER BY EmployeeID, EquipmentID;
-- Q6: Create the Training table in the Worker database
CREATE TABLE Training (
    TrainingID INTEGER NOT NULL,
    TrainingName VARCHAR(50) NOT NULL,
    PRIMARY KEY (TrainingID)
);
INSERT INTO Training (TrainingID, TrainingName) VALUES
(1, 'COVID-19 Awareness and Protection Training'),
(2, 'Code of Conduct Training'),
(3, 'Safety Training'),
(4, 'Intro to Python'),
(5, 'Machine Learning'),
(6, 'Microsoft Certifications'),
(7, 'Security and Privacy'),
(8, 'Product Knowledge'),
(9, 'Sales Skills'),
(10, 'Employee Relations'),
(11, 'Travel and Expense Management');
SELECT * FROM Training ORDER BY TrainingID;
-- Q7: Create the EmployeeTraining table in the Worker database 
CREATE TABLE EmployeeTraining (
    EmployeeID INTEGER NOT NULL,
    TrainingID INTEGER NOT NULL,
    PRIMARY KEY (EmployeeID, TrainingID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (TrainingID) REFERENCES Training(TrainingID)
);
INSERT INTO EmployeeTraining (EmployeeID, TrainingID) VALUES
(1, 2),
(1, 3),
(2, 2),
(2, 4),
(2, 5),
(3, 2),
(3, 6),
(3, 7),
(4, 2),
(4, 8),
(4, 9),
(5, 2),
(5, 10),
(6, 2),
(6, 11);
SELECT * FROM EmployeeTraining ORDER BY EmployeeID, TrainingID;
-- Q8: Create the Trainer table in the Worker database 
CREATE TABLE Trainer (
    TrainerID INTEGER NOT NULL,
    TrainingID VARCHAR(20) NOT NULL,
    TrainerFirstName VARCHAR(20),
    TrainerLastName VARCHAR(20),
    PRIMARY KEY (TrainerID)
);
INSERT INTO Trainer (TrainerID, TrainingID, TrainerFirstName, TrainerLastName) VALUES
(1, 1, 'James', 'Smith'),
(2, 1, 'Johnny', 'Khor'),
(3, 2, 'Michael', 'Smith'),
(4, 3, 'Maria', 'Garcia'),
(5, 4, 'John', NULL),
(6, 4, 'Paul', 'Deitel'),
(7, 5, 'Mike', 'Taylor'),
(8, 5, 'Avinash', 'Navlani'),
(9, 6, 'Robert', 'Smith'),
(10, 7, 'Maria', 'Rodriguez'),
(11, 8, 'Mike', 'Donlon'),
(12, 9, 'Kathy', 'Corby'),
(13, 10, 'Mary', 'Garcia'),
(14, 10, 'Vanessa', NULL),
(15, 11, 'Jordan', NULL),
(16, 11, 'Maria', 'Hernandez');

  SELECT * FROM Trainer ORDER BY TrainerID;
  CREATE TABLE TrainerTraining (
    TrainerID INTEGER NOT NULL,
    TrainingID INTEGER NOT NULL,
    PRIMARY KEY (TrainerID, TrainingID),
    FOREIGN KEY (TrainerID) REFERENCES Trainer(TrainerID),
    FOREIGN KEY (TrainingID) REFERENCES Training(TrainingID)
);
INSERT INTO TrainerTraining (TrainerID, TrainingID) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 3),
(5, 4),
(6, 4),
(7, 5),
(8, 5),
(9, 6),
(10, 7),
(11, 8),
(12, 9),
(13, 10),
(14, 10),
(15, 11),
(16, 11);
SELECT * FROM TrainerTraining ORDER BY TrainerID, TrainingID;

-- Q9: Retrieve the data from the Trainer table 
SELECT * 
FROM Trainer 
WHERE TrainerLastName IS NULL
ORDER BY TrainerID;





-- Q10: By using the SHOW tables statements, show the list of tables you have created in the Worker databasee 
SHOW TABLES;
-- Q11: Write a single-row subquery to display EmployeeID, FirstName, LastName, and HireDate of employees hired after employee Vivek Pandey. Sort the results by EmployeeID. 
SELECT HireDate 
FROM Employee 
WHERE FirstName = 'Vivek' AND LastName = 'Pandey';

SELECT EmployeeID, FirstName, LastName, HireDate
FROM Employee
WHERE HireDate > (
    SELECT HireDate
    FROM Employee
    WHERE FirstName = 'Vivek' AND LastName = 'Pandey'
)
ORDER BY EmployeeID;
-- Q12:Write a query to display FirstName, LastName, and TrainingName for employee Tom Harper. Sort the results by TrainingName
SELECT e.FirstName, e.LastName, t.TrainingName
FROM Employee e
JOIN EmployeeTraining et ON e.EmployeeID = et.EmployeeID
JOIN Training t ON et.TrainingID = t.TrainingID
WHERE e.FirstName = 'Tom' AND e.LastName = 'Harper'
ORDER BY t.TrainingName;
-- Q13:  Write a query to display the complete list of Trainings, and trainers
SELECT t.TrainingName, tr.TrainerFirstName, tr.TrainerLastName
FROM Training t
INNER JOIN Trainer tr ON t.TrainingID = tr.TrainingID
ORDER BY t.TrainingName, tr.TrainerFirstName, tr.TrainerLastName;

   

-- Q14: Write a multiple-row subquery to display EmployeeID, FirstName, LastName, and HireDate of employees who work for the following departments: Accounting and Finance, IT Support, and Production. Sort the results by EmployeeID. 
SELECT 
    e.EmployeeID, 
    e.FirstName, 
    e.LastName, 
    e.HireDate
FROM 
    Employee e
WHERE 
    e.DepartmentID IN (
        SELECT d.DepartmentID
        FROM Department d
        WHERE d.DepartmentName IN ('Accounting and Finance', 'IT Support', 'Production')
    )
ORDER BY 
    e.EmployeeID;
    -- Q15: Write a query to display the EmployeeID, FirstName, LastName, EquipmentName, and EquipmentCostAmount for one of the employees. Sort the results by EmployeeID
    SELECT 
    e.EmployeeID, 
    e.FirstName, 
    e.LastName, 
    eq.EquipmentName, 
    eq.EquipmentCostAmount
FROM 
    Employee e
JOIN 
    EmployeeEquipment ee ON e.EmployeeID = ee.EmployeeID
JOIN 
    Equipment eq ON ee.EquipmentID = eq.EquipmentID
ORDER BY 
    e.EmployeeID;
    -- Q16: Write a query to display the TrainingID, TrainingName, TrainerID, TrainerFirstName, and TrainerLastName with the trainers who did not provide their last name. Sort the results by TrainingID and TrainerID. 
    SELECT 
    t.TrainingID,
    t.TrainingName,
    tr.TrainerID,
    tr.TrainerFirstName,
    tr.TrainerLastName
FROM 
    Training t
JOIN 
    TrainerTraining tt ON t.TrainingID = tt.TrainingID
JOIN 
    Trainer tr ON tt.TrainerID = tr.TrainerID
WHERE 
    tr.TrainerLastName IS NULL
ORDER BY 
	t.TrainingID,
    tr.TrainerID;


    -- Q17: Write a query to display the distinct list of equipments used by the current employees. Sort the output by EquipmentName.
SELECT DISTINCT
    eq.EquipmentName
FROM 
    Employee e
JOIN 
    EmployeeEquipment ee ON e.EmployeeID = ee.EmployeeID
JOIN 
    Equipment eq ON ee.EquipmentID = eq.EquipmentID
ORDER BY 
    eq.EquipmentName;
 -- Q18: Write a query to display the FirstName, LastName, TrainingName, and trainer(s) (with first and last name in two separate columns) for one of the employees. Sort the results by TrainingName and TrainerFirstName. 
 SELECT 
    e.FirstName AS EmployeeFirstName,
    e.LastName AS EmployeeLastName,
    t.TrainingName,
    tr.TrainerFirstName,
    tr.TrainerLastName
FROM 
    Employee e
JOIN 
    EmployeeTraining et ON e.EmployeeID = et.EmployeeID
JOIN 
    Training t ON et.TrainingID = t.TrainingID
JOIN 
    TrainerTraining tt ON t.TrainingID = tt.TrainingID
JOIN 
    Trainer tr ON tt.TrainerID = tr.TrainerID
WHERE 
    e.EmployeeID = 1  -- Replace 1 with the desired EmployeeID
ORDER BY 
    t.TrainingName,
    tr.TrainerFirstName;

-- Q19: Write a query to display the EmployeeID, FirstName, LastName, DepartmentID, DepartmentName, EquipmentID, EquipmentName for all employees. Sort the results by EmployeeID, DepartmentID, and EquipmentID. 
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.DepartmentID,
    d.DepartmentName,
    ee.EquipmentID,
    eq.EquipmentName
FROM 
    Employee e
JOIN 
    Department d ON e.DepartmentID = d.DepartmentID
JOIN 
    EmployeeEquipment ee ON e.EmployeeID = ee.EmployeeID
JOIN 
    Equipment eq ON ee.EquipmentID = eq.EquipmentID
ORDER BY 
    e.EmployeeID,
    e.DepartmentID,
    ee.EquipmentID;
    -- Q20 Write a query to display the EmployeeID, FirstName, LastName, DepartmentID, DepartmentName, TrainingID, TrainingName for all employees. Sort the results by EmployeeID, DepartmentID, and TrainingID.
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.DepartmentID,
    d.DepartmentName,
    et.TrainingID,
    t.TrainingName
FROM 
    Employee e
JOIN 
    Department d ON e.DepartmentID = d.DepartmentID
JOIN 
    EmployeeTraining et ON e.EmployeeID = et.EmployeeID
JOIN 
    Training t ON et.TrainingID = t.TrainingID
ORDER BY 
    e.EmployeeID,
    e.DepartmentID,
    et.TrainingID;




    






