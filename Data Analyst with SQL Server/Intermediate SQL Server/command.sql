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

--Select all the T-SQL keywords used to create a Common table expression.

--DEALLOCATE   OPEN   AS WITH   CTE
Ans: AS, WITH

--Create a CTE BloodGlucoseRandom that returns one column (MaxGlucose) which contains the maximum BloodGlucoseRandom in the table. 
--Join the CTE to the main table (Kidney) on BloodGlucoseRandom and MaxGlucose.
-- Specify the keyowrds to create the CTE
With BloodGlucoseRandom (MaxGlucose) 
As (SELECT MAX(BloodGlucoseRandom) AS MaxGlucose FROM Kidney)

SELECT a.Age, b.MaxGlucose
FROM Kidney a
-- Join the CTE on blood glucose equal to max blood glucose
JOIN BloodGlucoseRandom b
on BloodGlucoseRandom=MaxGlucose

--Create a CTE BloodPressure that returns one column (MaxBloodPressure) which contains the maximum BloodPressure in the table.
--Join this CTE (using an alias b) to the main table (Kidney) to return information about patients with the maximum BloodPressure.

-- Create the CTE
WITH BloodPressure(MaxBloodPressure) 
AS (select Max(BloodPressure) as MaxBloodPressure from kidney)

SELECT *
FROM Kidney a
-- Join the CTE  
join BloodPressure b
on BloodPressure=MaxBloodPressure

--             							Chapter 4

--Write a T-SQL query that returns the sum of OrderPrice by creating partitions for each TerritoryName.

SELECT OrderID, TerritoryName, 
       -- Total price for each partition
       sum(OrderPrice) 
       -- Create the window and partitions
       Over(Partition by TerritoryName) AS TotalPrice
FROM Orders

--Count the number of rows in each partition. Partition the table by TerritoryName.

SELECT OrderID, TerritoryName, 
       -- Number of rows per partition
       count(TerritoryName) 
       -- Create the window and partitions
       over(partition by TerritoryName) AS TotalOrders
FROM Orders

--Which of the following statements is incorrect regarding window queries?
--Ans: The standard aggregations like SUM(), AVG(), and COUNT() require ORDER BY in the OVER() clause.

--Write a T-SQL query that returns the first OrderDate by creating partitions for each TerritoryName.
SELECT TerritoryName, OrderDate, 
       -- Select the first value in each partition
       First_Value(OrderDate) 
       -- Create the partitions and arrange the rows
       OVER(PARTITION BY TerritoryName order by OrderDate) AS FirstOrder
FROM Orders

--Write a T-SQL query that for each territory:
--Shifts the values in OrderDate one row down. Call this column PreviousOrder.
--Shifts the values in OrderDate one row up. Call this column NextOrder. You will need to PARTITION BY the territory

SELECT TerritoryName, OrderDate, 
       -- Specify the previous OrderDate in the window
       LAG(OrderDate) 
       -- Over the window, partition by territory & order by order date
       Over(partition BY TerritoryName order BY OrderDate) AS PreviousOrder,
       -- Specify the next OrderDate in the window
       LEAD(OrderDate) 
       -- Create the partitions and arrange the rows
       Over(partition BY TerritoryName order BY OrderDate) AS NextOrder
FROM Orders

--Create the window, partition by TerritoryName and order by OrderDate to calculate a running total of OrderPrice.
SELECT TerritoryName, OrderDate, orderprice,
       -- Create a running total
       sum(OrderPrice) 
       -- Create the partitions and arrange the rows
       over(partition by TerritoryName order by OrderDate) AS TerritoryTotal	  
FROM Orders

--Write a T-SQL query that assigns row numbers to all records partitioned by TerritoryName and ordered by OrderDate.
SELECT TerritoryName, OrderDate, 
       -- Assign a row number
       row_number() 
       -- Create the partitions and arrange the rows
       OVER(PARTITION BY TerritoryName ORDER BY OrderDate) AS OrderCount
FROM Orders

--Create the window, partition by TerritoryName and order by OrderDate to calculate a running standard deviation of OrderPrice.
SELECT OrderDate, TerritoryName, 
       -- Calculate the standard deviation
	stdev(orderprice)
       OVER(PARTITION BY TerritoryName ORDER BY OrderDate) AS StdDevPrice	  
FROM Orders

--Create a CTE ModePrice that returns two columns (OrderPrice and UnitPriceFrequency).
--Write a query that returns all rows in this CTE.

-- Create a CTE Called ModePrice which contains two columns
With ModePrice (OrderPrice, UnitPriceFrequency)
as
(
	SELECT OrderPrice, 
	ROW_NUMBER() 
	OVER(PARTITION BY OrderPrice ORDER BY OrderPrice) AS
		UnitPriceFrequency
	FROM Orders 
)
-- Select everything from the CTE
select * from ModePrice

--Use the CTE ModePrice to return the value of OrderPrice with the highest row number.
-- CTE from the previous exercise
WITH ModePrice (OrderPrice, UnitPriceFrequency)
AS
(
	SELECT OrderPrice,
	ROW_NUMBER() 
    OVER (PARTITION BY OrderPrice ORDER BY OrderPrice) AS UnitPriceFrequency
	FROM Orders
)

-- Select the order price from the CTE
SELECT OrderPrice AS ModeOrderPrice
FROM ModePrice
-- Select the maximum UnitPriceFrequency from the CTE
WHERE UnitPriceFrequency IN (select max(UnitPriceFrequency) FROM ModePrice)




