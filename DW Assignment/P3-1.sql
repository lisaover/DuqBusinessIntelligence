USE [AdventureWorksDW2012]
GO

SELECT TOP 10 ((Y2.Sales - Y1.Sales)/Y1.Sales)*100 as 'Percentage Increase', Y1.Category
FROM (
	SELECT sum(fact.UnitPrice*fact.OrderQuantity) as 'Sales', sub.EnglishProductSubcategoryName as 'Category'
	FROM DimProductCategory as cat INNER JOIN
                         DimProductSubcategory as sub ON cat.ProductCategoryKey = sub.ProductCategoryKey INNER JOIN
                         DimProduct as prod ON sub.ProductSubcategoryKey = prod.ProductSubcategoryKey INNER JOIN
                         FactResellerSales as fact ON prod.ProductKey = fact.ProductKey INNER JOIN
						 DimDate as dt ON fact.OrderDateKey = dt.DateKey
	WHERE dt.CalendarYear in (2006)                     
	GROUP BY sub.EnglishProductSubcategoryName
) as Y1 INNER JOIN (
	SELECT sum(fact.UnitPrice*fact.OrderQuantity) as 'Sales', sub.EnglishProductSubcategoryName as 'Category'
	FROM DimProductCategory as cat INNER JOIN
                         DimProductSubcategory as sub ON cat.ProductCategoryKey = sub.ProductCategoryKey INNER JOIN
                         DimProduct as prod ON sub.ProductSubcategoryKey = prod.ProductSubcategoryKey INNER JOIN
                         FactResellerSales as fact ON prod.ProductKey = fact.ProductKey INNER JOIN
						 DimDate as dt ON fact.OrderDateKey = dt.DateKey
	WHERE cat.EnglishProductCategoryName = 'Bikes' AND dt.CalendarYear in (2007)                     
	GROUP BY sub.EnglishProductSubcategoryName
) as Y2 ON Y1.Category = Y2.Category
ORDER BY 'Percentage Increase' DESC

USE [AdventureWorksDW2012]
GO

SELECT TOP 10 (Y2.Quantity - Y1.Quantity) as 'Quantity Difference', Y1.Category
FROM (
	SELECT sum(fact.OrderQuantity) as 'Quantity', sub.EnglishProductSubcategoryName as 'Category'
	FROM DimProductCategory as cat INNER JOIN
                         DimProductSubcategory as sub ON cat.ProductCategoryKey = sub.ProductCategoryKey INNER JOIN
                         DimProduct as prod ON sub.ProductSubcategoryKey = prod.ProductSubcategoryKey INNER JOIN
                         FactResellerSales as fact ON prod.ProductKey = fact.ProductKey INNER JOIN
						 DimDate as dt ON fact.OrderDateKey = dt.DateKey
	WHERE dt.CalendarYear in ( 2006)                     
	GROUP BY sub.EnglishProductSubcategoryName
) as Y1 INNER JOIN (
	SELECT sum(fact.OrderQuantity) as 'Quantity', sub.EnglishProductSubcategoryName as 'Category'
	FROM DimProductCategory as cat INNER JOIN
                         DimProductSubcategory as sub ON cat.ProductCategoryKey = sub.ProductCategoryKey INNER JOIN
                         DimProduct as prod ON sub.ProductSubcategoryKey = prod.ProductSubcategoryKey INNER JOIN
                         FactResellerSales as fact ON prod.ProductKey = fact.ProductKey INNER JOIN
						 DimDate as dt ON fact.OrderDateKey = dt.DateKey
	WHERE cat.EnglishProductCategoryName = 'Bikes' AND dt.CalendarYear in ( 2007)                     
	GROUP BY sub.EnglishProductSubcategoryName
) as Y2 ON Y1.Category = Y2.Category
ORDER BY 'Quantity Difference' DESC

USE tempdb;
IF OBJECT_ID('#Y1') IS NOT NULL
	DROP TABLE #Y1
	
IF OBJECT_ID('#Y2') IS NOT NULL
	DROP TABLE #Y2

IF OBJECT_ID('#Y3') IS NOT NULL
	DROP TABLE #Y3

USE [AdventureWorksDW2012]
GO

/* 
Create two Temporary Tables #Y1 and #Y2 to hold the quantity of bikes sold in each subcategory for the 
specified years - one table for each year.

Create the #Y1 Temporary Table for 2006
*/
SELECT sum(fact.OrderQuantity) as 'Quantity', sub.EnglishProductSubcategoryName as 'Category'
INTO #Y1
FROM DimProductCategory as cat INNER JOIN
                         DimProductSubcategory as sub ON cat.ProductCategoryKey = sub.ProductCategoryKey INNER JOIN
                         DimProduct as prod ON sub.ProductSubcategoryKey = prod.ProductSubcategoryKey INNER JOIN
                         FactResellerSales as fact ON prod.ProductKey = fact.ProductKey INNER JOIN
						 DimDate as dt ON fact.OrderDateKey = dt.DateKey
	WHERE cat.EnglishProductCategoryName = 'Bikes' AND dt.CalendarYear in (2006)                     
	GROUP BY sub.EnglishProductSubcategoryName

/* 
Create the #Y2 Temporary Table for 2007
*/	
SELECT sum(fact.OrderQuantity) as 'Quantity', sub.EnglishProductSubcategoryName as 'Category'
INTO #Y2
FROM DimProductCategory as cat INNER JOIN
                         DimProductSubcategory as sub ON cat.ProductCategoryKey = sub.ProductCategoryKey INNER JOIN
                         DimProduct as prod ON sub.ProductSubcategoryKey = prod.ProductSubcategoryKey INNER JOIN
                         FactResellerSales as fact ON prod.ProductKey = fact.ProductKey INNER JOIN
						 DimDate as dt ON fact.OrderDateKey = dt.DateKey
	WHERE cat.EnglishProductCategoryName = 'Bikes' AND dt.CalendarYear in (2007)                     
	GROUP BY sub.EnglishProductSubcategoryName


/* 
Combine the newly created temporary tables into another temporary table to 
compare the difference in quantity of bikes sold by category and year.
 */	
SELECT #Y1.Category as 'Bike Category', #Y1.Quantity as 'Quantity 2006', 
	#Y2.Quantity as 'Quantity 2007', (#Y2.Quantity - #Y1.Quantity) as 'Qty Difference'
INTO #Y3
FROM #Y1 INNER JOIN #Y2 ON #Y1.Category = #Y2.Category
ORDER BY 'Bike Category'

Select *
FROM #Y3