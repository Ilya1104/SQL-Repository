USE OMA01;
GO

create trigger checkForUpdates
on adrmst
after UPDATE
as
begin try
    begin tran;

    if exists (select 1 from inserted) and exists (select 1 from deleted)
    begin
        if exists (select 1 from inserted where ctry_name is null)
        begin
            print 'Oh, no: <ctry_name> is null :(. Rollback tran, sorry!';
            rollback tran; 
            return;
        end;

        SELECT * INTO #ins FROM inserted;
        SELECT * INTO #del FROM deleted;

        DECLARE @query NVARCHAR(MAX);

        set @query = N'WITH ins AS (
            SELECT adr_id, col_name, col_value
            FROM (
                SELECT
                    adr_id,
                    CAST(adrnam     AS NVARCHAR(255)) AS adrnam,
                    CAST(adrtyp     AS NVARCHAR(255)) AS adrtyp,
                    CAST(ctry_name  AS NVARCHAR(255)) AS ctry_name,
                    CAST(last_name  AS NVARCHAR(255)) AS last_name,
                    CAST(first_name AS NVARCHAR(255)) AS first_name,
                    CAST(usr_dsp    AS NVARCHAR(255)) AS usr_dsp
                FROM #ins
            ) AS src
            UNPIVOT (col_value FOR col_name IN (
                adrnam, adrtyp, ctry_name, last_name, first_name, usr_dsp
            )) AS u
        ),
        del AS (
            SELECT adr_id, col_name, col_value
            FROM (
                SELECT
                    adr_id,
                    CAST(adrnam     AS NVARCHAR(255)) AS adrnam,
                    CAST(adrtyp     AS NVARCHAR(255)) AS adrtyp,
                    CAST(ctry_name  AS NVARCHAR(255)) AS ctry_name,
                    CAST(last_name  AS NVARCHAR(255)) AS last_name,
                    CAST(first_name AS NVARCHAR(255)) AS first_name,
                    CAST(usr_dsp    AS NVARCHAR(255)) AS usr_dsp
                FROM #del
            ) AS src
            UNPIVOT (col_value FOR col_name IN (
                adrnam, adrtyp, ctry_name, last_name, first_name, usr_dsp
            )) AS u
        )
        INSERT INTO LogTable (old_value, new_value, user_name_, type_action, datetime_action)
        SELECT
            d.col_value,
            i.col_value,
            SYSTEM_USER,
            N''Обновление'',
            GETDATE()
        FROM ins i
        JOIN del d ON i.adr_id = d.adr_id
                  AND i.col_name = d.col_name
        WHERE ISNULL(i.col_value, '''') <> ISNULL(d.col_value, '''');';




    end;
    exec sp_executesql @query;
    print 'Oh, yeah: tran is completed successfully :). Congratulations!';
    print 'if you ask me, need to inert in LogTable :/';
    commit tran;
end try
begin catch
    rollback tran;
    print 'Ошибка: ' + ERROR_MESSAGE();
end catch;
go
-- UPDATE adrmst SET adrnam='СОСНОВСКИЙ'  WHERE adr_id = 'A000000048' 
--select * from adrmst
--select * from LogTable
/*use OMA01;
go
DROP TRIGGER  checkForUpdates1;*/