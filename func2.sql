use OMA01
go
create function f_columnsCnt (@tableName nvarchar(128))
returns int
as
begin
	declare @columnCount int;
	select @columnCount = count(*)
	from INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME = @tableName;
	return @columnCount
end;


-- функция и так при каждом вызове считает количество столбцов

/*
use OMA01
go
SELECT dbo.f_columnsCnt('les_usr_ath') AS Result;*/