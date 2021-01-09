/****** Object:  Database ist722_hhkhan_oc1_dw    Script Date: 12/14/2020 6:01:50 PM ******/
/*
Kimball Group, The Microsoft Data Warehouse Toolkit
Generate a database from the datamodel worksheet, version: 4

You can use this Excel workbook as a data modeling tool during the logical design phase of your project.
As discussed in the book, it is in some ways preferable to a real data modeling tool during the inital design.
We expect you to move away from this spreadsheet and into a real modeling tool during the physical design phase.
The authors provide this macro so that the spreadsheet isn't a dead-end. You can 'import' into your
data modeling tool by generating a database using this script, then reverse-engineering that database into
your tool.

Uncomment the next lines if you want to drop and create the database
*/
/*
DROP DATABASE ist722_hhkhan_oc1_dw
GO
CREATE DATABASE ist722_hhkhan_oc1_dw
GO
ALTER DATABASE ist722_hhkhan_oc1_dw
SET RECOVERY SIMPLE
GO
*/
USE ist722_hhkhan_oc1_dw
;
IF EXISTS (SELECT Name from sys.extended_properties where Name = 'Description')
    EXEC sys.sp_dropextendedproperty @name = 'Description'
EXEC sys.sp_addextendedproperty @name = 'Description', @value = 'Default description - you should change this.'
;





-- Create a schema to hold user views (set schema name on home page of workbook).
-- It would be good to do this only if the schema doesn't exist already.
GO
/*CREATE SCHEMA fudgemix
GO
*/


/* Drop table fudgemix.FactOrderFulfillment */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemix.FactOrderFulfillment') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemix.FactOrderFulfillment 
/* Drop table fudgemix.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemix.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemix.DimDate 
/* Drop table fudgemix.DimCustomer */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemix.DimCustomer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemix.DimCustomer 
/* Drop table fudgemix.DimProduct */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemix.DimProduct') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemix.DimProduct 
;

/* Create table fudgemix.DimProduct */
CREATE TABLE fudgemix.DimProduct (
   [ProductKey]  int IDENTITY  NOT NULL
,  [ProductID]  nvarchar(50)   NOT NULL
,  [ProductName]  nvarchar(200)   NOT NULL
,  [isAvailable]  nvarchar(1) null
,  [CategoryName]  nvarchar(20)   NULL
,  [RowIsCurrent]  nchar(1)  NULL
,  [RowStartDate]  datetime   NULL
,  [RowEndDate]  datetime  NULL
,  [RowChangeReason]  nvarchar(200)  NULL
, CONSTRAINT [PK_fudgemix.DimProduct] PRIMARY KEY CLUSTERED 
( [ProductKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT fudgemix.DimProduct ON
;
INSERT INTO fudgemix.DimProduct (ProductKey, ProductID, ProductName, isAvailable, CategoryName, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, '-1', 'Unk Attr', '0', 'Unk Atr', 'Y', '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT fudgemix.DimProduct OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgemix].[Product]'))
DROP VIEW [fudgemix].[Product]
GO
CREATE VIEW [fudgemix].[Product] AS 
SELECT [ProductKey] AS [ProductKey]
, [ProductID] AS [ProductID]
, [ProductName] AS [ProductName]
, [isAvailable] AS [isAvailable]
, [CategoryName] AS [CategoryName]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM fudgemix.DimProduct
GO




/* Drop table fudgemix.DimCustomer */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemix.DimCustomer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemix.DimCustomer 
;

/* Create table fudgemix.DimCustomer */
CREATE TABLE fudgemix.DimCustomer (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [CustomerID]  int   NOT NULL
,  [CustomerName]  nvarchar(101)   NOT NULL
,  [CustomerEmail]  nvarchar(200)   NULL
,  [CustomerAddress]  nvarchar(255)   NULL
,  [CustomerCity]  nvarchar(50)   NULL
,  [CustomerState]  nvarchar(2)  DEFAULT 'NA' NULL
,  [CustomerZipcode]  nvarchar(20)   NULL
,  [RowIsCurrent]  nchar(1)  NULL
,  [RowStartDate]  datetime   NULL
,  [RowEndDate]  datetime  NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_fudgemix.DimCustomer] PRIMARY KEY CLUSTERED 
( [CustomerKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT fudgemix.DimCustomer ON
;
INSERT INTO fudgemix.DimCustomer (CustomerKey, CustomerID, CustomerName, CustomerEmail, CustomerAddress, CustomerCity, CustomerState, CustomerZipcode, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'Unknown Name', 'Unknown Email', 'Unknown Address', 'None', 'NA', 'None', '1', '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT fudgemix.DimCustomer OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgemix].[Customer]'))
DROP VIEW [fudgemix].[Customer]
GO
CREATE VIEW [fudgemix].[Customer] AS 
SELECT [CustomerKey] AS [CustomerKey]
, [CustomerID] AS [CustomerID]
, [CustomerName] AS [CustomerName]
, [CustomerEmail] AS [CustomerEmail]
, [CustomerAddress] AS [CustomerAddress]
, [CustomerCity] AS [CustomerCity]
, [CustomerState] AS [CustomerState]
, [CustomerZipcode] AS [CustomerZipcode]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM fudgemix.DimCustomer
GO




/* Drop table fudgemix.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemix.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemix.DimDate 
;

/* Create table fudgemix.DimDate */
CREATE TABLE fudgemix.DimDate (
   [DateKey]  int   NOT NULL
,  [Date]  datetime   NULL
,  [FullDateUSA]  nchar(11)   NOT NULL
,  [DayOfWeek]  tinyint   NOT NULL
,  [DayName]  nchar(10)   NOT NULL
,  [DayOfMonth]  tinyint   NOT NULL
,  [DayOfYear]  int   NOT NULL
,  [WeekOfYear]  tinyint   NOT NULL
,  [MonthName]  nchar(10)   NOT NULL
,  [MonthOfYear]  tinyint   NOT NULL
,  [Quarter]  tinyint   NOT NULL
,  [QuarterName]  nchar(10)   NOT NULL
,  [Year]  int   NOT NULL
,  [IsWeekday]  varchar(1)  DEFAULT 'N' NOT NULL
, CONSTRAINT [PK_fudgemix.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;

INSERT INTO fudgemix.DimDate (DateKey, Date, FullDateUSA, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsWeekday)
VALUES (-1, null, 'Unk date', 0, 'Unk date', 0, 0, 0, 'Unk month', 0, 0, 'Unk qtr', 0, '?')
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgemix].[Date]'))
DROP VIEW [fudgemix].[Date]
GO
CREATE VIEW [fudgemix].[Date] AS 
SELECT [DateKey] AS [DateKey]
, [Date] AS [Date]
, [FullDateUSA] AS [FullDateUSA]
, [DayOfWeek] AS [DayOfWeek]
, [DayName] AS [DayName]
, [DayOfMonth] AS [DayOfMonth]
, [DayOfYear] AS [DayOfYear]
, [WeekOfYear] AS [WeekOfYear]
, [MonthName] AS [MonthName]
, [MonthOfYear] AS [MonthOfYear]
, [Quarter] AS [Quarter]
, [QuarterName] AS [QuarterName]
, [Year] AS [Year]
, [IsWeekday] AS [IsWeekday]
FROM fudgemix.DimDate
GO




/* Drop table fudgemix.FactOrderFulfillment */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemix.FactOrderFulfillment') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemix.FactOrderFulfillment 
;

/* Create table fudgemix.FactOrderFulfillment */
CREATE TABLE fudgemix.FactOrderFulfillment (
   [ProductKey]  int   NOT NULL
,  [CustomerKey]  int   NOT NULL
,  [ShippedDateKey]  int  NULL
,  [OrderID]  int   NOT NULL
,  [OrderDateKey]  int  NOT NULL
,  [OrderToShippedLagInDays] smallint NULL
, CONSTRAINT [PK_fudgemix.FactOrderFulfillment] PRIMARY KEY NONCLUSTERED 
( [ProductKey], [OrderID] )
) ON [PRIMARY]
;


-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgemix].[Order Fulfillment]'))
DROP VIEW [fudgemix].[Order Fulfillment]
GO
CREATE VIEW [fudgemix].[Order Fulfillment] AS 
SELECT [ProductKey] AS [ProductKey]
, [CustomerKey] AS [CustomerKey]
, [ShippedDateKey] AS [ShippedDateKey]
, [OrderID] AS [OrderID]
, [OrderDateKey] AS [OrderDateKey]
FROM fudgemix.FactOrderFulfillment
GO




/* Drop table fudgemix.DimOrder */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemix.DimOrder') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemix.DimOrder 
;

/* Create table fudgemix.DimOrder */
CREATE TABLE fudgemix.DimOrder (
   [OrderKey]  int IDENTITY  NOT NULL
,  [OrderID]  int   NOT NULL
,  [CustomerID] int NOT NULL
,  [ProductID] nvarchar(50) NOT NULL
,  [OrderDate] datetime NULL
,  [ShippedDate] datetime NULL
,  [RowIsCurrent]  nchar(1)   NULL
,  [RowStartDate]  datetime   NULL
,  [RowEndDate]  datetime  NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_fudgemix.DimOrder] PRIMARY KEY CLUSTERED 
( [OrderKey] )
) ON [PRIMARY]
;


SET IDENTITY_INSERT fudgemix.DimOrder ON
;
INSERT INTO fudgemix.DimOrder (OrderKey, OrderID, CustomerID, ProductID, OrderDate, ShippedDate, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, -1, -1, '12/31/9999', '12/31/9999', 'Y', '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT fudgemix.DimOrder OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgemix].[Order]'))
DROP VIEW [fudgemix].[Order]
GO
CREATE VIEW [fudgemix].[Order] AS 
SELECT [OrderKey] AS [OrderKey]
, [OrderID] AS [OrderID]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM fudgemix.DimOrder
GO

ALTER TABLE fudgemix.FactOrderFulfillment ADD CONSTRAINT
   FK_fudgemix_FactOrderFulfillment_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES fudgemix.DimProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgemix.FactOrderFulfillment ADD CONSTRAINT
   FK_fudgemix_FactOrderFulfillment_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES fudgemix.DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgemix.FactOrderFulfillment ADD CONSTRAINT
   FK_fudgemix_FactOrderFulfillment_ShippedDateKey FOREIGN KEY
   (
   ShippedDateKey
   ) REFERENCES fudgemix.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;

 
ALTER TABLE fudgemix.FactOrderFulfillment ADD CONSTRAINT
   FK_fudgemix_FactOrderFulfillment_OrderDateKey FOREIGN KEY
   (
   OrderDateKey
   ) REFERENCES fudgemix.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
