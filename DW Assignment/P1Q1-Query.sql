SELECT cust.Gender, COUNT(*) as Purchases
/*
INNER JOINS: FactInternetSales/DimProduct, DimProduct/DimProductSubcategory,
				FactInternetSales/DimCustomer
GROUP BY: Gender 
ORDER BY: Gender ascending (F first)
*/
FROM FactInternetSales as fact INNER JOIN
		DimProduct as prod ON fact.ProductKey = prod.ProductKey INNER JOIN
		DimProductSubcategory as subcat ON prod.ProductSubcategoryKey = subcat.ProductSubcategoryKey INNER JOIN
		DimCustomer as cust ON fact.CustomerKey = cust.CustomerKey

WHERE subcat.EnglishProductSubcategoryName LIKE 'Jerseys'
GROUP BY cust.Gender
ORDER BY 1