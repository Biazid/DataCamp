--Which table has the most rows? Which table has the most columns?
--stackoverflow has the most rows; fortune500 has the most columns

--First, figure out how many rows are in fortune500 by counting them.
-- Select the count of the number of rows
SELECT count(*)
  FROM fortune500;
  
-- Subtract the count of the non-NULL ticker values from the total number of rows; alias the difference as missing.
-- Select the count of ticker, 
-- subtract from the total number of rows, 
-- and alias as missing
SELECT count(*) - count(ticker) AS missing
  FROM fortune500;
  
 -- Repeat for the profits_change column.
-- Select the count of profits_change, 
-- subtract from total number of rows, and alias as missing
select count(profits_change)
from fortune500;

select count(*)- count(profits_change) as missing
from fortune500

-- Repeat for the industry column.
-- Select the count of industry, 
-- subtract from total number of rows, and alias as missing
select count(industry)
from fortune500;

select count(*)- count(industry) as missing
from fortune500

--Look at the contents of the company and fortune500 tables. Find a column that they have in common where the values for each company are the same in both tables.
--Join the company and fortune500 tables with an INNER JOIN.
--Select only company.name for companies that appear in both tables.

-- SELECT company.name
-- Table(s) to select from
  FROM company
       INNER JOIN  fortune500 ON
      company.ticker=fortune500.ticker;

-- Recall that foreign keys reference another row in the database via a unique ID. Values in a foreign key column are restricted to values in the referenced column OR NULL.
--Using what you know about foreign keys, why can't the tag column in the tag_type table be a foreign key that references the tag column in the stackoverflow table?
--Remember, you can reference the slides using the icon in the upper right of the screen to review the requirements for a foreign key.
-- Ans: stackoverflow.tag contains duplicate values


-- First, using the tag_type table, count the number of tags with each type.
--Order the results to find the most common tag type.
-- Count the number of tags with each type
SELECT type, count(tag) AS count
  FROM tag_type
 -- To get the count for each type, what do you need to do?
 GROUP BY type 
 -- Order the results with the most common
 -- tag types listed first
 ORDER BY count desc;
 
 -- Join the tag_company, company, and tag_type tables, keeping only mutually occurring records.
-- Select company.name, tag_type.tag, and tag_type.type for tags with the most common type from the previous step.
-- Select the 3 columns desired
SELECT company.name, tag_type.tag, tag_type.type
  FROM company
  	   -- Join to the tag_company table
       INNER JOIN tag_company 
       ON company.id = tag_company.company_id
       -- Join to the tag_type table
       INNER JOIN tag_type
       ON tag_company.tag = tag_type.tag
  -- Filter to most common type
  WHERE type='cloud';
  
  -- Use coalesce() to select the first non-NULL value from industry, sector, or 'Unknown' as a fallback value.
-- Alias the result of the call to coalesce() as industry2.
-- Count the number of rows with each industry2 value.
-- Find the most common value of industry2.
-- Use coalesce
SELECT coalesce(industry, sector, 'Unknown') AS industry2,
       -- Don't forget to count!
       count(industry) 
  FROM fortune500 
-- Group by what? (What are you counting by?)
 GROUP BY industry2
-- Order results to see most common first
ORDER BY count(industry) desc
-- Limit results to get just the one value you want
limit 1

-- Coalesce with a self-join
-- Join company to itself to add information about a company's parent to the original company's information.
--Use coalesce to get the parent company ticker if available and the original company ticker otherwise.
--INNER JOIN to fortune500 using the ticker.
--Select original company name, fortune500 title and rank.

SELECT company_original.name, title, rank
  -- Start with original company information
  FROM company AS company_original
       -- Join to another copy of company with parent
       -- company information
	   LEFT JOIN company AS company_parent
       ON company_original.parent_id = company_parent.id 
       -- Join to fortune500, only keep rows that match
       INNER JOIN fortune500 
       -- Use parent ticker if there is one, 
       -- otherwise original ticker
       ON coalesce(company_parent.ticker, 
                   company_original.ticker) = 
             fortune500.ticker
 -- For clarity, order by rank
 ORDER BY rank; 
 
 
--Effects of casting
--Select profits_change and profits_change cast as integer from fortune500.
--Look at how the values were converted.
-- Select the original value
SELECT profits_change, 
	   -- Cast profits_change
       CAST(profits_change as integer) AS profits_change_int
  FROM fortune500;

--Compare the results of casting of dividing the integer value 10 by 3 to the result of dividing the numeric value 10 by 3.
-- Divide 10 by 3
SELECT 10/3, 
       -- Cast 10 as numeric and divide by 3
       10::numeric  /3;
    
--Now cast numbers that appear as text as numeric. Note: 1e3 is scientific notation.
SELECT '3.2'::numeric,
       '-123'::numeric,
       '1e3'::numeric,
       '1e-3'::numeric,
       '02314'::numeric,
       '0002'::numeric;
       
--Summarize the distribution of numeric values
--Use GROUP BY and count() to examine the values of revenues_change.
--Order the results by revenues_change to see the distribution.
-- Select the count of each value of revenues_change
SELECT revenues_change,count(revenues_change)
  FROM fortune500
Group by revenues_change
 -- order by the values of revenues_change
 ORDER BY revenues_change;
 
--Repeat step 1, but this time, cast revenues_change as an integer to reduce the number of different values.
-- Select the count of each revenues_change integer value
SELECT revenues_change::integer, count(revenues_change)
  FROM fortune500
 group by  revenues_change::integer
 -- order by the values of revenues_change
 ORDER BY revenues_change;
 
 --How many of the Fortune 500 companies had revenues increase in 2017 compared to 2016? 
 --To find out, count the rows of fortune500 where revenues_change indicates an increase.
 -- Count rows 
SELECT count(*)
  FROM fortune500
 -- Where...
 WHERE revenues_change > 0;
 
 
 
 
 --							Chapter 2: Summarizing and aggregating numeric data



--Compute revenue per employee by dividing revenues by employees; use casting to produce a numeric result.
--Take the average of revenue per employee with avg(); alias this as avg_rev_employee.
--Group by sector.
--Order by the average revenue per employee.
-- Select average revenue per employee by sector
SELECT sector, 
       avg(revenues/employees::numeric) AS avg_rev_employee
  FROM fortune500
 GROUP BY sector
 -- Use the column alias to order the results
 ORDER BY avg_rev_employee;
 
 --Exclude rows where question_count is 0 to avoid a divide by zero error.
--Limit the result to 10 rows.
-- Divide unanswered_count by question_count
SELECT unanswered_count/question_count::numeric AS computed_pct, 
       -- What are you comparing the above quantity to?
       unanswered_pct
  FROM stackoverflow
 -- Select rows where question_count is not 0
 WHERE question_count<>0
 LIMIT 10;
 
 
 	--Summarize numeric columns
--Compute the min(), avg(), max(), and stddev() of profits.
-- Select min, avg, max, and stddev of fortune500 profits
SELECT min(profits),
       avg(profits),
       max(profits),
       stddev(profits)
  FROM fortune500;
  
--Now repeat step 1, but summarize profits by sector.
--Order the results by the average profits for each sector.
-- Select sector and summary measures of fortune500 profits
SELECT sector,
       min(profits),
       avg(profits),
       max(profits),
       stddev(profits)
  FROM fortune500
 -- What to group by?
 GROUP BY sector
 -- Order by the average profits
 ORDER BY avg;
 
 --		Summarize group statistics
--Start by writing a subquery to compute the max() of question_count per tag; alias the subquery result as maxval.
--Then compute the standard deviation of maxval with stddev().
--Compute the min(), max(), and avg() of maxval too.
-- Compute standard deviation of maximum values
SELECT stddev(maxval),
	   -- min
       min(maxval),
       -- max
       max(maxval),
       -- avg
       avg(maxval)
  -- Subquery to compute max of question_count by tag
  FROM (SELECT max(question_count) AS maxval
          FROM stackoverflow
         -- Compute max by...
         GROUP BY tag) AS max_results; -- alias for subquery
	 
--		Truncate
--Use trunc() to truncate employees to the 100,000s (5 zeros).
--Count the number of observations with each truncated value.
-- Truncate employees
SELECT trunc(employees, -5) AS employee_bin,
       -- Count number of companies with each truncated value
       count(title)
  FROM fortune500
 -- Use alias to group
 GROUP BY employee_bin
 -- Use alias to order
 ORDER BY employee_bin;
 
 --Repeat step 1 for companies with < 100,000 employees (most common). This time, truncate employees to the 10,000s place.
-- Truncate employees
SELECT trunc(employees, -4) AS employee_bin,
       -- Count number of companies with each truncated value
       count(title)
  FROM fortune500
 -- Limit to which companies?
 WHERE employees< 100000
 -- Use alias to group
 GROUP BY employee_bin
 -- Use alias to order
 ORDER BY employee_bin;
 
 ---		Generate series
--Start by selecting the minimum and maximum of the question_count column for the tag 'dropbox' so you know the range of values to cover with the bins.
-- Select the min and max of question_count
SELECT min(question_count), 
       max(question_count)
  -- From what table?
  FROM stackoverflow
 -- For tag dropbox
 where tag = 'dropbox';
 
 --Next, use generate_series() to create bins of size 50 from 2200 to 3100.

--To do this, you need an upper and lower bound to define a bin.

--This will require you to modify the stopping value of the lower bound and the starting value of the upper bound by the bin width.

-- Create lower and upper bounds of bins
SELECT generate_series(2200, 3050, 50) AS lower,
       generate_series(2250, 3100, 50) AS upper;
       
-- Select lower and upper from bins, along with the count of values within each bin bounds.
--To do this, you'll need to join 'dropbox', which contains the question_count for tag "dropbox", to the bins created by generate_series().
--The join should occur where the count is greater than or equal to the lower bound, and str--ctly less than the upper bound.

-- Bins created in Step 2
WITH bins AS (
      SELECT generate_series(2200, 3050, 50) AS lower,
             generate_series(2250, 3100, 50) AS upper),
     -- Subset stackoverflow to just tag dropbox (Step 1)
     dropbox AS (
      SELECT question_count 
        FROM stackoverflow
       WHERE tag='dropbox') 
-- Select columns for result
-- What column are you counting to summarize?
SELECT lower, upper, count(question_count) 
  FROM bins  -- Created above
       -- Join to dropbox (created above), 
       -- keeping all rows from the bins table in the join
       LEFT JOIN dropbox
       -- Compare question_count to lower and upper
         ON question_count >= lower 
        AND question_count < upper
 -- Group by lower and upper to count values in each bin
 GROUP BY lower, upper
 -- Order by lower to put bins in order
 ORDER BY lower;
 
 
 --		Correlation
 
 --Compute the correlation between revenues and profits.
--Compute the correlation between revenues and assets.
--Compute the correlation between revenues and equity.

-- Correlation between revenues and profit
SELECT corr(revenues,profits) AS rev_profits,
	   -- Correlation between revenues and assets
       corr(revenues,assets) AS rev_assets,
       -- Correlation between revenues and equity
       corr(revenues,equity) AS rev_equity 
  FROM fortune500;
  
  --		Mean and Median

-- Select the mean and median of assets.
--Group by sector.
--Order the results by the mean.

-- What groups are you computing statistics by?
SELECT sector,
       -- Select the mean of assets with the avg function
       avg(assets) AS mean,
       -- Select the median
       percentile_disc(0.5) WITHIN GROUP (ORDER BY assets) AS median
  FROM fortune500
 -- Computing statistics for each what?
 GROUP BY sector
 -- Order results by a value of interest
 ORDER BY mean;


--		Create a temp table
---- To clear table if it already exists;
-- fill in name of temp table
DROP TABLE IF EXISTS profit80;
-- Create the temporary table
CREATE TEMP TABLE profit80 AS 
  -- Select the two columns you need; alias as needed
  SELECT sector,
         percentile_disc(0.8) WITHIN GROUP (ORDER BY profits) AS pct80
    -- What table are you getting the data from?
    FROM fortune500
   -- What do you need to group by?
   GROUP BY sector;
SELECT * 
  FROM profit80;
  
  
  --2 -- DROP TABLE IF EXISTS profit80;
CREATE TEMP TABLE profit80 AS
  SELECT sector, 
         percentile_disc(0.8) WITHIN GROUP (ORDER BY profits) AS pct80
    FROM fortune500 
   GROUP BY sector;
-- Select columns, aliasing as needed
SELECT title, fortune500.sector, 
       profits, profits/pct80 AS ratio
-- What tables do you need to join?  
  FROM fortune500 
       LEFT JOIN profit80
-- How are the tables joined?
       ON fortune500.sector=profit80.sector
-- What rows do you want to select?
 WHERE profits>pct80;


---		Create a temp table to simplify a query
--First, create a temporary table called startdates with each tag and the min() date for the tag in stackoverflow.
-- To clear table if it already exists
DROP TABLE IF EXISTS startdates;
-- Create temp table syntax
CREATE temp table startdates AS
-- Compute the minimum date for each what?
SELECT tag,
       min(date) AS mindate
  FROM stackoverflow
 -- What do you need to compute the min date for each tag?
 Group by tag;
 -- Look at the table you created
 SELECT * 
   FROM startdates;
   
   
   --2 --Join startdates to stackoverflow twice using different table aliases.
--For each tag, select mindate, question_count on the mindate, and question_count on 2018-09-25 (the max date).
--Compute the change in question_count over time.
DROP TABLE IF EXISTS startdates;
CREATE TEMP TABLE startdates AS
SELECT tag, min(date) AS mindate
  FROM stackoverflow
 GROUP BY tag;
SELECT startdates.tag, 
       mindate, 
       -- Select question count on the min and max days
	   so_min.question_count AS min_date_question_count,
       so_max.question_count AS max_date_question_count,
       -- Compute the change in question_count (max- min)
       so_max.question_count - so_min.question_count AS change
  FROM startdates
       -- Join startdates to stackoverflow with alias so_min
       INNER JOIN stackoverflow AS so_min
          -- What needs to match between tables?
          ON startdates.tag = so_min.tag
         AND startdates.mindate = so_min.date
       -- Join to stackoverflow again with alias so_max
       INNER JOIN stackoverflow AS so_max
       	  -- Again, what needs to match between tables?
          ON startdates.tag = so_max.tag
          AND so_max.date = '2018-09-25';
	  
	  
	  
	--	Insert into a temp table

--Create a temp table correlations.
--Compute the correlation between profits and each of the three variables (i.e. correlate profits with profits, profits with profits_change, etc).
--Alias columns by the name of the variable for which the correlation with profits is being computed.
DROP TABLE IF EXISTS correlations;
-- Create temp table 
Create temp table correlations AS
-- Select each correlation
SELECT 'profits'::varchar AS measure,
       -- Compute correlations
       corr(profits,profits) AS profits,
       corr(profits,profits_change) AS profits_change,
       corr(profits,revenues_change) AS revenues_change
  FROM fortune500;

--Insert rows into the correlations table for profits_change and revenues_change.
DROP TABLE IF EXISTS correlations;
CREATE TEMP TABLE correlations AS
SELECT 'profits'::varchar AS measure,
       corr(profits, profits) AS profits,
       corr(profits, profits_change) AS profits_change,
       corr(profits, revenues_change) AS revenues_change
  FROM fortune500;
-- Add a row for profits_change
-- Insert into what table?
INSERT INTO correlations
-- Follow the pattern of the select statement above
-- Using profits_change instead of profits
SELECT 'profits_change'::varchar AS measure,
       corr(profits_change, profits) AS profits,
       corr(profits_change, profits_change) AS profits_change,
       corr(profits_change, revenues_change) AS revenues_change
  FROM fortune500;

-- Repeat the above, but for revenues_change
INSERT INTO correlations
SELECT 'revenues_change'::varchar AS measure,
       corr(revenues_change, profits) AS profits,
       corr(revenues_change, profits_change) AS profits_change,
       corr(revenues_change, revenues_change) AS revenues_change
  FROM fortune500;
  
--Select all rows and columns from the correlations table to view the correlation matrix.
--First, you will need to round each correlation to 2 decimal places.
--The output of corr() is of type double precision, so you will need to also cast columns to numeric.
DROP TABLE IF EXISTS correlations;
CREATE TEMP TABLE correlations AS
SELECT 'profits'::varchar AS measure,
       corr(profits, profits) AS profits,
       corr(profits, profits_change) AS profits_change,
       corr(profits, revenues_change) AS revenues_change
  FROM fortune500;
INSERT INTO correlations
SELECT 'profits_change'::varchar AS measure,
       corr(profits_change, profits) AS profits,
       corr(profits_change, profits_change) AS profits_change,
       corr(profits_change, revenues_change) AS revenues_change
  FROM fortune500;
INSERT INTO correlations
SELECT 'revenues_change'::varchar AS measure,
       corr(revenues_change, profits) AS profits,
       corr(revenues_change, profits_change) AS profits_change,
       corr(revenues_change, revenues_change) AS revenues_change
  FROM fortune500;
-- Select each column, rounding the correlations
SELECT measure, 
       round(profits::numeric, 2) AS profits,
       round(profits_change::numeric, 2) AS profits_change,
       round(revenues_change::numeric, 2) AS revenues_change
  FROM correlations;
  
  
  
---						Chapter 3: 


--	Count the categories
--How many rows does each priority level have?
-- Select the count of each level of priority
SELECT priority, count(*)
  from evanston311
 group by priority;
 
 --How many distinct values of zip appear in at least 100 rows?
-- Find values of zip that appear in at least 100 rows
-- Also get the count of each value
SELECT zip, count(*)
  FROM evanston311
 GROUP BY zip
HAVING count(*)>=100; 

--How many distinct values of source appear in at least 100 rows?
-- Find values of source that appear in at least 100 rows
-- Also get the count of each value
SELECT source, count(*)
  FROM evanston311
  GROUP BY source
  HAVING Count(*)>=100
  
  --Select the five most common values of street and the count of each.

-- Find the 5 most common values of street and the count of each
SELECT street, count(*)
  FROM evanston311
 Group by street
 Order by count(*) desc
 limit 5
 
 
 --	Spotting character data problems
 
 --Explore the distinct values of the street column. Select each street value and the count of the number of rows with that value. 
 --Sort the results by street to see similar values near each other.
--Which of the following is NOT an issue you see with the values of street?
--Ans: 	There are sometimes extra spaces at the beginning and end of values

	--Trimming
SELECT distinct street,
       -- Trim off unwanted characters from street
       trim(street,'0123456789 #/.') AS cleaned_street
  FROM evanston311
 ORDER BY street;
 
	--Exploring unstructured text
--Use ILIKE to count rows in evanston311 where the description contains 'trash' or 'garbage' regardless of case.
-- Count rows
SELECT count(*)
  FROM evanston311
 -- Where description includes trash or garbage
 WHERE description ILIKE '%trash%' 
    OR description ILIKE '%garbage%';
    
    
--category values are in title case. Use LIKE to find category values with 'Trash' or 'Garbage' in them.
-- Select categories containing Trash or Garbage
SELECT category
  FROM evanston311
 -- Use LIKE
 WHERE category LIKE '%Trash%' 
    OR category LIKE '%Garbage%';
 
 --Count rows where the description includes 'trash' or 'garbage' but the category does not.
-- Count rows
SELECT count(*)
  FROM evanston311 
 -- description contains trash or garbage (any case)
 WHERE (description iLIKE  '%trash%'
    OR description iLIKE  '%garbage%') 
 -- category does not contain Trash or Garbage
   AND category NOT LIKE '%Trash%'
   AND category NOT LIKE '%Garbage%';
   
--Find the most common categories for rows with a description about trash that don't have a trash-related category.
-- Count rows with each category
SELECT category, count(*)
  FROM evanston311 
 WHERE (description ILIKE '%trash%'
    OR description ILIKE '%garbage%') 
   AND category NOT LIKE '%Trash%'
   AND category NOT LIKE '%Garbage%'
 -- What are you counting?
 GROUP BY category
 --- order by most frequent values
 ORDER BY Count desc
 LIMIT 10;

	--Concatenate strings
--Concatenate house_num, a space ' ', and street into a single value using the concat().
--Use a trim function to remove any spaces from the start of the concatenated value.
-- Concatenate house_num, a space, and street
-- and trim spaces from the start of the result
SELECT ltrim(concat(house_num,' ',street)) AS address
  FROM evanston311;
  
  	--Split strings on a delimiter
--Use split_part() to select the first word in street; alias the result as street_name. Also select the count of each value of street_name.
-- Select the first word of the street value
SELECT split_part(street,' ',1) AS street_name, 
       count(*)
  FROM evanston311
 GROUP BY street_name
 ORDER BY count DESC
 LIMIT 20;
 		--Shorten long strings

 --Select the first 50 characters of description with '...' concatenated on the end where the length() of the description is greater than 50 characters. 
--Otherwise just select the description as is.
--Select only descriptions that begin with the word 'I' and not the letter 'I'.
--For example, you would want to select "I like using SQL!", but would not want to select "In this course we use SQL!".
-- Select the first 50 chars when length is greater than 50
SELECT CASE WHEN length(description) > 50
            THEN left(description, 50) || '...'
       -- otherwise just select description
       ELSE description
       END
  FROM evanston311
 -- limit to descriptions that start with the word I
 WHERE description LIKE 'I %'
 ORDER BY description;
 
 		--




