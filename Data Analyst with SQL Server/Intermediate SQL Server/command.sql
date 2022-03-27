--Chapter 1: Summarizing Data

-- Calculate the average, minimum and maximum
SELECT Avg(DurationSeconds) AS Average,
       Min(DurationSeconds) AS Minimum,
       Max(DurationSeconds) AS Maximum
FROM Incidents

SELECT State, MAX(DurationSeconds)
FROM Incidents
GROUP BY State;
-- Calculate the aggregations by Shape
SELECT shape,
       AVG(DurationSeconds) AS Average,
       MIN(DurationSeconds) AS Minimum,
       MAX(DurationSeconds) AS Maximum
FROM Incidents
GROUP BY shape;
-- Calculate the aggregations by Shape
SELECT Shape,
       AVG(DurationSeconds) AS Average,
       MIN(DurationSeconds) AS Minimum,
       MAX(DurationSeconds) AS Maximum
FROM Incidents
GROUP BY Shape
-- Return records where minimum of DurationSeconds is greater than 1
HAVING MIN(DurationSeconds) > 1


--Removing missing values
--Write a T-SQL query which returns only the IncidentDateTime and IncidentState columns where IncidentState is not missing.
-- Return the specified columns
select IncidentDateTime, IncidentState
FROM Incidents
-- Exclude all the missing values from IncidentState  
WHERE IncidentState is not null

--Write a T-SQL query which only returns rows where IncidentState is missing.
--Replace all the missing values in the IncidentState column with the values in the City column and name this new column Location.
-- Check the IncidentState column for missing values and replace them with the City column
SELECT IncidentState, 
ISNULL(IncidentState,City) AS Location
FROM Incidents
-- Filter to only return missing values from IncidentState
WHERE IncidentState is null

--Replace missing values in Country with the first non-missing value from IncidentState or City, in that order. Name the new column Location.
-- Replace missing values 
SELECT Country, COALESCE(Country,IncidentState, City) AS Location
FROM Incidents
WHERE Country IS NULL


--                                                                  Chapter 2: Math Functions
--Write a T-SQL query which will return the sum of the Quantity column as Total for each type of MixDesc.
-- Write a query that returns an aggregation 
select MixDesc, sum(quantity) total
FROM Shipments
-- Group by the relevant column
group by MixDesc

--     Create a query that returns the number of rows for each type of MixDesc.
-- Count the number of rows by MixDesc
SELECT MixDesc, count(MixDesc)
FROM Shipments
GROUP BY MixDesc

--Which date function should you use?
--Suppose you want to calculate the number of years between two different dates, DateOne and DateTwo. Which SQL statement would you use to perform that calculation?
--Ans: SELECT DATEDIFF(YYYY, DateOne, DateTwo)

--Write a query that returns the number of days between OrderDate and ShipDate.
SELECT OrderDate, ShipDate, 
       DateDiff(DD, OrderDate, ShipDate) AS Duration
FROM Shipments

--Write a query that returns the approximate delivery date as five days after the ShipDate.
-- Return the DeliveryDate as 5 days after the ShipDate
SELECT OrderDate, 
       DATEADD(DD, 5, ShipDate) AS DeliveryDate
FROM Shipments

--Write a SQL query to round the values in the Cost column to the nearest whole number.
-- Round Cost to the nearest dollar
SELECT Cost, 
       ROUND(Cost,0) AS RoundedCost
FROM Shipments

--Write a SQL query to truncate the values in the Cost column to the nearest whole number.
-- Truncate cost to whole number
SELECT Cost, 
       ROUND(cost, 0,1) AS TruncateCost
FROM Shipments

--Write a query that converts all the negative values in the DeliveryWeight column to positive values.
-- Return the absolute value of DeliveryWeight
SELECT DeliveryWeight,
       abs(DeliveryWeight) AS AbsoluteValue
FROM Shipments

--Write a query that calculates the square and square root of the WeightValue column.
-- Return the square and square root of WeightValue
SELECT WeightValue, 
       square(WeightValue) AS WeightSquare, 
       sqrt(WeightValue) AS WeightSqrt
FROM Shipments

--                                                      Chapter 3: Processing Data in SQL Server


DECLARE @counter INT
SET @counter = 20

-- Create a loop
WHILE @counter<30

-- Loop code starting point
BEGIN
	SELECT @counter = @counter + 1
-- Loop finish
END

-- Check the value of the variable
SELECT @counter

 --Return MaxGlucose from the derived table.
 --Join the derived table to the main query on Age.
SELECT a.RecordId, a.Age, a.BloodGlucoseRandom,
-- Select maximum glucose value (use colname from derived table)    
       b.MaxGlucose
FROM Kidney a
-- Join to derived table
JOIN (SELECT Age, MAX(BloodGlucoseRandom) AS MaxGlucose FROM Kidney GROUP BY Age) b
-- Join on Age
ON a.Age=b.Age


/* Create a derived table
returning Age and MaxBloodPressure; the latter is the maximum of BloodPressure.
is taken from the kidney table.
is grouped by Age.
Join the derived table to the main query on
blood pressure equal to max blood pressure.
age. */

SELECT *
FROM Kidney a
-- JOIN and create the derived table
JOIN (SELECT Age, MAX(BloodPressure) AS MaxBloodPressure FROM Kidney GROUP BY Age) b
-- JOIN on BloodPressure equal to MaxBloodPressure
ON a.BloodPressure = b.MaxBloodPressure
-- Join on Age
AND a.Age = b.Age

--

