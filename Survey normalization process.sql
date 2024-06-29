-- 0. View Data
SELECT *
FROM general_data;

-- 0.1 Check for duplicates (Using EmployeeID)
SELECT EmployeeID, COUNT(*) Count
FROM general_data
GROUP BY EmployeeID
HAVING COUNT(*) > 1;		-- RESULT: No duplicates

-- 0.2 Check for null values
SELECT EmployeeID, MonthlyIncome
FROM general_data
WHERE EmployeeID IS NULL OR
	MonthlyIncome IS NULL;		-- RESULT: No nulls

-- 0.3 Check for invalid data or Out;iers
SELECT MonthlyIncome
FROM general_data
WHERE MonthlyIncome < 0;		-- RESULT: No invalid data

-- 0.4 Create a related table to group similar columns and reduce length
CREATE TABLE `employee_metrics` (
  `EmployeeID` int DEFAULT NULL,
  `NumCompaniesWorked` int DEFAULT NULL,
  `Over18` text,
  `PercentSalaryHike` int DEFAULT NULL,
  `StandardHours` int DEFAULT NULL,
  `StockOptionLevel` int DEFAULT NULL,
  `TotalWorkingYears` int DEFAULT NULL,
  `TrainingTimesLastYear` int DEFAULT NULL,
  `YearsAtCompany` int DEFAULT NULL,
  `YearsSinceLastPromotion` int DEFAULT NULL,
  `YearsWithCurrManager` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO employee_metrics
SELECT `EmployeeID`,`NumCompaniesWorked`,`Over18`,`PercentSalaryHike`,`StandardHours`,`StockOptionLevel`,
`TotalWorkingYears`,`TrainingTimesLastYear`,`YearsAtCompany`,`YearsSinceLastPromotion`,`YearsWithCurrManager`
FROM general_data;

-- 0.5 Create Table copy
CREATE TABLE data_backup as SELECT * FROM general_data;

-- 0.6 Drop columns
ALTER TABLE general_data
DROP COLUMN `NumCompaniesWorked`, DROP COLUMN `Over18`, DROP COLUMN `PercentSalaryHike`, DROP COLUMN`StandardHours`,
DROP COLUMN`StockOptionLevel`, DROP COLUMN`TotalWorkingYears`, DROP COLUMN`TrainingTimesLastYear`, DROP COLUMN`YearsAtCompany`,
DROP COLUMN`YearsSinceLastPromotion`, DROP COLUMN`YearsWithCurrManager`;

-- 0.7 Rearrange columns to preferred order
CREATE TABLE `generaldata_new` (
  `EmployeeID` int DEFAULT NULL,
  `EmployeeCount` int DEFAULT NULL,
  `Department` text,
  `Attrition` text,
  `BusinessTravel` text,
  `DistanceFromHome` int DEFAULT NULL,
  `Education` int DEFAULT NULL,
  `EducationField` text,
  `Age` int DEFAULT NULL,
  `Gender` text,
  `JobLevel` int DEFAULT NULL,
  `JobRole` text,
  `MaritalStatus` text,
  `MonthlyIncome` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 0.8 Inserting te rows from the table
INSERT INTO generaldata_new
SELECT   `EmployeeID`,`EmployeeCount`,`Department` text,`Attrition` text,`BusinessTravel` text,`DistanceFromHome`,
`Education`,`EducationField` text,`Age`,`Gender` text,`JobLevel`,`JobRole` text,`MaritalStatus` text,`MonthlyIncome`
FROM general_data;

-- 0.9 Drop and recreate the table
DROP TABLE general_data;
ALTER TABLE generaldata_new RENAME TO general_data;

-- 1.0 View Data
SELECT *
FROM general_data;