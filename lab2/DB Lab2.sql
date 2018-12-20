create login test_login_ with password = '1'
use [master]
create user test_login_ for login test_login

--роли БД
alter role db_backupoperator add member test_login
exec sp_helprolemember

--новая роль БД
create role test_role_ authorization db_ddladmin
alter role db_ddladmin add member test_login
alter role db_ddladmin drop member test_login

--разрешения для роли
grant select to test_role_

--разрешения для пользователя
grant select to test_login
revoke insert to test_login
deny delete to test_login

USE [master]
GO
CREATE SERVER ROLE [BulkAdmin5] AUTHORIZATION [sa]
GO
ALTER SERVER ROLE [BulkAdmin5] ADD MEMBER [test_login]
GO
GRANT Administer Bulk Operations TO [test_login]
GO
--
--
ALTER SERVER ROLE [BulkAdmin5] DROP MEMBER [test_login]
Go
--роли БД
alter role db_backupoperator DROP member test_login
Go

--Проверка прав доступа:
SELECT DB_NAME() AS 'Database', p.name, p.type_desc, p.is_fixed_role, dbp.state_desc,
dbp.permission_name, so.name, so.type_desc
FROM sys.database_permissions dbp
LEFT JOIN sys.objects so ON dbp.major_id = so.object_id
LEFT JOIN sys.database_principals p ON dbp.grantee_principal_id = p.principal_id
--WHERE p.name = 'ProdDataEntry'
ORDER BY so.name, dbp.permission_name;

--Проверка применения прав:
EXECUTE AS LOGIN = 'test_login';
--Затем мы возвращаемся к разрешениям sysadmin с помощью следующей инструкции.
REVERT;

--Просмотр ролей:
--Роли на сервере:
exec sp_helpsrvrolemember
--Роли и в БД
exec sp_helpsrvrolemember

exec sp_addlogin @loginame = 'test3_login_proc',  @passwd='2'

exec sp_adduser 'test3_login_proc', 'test3_loginu_proc'

use [Hospital2]

grant select ON [Hospital2] to test3_loginu_proc

--создание роли

exec sp_addrole df

grant create table to df

--Проверка
 
exec sp_helpuser

