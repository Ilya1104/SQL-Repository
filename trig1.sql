USE OMA01;
GO

create trigger checkForActions
on les_usr_ath
after insert, delete, update
as
begin
    if exists (select 1 from inserted) and exists (select 1 from deleted)
    begin
        WITH ins AS (
            SELECT usr_id, col_name, col_value
            FROM (
                SELECT
                    usr_id,
                    CAST(login_id      AS NVARCHAR(255)) AS login_id,
                    CAST(locale_id     AS NVARCHAR(255)) AS locale_id,
                    CAST(usr_sts       AS NVARCHAR(255)) AS usr_sts,
                    CAST(super_usr_flg AS NVARCHAR(255)) AS super_usr_flg,
                    CAST(adr_id        AS NVARCHAR(255)) AS adr_id
                FROM inserted
            ) AS src
            UNPIVOT (col_value FOR col_name IN (
                login_id, locale_id, usr_sts, super_usr_flg, adr_id
            )) AS u
        ),
        del AS (
            SELECT usr_id, col_name, col_value
            FROM (
                SELECT
                    usr_id,
                    CAST(login_id      AS NVARCHAR(255)) AS login_id,
                    CAST(locale_id     AS NVARCHAR(255)) AS locale_id,
                    CAST(usr_sts       AS NVARCHAR(255)) AS usr_sts,
                    CAST(super_usr_flg AS NVARCHAR(255)) AS super_usr_flg,
                    CAST(adr_id        AS NVARCHAR(255)) AS adr_id
                FROM deleted
            ) AS src
            UNPIVOT (col_value FOR col_name IN (
                login_id, locale_id, usr_sts, super_usr_flg, adr_id
            )) AS u
        )
        insert into LogTable (old_value, new_value, user_name_, type_action, datetime_action)
        select
            d.col_value,
            i.col_value,
            SYSTEM_USER,
            N'Обновление',
            GETDATE()
            from ins i
            join del d ON i.usr_id = d.usr_id
                      and i.col_name = d.col_name
            where ISNULL(i.col_value, '') <> ISNULL(d.col_value, '');
    end

    else if exists (select 1 from deleted)
            begin
                insert into LogTable (old_value, new_value, user_name_, type_action, datetime_action)
                select
                    CAST(usr_id AS NVARCHAR(255)), 
                    NULL,
                    SYSTEM_USER,
                    N'Удаление',
                    GETDATE()
                from deleted;
            end

    else
        begin
            insert into LogTable (old_value, new_value, user_name_, type_action, datetime_action)
            select
                null,
                CAST(usr_id AS NVARCHAR(255)),
                SYSTEM_USER,  
                N'Вставка',
                GETDATE()
            from inserted;
        end
end;
--insert into les_usr_ath values ('87654321','87654321',	'GERMANY','A','0',	'A000218858'	,'2020-01-04 13:04:09.237',	'2020-01-04 18:39:40.000')
-- UPDATE les_usr_ath SET login_id='111'  WHERE usr_id = '87654321' 
-- DELETE FROM les_usr_ath WHERE usr_id = '87654321' 
--drop table LogTable
--select * from LogTable
/*
use OMA01
go
CREATE TABLE LogTable (
    log_id INT           IDENTITY(1,1) PRIMARY KEY,
    old_value    NVARCHAR(50) NULL,
    new_value    NVARCHAR(50) NULL,
    user_name_    NVARCHAR(50) NOT NULL,
    type_action  NVARCHAR(50)  NOT NULL,
    datetime_action DATETIME   NOT NULL DEFAULT GETDATE()
);
drop table LogTable
select * from LogTable


SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
*/


