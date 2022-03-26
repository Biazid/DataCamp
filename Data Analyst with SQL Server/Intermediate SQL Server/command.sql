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





