--                                                                Chapter 1: Working with Dates and Times

--Use the YEAR(), MONTH(), and DAY() functions to determine the year, month, and day for the current date and time.
 DECLARE
	@SomeTime DATETIME2(7) = SYSUTCDATETIME();
-- Retrieve the year, month, and day
SELECT
	year(@SomeTime) AS TheYear,
	month(@SomeTime) AS TheMonth,
	day(@SomeTime) AS TheDay;
  
--Using the DATEPART() function, fill in the appropriate date parts. 
--For a list of parts, review https://docs.microsoft.com/en-us/sql/t-sql/functions/datepart-transact-sql
DECLARE
	@BerlinWallFalls DATETIME2(7) = '1989-11-09 23:49:36.2294852';
-- Fill in each date part
SELECT
	DATEPART(year, @BerlinWallFalls) AS TheYear,
	DATEPART(month, @BerlinWallFalls) AS TheMonth,
	DATEPART(day, @BerlinWallFalls) AS TheDay,
	DATEPART(DAYOFYEAR, @BerlinWallFalls) AS TheDayOfYear,
    -- Day of week is WEEKDAY
	DATEPART(WEEKDAY, @BerlinWallFalls) AS TheDayOfWeek,
	DATEPART(week, @BerlinWallFalls) AS TheWeek,
	DATEPART(second, @BerlinWallFalls) AS TheSecond,
	DATEPART(nanosecond, @BerlinWallFalls) AS TheNanosecond;
  
  --Using the DATENAME() function, fill in the appropriate function calls.
  DECLARE
	@BerlinWallFalls DATETIME2(7) = '1989-11-09 23:49:36.2294852';

-- Fill in the function to show the name of each date part
SELECT
	DATENAME(YEAR, @BerlinWallFalls) AS TheYear,
	DATENAME(MONTH, @BerlinWallFalls) AS TheMonth,
	DATENAME(DAY, @BerlinWallFalls) AS TheDay,
	DATENAME(DAYOFYEAR, @BerlinWallFalls) AS TheDayOfYear,
    -- Day of week is WEEKDAY
	DATENAME(WEEKDAY, @BerlinWallFalls) AS TheDayOfWeek,
	DATENAME(WEEK, @BerlinWallFalls) AS TheWeek,
	DATENAME(SECOND, @BerlinWallFalls) AS TheSecond,
	DATENAME(NANOSECOND, @BerlinWallFalls) AS TheNanosecond;
  
--How many DATENAME() results differ from their DATEPART() counterparts?
--Ans: two

--Fill in the date parts and intervals needed to determine how SQL Server works on February 29th of a leap year.
--2012 was a leap year. The leap year before it was 4 years earlier, and the leap year after it was 4 years later.

DECLARE
	@LeapDay DATETIME2(7) = '2012-02-29 18:00:00';
-- Fill in the date parts and intervals as needed
SELECT
	DATEADD(Day, -1, @LeapDay) AS PriorDay,
	DATEADD(Day, 1, @LeapDay) AS NextDay,
    -- For leap years, we need to move 4 years, not just 1
	DATEADD(YEAR, -4, @LeapDay) AS PriorLeapYear,
	DATEADD(YEAR, 4, @LeapDay) AS NextLeapYear,
	DATEADD(YEAR, -1, @LeapDay) AS PriorYear;
  
--Fill in the date parts and intervals needed to determine how SQL Server works on days next to a leap year.
DECLARE
	@PostLeapDay DATETIME2(7) = '2012-03-01 18:00:00';
-- Fill in the date parts and intervals as needed
SELECT
	DATEADD(DAY, -1, @PostLeapDay) AS PriorDay,
	DATEADD(DAY, 1, @PostLeapDay) AS NextDay,
	DATEADD(YEAR, -4, @PostLeapDay) AS PriorLeapYear,
	DATEADD(YEAR, 4, @PostLeapDay) AS NextLeapYear,
	DATEADD(YEAR, -1, @PostLeapDay) AS PriorYear,
    -- Move 4 years forward and one day back
	DATEADD(DAY, -1, DATEADD(YEAR, 4, @PostLeapDay)) AS NextLeapDay,
  DATEADD(DAY, -2, @PostLeapDay) AS TwoDaysAgo;
    
--Taking TwoDaysAgo from the prior step, use the DATEDIFF() function to test how it handles leap years.
DECLARE
	@PostLeapDay DATETIME2(7) = '2012-03-01 18:00:00',
    @TwoDaysAgo DATETIME2(7);
SELECT
	@TwoDaysAgo = DATEADD(DAY, -2, @PostLeapDay);
SELECT
	@TwoDaysAgo AS TwoDaysAgo,
	@PostLeapDay AS SomeTime,
    -- Fill in the appropriate function and date types
	DATEDIFF(DAY, @TwoDaysAgo, @PostLeapDay) AS DaysDifference,
	DATEDIFF(HOUR, @TwoDaysAgo, @PostLeapDay) AS HoursDifference,
	DATEDIFF(MINUTE, @TwoDaysAgo, @PostLeapDay) AS MinutesDifference;
  
--Use DATEADD() and DATEDIFF() in conjunction with date parts to round down our time to the day, hour, and minute.
DECLARE
	@SomeTime DATETIME2(7) = '2018-06-14 16:29:36.2248991';
-- Fill in the appropriate functions and date parts
SELECT
	DATEADD(DAY, DATEDIFF(DAY, 0, @SomeTime), 0) AS RoundedToDay,
	DATEADD(HOUR, DATEDIFF(HOUR, 0, @SomeTime), 0) AS RoundedToHour,
	DATEADD(MINUTE, DATEDIFF(MINUTE, 0, @SomeTime), 0) AS RoundedToMinute;
	
RoundedToDay		RoundedToHour		RoundedToMinute
2018-06-14 00:00:00	2018-06-14 16:00:00	2018-06-14 16:29:00

--









