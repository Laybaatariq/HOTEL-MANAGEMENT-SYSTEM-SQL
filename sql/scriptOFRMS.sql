USE [master]
GO
/****** Object:  Database [RMS]    Script Date: 1/10/2024 9:32:37 AM ******/
CREATE DATABASE [RMS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'RMS', FILENAME = N'C:\SQLDATA\RMS.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'RMS_log', FILENAME = N'C:\SQLDATA\RMS_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [RMS] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [RMS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [RMS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [RMS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [RMS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [RMS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [RMS] SET ARITHABORT OFF 
GO
ALTER DATABASE [RMS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [RMS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [RMS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [RMS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [RMS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [RMS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [RMS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [RMS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [RMS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [RMS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [RMS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [RMS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [RMS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [RMS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [RMS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [RMS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [RMS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [RMS] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [RMS] SET  MULTI_USER 
GO
ALTER DATABASE [RMS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [RMS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [RMS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [RMS] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [RMS] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [RMS] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [RMS] SET QUERY_STORE = ON
GO
ALTER DATABASE [RMS] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [RMS]
GO
/****** Object:  UserDefinedFunction [dbo].[f1]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[f1] (@shift varchar(50))
RETURNS varchar(100)
AS
BEGIN
    DECLARE @femaleCount INT, @maleCount INT,@result varchar(100);

    SELECT
        @femaleCount = COUNT(CASE WHEN Gender = 'Female' THEN 1 END),
        @maleCount = COUNT(CASE WHEN Gender = 'Male' THEN 1 END)
    FROM Emp
    WHERE shift = @shift;

    IF( @femaleCount < @maleCount)
      set @result= ('Need more female staff for '+@shift+' shift')
    ELSE
       set @result = ('Staff is balanced in '+@shift+' shift')
	   return @result
END
GO
/****** Object:  UserDefinedFunction [dbo].[f11]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[f11] (
    @dishID INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @result NVARCHAR(MAX)

    SELECT @result = 
        'Dish Name: ' + m.dishName + CHAR(13) + CHAR(10) +
        'Total Sales: ' + CAST(ISNULL(SUM(o.Quantity), 0) AS NVARCHAR(10)) + CHAR(13) + CHAR(10) +
        'Total Amount: ' + CAST(ISNULL(SUM(o.Quantity * m.price), 0) AS NVARCHAR(10))
   from "order" o inner join EmpCustomerOrder eco
on o.OrderID=eco.OrderID
inner join Menu m
on eco.DishID=m.DishID
        where eco.dishID = @dishID
    GROUP BY
        m.DishName

    RETURN @result
END
GO
/****** Object:  UserDefinedFunction [dbo].[f2]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f2]
(@DishID int)
returns int
as
begin
declare @totalsale int
select @totalsale=SUM(Quantity) 
from "order" o inner join EmpCustomerOrder eco
on o.OrderID=eco.OrderID
inner join Menu m
on eco.DishID=m.DishID
where m.DishID=@DishID
return @totalsale
end
GO
/****** Object:  Table [dbo].[Vendor]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vendor](
	[VendorID] [int] IDENTITY(1,2) NOT NULL,
	[VendorName] [varchar](25) NULL,
	[Address] [varchar](25) NULL,
	[PhoneNo] [varchar](25) NULL,
 CONSTRAINT [PK_Vendor] PRIMARY KEY CLUSTERED 
(
	[VendorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inventory]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inventory](
	[VendorID] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[ItemName] [varchar](25) NULL,
	[ItemStatus] [varchar](25) NULL,
 CONSTRAINT [PK_Inventory] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Item_Status]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Item_Status]
as
select v.vendorId,vendorName,i.ItemID,itemName,itemStatus
from vendor v inner join inventory i
on v.VendorID=i.VendorID
where itemstatus like 'in-stock'
GO
/****** Object:  Table [dbo].[Emp]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp](
	[EmpID] [int] IDENTITY(1,1) NOT NULL,
	[EmpName] [varchar](25) NOT NULL,
	[Gender] [char](1) NULL,
	[DOB] [smalldatetime] NULL,
	[Designation] [varchar](25) NULL,
	[Sal] [numeric](18, 0) NULL,
	[Shift] [varchar](50) NULL,
	[HireDate] [smalldatetime] NULL,
	[Address] [varchar](50) NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[EmpID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[Annual_Salary]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Annual_Salary]
(@empid int)
returns table
as
return(
select empid,empname,designation,shift,(sal*12) as 'Annual Salary'
from Emp
where empid=@empid)
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerName] [varchar](25) NULL,
	[PhoneNo] [varchar](25) NOT NULL,
	[TableNo] [int] NULL,
	[Date] [smalldatetime] NULL,
	[CustomerStatus] [varchar](50) NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Menu]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Menu](
	[DishID] [int] NOT NULL,
	[DishName] [varchar](25) NULL,
	[Price] [numeric](18, 0) NULL,
 CONSTRAINT [PK_Menu] PRIMARY KEY CLUSTERED 
(
	[DishID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[OrderID] [int] NOT NULL,
	[DishID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmpCustomerOrder]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmpCustomerOrder](
	[EmpID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[OrderID] [int] NOT NULL,
	[DishID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[Order_Summary]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Order_Summary]
(@customerid int)
returns table
as
return(
select e.EmpID,empname,c.CustomerID,CustomerName,Tableno,DishName,Quantity,Amount
from Emp e inner join EmpCustomerOrder eco
on e.EmpID=eco.EmpID
inner join Customer c
on eco.CustomerID=c.CustomerID
inner join Menu m
on eco.DishID=m.DishID
inner join "Order" o
on  eco.OrderID=o.OrderID
where c.CustomerID=@customerid)
GO
/****** Object:  UserDefinedFunction [dbo].[f3]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f3]
(@DishID int)
returns table
as

return(select DishName,sum(Quantity) as 'Total_Sale',Amount*sum(Quantity) as 'Total_Amount'
from "order" o inner join EmpCustomerOrder eco
on o.OrderID=eco.OrderID
inner join Menu m
on eco.DishID=m.DishID
where m.DishID=@DishID
group by m.DishName, o.Amount)
GO
/****** Object:  UserDefinedFunction [dbo].[f4]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f4]
(@DishID int)
returns table
as

return(select distinct DishName,sum(Quantity) as 'Total_Sale',Amount as 'Total_Amount'
from "order" o inner join EmpCustomerOrder eco
on o.OrderID=eco.OrderID
inner join Menu m
on eco.DishID=m.DishID
where m.DishID=@DishID 
group by m.DishName, o.Amount
having Amount=amount*sum(quantity))
GO
/****** Object:  UserDefinedFunction [dbo].[f5]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f5]
(@DishID int)
returns table
as

return(select  DishName,sum(Quantity) as 'Total_Sale',Amount as 'Total_Amount'
from "order" o inner join EmpCustomerOrder eco
on o.OrderID=eco.OrderID
inner join Menu m
on eco.DishID=m.DishID
where m.DishID=@DishID 
group by m.DishName, o.Amount
having Amount=amount*sum(quantity))

GO
/****** Object:  UserDefinedFunction [dbo].[f6]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f6]
(@DishID int)
returns table
as

return(select  DishName,count(Quantity) as 'Total_Sale',Amount as 'Total_Amount'
from "order" o inner join EmpCustomerOrder eco
on o.OrderID=eco.OrderID
inner join Menu m
on eco.DishID=m.DishID
where m.DishID=@DishID 
group by m.DishName, o.Amount
having Amount=amount*count(quantity))
GO
/****** Object:  UserDefinedFunction [dbo].[f7]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f7]
(@DishID int)
returns table
as

return(select  DishName,count(@DishID) as 'Total_Sale',Amount as 'Total_Amount'
from "order" o inner join EmpCustomerOrder eco
on o.OrderID=eco.OrderID
inner join Menu m
on eco.DishID=m.DishID
where m.DishID=@DishID 
group by m.DishName, o.Amount
having Amount=amount*count(@DishID))
GO
/****** Object:  UserDefinedFunction [dbo].[f8]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f8]
(@DishID int)
returns table
as

return(select  DishName,SUM(Quantity) as 'Total_Sale'
from "order" o inner join EmpCustomerOrder eco
on o.OrderID=eco.OrderID
inner join Menu m
on eco.DishID=m.DishID
where m.DishID=@DishID 
group by m.DishName, o.Amount)
GO
/****** Object:  UserDefinedFunction [dbo].[f9]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f9]
(@DishID int)
returns table
as

return(select C.CustomerName, DishName,SUM(Quantity) as 'Total_Sale',Sum(Amount) as 'Total_Amount'
from "order" o inner join EmpCustomerOrder eco
on o.OrderID=eco.OrderID
inner join Menu m
on eco.DishID=m.DishID
inner join Customer c
on eco.CustomerID=c.CustomerID
where m.DishID=@DishID 
group by C.CustomerName,m.DishName, o.Amount)
GO
/****** Object:  UserDefinedFunction [dbo].[f10]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f10]
(@DishID int)
returns table
as

return(select DishName,isnull(SUM(Quantity),0) as 'Total_Sale',isnull(Sum(quantity*amount),0) as 'Total_Amount'
from "order" o inner join EmpCustomerOrder eco
on o.OrderID=eco.OrderID
inner join Menu m
on eco.DishID=m.DishID
where m.DishID=@DishID 
group by m.DishName, o.Amount)
GO
/****** Object:  View [dbo].[Customer_With_High_Spending]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Customer_With_High_Spending]
as
SELECT c.CustomerID, c.CustomerName, SUM(o.Quantity * m.Price) AS TotalSpending
from "order" o inner join EmpCustomerOrder eco
on o.OrderID=eco.OrderID
inner join Menu m
on eco.DishID=m.DishID
inner join Customer c
on eco.CustomerID=c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING SUM(o.Quantity * m.Price) > 1000;
GO
/****** Object:  UserDefinedFunction [dbo].[Discount]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Discount]
(@orderID int)
returns table
as
return(
select  o.orderID,c.customerID,sum(o.Quantity*m.Price) as 'List Price',(Amount*0.05) as 'Discount',(Amount-(Amount*0.05) ) as 'Net Cash Price'
from Customer c inner join EmpCustomerOrder eco
on eco.CustomerID=c.CustomerID
inner join "Order" o
on o.OrderID=eco.OrderID
inner join Menu m
on m.DishID=eco.DishID
where o.orderID=@orderID
group by o.OrderID,c.CustomerID,o.Amount
having sum(o.Quantity*m.Price)>500

)
GO
/****** Object:  View [dbo].[Sales_Report]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Sales_Report]
as
select YEAR(Date) as 'Year',MONTH(Date) as 'Month',sum(Amount) as 'Total Sales'
from "Order" 
group by YEAR(Date) ,MONTH(Date)
GO
/****** Object:  View [dbo].[Emp_With_Max_Orders]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Emp_With_Max_Orders]
as
SELECT top 3 e.EmpID,EmpName,Designation, COUNT(*) AS 'No. Of Orders'
FROM EmpCustomerOrder eco inner join Emp e
on eco.EmpID=e.EmpID
GROUP BY e.EmpID,EmpName,Designation

GO
/****** Object:  View [dbo].[Customers_Having_Same_Dishes]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Customers_Having_Same_Dishes]
as
SELECT 
    c1.CustomerID AS Customer1,
    c2.CustomerID AS Customer2,
    COUNT(DISTINCT eco1.DishID) AS 'Shared Items Count',DishName
FROM Customer c1
JOIN Customer c2 ON c1.CustomerID < c2.CustomerID
JOIN EmpCustomerOrder eco1 ON c1.CustomerID = eco1.CustomerID
JOIN EmpCustomerOrder eco2 ON c2.CustomerID = eco2.CustomerID AND eco1.DishID = eco2.DishID
inner join Menu m
on eco1.DishID=m.DishID
GROUP BY c1.CustomerID, c2.CustomerID,DishName
GO
/****** Object:  View [dbo].[Avg_Order_Value]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Avg_Order_Value]
as
SELECT 
    c.CustomerID,
    c.CustomerName,
    SUM(o.Amount) AS TotalSpending,
    COUNT(DISTINCT eco.OrderID) AS TotalOrders,
    AVG(o.Amount) AS AvgOrderValue
FROM Customer c
LEFT JOIN EmpCustomerOrder eco ON c.CustomerID = eco.CustomerID
inner join "Order" o 
on o.OrderID=eco.OrderID
GROUP BY c.CustomerID, c.CustomerName
GO
/****** Object:  UserDefinedFunction [dbo].[Get_Emp_By_Shift]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create function [dbo].[Get_Emp_By_Shift]
(@targetShift varchar (50))
returns table
as
return
(select * from Emp
where shift=@targetshift)
GO
/****** Object:  Table [dbo].[Logs_For_Customer]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Logs_For_Customer](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerName] [varchar](25) NULL,
	[PhoneNo] [varchar](25) NOT NULL,
	[TableNo] [int] NULL,
	[Date] [smalldatetime] NULL,
	[CustomerStatus] [varchar](50) NULL,
	[Activity] [varchar](50) NULL,
	[ActivityDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Logs_For_Employee]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Logs_For_Employee](
	[EmpID] [int] IDENTITY(1,1) NOT NULL,
	[EmpName] [varchar](25) NOT NULL,
	[Gender] [char](1) NULL,
	[DOB] [smalldatetime] NULL,
	[Designation] [varchar](25) NULL,
	[Sal] [numeric](18, 0) NULL,
	[Shift] [varchar](50) NULL,
	[HireDate] [smalldatetime] NULL,
	[Address] [varchar](50) NULL,
	[Activity] [varchar](50) NULL,
	[ActivityDate] [datetime] NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Customer] ON 

INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [PhoneNo], [TableNo], [Date], [CustomerStatus]) VALUES (1, N'Fahad', N'02-123456789', 10, CAST(N'2023-02-01T00:00:00' AS SmallDateTime), N'Dine-in')
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [PhoneNo], [TableNo], [Date], [CustomerStatus]) VALUES (2, N'Ayesha', N'021-34567891', 9, CAST(N'2023-02-01T00:00:00' AS SmallDateTime), N'Take away')
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [PhoneNo], [TableNo], [Date], [CustomerStatus]) VALUES (3, N'Rohum', N'0333-5678910', 2, CAST(N'2023-02-02T00:00:00' AS SmallDateTime), N'Take away')
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [PhoneNo], [TableNo], [Date], [CustomerStatus]) VALUES (4, N'Amna', N'0300-8204457', 11, CAST(N'2023-02-02T00:00:00' AS SmallDateTime), N'Dine-in')
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [PhoneNo], [TableNo], [Date], [CustomerStatus]) VALUES (5, N'Tariq', N'0332-3563324', 8, CAST(N'2023-02-05T00:00:00' AS SmallDateTime), N'Take away')
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [PhoneNo], [TableNo], [Date], [CustomerStatus]) VALUES (6, N'Romaisa', N'0333-8632971', 2, CAST(N'2023-02-05T00:00:00' AS SmallDateTime), N'Dine-in')
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [PhoneNo], [TableNo], [Date], [CustomerStatus]) VALUES (7, N'Hafsa', N'0333-2917424', 3, CAST(N'2023-02-05T00:00:00' AS SmallDateTime), N'Dine-in')
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [PhoneNo], [TableNo], [Date], [CustomerStatus]) VALUES (8, N'Saif', N'021-87596723', 5, CAST(N'2023-02-05T00:00:00' AS SmallDateTime), N'Dine-in')
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [PhoneNo], [TableNo], [Date], [CustomerStatus]) VALUES (9, N'Hira', N'021-98765431', 9, CAST(N'2023-02-09T00:00:00' AS SmallDateTime), N'Take away')
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [PhoneNo], [TableNo], [Date], [CustomerStatus]) VALUES (10, N'Hamza', N'0333-9242291', 1, CAST(N'2023-02-09T00:00:00' AS SmallDateTime), N'Dine-in')
SET IDENTITY_INSERT [dbo].[Customer] OFF
GO
SET IDENTITY_INSERT [dbo].[Emp] ON 

INSERT [dbo].[Emp] ([EmpID], [EmpName], [Gender], [DOB], [Designation], [Sal], [Shift], [HireDate], [Address]) VALUES (2, N'Laiba', N'F', CAST(N'1989-06-12T00:00:00' AS SmallDateTime), N'Manager', CAST(150000 AS Numeric(18, 0)), N'Morning', CAST(N'2018-01-18T00:00:00' AS SmallDateTime), N'Appartment Xyz House no 1A')
INSERT [dbo].[Emp] ([EmpID], [EmpName], [Gender], [DOB], [Designation], [Sal], [Shift], [HireDate], [Address]) VALUES (3, N'Nameer', N'M', CAST(N'1987-05-21T00:00:00' AS SmallDateTime), N'Exec. Chef', CAST(100000 AS Numeric(18, 0)), N'Afternoon', CAST(N'2016-07-01T00:00:00' AS SmallDateTime), N'Appartment Xyz House no 2B')
INSERT [dbo].[Emp] ([EmpID], [EmpName], [Gender], [DOB], [Designation], [Sal], [Shift], [HireDate], [Address]) VALUES (4, N'Sarmad', N'M', CAST(N'1992-07-11T00:00:00' AS SmallDateTime), N'Kitchen Manager', CAST(100000 AS Numeric(18, 0)), N'Afternoon', CAST(N'2017-02-28T00:00:00' AS SmallDateTime), N'Abc Society House no 3C')
INSERT [dbo].[Emp] ([EmpID], [EmpName], [Gender], [DOB], [Designation], [Sal], [Shift], [HireDate], [Address]) VALUES (5, N'Amna', N'F', CAST(N'2001-09-19T00:00:00' AS SmallDateTime), N'Sous Chef', CAST(80000 AS Numeric(18, 0)), N'Midnight', CAST(N'2017-11-15T00:00:00' AS SmallDateTime), N'Abc Society House no 4D')
INSERT [dbo].[Emp] ([EmpID], [EmpName], [Gender], [DOB], [Designation], [Sal], [Shift], [HireDate], [Address]) VALUES (6, N'Sara', N'F', CAST(N'1999-08-24T00:00:00' AS SmallDateTime), N'Waiter', CAST(40000 AS Numeric(18, 0)), N'Morning', CAST(N'2020-12-01T00:00:00' AS SmallDateTime), N'Appartment Abc House no 5D')
INSERT [dbo].[Emp] ([EmpID], [EmpName], [Gender], [DOB], [Designation], [Sal], [Shift], [HireDate], [Address]) VALUES (7, N'Zaviyar', N'M', CAST(N'2000-02-05T00:00:00' AS SmallDateTime), N'Delivery Man', CAST(20000 AS Numeric(18, 0)), N'Afternoon', CAST(N'2018-01-25T00:00:00' AS SmallDateTime), N'Appartment Abc House no 4F')
INSERT [dbo].[Emp] ([EmpID], [EmpName], [Gender], [DOB], [Designation], [Sal], [Shift], [HireDate], [Address]) VALUES (8, N'Ahsan', N'M', CAST(N'2014-06-29T00:00:00' AS SmallDateTime), N'Waiter', CAST(40000 AS Numeric(18, 0)), N'Midnight', CAST(N'2017-12-16T00:00:00' AS SmallDateTime), N'Xyz Society House no 2L')
INSERT [dbo].[Emp] ([EmpID], [EmpName], [Gender], [DOB], [Designation], [Sal], [Shift], [HireDate], [Address]) VALUES (9, N'Rafia', N'F', CAST(N'1995-08-17T00:00:00' AS SmallDateTime), N'Kitchen Manager', CAST(10000 AS Numeric(18, 0)), N'Morning', CAST(N'2018-07-11T00:00:00' AS SmallDateTime), N'Appartment Xyz House no 8C')
INSERT [dbo].[Emp] ([EmpID], [EmpName], [Gender], [DOB], [Designation], [Sal], [Shift], [HireDate], [Address]) VALUES (10, N'Hammad', N'M', CAST(N'2001-12-12T00:00:00' AS SmallDateTime), N'Waiter', CAST(40000 AS Numeric(18, 0)), N'Afternoon', CAST(N'2015-03-12T00:00:00' AS SmallDateTime), N'Appartment Abc House no 2H')
INSERT [dbo].[Emp] ([EmpID], [EmpName], [Gender], [DOB], [Designation], [Sal], [Shift], [HireDate], [Address]) VALUES (11, N'Hafsa', N'F', CAST(N'1992-03-15T00:00:00' AS SmallDateTime), N'Exec. Chef', CAST(110000 AS Numeric(18, 0)), N'Midnight', CAST(N'2014-09-08T00:00:00' AS SmallDateTime), N'Xyz Society House no 7X')
INSERT [dbo].[Emp] ([EmpID], [EmpName], [Gender], [DOB], [Designation], [Sal], [Shift], [HireDate], [Address]) VALUES (12, N'Adil', N'M', CAST(N'2002-11-19T00:00:00' AS SmallDateTime), N'Delivery Man', CAST(30000 AS Numeric(18, 0)), N'Midnight', CAST(N'2020-04-17T00:00:00' AS SmallDateTime), N'Appartment Abc House no 13F')
SET IDENTITY_INSERT [dbo].[Emp] OFF
GO
INSERT [dbo].[EmpCustomerOrder] ([EmpID], [CustomerID], [OrderID], [DishID]) VALUES (6, 1, 210, 101)
INSERT [dbo].[EmpCustomerOrder] ([EmpID], [CustomerID], [OrderID], [DishID]) VALUES (7, 2, 211, 129)
INSERT [dbo].[EmpCustomerOrder] ([EmpID], [CustomerID], [OrderID], [DishID]) VALUES (7, 3, 212, 511)
INSERT [dbo].[EmpCustomerOrder] ([EmpID], [CustomerID], [OrderID], [DishID]) VALUES (6, 4, 213, 428)
INSERT [dbo].[EmpCustomerOrder] ([EmpID], [CustomerID], [OrderID], [DishID]) VALUES (12, 5, 214, 288)
INSERT [dbo].[EmpCustomerOrder] ([EmpID], [CustomerID], [OrderID], [DishID]) VALUES (10, 6, 215, 216)
INSERT [dbo].[EmpCustomerOrder] ([EmpID], [CustomerID], [OrderID], [DishID]) VALUES (10, 7, 216, 589)
INSERT [dbo].[EmpCustomerOrder] ([EmpID], [CustomerID], [OrderID], [DishID]) VALUES (6, 8, 217, 501)
INSERT [dbo].[EmpCustomerOrder] ([EmpID], [CustomerID], [OrderID], [DishID]) VALUES (12, 9, 218, 413)
INSERT [dbo].[EmpCustomerOrder] ([EmpID], [CustomerID], [OrderID], [DishID]) VALUES (10, 10, 219, 216)
GO
INSERT [dbo].[Inventory] ([VendorID], [ItemID], [ItemName], [ItemStatus]) VALUES (17, 1001, N'Chicken', N'In-Stock')
INSERT [dbo].[Inventory] ([VendorID], [ItemID], [ItemName], [ItemStatus]) VALUES (15, 1002, N'Flour', N'In-Stock')
INSERT [dbo].[Inventory] ([VendorID], [ItemID], [ItemName], [ItemStatus]) VALUES (21, 1003, N'Eggs', N'Not in-Stock')
INSERT [dbo].[Inventory] ([VendorID], [ItemID], [ItemName], [ItemStatus]) VALUES (29, 1004, N'Fish', N'In-Stock')
INSERT [dbo].[Inventory] ([VendorID], [ItemID], [ItemName], [ItemStatus]) VALUES (23, 1005, N'Tomatoes', N'Not in-Stock')
INSERT [dbo].[Inventory] ([VendorID], [ItemID], [ItemName], [ItemStatus]) VALUES (27, 1006, N'Onions', N'Not in-Stock')
INSERT [dbo].[Inventory] ([VendorID], [ItemID], [ItemName], [ItemStatus]) VALUES (17, 1007, N'Lemons', N'In-Stock')
INSERT [dbo].[Inventory] ([VendorID], [ItemID], [ItemName], [ItemStatus]) VALUES (25, 1008, N'Shrimp', N'In-Stock')
INSERT [dbo].[Inventory] ([VendorID], [ItemID], [ItemName], [ItemStatus]) VALUES (23, 1009, N'Beef', N'In-Stock')
INSERT [dbo].[Inventory] ([VendorID], [ItemID], [ItemName], [ItemStatus]) VALUES (19, 1010, N'Milk', N'Not in-Stock')
INSERT [dbo].[Inventory] ([VendorID], [ItemID], [ItemName], [ItemStatus]) VALUES (25, 1011, N'Cheese', N'In-Stock')
INSERT [dbo].[Inventory] ([VendorID], [ItemID], [ItemName], [ItemStatus]) VALUES (23, 1012, N'Pasta', N'In-Stock')
INSERT [dbo].[Inventory] ([VendorID], [ItemID], [ItemName], [ItemStatus]) VALUES (15, 1013, N'Rice', N'In-Stock')
INSERT [dbo].[Inventory] ([VendorID], [ItemID], [ItemName], [ItemStatus]) VALUES (29, 1014, N'Coffee', N'Not In-Stock')
INSERT [dbo].[Inventory] ([VendorID], [ItemID], [ItemName], [ItemStatus]) VALUES (17, 1015, N'Spices', N'In-Stock')
INSERT [dbo].[Inventory] ([VendorID], [ItemID], [ItemName], [ItemStatus]) VALUES (25, 1016, N'Bread', N'In-Stock')
INSERT [dbo].[Inventory] ([VendorID], [ItemID], [ItemName], [ItemStatus]) VALUES (29, 1017, N'Butter', N'In-Stock')
GO
SET IDENTITY_INSERT [dbo].[Logs_For_Customer] ON 

INSERT [dbo].[Logs_For_Customer] ([CustomerID], [CustomerName], [PhoneNo], [TableNo], [Date], [CustomerStatus], [Activity], [ActivityDate]) VALUES (1, N'Rafay', N'0333-924222', 10, CAST(N'2023-02-09T00:00:00' AS SmallDateTime), N'Dine-In', N'Record to be inserted in Customer table', CAST(N'2024-01-09T08:53:10.557' AS DateTime))
INSERT [dbo].[Logs_For_Customer] ([CustomerID], [CustomerName], [PhoneNo], [TableNo], [Date], [CustomerStatus], [Activity], [ActivityDate]) VALUES (2, N'Hamza', N'0333-9242291', 1, CAST(N'2023-02-09T00:00:00' AS SmallDateTime), N'Dine-in', N'Record to be deleted from Customer table', CAST(N'2024-01-09T08:53:56.547' AS DateTime))
SET IDENTITY_INSERT [dbo].[Logs_For_Customer] OFF
GO
SET IDENTITY_INSERT [dbo].[Logs_For_Employee] ON 

INSERT [dbo].[Logs_For_Employee] ([EmpID], [EmpName], [Gender], [DOB], [Designation], [Sal], [Shift], [HireDate], [Address], [Activity], [ActivityDate]) VALUES (1, N'Zeeshan', N'M', CAST(N'2000-01-04T00:00:00' AS SmallDateTime), N'Manager', CAST(13000 AS Numeric(18, 0)), N'Morning', CAST(N'2023-01-12T00:00:00' AS SmallDateTime), N'Appartment Xyz House no C12', N'Record to be inserted in Employee table', CAST(N'2024-01-09T08:57:37.210' AS DateTime))
INSERT [dbo].[Logs_For_Employee] ([EmpID], [EmpName], [Gender], [DOB], [Designation], [Sal], [Shift], [HireDate], [Address], [Activity], [ActivityDate]) VALUES (2, N'Laiba', N'F', CAST(N'1989-06-12T00:00:00' AS SmallDateTime), N'Manager', CAST(150000 AS Numeric(18, 0)), N'Morning', CAST(N'2018-01-18T00:00:00' AS SmallDateTime), N'Appartment Xyz House no 1A', N'Record to be deleted from Employee table', CAST(N'2024-01-09T08:58:16.543' AS DateTime))
INSERT [dbo].[Logs_For_Employee] ([EmpID], [EmpName], [Gender], [DOB], [Designation], [Sal], [Shift], [HireDate], [Address], [Activity], [ActivityDate]) VALUES (3, N'Laiba', N'F', CAST(N'1989-06-12T00:00:00' AS SmallDateTime), N'Exec. Chef', CAST(150000 AS Numeric(18, 0)), N'Morning', CAST(N'2018-01-18T00:00:00' AS SmallDateTime), N'Appartment Xyz House no 1A', N'Record to be inserted in Employee table', CAST(N'2024-01-09T08:58:16.547' AS DateTime))
SET IDENTITY_INSERT [dbo].[Logs_For_Employee] OFF
GO
INSERT [dbo].[Menu] ([DishID], [DishName], [Price]) VALUES (101, N'Fish and Chips', CAST(450 AS Numeric(18, 0)))
INSERT [dbo].[Menu] ([DishID], [DishName], [Price]) VALUES (129, N'Club Sandwich', CAST(300 AS Numeric(18, 0)))
INSERT [dbo].[Menu] ([DishID], [DishName], [Price]) VALUES (216, N'Hot n Sour Soup', CAST(550 AS Numeric(18, 0)))
INSERT [dbo].[Menu] ([DishID], [DishName], [Price]) VALUES (288, N'Biryani', CAST(250 AS Numeric(18, 0)))
INSERT [dbo].[Menu] ([DishID], [DishName], [Price]) VALUES (413, N'Nihari', CAST(450 AS Numeric(18, 0)))
INSERT [dbo].[Menu] ([DishID], [DishName], [Price]) VALUES (428, N'Zinger Burger', CAST(300 AS Numeric(18, 0)))
INSERT [dbo].[Menu] ([DishID], [DishName], [Price]) VALUES (501, N'Alfredo Pasta', CAST(1150 AS Numeric(18, 0)))
INSERT [dbo].[Menu] ([DishID], [DishName], [Price]) VALUES (511, N'IceCream', CAST(200 AS Numeric(18, 0)))
INSERT [dbo].[Menu] ([DishID], [DishName], [Price]) VALUES (589, N'Mojito', CAST(450 AS Numeric(18, 0)))
INSERT [dbo].[Menu] ([DishID], [DishName], [Price]) VALUES (609, N'Pepsi', CAST(100 AS Numeric(18, 0)))
GO
INSERT [dbo].[Order] ([OrderID], [DishID], [Quantity], [Amount], [Date]) VALUES (210, 101, 1, 450.0000, CAST(N'2023-01-02T00:00:00.000' AS DateTime))
INSERT [dbo].[Order] ([OrderID], [DishID], [Quantity], [Amount], [Date]) VALUES (211, 129, 2, 600.0000, CAST(N'2023-01-02T00:00:00.000' AS DateTime))
INSERT [dbo].[Order] ([OrderID], [DishID], [Quantity], [Amount], [Date]) VALUES (212, 511, 4, 800.0000, CAST(N'2023-01-03T00:00:00.000' AS DateTime))
INSERT [dbo].[Order] ([OrderID], [DishID], [Quantity], [Amount], [Date]) VALUES (213, 428, 3, 900.0000, CAST(N'2023-01-03T00:00:00.000' AS DateTime))
INSERT [dbo].[Order] ([OrderID], [DishID], [Quantity], [Amount], [Date]) VALUES (214, 288, 6, 15000.0000, CAST(N'2023-01-11T00:00:00.000' AS DateTime))
INSERT [dbo].[Order] ([OrderID], [DishID], [Quantity], [Amount], [Date]) VALUES (215, 216, 2, 1100.0000, CAST(N'2023-01-23T00:00:00.000' AS DateTime))
INSERT [dbo].[Order] ([OrderID], [DishID], [Quantity], [Amount], [Date]) VALUES (216, 589, 4, 1800.0000, CAST(N'2023-01-29T00:00:00.000' AS DateTime))
INSERT [dbo].[Order] ([OrderID], [DishID], [Quantity], [Amount], [Date]) VALUES (217, 501, 1, 1150.0000, CAST(N'2023-02-04T00:00:00.000' AS DateTime))
INSERT [dbo].[Order] ([OrderID], [DishID], [Quantity], [Amount], [Date]) VALUES (218, 413, 2, 900.0000, CAST(N'2023-02-04T00:00:00.000' AS DateTime))
INSERT [dbo].[Order] ([OrderID], [DishID], [Quantity], [Amount], [Date]) VALUES (219, 216, 1, 550.0000, CAST(N'2023-02-05T00:00:00.000' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Vendor] ON 

INSERT [dbo].[Vendor] ([VendorID], [VendorName], [Address], [PhoneNo]) VALUES (15, N'Abdullah', N'Street 01 xyz location', N'03332298562')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [Address], [PhoneNo]) VALUES (17, N'Ahad', N'Street 02 xyz location', N'03334567891')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [Address], [PhoneNo]) VALUES (19, N'Danish', N'Street 03 xyz location', N'02189245678')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [Address], [PhoneNo]) VALUES (21, N'Saim', N'Street 04 xyz location', N'03008245678')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [Address], [PhoneNo]) VALUES (23, N'Laiba', N'Street 05 xyz location', N'02182044589')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [Address], [PhoneNo]) VALUES (25, N'Aqsa', N'Street 06 xyz location', N'03324587985')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [Address], [PhoneNo]) VALUES (27, N'Dania', N'Street 07 xyz location', N'02145789358')
INSERT [dbo].[Vendor] ([VendorID], [VendorName], [Address], [PhoneNo]) VALUES (29, N'Laraib', N'Street 08 xyz location', N'03004578923')
SET IDENTITY_INSERT [dbo].[Vendor] OFF
GO
ALTER TABLE [dbo].[EmpCustomerOrder]  WITH CHECK ADD  CONSTRAINT [FK_EmpCustomerOrder_Customer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO
ALTER TABLE [dbo].[EmpCustomerOrder] CHECK CONSTRAINT [FK_EmpCustomerOrder_Customer]
GO
ALTER TABLE [dbo].[EmpCustomerOrder]  WITH CHECK ADD  CONSTRAINT [FK_EmpCustomerOrder_Emp] FOREIGN KEY([EmpID])
REFERENCES [dbo].[Emp] ([EmpID])
GO
ALTER TABLE [dbo].[EmpCustomerOrder] CHECK CONSTRAINT [FK_EmpCustomerOrder_Emp]
GO
ALTER TABLE [dbo].[EmpCustomerOrder]  WITH CHECK ADD  CONSTRAINT [FK_EmpCustomerOrder_Menu] FOREIGN KEY([DishID])
REFERENCES [dbo].[Menu] ([DishID])
GO
ALTER TABLE [dbo].[EmpCustomerOrder] CHECK CONSTRAINT [FK_EmpCustomerOrder_Menu]
GO
ALTER TABLE [dbo].[EmpCustomerOrder]  WITH CHECK ADD  CONSTRAINT [FK_EmpCustomerOrder_Order] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Order] ([OrderID])
GO
ALTER TABLE [dbo].[EmpCustomerOrder] CHECK CONSTRAINT [FK_EmpCustomerOrder_Order]
GO
ALTER TABLE [dbo].[Inventory]  WITH CHECK ADD  CONSTRAINT [FK_Inventory_Vendor] FOREIGN KEY([VendorID])
REFERENCES [dbo].[Vendor] ([VendorID])
GO
ALTER TABLE [dbo].[Inventory] CHECK CONSTRAINT [FK_Inventory_Vendor]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Menu] FOREIGN KEY([DishID])
REFERENCES [dbo].[Menu] ([DishID])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Menu]
GO
/****** Object:  StoredProcedure [dbo].[Add_Dish_To_Menu]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[Add_Dish_To_Menu]
@dishID int,
@dishname varchar(50),
@price numeric(18,0)

as
begin
insert into Menu(DishID,DishName,Price)
values(@dishID,@dishname,@price)
end
GO
/****** Object:  StoredProcedure [dbo].[Daily_Sales_Record]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[Daily_Sales_Record]
@date datetime
as
begin
select m.DishID,DishName,Quantity,Amount
from Menu m inner join EmpCustomerOrder eco
on m.DishID=eco.DishID
inner join "Order" o
on eco.OrderID=o.OrderID
where o.Date=@date
group by m.DishID,DishName,Quantity,Amount
end
GO
/****** Object:  StoredProcedure [dbo].[Employee_Order_Count]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Employee_Order_Count]

as
begin
SELECT e.EmpID,EmpName,Designation,COUNT(*) AS OrderCount
FROM EmpCustomerOrder eco inner join Emp e
on eco.EmpID=e.EmpID
GROUP BY e.EmpID,EmpName,Designation
ORDER BY OrderCount DESC
end
GO
/****** Object:  StoredProcedure [dbo].[GenerateMonthlySales]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[GenerateMonthlySales]
@date datetime
as
begin
select m.DishID,DishName,Quantity,Amount
from Menu m inner join EmpCustomerOrder eco
on m.DishID=eco.DishID
inner join "Order" o
on eco.OrderID=o.OrderID
where o.Date=@date
group by m.DishID,DishName,Quantity,Amount
end
GO
/****** Object:  StoredProcedure [dbo].[Increment]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Increment]
as
begin
select empid,empname,designation,(sal +(sal*0.15)) as 'New Salary',datediff(year,hiredate,getdate()) as 'Years_Of_Work' from Emp
where datediff(year,hiredate,getdate())>5
end
GO
/****** Object:  StoredProcedure [dbo].[Notify_Out_Of_Stock]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Notify_Out_Of_Stock]
as
begin
select ItemID,ItemName,ItemStatus
from Inventory
where itemStatus like 'Not in-Stock'
end
GO
/****** Object:  Trigger [dbo].[Trigger_For_Customer_Table]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[Trigger_For_Customer_Table]
on [dbo].[Customer]
instead Of insert,delete,update
as
begin
if (exists(select * from deleted))
declare @activity varchar(50),@activityDate datetime
set @activity= 'Record to be deleted from Customer table'
set @activityDate= GETDATE()
begin
insert into Logs_For_Customer(CustomerName,PhoneNo,TableNo,Date,CustomerStatus,Activity,ActivityDate)
select d.CustomerName,d.PhoneNo,d.TableNo,d.Date,d.CustomerStatus,@activity,@activityDate
from deleted d
end

if(exists(select * from inserted))
begin
declare @activity1 varchar(50),@activityDate1 datetime
set @activity1= 'Record to be inserted in Customer table'
set @activityDate1= GETDATE()
insert into Logs_For_Customer(CustomerName,PhoneNo,TableNo,Date,CustomerStatus,Activity,ActivityDate)
select i.CustomerName,i.PhoneNo,i.TableNo,i.Date,i.CustomerStatus,@activity1,@activityDate1
from inserted i
end

END
GO
ALTER TABLE [dbo].[Customer] ENABLE TRIGGER [Trigger_For_Customer_Table]
GO
/****** Object:  Trigger [dbo].[For_Emp_Table]    Script Date: 1/10/2024 9:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[For_Emp_Table]
on [dbo].[Emp]
instead Of insert,delete,update
as
begin
if (exists(select * from deleted))
declare @activity varchar(50),@activityDate datetime
set @activity= 'Record to be deleted from Employee table'
set @activityDate= GETDATE()
begin
insert into Logs_For_Employee(EmpName,Gender,DOB,Designation,Sal,Shift,HireDate,Address,Activity,ActivityDate)
select d.EmpName,d.Gender,d.DOB,d.Designation,d.Sal,d.Shift,d.HireDate,d.Address,@activity,@activityDate
from deleted d
end

if(exists(select * from inserted))
begin
declare @activity1 varchar(50),@activityDate1 datetime
set @activity1= 'Record to be inserted in Employee table'
set @activityDate1= GETDATE()
insert into Logs_For_Employee(EmpName,Gender,DOB,Designation,Sal,Shift,HireDate,Address,Activity,ActivityDate)
select i.EmpName,i.Gender,i.DOB,i.Designation,i.Sal,i.Shift,i.HireDate,i.Address,@activity1,@activityDate1
from inserted i
end

END
GO
ALTER TABLE [dbo].[Emp] ENABLE TRIGGER [For_Emp_Table]
GO
USE [master]
GO
ALTER DATABASE [RMS] SET  READ_WRITE 
GO
