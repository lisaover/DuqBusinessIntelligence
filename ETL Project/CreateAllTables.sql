USE BI_Project_DW
GO

/****** Object:  Table [dbo].[Product]    Script Date: 3/26/2015 6:23:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*CREATE ALL EMPTY TABLES IF IT DOES NOT EXIST */
IF OBJECT_ID('DimCustomer') IS NULL

	CREATE TABLE [dbo].[DimCustomer](
		[CustomerID] INT PRIMARY KEY IDENTITY ( 1, 1 ),
		[CustomerID_OLTP] [int] NOT NULL,
		[Title] [nvarchar](8) NULL,
		[FirstName] [nvarchar](50) NOT NULL,
		[MiddleName] [nvarchar](50) NULL,
		[LastName] [nvarchar](50) NOT NULL,
		[Suffix] [nvarchar](10) NULL,
		[BirthDate] [date] NULL,
		[MaritalStatus] [nchar](1) NULL,
		[Gender] [nvarchar](1) NULL,
		[YearlyIncome] [money] NULL,
		[TotalChildren] [tinyint] NULL,
		[NumberChildrenAtHome] [tinyint] NULL,
		[Education] [nvarchar](40) NULL,
		[Occupation] [nvarchar](100) NULL,
		[HouseOwnerFlag] [nchar](1) NULL,
		[NumberCarsOwned] [tinyint] NULL,
		[CommuteDistance] [nvarchar](15) NULL,
		[AddressLine1] [nvarchar](60) NULL,
		[AddressLine2] [nvarchar](60) NULL,
		[City] [nvarchar](30) NULL,
		[PostalCode] [nvarchar](15) NULL,
		[StateName] [nvarchar](50) NULL,
		[CountryCode] [nvarchar](3) NULL,
		[EmailAddress] [nvarchar](50) NULL,
		[HomePhoneNumber] [nvarchar](25) NULL,
		[CellPhoneNumber] [nvarchar](25) NULL,
		[PrimarySalesReason] [nvarchar](25) NULL,
		[SecondarySalesReason] [nvarchar](25) NULL,
	)
ELSE 
	PRINT 'DimCustomer TABLE Exist Already'

IF OBJECT_ID('DimStore') IS NULL

	CREATE TABLE [dbo].[DimStore](
		[StoreID] INT PRIMARY KEY IDENTITY ( 1, 1 ),
		[StoreID_OTLP] [int] NULL,
		[ManagersLastName] [nchar](50) NOT NULL,
		[StoreDescription] [nchar](50) NOT NULL,
		[RegionDescription] [nchar](50) NOT NULL,
	)
ELSE 
	PRINT 'DimStore TABLE Exist Already'

IF OBJECT_ID('DimSalesPerson') IS NULL

	CREATE TABLE [dbo].[DimSalesPerson](
		[SalesPersonID] INT PRIMARY KEY IDENTITY ( 1, 1 ),
		[SalesPersonID_OLTP] [int] NULL,
		[Title] [nvarchar](8) NULL,
		[FirstName] [nvarchar](50) NOT NULL,
		[MiddleName] [nvarchar](50) NULL,
		[LastName] [nvarchar](50) NOT NULL,
		[AddressLine1] [nvarchar](60) NOT NULL,
		[AddressLine2] [nvarchar](60) NULL,
		[City] [nvarchar](30) NOT NULL,
		[PostalCode] [nvarchar](15) NOT NULL,
		[State] [nchar](3) NOT NULL,
		[HomePhone] [nvarchar](25) NOT NULL,
		[BirthDate] [date] NOT NULL,
		[HireDate] [date] NOT NULL,
		[Gender] [nchar](1) NOT NULL,
		[MaritalStatus] [nchar](1) NOT NULL,
		[SalariedFlag] [bit] NOT NULL,
		[CurrentFlag] [bit] NOT NULL,
		[ReportsTo] [nvarchar](60) NOT NULL,
		[StoreID] [nvarchar](60) NOT NULL,
	)

IF OBJECT_ID('DimDate') IS NULL

	CREATE TABLE [dbo].[DimDate](
		[DateKey] INT PRIMARY KEY IDENTITY ( 1, 1 ) NOT NULL,
		[FullDate] [date] NOT NULL,
		[DayOfWeek] [tinyint] NOT NULL,
		[DayNameOfWeek] [nvarchar](10) NOT NULL,
		[DayOfMonth] [tinyint] NOT NULL,
		[MonthName] [nvarchar](10) NOT NULL,
		[MonthOfYear] [tinyint] NOT NULL,
		[CalendarQuarter] [tinyint] NOT NULL,
		[CalendarYear] [smallint] NOT NULL,
		[Season] [nvarchar](10) NOT NULL,
		[xmasFlag] [tinyint] NOT NULL,
		[IndepDayFlag] [smallint] NOT NULL,
		[NewYrsFlag] [tinyint] NOT NULL,
	)
ELSE 
	PRINT 'DimDate TABLE Exist Already'

IF OBJECT_ID('DimProduct') IS NULL

	CREATE TABLE [dbo].[DimProduct](
		[ProductID] INT PRIMARY KEY IDENTITY (1,1),
		[ProductID_OLTP] [int]  NOT NULL,
		[Name] [nvarchar](50) NOT NULL,
		[ProductNumber] [nvarchar](25) NOT NULL,
		[MakeFlag] [bit] NOT NULL,
		[FinishedGoodsFlag] [bit] NOT NULL,
		[Color] [nvarchar](15) NULL,
		[SafetyStockLevel] [smallint] NOT NULL,
		[ReorderPoint] [smallint] NOT NULL,
		[StandardCost] [money] NOT NULL,
		[ListPrice] [money] NOT NULL,
		[Size] [nvarchar](5) NULL,
		[SizeUnitMeasureCode] [nchar](3) NULL,
		[WeightUnitMeasureCode] [nchar](3) NULL,
		[Weight] [decimal](8, 2) NULL,
		[DaysToManufacture] [int] NOT NULL,
		[SellStartDate] [datetime] NOT NULL,
		[DiscontinuedDate] [datetime] NULL,
		[SubCategoryName] [nvarchar](50) NULL,
		[CategoryName] [nvarchar](50) NULL
	
	 )
ELSE 
	PRINT 'DimProduct TABLE Exist Already'

IF OBJECT_ID('FactStoreSales') IS NULL

	CREATE TABLE [dbo].FactStoreSales(
		[OrderDateKey] [int] FOREIGN KEY REFERENCES DimDate(DateKey)NOT NULL,
		[CustomerID] [int] FOREIGN KEY REFERENCES DimCustomer(CustomerID),
		[SalesPersonID] [int] FOREIGN KEY REFERENCES DimSalesperson(SalesPersonID),
		[StoreID] [int] FOREIGN KEY REFERENCES DimStore(StoreID),
		[ProductID] [int] FOREIGN KEY REFERENCES DimProduct(ProductID),
		[SalesOrderNumber] [nvarchar](25) NOT NULL,
		[OnlineOrderFlag] [bit] NOT NULL,
		[Freight] [money] NOT NULL,
		[TaxAmt] [money] NOT NULL,
		[OrderQty] [smallint] NOT NULL,
		[UnitPrice] [money] NOT NULL,
		[ExtendedPrice] [money] NOT NULL
	 )
ELSE 
	PRINT 'FactStoreSales TABLE Exist Already'