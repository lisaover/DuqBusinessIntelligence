USE [AdventureWorksDW2012]
GO

SELECT *
FROM DimEmployee

USE [AdventureWorksDW2012]
GO

SELECT TOP 10 (ISNULL(T.FirstName + ' ', '') + ISNULL(T.MiddleName + ' ', '') + COALESCE(T.LastName,'')) as 'Employee Name', 
			T.SalesAmount as 'Sales Amount'
FROM (
	SELECT SUM(fact.SalesAmount) as 'SalesAmount', 
		emp.FirstName as 'FirstName', emp.MiddleName as 'MiddleName', emp.LastName as 'LastName', 
		emp.EmployeeKey as 'Employee Key'
	FROM DimEmployee as emp INNER JOIN
	 FactResellerSales as fact ON emp.EmployeeKey = fact.EmployeeKey INNER JOIN
	 DimDate as dt ON fact.OrderDateKey = dt.DateKey
	WHERE dt.CalendarYear in (2007)                     
	GROUP BY emp.EmployeeKey, emp.LastName, emp.FirstName, emp.MiddleName
	) as T
	ORDER BY 2 DESC
	GO

USE tempdb;
IF OBJECT_ID('#Sales') IS NOT NULL
	DROP TABLE #Sales
	
IF OBJECT_ID('#Emp') IS NOT NULL
	DROP TABLE #Emp

IF OBJECT_ID('#Quota') IS NOT NULL
	DROP TABLE #Quota

IF OBJECT_ID('#EmployeeSales') IS NOT NULL
	DROP TABLE #EmployeeSales

USE [AdventureWorksDW2012]
GO

/* 
Create the #Sales Temporary Table for sales amount
*/
SELECT SUM(fact.SalesAmount) as 'SalesAmount', emp.EmployeeKey as 'EmployeeKey'
	INTO #Sales
	FROM DimEmployee as emp INNER JOIN
	 FactResellerSales as fact ON emp.EmployeeKey = fact.EmployeeKey INNER JOIN
	 DimDate as dt ON fact.OrderDateKey = dt.DateKey
	WHERE dt.CalendarYear in (2007) AND dt.CalendarQuarter in (4)                     
	GROUP BY emp.EmployeeKey

SELECT SUM(fact.SalesAmountQuota) as 'SalesQuota', fact.EmployeeKey as 'EmployeeKey'
	INTO #Quota
	FROM DimEmployee as emp INNER JOIN
	 FactSalesQuota as fact ON emp.EmployeeKey = fact.EmployeeKey INNER JOIN
	 DimDate as dt ON fact.DateKey = dt.DateKey
	WHERE dt.CalendarYear in (2007) AND dt.CalendarQuarter in (4)                    
	GROUP BY fact.EmployeeKey

/* 
Create the #Emp Temporary Table for employee names
*/	
SELECT emp.FirstName as 'FirstName', emp.MiddleName as 'MiddleName', emp.LastName as 'LastName', emp.EmployeeKey as 'EmployeeKey'
INTO #Emp
FROM DimEmployee as emp                 


/* 
Combine the newly created temporary tables into another temporary table to 
show sales amount per employee in 2007.
 */	
SELECT TOP 99.99 PERCENT WITH TIES (ISNULL(#Emp.FirstName + ' ', '') + ISNULL(#Emp.MiddleName + ' ', '') + COALESCE(#Emp.LastName,'')) as 'Employee Name', 
			#Sales.SalesAmount as 'Sales Amount', #Quota.SalesQuota as 'Sales Quota', (#Quota.SalesQuota - #Sales.SalesAmount) as 'Quota to Sales Difference'
INTO #EmployeeSales
FROM #Sales JOIN #Emp ON #Sales.EmployeeKey = #Emp.EmployeeKey JOIN #Quota ON #Sales.EmployeeKey = #Quota.EmployeeKey
ORDER BY 'Quota to Sales Difference'

Select *
FROM #EmployeeSales