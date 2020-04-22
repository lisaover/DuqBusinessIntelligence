
USE DW;
GO

/* Question 1 -
 * What are the top 10 zip codes in which have we achieved the most Internet sales dollar penetration?
 */
SELECT top 10 sum(fact.Price*fact.OrderQty) as 'Sales Penetration', cust.PostalCode as 'Zip Codes'
FROM FactStoreSales as fact INNER JOIN
	DimCustomer as cust ON fact.CustomerID = cust.CustomerID 
GROUP BY cust.PostalCode
ORDER BY 'Sales Penetration' DESC

GO


/* Question 2 -
 * Which of those zip codes has experienced the greatest percentage increase in sales between 2010 and 2012?
 * Why is this "hard"?  Because we need to use data from the same table in 2 diffent time frames.
 * Think of it this way, when looking at any fact row it cannot simultaneously be from 2010 and 2012. 
 * So, I cannot calculate a % change row by row I have to essentially create 2 tables - a 2010 
 * table and a 2012 table.  
 * Use a derived table approach.
 */
SELECT TOP 10 ((Y12.Sales - Y10.Sales)/Y10.Sales)*100 as 'Percentage Increase', Y10.Zip
FROM (
	SELECT sum(fact.Price*fact.OrderQty) as 'Sales', cust.PostalCode as 'Zip'
	FROM FactStoreSales as fact INNER JOIN
	DimCustomer as cust ON fact.CustomerID = cust.CustomerID INNER JOIN
	DimDate as dt ON dt.DateKey = fact.OrderDateKey
	WHERE dt.CalendarYear in ( 2010)                     
	GROUP BY cust.PostalCode
) as Y10 INNER JOIN (
	SELECT sum(fact.Price*fact.OrderQty) as 'Sales', cust.PostalCode as 'Zip'
	FROM FactStoreSales as fact INNER JOIN
	DimCustomer as cust ON fact.CustomerID = cust.CustomerID INNER JOIN
	DimDate as dt ON dt.DateKey = fact.OrderDateKey
	WHERE dt.CalendarYear in ( 2012)                     
	GROUP BY cust.PostalCode
) as Y12 ON Y10.Zip = Y12.Zip
ORDER BY 'Percentage Increase' DESC

GO

/* A common table expression (CTE) can be thought of as a temporary 
 * result set that is defined within the execution scope of a single 
 * SELECT, INSERT, UPDATE, DELETE, or CREATE VIEW statement. A CTE is 
 * similar to a derived table in that it is not stored as an object and lasts 
 * only for the duration of the query. Unlike a derived table, a CTE can be 
 * self-referencing and can be referenced multiple times in the same query.
 * CTEs were invented with temporal SQL problems in mind!
 */

 WITH Y10 AS 
 (
 	SELECT sum(fact.Price*fact.OrderQty) as 'Sales', cust.PostalCode as 'Zip'
	FROM FactStoreSales as fact INNER JOIN
	DimCustomer as cust ON fact.CustomerID = cust.CustomerID INNER JOIN
	DimDate as dt ON dt.DateKey = fact.OrderDateKey
	WHERE dt.CalendarYear in ( 2010)                     
	GROUP BY cust.PostalCode
 ), 
 Y12 AS
 (
 	SELECT sum(fact.Price*fact.OrderQty) as 'Sales', cust.PostalCode as 'Zip'
	FROM FactStoreSales as fact INNER JOIN
	DimCustomer as cust ON fact.CustomerID = cust.CustomerID INNER JOIN
	DimDate as dt ON dt.DateKey = fact.OrderDateKey
	WHERE dt.CalendarYear in (2012)                     
	GROUP BY cust.PostalCode
)

SELECT TOP 10 ((Y12.Sales - Y10.Sales)/Y10.Sales)*100 as 'Percentage Increase', Y10.Zip
FROM Y10 INNER JOIN Y12 ON Y10.Zip = Y12.Zip
ORDER BY 'Percentage Increase' DESC;

GO


/* Below is the solution for Query 2 that leverages some
 * of what we learned about T-SLQ scripting in a previous lab.
 * 
 * If you want to know more about SQL "temporary" tables used in this
 * solution, review the T-SQL Basics_Part3.pdf PDF file from the last lab.
 */
 
/* Drop previously created temporary tables if they exist
 */
USE tempdb;
IF OBJECT_ID('#Y10') IS NOT NULL
	DROP TABLE #Y10
	
IF OBJECT_ID('#Y12') IS NOT NULL
	DROP TABLE #Y12

GO

USE DW;

/* Create a Y10 Temporary Table */
SELECT sum(fact.Price*fact.OrderQty) as 'Sales', cust.PostalCode as 'Zip'
INTO #Y10
FROM FactStoreSales as fact INNER JOIN
	DimCustomer as cust ON fact.CustomerID = cust.CustomerID INNER JOIN
	DimDate as dt ON dt.DateKey = fact.OrderDateKey
	WHERE dt.CalendarYear in ( 2010 )                     
	GROUP BY cust.PostalCode

/* Create a Y12 Temporary Table */	
SELECT sum(fact.Price*fact.OrderQty) as 'Sales', cust.PostalCode as 'Zip'
INTO #Y12
FROM FactStoreSales as fact INNER JOIN
	DimCustomer as cust ON fact.CustomerID = cust.CustomerID INNER JOIN
	DimDate as dt ON dt.DateKey = fact.OrderDateKey
	WHERE dt.CalendarYear in ( 2012 )                     
	GROUP BY cust.PostalCode


/* Join the newly created temporary tables.
 */	
SELECT TOP 10 ((#Y12.Sales - #Y10.Sales)/#Y10.Sales)*100 as 'Percentage Increase', #Y10.Zip
FROM #Y10 INNER JOIN #Y12 ON #Y10.Zip = #Y12.Zip
ORDER BY 'Percentage Increase' DESC

/* The answers are the same from either methods - as one would hope!
 */
