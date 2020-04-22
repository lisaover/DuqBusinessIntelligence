USE [AdventureWorksDW2012]
GO

IF OBJECT_ID('DimCustomer2') IS NOT NULL
	DROP TABLE DimCustomer2;

CREATE TABLE [dbo].[DimCustomer2](
	[CustomerKey] [int] IDENTITY(1,1) NOT NULL,
	[CustomerAlternateKey] [nvarchar](15) NOT NULL,
	[Title] [nvarchar](8) NULL,
	[FirstName] [nvarchar](50) NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[NameStyle] [bit] NULL,
	[BirthDate] [date] NULL,
	[MaritalStatus] [nchar](1) NULL,
	[Suffix] [nvarchar](10) NULL,
	[Gender] [nvarchar](1) NULL,
	[EmailAddress] [nvarchar](50) NULL,
	[YearlyIncome] [money] NULL,
	[TotalChildren] [tinyint] NULL,
	[NumberChildrenAtHome] [tinyint] NULL,
	[EnglishEducation] [nvarchar](40) NULL,
	[SpanishEducation] [nvarchar](40) NULL,
	[FrenchEducation] [nvarchar](40) NULL,
	[EnglishOccupation] [nvarchar](100) NULL,
	[SpanishOccupation] [nvarchar](100) NULL,
	[FrenchOccupation] [nvarchar](100) NULL,
	[HouseOwnerFlag] [nchar](1) NULL,
	[NumberCarsOwned] [tinyint] NULL,
	[AddressLine1] [nvarchar](120) NULL,
	[AddressLine2] [nvarchar](120) NULL,
	[Phone] [nvarchar](20) NULL,
	[DateFirstPurchase] [date] NULL,
	[CommuteDistance] [nvarchar](15) NULL,
	[City] [nvarchar](30) NULL,
	[StateProvinceCode] [nvarchar](3) NULL,
	[StateProvinceName] [nvarchar](50) NULL,
	[CountryRegionCode] [nvarchar](3) NULL,
	[EnglishCountryRegionName] [nvarchar](50) NULL,
	[SpanishCountryRegionName] [nvarchar](50) NULL,
	[FrenchCountryRegionName] [nvarchar](50) NULL,
	[PostalCode] [nvarchar](15) NULL,
	[IpAddressLocator] [nvarchar](15) NULL,
	[SalesTerritoryRegion] [nvarchar](50) NOT NULL,
	[SalesTerritoryCountry] [nvarchar](50) NOT NULL,
	[SalesTerritoryGroup] [nvarchar](50) NULL
	);

SET IDENTITY_INSERT DimCustomer2 ON

INSERT INTO DimCustomer2
(
	[CustomerKey],
	[CustomerAlternateKey],
	[Title],
	[FirstName],
	[MiddleName],
	[LastName],
	[NameStyle],
	[BirthDate],
	[MaritalStatus],
	[Suffix],
	[Gender],
	[EmailAddress],
	[YearlyIncome],
	[TotalChildren],
	[NumberChildrenAtHome],
	[EnglishEducation],
	[SpanishEducation],
	[FrenchEducation],
	[EnglishOccupation],
	[SpanishOccupation],
	[FrenchOccupation],
	[HouseOwnerFlag],
	[NumberCarsOwned],
	[AddressLine1],
	[AddressLine2],
	[Phone],
	[DateFirstPurchase],
	[CommuteDistance],
	[City],
	[StateProvinceCode],
	[StateProvinceName],
	[CountryRegionCode],
	[EnglishCountryRegionName],
	[SpanishCountryRegionName],
	[FrenchCountryRegionName],
	[PostalCode],
	[IpAddressLocator],
	[SalesTerritoryRegion],
	[SalesTerritoryCountry],
	[SalesTerritoryGroup]
	)

SELECT DimCustomer.CustomerKey,
	DimCustomer.CustomerAlternateKey,
	DimCustomer.Title,
	DimCustomer.FirstName,
	DimCustomer.MiddleName,
	DimCustomer.LastName,
	DimCustomer.NameStyle,
	DimCustomer.BirthDate,
	DimCustomer.MaritalStatus,
	DimCustomer.Suffix,
	DimCustomer.Gender,
	DimCustomer.EmailAddress,
	DimCustomer.YearlyIncome,
	DimCustomer.TotalChildren,
	DimCustomer.NumberChildrenAtHome,
	DimCustomer.EnglishEducation,
	DimCustomer.SpanishEducation,
	DimCustomer.FrenchEducation,
	DimCustomer.EnglishOccupation,
	DimCustomer.SpanishOccupation,
	DimCustomer.FrenchOccupation,
	DimCustomer.HouseOwnerFlag,
	DimCustomer.NumberCarsOwned,
	DimCustomer.AddressLine1,
	DimCustomer.AddressLine2,
	DimCustomer.Phone,
	DimCustomer.DateFirstPurchase,
	DimCustomer.CommuteDistance,
	DimGeography.City,
	DimGeography.StateProvinceCode,
	DimGeography.StateProvinceName,
	DimGeography.CountryRegionCode,
	DimGeography.EnglishCountryRegionName,
	DimGeography.SpanishCountryRegionName,
	DimGeography.FrenchCountryRegionName,
	DimGeography.PostalCode,
	DimGeography.IpAddressLocator,
	DimSalesTerritory.SalesTerritoryRegion,
	DimSalesTerritory.SalesTerritoryCountry,
	DimSalesTerritory.SalesTerritoryGroup

FROM DimCustomer INNER JOIN
		DimGeography ON DimCustomer.GeographyKey = DimGeography.GeographyKey INNER JOIN
        DimSalesTerritory ON DimGeography.SalesTerritoryKey = DimSalesTerritory.SalesTerritoryKey
