USE OMA01;
GO

create function table_func (
    @startDate datetime
)
returns @result table (
    lst_logout_dte datetime,
    last_name nvarchar(100),
    dateNow datetime
)
as
begin
    insert into @result (lst_logout_dte, last_name, dateNow)
    select
        u.lst_logout_dte,
        a.last_name, 
        SYSDATETIME()
    from les_usr_ath u
    inner join adrmst a on a.adr_id = u.adr_id
    where u.lst_logout_dte BETWEEN @startDate AND SYSDATETIME();
    return;
end;
go


/*
select * from adrmst
select * from les_usr_ath
use OMA01;
go
select * from table_func('2020-01-01');

SELECT * FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_NAME = 'table_func'
  AND ROUTINE_TYPE = 'FUNCTION';*/