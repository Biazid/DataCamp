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
/*
The same techniques we use to explore the data can be used to validate queries. By using the query as a subquery, you can run exploratory techniques to 
confirm the query results are as expected.

In this exercise, you will create a query that shows Bronze Medals by Country and then validate it using the subquery technique.

Feel free to reference the E:R Diagram as needed.
*/

--1 Create a query that outputs total bronze medals from the summer_games table.
-- Pull total_bronze_medals from summer_games below
SELECT count(bronze) AS total_bronze_medals
FROM summer_games;

--2 The value for total_bronze_medals is commented out for reference. Setup a query that shows bronze_medals for summer_games by country.

/* Pull total_bronze_medals from summer_games below
SELECT SUM(bronze) AS total_bronze_medals
FROM summer_games; 
>> OUTPUT = 141 total_bronze_medals */

-- Setup a query that shows bronze_medal by country
SELECT 
	country, 
    sum(bronze) AS bronze_medals
FROM summer_games AS s
JOIN countries AS c
ON c.id=s.country_id
GROUP BY country;


--3 Add parenthesis to your query you just created and alias as subquery.
--Select the total number of bronze_medals and compare to the total bronze medals in summer_games.

/* Pull total_bronze_medals below
SELECT SUM(bronze) AS total_bronze_medals
FROM summer_games; 
>> OUTPUT = 141 total_bronze_medals */

-- Select the total bronze_medals from your query
SELECT SUM(bronze_medals)
FROM
-- Previous query is shown below.  Alias this AS subquery
  (
  SELECT 
      country, 
      SUM(bronze) AS bronze_medals
  FROM summer_games AS s
  JOIN countries AS c
  ON s.country_id = c.id
  GROUP BY country) AS subquery
;

	
				--Report 1: Most decorated summer athletes
/*
Now that you have a good understanding of the data, let's get back to our case study and build out the first element for the dashboard, 
Most Decorated Summer Athletes:

Photo: Column Chart

Your job is to create the base report for this element. Base report details:

Column 1 should be athlete_name.
Column 2 should be gold_medals.
The report should only include athletes with at least 3 medals.
The report should be ordered by gold medals won, with the most medals at the top.
*/

--Select athlete_name and gold_medals by joining summer_games and athletes.
--Only include athlete_name with at least 3 gold medals.
--Sort the table so that the most gold_medals appears at the top.

-- Pull athlete_name and gold_medals for summer games
SELECT 
	a.name AS athlete_name, 
    sum(gold) AS gold_medals
FROM summer_games AS s
JOIN athletes AS a
ON s.athlete_id=a.id
GROUP BY athlete_name
-- Filter for only athletes with 3 gold medals or more
HAVING sum(gold)>2
-- Sort to show the most gold medals at the top
ORDER BY gold_medals DESC;



							--Chapter 2: Creating Reports

				--Planning the SELECT statement
/*
When setting up queries, it is important to use the correct aggregations for fields. A common mistake is to incorrectly set up a ratio. In this exercise, 
your goal is to create a report that shows the ratio of nobel_prize_winners and pop_in_millions.

Which of the following SELECT statements would sufficiently create this report?

Ans: SELECT SUM(nobel_prize_winners)/SUM(pop_in_millions)
*/

				--Planning the filter
/*
Your boss is looking to see which winter events include athletes over the age of 40. To answer this, you need a report that lists out all events that satisfy
this condition. In order to have a correct list, you will need to leverage a filter. In this exercise, you will decide which filter option to use.
*/

--1 Create a query that shows all unique event names in the winter_games table.

SELECT distinct event
FROM winter_games;

--2 Which of the following approaches will not work to filter this list for events that have athletes over the age of 40?

--Ans: JOIN to athletes and add a HAVING AVG(age) > 40.

				--JOIN then UNION query
/*
Your goal is to create a report with the following fields:

season, which outputs either summer or winter
country
events, which shows the unique number of events
There are multiple ways to create this report. In this exercise, create the report by using the JOIN first, UNION second approach.

As always, feel free to reference your E:R Diagram to identify relevant fields and tables.

*/
--Setup a query that shows unique events by country and season for summer events.
--Setup a similar query that shows unique events by country and season for winter events.
--Combine the two queries using a UNION ALL.
--Sort the report by events in descending order.


-- Query season, country, and events for all summer events
SELECT 
	'summer' AS season, 
    country, 
    COUNT(DISTINCT event) AS events
FROM summer_games AS s
JOIN countries AS c
ON c.id=s.country_id
GROUP BY season,country
-- Combine the queries
UNION ALL
-- Query season, country, and events for all winter events
SELECT 
	'winter' AS season, 
    country, 
    COUNT(DISTINCT event) AS events
FROM winter_games AS w
JOIN countries AS c
ON c.id=w.country_id
GROUP BY season,country
-- Sort the results to show most events at the top
ORDER BY events DESC;



						--UNION then JOIN query
/*
Your goal is to create the same report as before, which contains with the following fields:

-season, which outputs either summer or winter
-country
-events, which shows the unique number of events

In this exercise, create the query by using the UNION first, JOIN second approach. When taking this approach, 
you will need to use the initial UNION query as a subquery. The subquery will need to include all relevant fields, including those used in a join.
*/

--In the subquery, construct a query that outputs season, country_id and event by combining summer and winter games with a UNION ALL.
--Leverage a JOIN and another SELECT statement to show the fields season, country and unique events.
--GROUP BY any unaggregated fields.
--Sort the report by events in descending order.


-- Add outer layer to pull season, country and unique events
SELECT 
	season, 
    country, 
    COUNT(DISTINCT event) AS events
FROM
    -- Pull season, country_id, and event for both seasons
    (SELECT 
     	'summer' AS season, 
     	country_id, 
     	event
    FROM summer_games
    UNION ALL
    SELECT 
     	'winter' AS season, 
     	country_id, 
     	event
    FROM winter_games) AS subquery
JOIN countries AS c
ON c.id=subquery.country_id
-- Group by any unaggregated fields
GROUP BY season, country
-- Order to show most events at the top
ORDER BY events DESC;



						--CASE statement refresher
/*
CASE statements are useful for grouping values into different buckets based on conditions you specify. 
Any row that fails to satisfy any condition will fall to the ELSE statement (or show as null if no ELSE statement exists).

In this exercise, your goal is to create the segment field that buckets an athlete into one of three segments:

-Tall Female, which represents a female that is at least 175 centimeters tall.
-Tall Male, which represents a male that is at least 190 centimeters tall.
-Other

Each segment will need to reference the fields height and gender from the athletes table. Leverage CASE statements and conditional logic (such as AND/OR) to build this

Remember that each line of a case statement looks like this: CASE WHEN {condition} THEN {output}
*/

--Update the CASE statement to output three values: Tall Female, Tall Male, and Other.

SELECT 
	name,
    -- Output 'Tall Female', 'Tall Male', or 'Other'
	CASE WHEN gender='F' AND height>=175 THEN 'Tall Female'
    WHEN gender='M' AND height>=190 THEN 'Tall Male'
    ELSE 'Other' 
    END AS segment
FROM athletes;

	
				--BMI bucket by sport
/*
You are looking to understand how BMI differs by each summer sport. To answer this, set up a report that contains the following:

-sport, which is the name of the summer sport
-bmi_bucket, which splits up BMI into three groups: <.25, .25-.30, >.30
-athletes, or the unique number of athletes

Definition: BMI = 100 * weight / (height squared).

Also note that CASE statements run row-by-row, so the second conditional is only applied if the first conditional is false. 
This makes it that you do not need an AND statement excluding already-mentioned conditionals.
*/

--Build a query that pulls from summer_games and athletes to show sport, bmi_bucket, and athletes.
--Without using AND or ELSE, set up a CASE statement that splits bmi_bucket into three groups: '<.25', '.25-.30', and '>.30'.
--Group by the non-aggregated fields.
--Order the report by sport and then athletes in descending order.

-- Pull in sport, bmi_bucket, and athletes
SELECT 
	sport,
    -- Bucket BMI in three groups: <.25, .25-.30, and >.30	
    CASE WHEN (100*weight/height^2)<0.25 THEN '<.25'
    WHEN (100*weight/height^2)<=0.30 THEN '.25-.30'
    WHEN (100*weight/height^2)>0.30 THEN '>.30' 
    END AS bmi_bucket,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games AS s
JOIN athletes AS a
ON a.id=s.athlete_id
-- GROUP BY non-aggregated fields
GROUP BY sport, bmi_bucket
-- Sort by sport and then by athletes in descending order
ORDER BY sport, athletes desc;


					--Troubleshooting CASE statements
/*
In the previous exercise, you may have noticed several null values in our case statement, which can indicate there is an issue with the code.

In these instances, it's worth investigating to understand why these null values are appearing. In this exercise, you will go through a series of steps to 
identify the issue and make changes to the code where necessary.
*/

--1 Comment out the query from last exercise (lines 2 - 12).
--Create a query that pulls height, weight, and bmi from athletes and filters for null bmi values.



-- Show height, weight, and bmi for all athletes
SELECT 
	height,
    weight,
    weight/height^2*100 AS bmi
FROM athletes
-- Filter for NULL bmi values
WHERE weight/height^2*100 is NULL;


--2 What is the reason we have null values in our bmi field?

--Ans: There are numerous null weight values, which will calculate null bmi values.

--3 Comment out the troubleshooting query, uncomment the original query, and add an ELSE line to the CASE statement that outputs 'no weight recorded'.


SELECT 
	sport,
    CASE WHEN weight/height^2*100 <.25 THEN '<.25'
    WHEN weight/height^2*100 <=.30 THEN '.25-.30'
    WHEN weight/height^2*100 >.30 THEN '>.30'
    -- Add ELSE statement to output 'no weight recorded'
    ELSE 'no weight recorded'
    END AS bmi_bucket,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games AS s
JOIN athletes AS a
ON s.athlete_id = a.id
GROUP BY sport, bmi_bucket
ORDER BY sport, athletes DESC;



						--Filtering with a JOIN
/*
When adding a filter to a query that requires you to reference a separate table, there are different approaches you can take. 
One option is to JOIN to the new table and then add a basic WHERE statement.

Your goal is to create a report with the following characteristics:

First column is bronze_medals, or the total number of bronze.
Second column is silver_medals, or the total number of silver.
Third column is gold_medals, or the total number of gold.
Only summer_games are included.
Report is filtered to only include athletes age 16 or under.

In this exercise, use the JOIN approach.
*/

--Create a query that pulls total bronze_medals, silver_medals, and gold_medals from summer_games.
--Use a JOIN and a WHERE statement to filter for athletes ages 16 and below.


-- Pull summer bronze_medals, silver_medals, and gold_medals
SELECT 
	sum(bronze) as bronze_medals, 
    sum(silver) as silver_medals, 
    sum(gold) as gold_medals
FROM summer_games AS s
JOIN athletes AS a
ON a.id=s.athlete_id
-- Filter for athletes age 16 or below
WHERE age<=16;


				--Filtering with a subquery
/*
Another approach to filter from a separate table is to use a subquery. The process is as follows:

Create a subquery that outputs a list.
In your main query, add a WHERE statement that references the list.
Your goal is to create the same report as the last exercise, which contains the following characteristics:

First column is bronze_medals, or the total number of bronze.
Second column is silver_medals, or the total number of silver.
Third column is gold_medals, or the total number of gold.
Only summer_games are included.
Report is filtered to only include athletes age 16 or under.
In this exercise, use the subquery approach.
*/

--Create a query that pulls total bronze_medals, silver_medals, and gold_medals from summer_games.
--Setup a subquery that outputs all athletes age 16 or below.
--Add a WHERE statement that references the subquery to filter for athletes age 16 or below.

-- Pull summer bronze_medals, silver_medals, and gold_medals
SELECT 
	sum(bronze) as bronze_medals, 
    sum(silver) as silver_medals, 
    sum(gold) as gold_medals
FROM summer_games
-- Add the WHERE statement below
WHERE athlete_id IN
    -- Create subquery list for athlete_ids age 16 or below    
    (SELECT id
     FROM athletes
     WHERE age<=16);
     
     
     
     				--Report 2: Top athletes in nobel-prized countries
/*
It's time to bring together all the concepts brought up in this chapter to expand on your dashboard! 
Your next report to build is Report 2: Athletes Representing Nobel-Prize Winning Countries.

Report Details:

Column 1 should be event, which represents the Olympic event. Both summer and winter events should be included.
Column 2 should be gender, which represents the gender of athletes in the event.
Column 3 should be athletes, which represents the unique athletes in the event.
Athletes from countries that have had no nobel_prize_winners should be excluded.
The report should contain 10 events, where events with the most athletes show at the top.
*/

--1 Select event from the summer_games table and create the athletes field by counting the distinct number of athlete_id.

-- Pull event and unique athletes from summer_games 
SELECT 	
	event,
	COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
GROUP BY event;

--2 Explore the event field to determine how to split up events by gender (without adding a join), 
--then add the gender field by using a CASE statement that specifies a conditional for 'female' events (all other events should output as 'male').

-- Pull event and unique athletes from summer_games 
SELECT 
	event, 
    -- Add the gender field below
    CASE WHEN event LIKE '%Women%' THEN 'female'
    ELSE 'male' 
    END AS gender,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
GROUP BY event;

--3 Filter for Nobel-prize-winning countries by creating a subquery that outputs country_id from the country_stats table for any country
--with more than zero nobel_prize_winners.

-- Pull event and unique athletes from summer_games 
SELECT 
    event,
    -- Add the gender field below
    CASE WHEN event LIKE '%Women%' THEN 'female' 
    ELSE 'male' END AS gender,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
-- Only include countries that won a nobel prize
WHERE country_id IN 
	(SELECT country_id
    FROM country_stats
    WHERE nobel_prize_winners>0)
GROUP BY event;

--4 Copy your query with summer_games replaced by winter_games, UNION the two tables together, and order the final report to show the 10 rows with the most athletes.

-- Pull event and unique athletes from summer_games 
SELECT 
    event,
    -- Add the gender field below
    CASE WHEN event LIKE '%Women%' THEN 'female' 
    ELSE 'male' END AS gender,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
-- Only include countries that won a nobel prize
WHERE country_id IN 
	(SELECT country_id 
    FROM country_stats 
    WHERE nobel_prize_winners > 0)
GROUP BY event
-- Add the second query below and combine with a UNION
UNION ALL
SELECT 
    event,
    -- Add the gender field below
    CASE WHEN event LIKE '%Women%' THEN 'female' 
    ELSE 'male' END AS gender,
    COUNT(DISTINCT athlete_id) AS athletes
FROM winter_games
-- Only include countries that won a nobel prize
WHERE country_id IN 
	(SELECT country_id 
    FROM country_stats 
    WHERE nobel_prize_winners > 0)
GROUP BY event
-- Order and limit the final output
ORDER BY athletes DESC
LIMIT 10;




								--Chapter 3: Cleaning & Validation
					--












