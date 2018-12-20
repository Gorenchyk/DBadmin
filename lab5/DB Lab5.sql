use [master]
go

Drop CERTIFICATE Cert1
Drop database Shifr;
Drop master key
go

CREATE CERTIFICATE Cert1
ENCRYPTION BY PASSWORD = '11'
WITH SUBJECT = 'Проверка шифрования',
START_DATE = '11/12/2018'

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Password';

USE [master]
go

/****** Object:  Database [Shifr]    Script Date: 22.09.2018 15:38:27 ******/
CREATE DATABASE [Shifr]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = [Shifr], FILENAME = N'G:\Program\Server SQL\MSSQL12.SQLEXPRESS\MSSQL\DATA\Shifr.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME =[Shifr_log]  , FILENAME = N'G:\Program\Server SQL\MSSQL12.SQLEXPRESS\MSSQL\DATA\Shifr_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

ALTER DATABASE [Shifr] SET COMPATIBILITY_LEVEL = 120
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Shifr].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [Shifr] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [Shifr] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [Shifr] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [Shifr] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [Shifr] SET ARITHABORT OFF 
GO

ALTER DATABASE [Shifr] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [Shifr] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [Shifr] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [Shifr] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [Shifr] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [Shifr] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [Shifr] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [Shifr] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [Shifr] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [Shifr] SET  DISABLE_BROKER 
GO

ALTER DATABASE [Shifr] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [Shifr] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [Shifr] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [Shifr] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [Shifr] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [Shifr] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [Shifr] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [Shifr] SET RECOVERY SIMPLE 
GO

ALTER DATABASE [Shifr] SET  MULTI_USER 
GO

ALTER DATABASE [Shifr] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [Shifr] SET DB_CHAINING OFF 
GO

ALTER DATABASE [Shifr] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [Shifr] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
/*
ALTER DATABASE [Shifr] SET DELAYED_DURABILITY = DISABLED 
GO*/

ALTER DATABASE [Shifr] SET  READ_WRITE 
GO

use [Shifr]
go

CREATE TABLE [dbo].[Num_cards](
	[ID] int NOT NULL,
	[EncryptByCert] [nvarchar](4000) NULL )
	go

insert into Num_cards
values(1, EncryptByCert(Cert_ID('Cert1'),'111001') )
insert into Num_cards
values(2, EncryptByCert(Cert_ID('Cert1'),'111002') )
insert into Num_cards
values(3, EncryptByCert(Cert_ID('Cert1'),'111003') )

Select * From Num_cards;

select convert(nvarchar(50), DecryptByCert(Cert_ID('Cert1'), EncryptByCert, N'11') )
from Num_cards


--Асиметрмчний ключ 
CREATE ASYMMETRIC KEY ASymKey1
WITH ALGORITHM = RSA_512
ENCRYPTION BY PASSWORD = '11'

use [Shifr]
go

insert into Num_cards
values (1, EncryptByAsymKey(AsymKey_ID('ASymKey1'), N'111001'))
insert into Num_cards 
values (2, EncryptByAsymKey(AsymKey_ID('ASymKey1'), N'111002'))
insert into Num_cards 
values (3, EncryptByAsymKey(AsymKey_ID('ASymKey1'), N'111003'))

Select * From Num_cards;

SELECT Convert(nvarchar(50), DecryptByAsymKey(AsymKey_ID('ASymKey1'),EncryptByCert, N'11'))
FROM Num_cards

--Симетричний ключ

CREATE SYMMETRIC KEY SymKey1
WITH ALGORITHM = DES
ENCRYPTION BY PASSWORD = '11'


OPEN SYMMETRIC KEY SymKey1 DECRYPTION BY
PASSWORD = '11'
--Используем созданный ключ для шифрования данных:
use [Shifr]
go
insert into Num_cards
values(1, EncryptByKey(Key_GUID('SymKey1'), convert(nvarchar(50),'111001') ))
insert into Num_cards
values(2, EncryptByKey(Key_GUID('SymKey1'), convert(nvarchar(50),'111002') ))
insert into Num_cards
values(3, EncryptByKey(Key_GUID('SymKey1'),
convert(nvarchar(50),'111003') ))



select convert(nvarchar(50), DecryptByKey(EncryptByCert)) from Num_cards

insert into Num_cards
values(1, EncryptByPassphrase('Password', N'111004'))
Select * From Num_cards;
--Расшифровка производится при помощи функции DecryptByPassphrase:
select
convert(nvarchar(50), DecryptByPassPhrase('Password', EncryptByCert ))
from Num_cards



CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'StrongPassword#1';
select * from sys.key_encryptions

drop master key
select * from sys.key_encryptions

BACKUP MASTER KEY TO FILE = 'C:\sqltest2012_masterkey_backup.bak'
 ENCRYPTION BY PASSWORD = 'Password1'


 CREATE CERTIFICATE TDECertificate WITH SUBJECT ='TDE Certificate for DBClients'

select * from sys.certificates where name='TDECertificate'

 BACKUP CERTIFICATE TDECertificate
 TO FILE = 'c:\sqltest2012_cert_TDECertificate'
 WITH PRIVATE KEY
 (
 FILE = 'c:\sqltest2012SQLPrivateKeyFile',
 ENCRYPTION BY PASSWORD = 'Password#3'
 );

 USE [Shifr]
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_128
ENCRYPTION BY SERVER CERTIFICATE TDECertificate;
/*Transparent Data Encryption is not available in the edition of this SQL Server instance. See books online for more details on feature support in different SQL Server editions.*/