USE [master] GO 

/****** Object:  Database [Library]    Script Date: 17.12.2018 11:51:57 ******/

CREATE DATABASE [Library] CONTAINMENT = NONE ON PRIMARY (NAME = N'Library',
        FILENAME = N'G:\Program\Server SQL\MSSQL12.SQLEXPRESS\MSSQL\DATA\Library.mdf',
        SIZE = 5120KB,
        MAXSIZE =
        UNLIMITED,
        FILEGROWTH = 1024KB) LOG ON (NAME = N'Library_log',
        FILENAME = N'G:\Program\Server SQL\MSSQL12.SQLEXPRESS\MSSQL\DATA\Library_log.ldf',
        SIZE = 2048KB,
        MAXSIZE = 2048GB,
        FILEGROWTH = 10%) GO

ALTER DATABASE [Library]
SET COMPATIBILITY_LEVEL = 120 GO IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
BEGIN EXEC [Library].[dbo].[sp_fulltext_database] @action = 'enable' END GO
ALTER DATABASE [Library]
SET ANSI_NULL_DEFAULT OFF GO
ALTER DATABASE [Library]
SET ANSI_NULLS OFF GO
ALTER DATABASE [Library]
SET ANSI_PADDING OFF GO
ALTER DATABASE [Library]
SET ANSI_WARNINGS OFF GO
ALTER DATABASE [Library]
SET ARITHABORT OFF GO
ALTER DATABASE [Library]
SET AUTO_CLOSE OFF GO
ALTER DATABASE [Library]
SET AUTO_SHRINK OFF GO
ALTER DATABASE [Library]
SET AUTO_UPDATE_STATISTICS ON GO
ALTER DATABASE [Library]
SET CURSOR_CLOSE_ON_COMMIT OFF GO
ALTER DATABASE [Library]
SET CURSOR_DEFAULT GLOBAL GO
ALTER DATABASE [Library]
SET CONCAT_NULL_YIELDS_NULL OFF GO
ALTER DATABASE [Library]
SET NUMERIC_ROUNDABORT OFF GO
ALTER DATABASE [Library]
SET QUOTED_IDENTIFIER OFF GO
ALTER DATABASE [Library]
SET RECURSIVE_TRIGGERS OFF GO
ALTER DATABASE [Library]
SET DISABLE_BROKER GO
ALTER DATABASE [Library]
SET AUTO_UPDATE_STATISTICS_ASYNC OFF GO
ALTER DATABASE [Library]
SET DATE_CORRELATION_OPTIMIZATION OFF GO
ALTER DATABASE [Library]
SET TRUSTWORTHY OFF GO
ALTER DATABASE [Library]
SET ALLOW_SNAPSHOT_ISOLATION OFF GO
ALTER DATABASE [Library]
SET PARAMETERIZATION SIMPLE GO
ALTER DATABASE [Library]
SET READ_COMMITTED_SNAPSHOT OFF GO
ALTER DATABASE [Library]
SET HONOR_BROKER_PRIORITY OFF GO
ALTER DATABASE [Library]
SET RECOVERY SIMPLE GO
ALTER DATABASE [Library]
SET MULTI_USER GO
ALTER DATABASE [Library]
SET PAGE_VERIFY CHECKSUM GO
ALTER DATABASE [Library]
SET DB_CHAINING OFF GO
ALTER DATABASE [Library]
SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF) GO
ALTER DATABASE [Library]
SET TARGET_RECOVERY_TIME = 0 SECONDS GO
ALTER DATABASE [Library]
SET DELAYED_DURABILITY = DISABLED GO
ALTER DATABASE [Library]
SET READ_WRITE GO USE [Library] GO USE [Library] GO

/****** Object:  Table [dbo].[People]    Script Date: 17.12.2018 13:03:10 ******/

SET ANSI_NULLS ON GO
SET QUOTED_IDENTIFIER ON GO
CREATE TABLE [dbo].[People]( [FIO] [nvarchar](50) NOT NULL,
		[Address] [nvarchar](50) NOT NULL,
		[Telephon] [int] NOT NULL,
		[Bilet] [int] NOT NULL,
		[Tag_Vubitia] [bit] NOT NULL,
		[ID_People] [int] NOT NULL,
CONSTRAINT [PK_People] PRIMARY KEY CLUSTERED ( [ID_People] ASC)WITH (PAD_INDEX = OFF,
   STATISTICS_NORECOMPUTE = OFF,
   IGNORE_DUP_KEY = OFF,
   ALLOW_ROW_LOCKS = ON,
   ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY] GO USE [Library] GO 
   /****** Object:  Table [dbo].[Books]    Script Date: 17.12.2018 13:03:06 ******/
SET ANSI_NULLS ON GO
SET QUOTED_IDENTIFIER ON GO
CREATE TABLE [dbo].[Books]( [ID_Book] [int] NOT NULL,
		[Name] [nvarchar](50) NOT NULL,
		[Avtor] [nvarchar](50) NOT NULL,
		[Year] [datetime] NOT NULL,
		[Count] [int] NOT NULL,
		[Price] [int] NOT NULL,
CONSTRAINT [PK_Books] PRIMARY KEY CLUSTERED ( [ID_Book] ASC)WITH (PAD_INDEX = OFF,
		STATISTICS_NORECOMPUTE = OFF,
		IGNORE_DUP_KEY = OFF,
		ALLOW_ROW_LOCKS = ON,
		ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY] GO USE [Library] GO 
/****** Object:  Table [dbo].[Book_Vudana]    Script Date: 17.12.2018 13:02:58 ******/
SET ANSI_NULLS ON GO
SET QUOTED_IDENTIFIER ON GO
CREATE TABLE [dbo].[Book_Vudana]( [Data_Vudachi] [datetime] NOT NULL,
		[Real_Older] [datetime] NOT NULL,
		[Plan_vozvrata] [datetime] NOT NULL,
		[ID_Books] [int] NOT NULL,
		[ID_People] [int] NOT NULL) ON [PRIMARY] GO

ALTER TABLE [dbo].[Book_Vudana] WITH CHECK ADD CONSTRAINT [FK_Book_Vudana_Books1]
FOREIGN KEY([ID_Books]) REFERENCES [dbo].[Books] ([ID_Book]) GO
ALTER TABLE [dbo].[Book_Vudana] CHECK CONSTRAINT [FK_Book_Vudana_Books1] GO
ALTER TABLE [dbo].[Book_Vudana] WITH CHECK ADD CONSTRAINT [FK_Book_Vudana_People1]
FOREIGN KEY([ID_People]) REFERENCES [dbo].[People] ([ID_People]) GO
ALTER TABLE [dbo].[Book_Vudana] CHECK CONSTRAINT [FK_Book_Vudana_People1] GO
SELECT @@ServerName AS Server,
         DB_NAME() AS DBName,
         OBJECT_SCHEMA_NAME(p.object_id) AS SchemaName,
         OBJECT_NAME(p.object_id) AS TableName,
         i.Type_Desc,
         i.Name AS IndexUsedForCounts,
         SUM(p.Rows) AS ROWS
FROM sys.partitions p
JOIN sys.indexes i ON i.object_id = p.object_id
AND i.index_id = p.index_id
WHERE i.type_desc IN ('CLUSTERED',
                      'HEAP' )

AND OBJECT_SCHEMA_NAME(p.object_id) <> 'sys'
GROUP BY p.object_id,
         i.type_desc,
         i.Name
ORDER BY SchemaName,
         TableName;

USE Library;

GO
INSERT INTO Books(ID_Book, Name, Avtor, YEAR, COUNT, Price)
VALUES (1,
        'Кобзар',
        'Шевченко',
        '2011',
        85,
        50);

INSERT INTO Books(ID_Book, Name, Avtor, YEAR, COUNT, Price)
VALUES (2,
        'Мати все',
        'Люко Дашвар',
        '2008',
        35,
        45);

INSERT INTO Books(ID_Book, Name, Avtor, YEAR, COUNT, Price)
VALUES (3,
        'Абетка',
        'Народ',
        '1830',
        75,
        125);

INSERT INTO dbo.Book_Vudana(ID_Books, ID_People, Data_Vudachi, Real_Older, Plan_vozvrata)
VALUES (4,
        '20040523',
        '20040530',
        '20040523');
		
INSERT INTO dbo.Book_Vudana(ID_Books, ID_People, Data_Vudachi, Real_Older, Plan_vozvrata)
VALUES (5,
        '20040524',
        '20040531',
        '20040524');

INSERT INTO dbo.Book_Vudana(ID_Books, ID_People, Data_Vudachi, Real_Older, Plan_vozvrata)
VALUES (6,
        '20040525',
        '20040601',
        '20040525');

INSERT INTO dbo.People(ID_People, Tag_Vubitia, Bilet, Telephon, Address, FIO)
VALUES (1,
        0,
        'Bilet1',
        '25-55-66',
        'Грушевського',
        'BBB');

SELECT *
FROM Books ;

EXEC sp_addlogin @loginame = 'logtest1_login',
@passwd='1' EXEC sp_adduser 'logtest1_login',
'logtest1_log' USE Library GO GRANT

SELECT ON dbo.Books TO logtest1_log GO EXEC sp_addlogin @loginame = 'logtest2_login',
@passwd='1' EXEC sp_adduser 'logtest2_login',
'logtest2_log' GRANT

SELECT ON dbo.Books TO logtest2_log GRANT

INSERT ON dbo.Books TO logtest2_log EXEC sp_addlogin @loginame = 'logtest3_login',
@passwd='1' EXEC sp_adduser 'logtest3_login',
'logtest3_log' GRANT ADMIN ON dbo.Books TO logtest3_log USE [master] GO EXEC sp_helpuser USE [master] GO

CREATE SERVER ROLE [BulkAdmin5]
AUTHORIZATION [sa] GO
ALTER SERVER ROLE [BulkAdmin5] ADD MEMBER [test_login] GO GRANT Administer Bulk Operations TO [test_login] GO
CREATE ASYMMETRIC KEY ASymKey WITH ALGORITHM = RSA_512 ENCRYPTION BY PASSWORD = '11' USE [Library] GO
INSERT INTO dbo.People(ID_People, Tag_Vubitia, Bilet, Telephon, Address, FIO)

VALUES (6,
        0,
        132,
        EncryptByAsymKey(AsymKey_ID('ASymKey'), N'25-55-66'),
        EncryptByAsymKey(AsymKey_ID('ASymKey'), N'Грушевського'),
        'BBB');


SELECT *
FROM dbo.People ;


SELECT Convert(nvarchar(1000), DecryptByAsymKey(AsymKey_ID('ASymKey'), Address, N'11'))
FROM dbo.People
SELECT *
FROM dbo.People ;

USE [Library];

GO BACKUP DATABASE [Library] TO DISK = 'G:\education\Адміністрування та захист БД\Зберігання файлів для БД\Full_BackupLibrary.bak' WITH INIT,
NAME = 'Library Full Db backup',
DESCRIPTION = 'Library Full Database Backup';

GO BACKUP DATABASE [Library] TO DISK = 'G:\education\Адміністрування та захист БД\Зберігання файлів для БД\DiffDbBkup_Library.bak' WITH INIT,
DIFFERENTIAL,
NAME = 'Library Diff Db backup',
DESCRIPTION = 'Library Differential Database Backup' GO USE [master];

ALTER DATABASE [Hospital2]
SET RESTRICTED_USER GO RESTORE DATABASE [Library]
FROM DISK = 'G:\education\Адміністрування та захист БД\Зберігання файлів для БД\Full_BackupLibrary.bak' WITH NoRECOVERy,
REPLACE RESTORE DATABASE [Library]
FROM DISK = 'G:\education\Адміністрування та захист БД\Зберігання файлів для БД\DiffDbBkup_Library.bak' WITH RECOVERY,
REPLACE
SELECT *
FROM master..sysprocesses
WHERE db_name(dbid)='Library'