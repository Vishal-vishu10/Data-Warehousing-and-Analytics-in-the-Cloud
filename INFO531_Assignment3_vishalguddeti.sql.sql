-- Q1
CREATE DATABASE Customer;

show databases;

USE Customer;

-- Q2 

CREATE TABLE Customer.CustomerChurn_Stage (
    CustomerId INT PRIMARY KEY,
    Surname VARCHAR(50),
    CreditScore INT,
    Geography VARCHAR(50),
    Gender VARCHAR(10),
    Age INT,
    Balance DECIMAL(15,2),
    Exited INT
);

SHOW CREATE TABLE Customer.CustomerChurn_Stage;


CREATE TABLE Customer.CustomerChurn (
    CustomerId INT PRIMARY KEY,
    Surname VARCHAR(50),
    CreditScore INT,
    Geography VARCHAR(50),
    Gender VARCHAR(10),
    Age INT,
    Balance DECIMAL(15,2),
    Exited INT,
    SourceSystemNm NVARCHAR(20) NOT NULL,
    CreateAgentId NVARCHAR(20) NOT NULL,
    CreateDtm DATETIME NOT NULL,
    ChangeAgentId NVARCHAR(20) NOT NULL,
    ChangeDtm DATETIME NOT NULL
);

SHOW CREATE TABLE Customer.CustomerChurn;

-- Q3
-- Count rows in the CustomerChurn_Stage table
SELECT COUNT(*) AS StageTableRowCount FROM Customer.CustomerChurn_Stage;


SELECT * FROM Customer.CustomerChurn_Stage ORDER BY CustomerId DESC LIMIT 10;


-- Q4
DELIMITER //

CREATE PROCEDURE Customer.PrCustomerChurn()
BEGIN
    DECLARE VarCurrentTimestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
    DECLARE VarSourceRowCount, VarTargetRowCount, VarThresholdNbr INTEGER DEFAULT 0;
    DECLARE VarTinyIntVal TINYINT;

    -- Calculate row counts for source and target tables
    SELECT COUNT(*) INTO VarSourceRowCount FROM Customer.CustomerChurn_Stage;
    SELECT COUNT(*) INTO VarTargetRowCount FROM Customer.CustomerChurn;

    -- Calculate threshold number (20% of target table row count)
    SELECT CAST((VarTargetRowCount * .2) AS UNSIGNED INTEGER) INTO VarThresholdNbr FROM DUAL;

    -- Fail the stored procedure if the source row count is less than the threshold
    IF VarSourceRowCount < VarThresholdNbr THEN
        SELECT -129 INTO VarTinyIntVal FROM DUAL;
    END IF;

    -- Delete target table rows that are no longer available in the source table
    DELETE FROM Customer.CustomerChurn AS TrgtTbl
    WHERE EXISTS (
        SELECT *
        FROM (
            SELECT TT.CustomerId
            FROM Customer.CustomerChurn AS TT
            LEFT JOIN Customer.CustomerChurn_Stage AS ST ON TT.CustomerId = ST.CustomerId
            WHERE ST.CustomerId IS NULL
        ) AS SrcTbl
        WHERE TrgtTbl.CustomerId = SrcTbl.CustomerId
    );

    -- Update rows that have changed in the source table
    UPDATE Customer.CustomerChurn AS TrgtTbl
    INNER JOIN Customer.CustomerChurn_Stage AS SrcTbl ON TrgtTbl.CustomerId = SrcTbl.CustomerId
    SET TrgtTbl.Surname = SrcTbl.Surname,
        TrgtTbl.CreditScore = SrcTbl.CreditScore,
        TrgtTbl.Geography = SrcTbl.Geography,
        TrgtTbl.Gender = SrcTbl.Gender,
        TrgtTbl.Age = SrcTbl.Age,
        TrgtTbl.Balance = SrcTbl.Balance,
        TrgtTbl.Exited = SrcTbl.Exited,
        TrgtTbl.ChangeDtm = VarCurrentTimestamp
    WHERE COALESCE(TrgtTbl.Surname, '*') <> COALESCE(SrcTbl.Surname, '*')
       OR COALESCE(TrgtTbl.CreditScore, '*') <> COALESCE(SrcTbl.CreditScore, '*')
       OR COALESCE(TrgtTbl.Geography, '*') <> COALESCE(SrcTbl.Geography, '*')
       OR COALESCE(TrgtTbl.Gender, '*') <> COALESCE(SrcTbl.Gender, '*')
       OR COALESCE(TrgtTbl.Age, '*') <> COALESCE(SrcTbl.Age, '*')
       OR COALESCE(TrgtTbl.Balance, '*') <> COALESCE(SrcTbl.Balance, '*')
       OR COALESCE(TrgtTbl.Exited, '*') <> COALESCE(SrcTbl.Exited, '*');

    -- Insert new rows from the source table into the target table
    INSERT INTO Customer.CustomerChurn (
        CustomerId, Surname, CreditScore, Geography, Gender, Age, Balance, Exited,
        SourceSystemNm, CreateAgentId, CreateDtm, ChangeAgentId, ChangeDtm
    )
    SELECT SrcTbl.CustomerId, SrcTbl.Surname, SrcTbl.CreditScore, SrcTbl.Geography, SrcTbl.Gender, SrcTbl.Age, SrcTbl.Balance, SrcTbl.Exited,
           'Kaggle-CSV' AS SourceSystemNm, current_user() AS CreateAgentId, VarCurrentTimestamp AS CreateDtm, current_user() AS ChangeAgentId, VarCurrentTimestamp AS ChangeDtm
    FROM Customer.CustomerChurn_Stage AS SrcTbl
    LEFT JOIN Customer.CustomerChurn AS TT ON SrcTbl.CustomerId = TT.CustomerId
    WHERE TT.CustomerId IS NULL;
END //

DELIMITER ;



CALL Customer.PrCustomerChurn();



SELECT COUNT(*) AS StagingRowCount  FROM Customer.CustomerChurn_Stage;


SELECT COUNT(*) AS PersistentCount FROM Customer.CustomerChurn;

SELECT * FROM Customer.CustomerChurn ORDER BY CustomerId DESC LIMIT 10;

-- Q6
CREATE TABLE Customer.CustomerChurn_Version1 AS

SELECT * FROM Customer.CustomerChurn;


SHOW CREATE TABLE Customer.CustomerChurn_Version1;


SELECT COUNT(*) AS Version1RowCount FROM Customer.CustomerChurn_Version1;



SELECT * FROM Customer.CustomerChurn_Version1 ORDER BY CustomerId DESC LIMIT 10;


-- Empty the staging table
TRUNCATE TABLE Customer.CustomerChurn_Stage;

-- Show row count of the staging table
SELECT COUNT(*) AS RowCount FROM Customer.CustomerChurn_Stage;

-- Display last few rows from the staging table
SELECT * FROM Customer.CustomerChurn_Stage ORDER BY CustomerId  DESC LIMIT 10;



-- Q7
CALL Customer.PrCustomerChurn();


-- Show row count of Customer.CustomerChurn_Version1
SELECT COUNT(*) AS Version1RowCount FROM Customer.CustomerChurn_Version1;


-- Show row count of Customer.CustomerChurn
SELECT COUNT(*) AS ChurnRowCount FROM Customer.CustomerChurn;



-- Show rows that are in Customer.CustomerChurn_Version1 but not in Customer.CustomerChurn
SELECT *
FROM Customer.CustomerChurn_Version1
WHERE CustomerId NOT IN (SELECT CustomerId FROM Customer.CustomerChurn);

-- Q8
SELECT
    ChurnTbl.CustomerId,
    ChurnTbl.Surname AS ChurnSurname,
    ChurnTbl.CreditScore AS ChurnCreditScore,
    ChurnTbl.Geography AS ChurnGeography,
    ChurnTbl.Gender AS ChurnGender,
    ChurnTbl.Age AS ChurnAge,
    ChurnTbl.Balance AS ChurnBalance,
    ChurnTbl.Exited AS ChurnExited,
    Version1Tbl.Surname AS Version1Surname,
    Version1Tbl.CreditScore AS Version1CreditScore,
    Version1Tbl.Geography AS Version1Geography,
    Version1Tbl.Gender AS Version1Gender,
    Version1Tbl.Age AS Version1Age,
    Version1Tbl.Balance AS Version1Balance,
    Version1Tbl.Exited AS Version1Exited,
    ChurnTbl.CreateDtm AS ChurnCreateDtm,
    ChurnTbl.ChangeDtm AS ChurnChangeDtm
FROM Customer.CustomerChurn AS ChurnTbl
INNER JOIN Customer.CustomerChurn_Version1 AS Version1Tbl
    ON ChurnTbl.CustomerId = Version1Tbl.CustomerId
WHERE ChurnTbl.Surname <> Version1Tbl.Surname
   OR ChurnTbl.CreditScore <> Version1Tbl.CreditScore
   OR ChurnTbl.Geography <> Version1Tbl.Geography
   OR ChurnTbl.Gender <> Version1Tbl.Gender
   OR ChurnTbl.Age <> Version1Tbl.Age
   OR ChurnTbl.Balance <> Version1Tbl.Balance
   OR ChurnTbl.Exited <> Version1Tbl.Exited
ORDER BY ChurnTbl.CustomerId;


-- Q9
-- Execute the query to find rows in Customer.CustomerChurn but not in Customer.CustomerChurn_Version1

SELECT *
FROM Customer.CustomerChurn
WHERE CustomerId NOT IN (SELECT CustomerId FROM Customer.CustomerChurn_Version1)
ORDER BY CustomerId DESC LIMIT 10;






