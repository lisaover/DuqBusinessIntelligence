SELECT ProductKey, EnglishProductName
FROM DimProduct
WHERE ProductKey NOT IN (
		SELECT distinct f.ProductKey
		FROM FactInternetSales as f INNER JOIN DimDate as dt ON f.OrderDateKey = dt.DateKey
		WHERE dt.CalendarYear=2007
		)

BEGIN TRY
INSERT INTO DimProduct(ProductKey)
VALUES (1)
PRINT 'SUCCESS: Record was inserted.'
END TRY
BEGIN CATCH
PRINT 'FAILURE: Record was not inserted.'
PRINT 'Error ' + CONVERT(varchar, ERROR_NUMBER(), 1)
+ ': ' + ERROR_MESSAGE()
END CATCH