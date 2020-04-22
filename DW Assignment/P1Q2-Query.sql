SELECT dt.CalendarYear, cust.Gender, COUNT(*) as Purchases
/*
INNER JOINS: FactInternetSales/DimProduct, DimProduct/DimProductSubcategory,
				FactInternetSales/DimCustomer, FactInternetSales/DimDate
GROUP BY: first CalendarYear then Gender
ORDER BY: first CalendarYear ascending then Gender descending (M first)
*/
FROM FactInternetSales as fact INNER JOIN
		DimProduct as prod ON fact.ProductKey = prod.ProductKey INNER JOIN
		DimProductSubcategory as subcat ON prod.ProductSubcategoryKey = subcat.ProductSubcategoryKey INNER JOIN
		DimCustomer as cust ON fact.CustomerKey = cust.CustomerKey INNER JOIN
		DimDate as dt ON fact.OrderDateKey = dt.DateKey 

WHERE subcat.EnglishProductSubcategoryName LIKE 'Jerseys'
GROUP BY dt.CalendarYear, cust.Gender
ORDER BY 1, 2 DESC 