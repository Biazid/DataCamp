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



				--





