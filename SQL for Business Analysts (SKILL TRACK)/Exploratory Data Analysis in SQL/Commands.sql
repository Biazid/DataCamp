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
 
 
 --		
















