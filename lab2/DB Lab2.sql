create login test_login_ with password = '1'
use [master]
create user test_login_ for login test_login

--���� ��
alter role db_backupoperator add member test_login
exec sp_helprolemember

--����� ���� ��
create role test_role_ authorization db_ddladmin
alter role db_ddladmin add member test_login
alter role db_ddladmin drop member test_login

--���������� ��� ����
grant select to test_role_

--���������� ��� ������������
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
--���� ��
alter role db_backupoperator DROP member test_login
Go

--�������� ���� �������:
SELECT DB_NAME() AS 'Database', p.name, p.type_desc, p.is_fixed_role, dbp.state_desc,
dbp.permission_name, so.name, so.type_desc
FROM sys.database_permissions dbp
LEFT JOIN sys.objects so ON dbp.major_id = so.object_id
LEFT JOIN sys.database_principals p ON dbp.grantee_principal_id = p.principal_id
--WHERE p.name = 'ProdDataEntry'
ORDER BY so.name, dbp.permission_name;

--�������� ���������� ����:
EXECUTE AS LOGIN = 'test_login';
--����� �� ������������ � ����������� sysadmin � ������� ��������� ����������.
REVERT;

--�������� �����:
--���� �� �������:
exec sp_helpsrvrolemember
--���� � � ��
exec sp_helpsrvrolemember

exec sp_addlogin @loginame = 'test3_login_proc',  @passwd='2'

exec sp_adduser 'test3_login_proc', 'test3_loginu_proc'

use [Hospital2]

grant select ON [Hospital2] to test3_loginu_proc

--�������� ����

exec sp_addrole df

grant create table to df

--��������
 
exec sp_helpuser

