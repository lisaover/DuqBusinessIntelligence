USE tempdb;
GO

IF OBJECT_ID('#DimCustomer') IS NOT NULL
	DROP TABLE #DimCustomer;

CREATE TABLE #DimCustomer (
	[CustomerID] [int] NOT NULL,
	[Title] [nvarchar](8) NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[AddressLine1] [nvarchar](60) NOT NULL,
	[AddressLine2] [nvarchar](60) NULL,
	[City] [nvarchar](30) NOT NULL,
	[StateProvince] [nvarchar](50) NOT NULL,
	[CountryRegion] [nvarchar](50) NOT NULL,
	[PostalCode] [nvarchar](15) NOT NULL,
	[EmailAddress] [nvarchar](50) NULL,
	[CellPhoneNumber] [nvarchar](25) NOT NULL
);

USE AdventureWorks2012;
GO

INSERT INTO #DimCustomer
(
	[CustomerID],
	[Title],
	[FirstName],
	[MiddleName],
	[LastName],
	[AddressLine1],
	[AddressLine2],
	[City],
	[StateProvince],
	[CountryRegion],
	[PostalCode],
	[EmailAddress],
	[CellPhoneNumber]
)

SELECT
	Sales.Customer.CustomerID,
	Person.Person.Title, 
	Person.Person.FirstName, 
	Person.Person.MiddleName, 
	Person.Person.LastName, 
	Person.Address.AddressLine1, 
	Person.Address.AddressLine2, 
	Person.Address.City,
	Person.StateProvince.Name AS StateName,
	Person.CountryRegion.Name AS Country,
	Person.Address.PostalCode,
	Person.EmailAddress.EmailAddress,
	Person.PersonPhone.PhoneNumber AS CellPhoneNumber

FROM	Sales.Customer
	INNER JOIN Person.Person ON Sales.Customer.PersonID = Person.Person.BusinessEntityID 
	INNER JOIN Person.EmailAddress ON Person.Person.BusinessEntityID = Person.EmailAddress.BusinessEntityID 
	INNER JOIN Person.BusinessEntity ON Person.Person.BusinessEntityID = Person.BusinessEntity.BusinessEntityID 
	INNER JOIN Person.BusinessEntityAddress ON Person.BusinessEntity.BusinessEntityID = Person.BusinessEntityAddress.BusinessEntityID 
	INNER JOIN Person.Address ON Person.BusinessEntityAddress.AddressID = Person.Address.AddressID 
	INNER JOIN Person.AddressType ON Person.BusinessEntityAddress.AddressTypeID = Person.AddressType.AddressTypeID 
	INNER JOIN Person.StateProvince ON Person.Address.StateProvinceID = Person.StateProvince.StateProvinceID 
	INNER JOIN Person.CountryRegion ON Person.StateProvince.CountryRegionCode = Person.CountryRegion.CountryRegionCode 
	INNER JOIN Person.PersonPhone ON Person.Person.BusinessEntityID = Person.PersonPhone.BusinessEntityID 
	INNER JOIN Person.PhoneNumberType ON Person.PersonPhone.PhoneNumberTypeID = Person.PhoneNumberType.PhoneNumberTypeID
WHERE
	Person.AddressType.Name = 'Home'
	AND 
	Person.PhoneNumberType.Name = 'Cell'
;


SELECT * FROM #DimCustomer;