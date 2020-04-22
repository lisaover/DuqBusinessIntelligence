USE Northwind;
GO

DECLARE @MyMsg VARCHAR(50);
SELECT @MyMsg = 'Hello World.';
PRINT @MyMsg;
GO

DECLARE @ROWCNT INT;
SELECT @ROWCNT = COUNT(*) FROM Customers;
PRINT @ROWCNT
GO

DECLARE @City VARCHAR(25);
SET @City = 'Boston';
SELECT * FROM Customers WHERE City = @City;
GO

DECLARE @x INT;
SELECT @x=COUNT(*) FROM Customers WHERE City = 'Boston';
IF @x > 0 PRINT 'Found Boston';
GO

IF (SELECT COUNT(*) FROM Customers WHERE City = 'Boston') > 0
	PRINT 'Found Boston';
	GO

IF (SELECT COUNT(*) FROM Customers WHERE City = 'Boston') > 0
BEGIN
	PRINT 'Count of Boston Customers:';
	SELECT COUNT(*) FROM Customers WHERE City = 'Boston';
END;
GO

IF EXISTS(SELECT * FROM Customers WHERE [Last Name] = 'Andersen')
	PRINT 'Need to update customer record Andersen';
ELSE
	PRINT 'Need to add customer record Andersen';
IF EXISTS(SELECT * FROM Customers WHERE [Last Name] = 'Larse')
	PRINT 'Need to update customer record Larse';
ELSE
	PRINT 'Need to add customer record Larse';
GO

IF DB_NAME() = 'Northwind'
	IF OBJECT_ID('Customers') IS NOT NULL
		PRINT 'Table Customers exists';
	ELSE
		PRINT 'Table Custoemrs does not exist';
ELSE
	PRINT 'Not using the Northwind database';

USE [master];
GO

IF DB_ID('MyDB') IS NOT NULL
BEGIN
	PRINT 'Dropping DB';
	ALTER DATABASE MyDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE MyDB;
END;

PRINT 'Creating DB';

CREATE DATABASE MyDB
ON PRIMARY
	(NAME='MyDB', FILENAME='J:\MyDB.mdf') 
LOG ON
	(NAME='MyDB_log', FILENAME='J:\MyDB.ldf')
GO

USE MyDB
GO

IF OBJECT_ID('aTable') IS NOT NULL
	BEGIN
		PRINT 'Deleting aTable';
		DROP TABLE aTable;
	END;

CREATE TABLE aTable (
		aT_Id INT NOT NULL IDENTITY PRIMARY KEY,
		aT_String VARCHAR(50)
		);

IF OBJECT_ID('bTable') IS NOT NULL
	BEGIN
		PRINT 'Deleting aTable';
		DROP TABLE bTable;
	END;

CREATE TABLE bTable (
		bT_Id INT NOT NULL IDENTITY PRIMARY KEY,
		bT_aId INT NULL
		);

ALTER TABLE bTable
ADD CONSTRAINT FK_aT_ID FOREIGN KEY (bT_aId) REFERENCES aTable(aT_Id);
GO

USE Northwind;
GO 

BEGIN TRY
	INSERT Invoices
	VALUES (799, 'ZXK-799', '2008-07-01', 299.95)
	PRINT 'SUCCESS: Record was inserted.'
END TRY
BEGIN CATCH
	PRINT 'FAILURE: Record was not inserted.'
	PRINT 'Error ' + 'CONVERT(varchar, ERROR_NUMBER(), 1)' + ': ' + 'ERROR_MESSGAE()'
END CATCH





 
