                                                               --Chapter 1: Exploring the Olympics Dataset

				--Identifying the base report
/*
You are tasked with building the following visualization:

Photo: Bar chart	
A base report is an underlying report that sources a visualization. From a SQL point of view, you first want to build a base report before creating the visualization.

Which of the following statements about the base report for this visualization is false?

Ans: The query needs a WHERE statement.
*/

				--Building the base report
				/*
Now, build the base report for this visualization:

This should be built by querying the summer_games table, found in the explorer on the bottom right. 
*/

--Using the console on the right, select the sport field from the summer_games table.
--Create athletes by counting the distinct occurrences of athlete_id.
--Group by the sport field.
--Make the report only show 3 rows, with the highest athletes at the top.

-- Query the sport and distinct number of athletes
SELECT 
	sport, 
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
GROUP BY sport
-- Only include the 3 sports with the most athletes
ORDER BY athletes DESC
LIMIT 3;


				--Athletes vs events by sport
/*
Now consider the following visualization:

Photo: Athletes vs Events, by sports [Graph point x]

Using the summer_games table, run a query that creates the base report that sources this visualization.
*/

--Pull a report that shows each sport, the number of unique events, and the number of unique athletes from the summer_games table.
--Group by the non-aggregated field, which is sport.

-- Query sport, events, and athletes from summer_games
SELECT 
	sport, 
    COUNT(DISTINCT event) AS events, 
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
GROUP BY sport;



				--Planning queries with an E:R diagram
/*
An E:R diagram visually shows all tables, fields, and relationships in a database. You are given the following E:R diagram:

You are tasked with building a report that shows Age of Oldest Athlete by Region. What tables will need to be included in the query?
Ans: athletes, summer_games, countries
*/


				--Age of oldest athlete by region
/*
In the previous exercise, you identified which tables are needed to create a report that shows Age of Oldest Athlete by Region. 
Now, set up the query to create this report.
*/

--Create a report that shows region and age_of_oldest_athlete.
--Include all three tables by running two separate JOIN statements.
--Group by the non-aggregated field.
--Alias each table AS the first letter in the table (in lower case).

-- Select the age of the oldest athlete for each region
SELECT 
	region, 
    max(age) AS age_of_oldest_athlete
FROM summer_games as sg
-- First JOIN statement
JOIN athletes as a
on a.id=sg.athlete_id
-- Second JOIN statement
JOIN countries as c
on c.id=sg.country_id
GROUP BY region;


				--Number of events in each sport
/*
Since the company will be involved in both summer sports and winter sports, it is beneficial to look at all sports in one centralized report.

Your task is to create a query that shows the unique number of events held for each sport. Note that since no relationships exist between these two tables,
you will need to use a UNION instead of a JOIN.
*/
--Create a report that shows unique events by sport for both summer and winter events.
--Use a UNION to combine the relevant tables.
--Use two GROUP BY statements as needed.
--Order the final query to show the highest number of events first.

-- Select sport and events for summer sports
SELECT
	sport, 
    COUNT(DISTINCT event) AS events
FROM summer_games
GROUP BY sport
UNION
-- Select sport and events for winter sports
SELECT 
	sport, 
    COUNT(DISTINCT event) AS events
FROM winter_games
GROUP BY sport
-- Show the most events at the top of the report
ORDER BY events DESC;


				--Exploring summer_games
/*
Exploring the data in a table can provide further insights into the database as a whole. 
In this exercise, you will try out a series of different techniques to explore the summer_games table.
*/

--1 Select bronze from the summer_games table, but do not use DISTINCT or GROUP BY.

-- Update the query to explore the bronze field
SELECT bronze
FROM summer_games;

-- 2 The results do not provide much insight as we mostly see NULL. Add a DISTINCT to only show unique bronze values.

-- Update query to explore the unique bronze field values
SELECT distinct bronze
FROM summer_games;

--3 GROUP BY is an alternative to using DISTINCT. Remove the DISTINCT and add a GROUP BY statement.

-- Recreate the query by using GROUP BY 
SELECT bronze
FROM summer_games
Group by bronze;

--4 Let's see how much of our dataset is NULL. Add a field that shows number of rows to your query.

-- Add the rows column to your query
SELECT 
	bronze, 
	count(*) AS rows
FROM summer_games
GROUP BY bronze;


				--Validating our query








