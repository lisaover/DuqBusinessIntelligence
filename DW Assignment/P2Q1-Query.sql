USE [AdventureWorksDW2012]
GO

SELECT promo.EnglishPromotionName as Promotion, SUM(SalesAmount) as TotalSales
/*
INNER JOINS: FactResellerSales/DimPromotion
GROUP BY: promo.EnglishPromotionName
ORDER BY: SalesAmount descending
*/
FROM FactResellerSales as fact INNER JOIN
		DimPromotion as promo ON fact.PromotionKey = promo.PromotionKey 

WHERE promo.EnglishPromotionCategory = 'Reseller' AND 
		(promo.EnglishPromotionType <> 'No Discount' 
		AND promo.EnglishPromotionType NOT LIKE 'Volume Discount%') AND
		YEAR(fact.OrderDate) BETWEEN '2005' AND '2008'

GROUP BY promo.EnglishPromotionName

ORDER BY 2 DESC