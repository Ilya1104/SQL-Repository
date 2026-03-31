use OMA01;
go
create procedure Procedure_3
as
begin
	 declare @newAdrmst table (
     adr_id_cor	nvarchar(50),
     adrnam_cor	nvarchar(50),
     ctry_name_cor nvarchar(50)
     );

    declare  @correct_adr_id nvarchar(50),
    @correct_adrnam nvarchar(50),
    @correct_ctry_name nvarchar(50), 
    @stopTrigger int = 0,
    @char nchar(1);

    declare users cursor for
    select adr_id, adrnam, ctry_name
    from adrmst;

    open users;
    fetch next from users into @correct_adr_id,@correct_adrnam,@correct_ctry_name;
    declare @prefixCounter int = 1;
    while @@FETCH_STATUS=0
        begin
        if @correct_ctry_name is null
            set @correct_ctry_name='BLR'
        set @stopTrigger = 0;
        set @prefixCounter = 1;
            while @stopTrigger = 0
            begin
            
                if (SUBSTRING(@correct_adr_id, @prefixCounter, 1) like '%[A-Za-zА-Яа-я]%') or (SUBSTRING(@correct_adr_id, @prefixCounter, 1) = '0')
                begin 
                 SET @char = SUBSTRING(@correct_adr_id, @prefixCounter, 1);
                    set @prefixCounter +=1;
                end;

                else
                    begin 
                       set @stopTrigger +=1;
                    end;
            end;


            if (@correct_adrnam like '%[0-9]%') and (@correct_adrnam like '[A-Za-zА-Яа-я]')
                 insert into @newAdrmst values (SUBSTRING(@correct_adr_id, @prefixCounter, LEN(@correct_adr_id)), 'Other', @correct_ctry_name)
            else
                if  (@correct_adrnam like '%[0-9]%')
                    begin
                    insert into @newAdrmst values (SUBSTRING(@correct_adr_id, @prefixCounter, LEN(@correct_adr_id)), 'Number', @correct_ctry_name)
                    end
                else
                    insert into @newAdrmst values (SUBSTRING(@correct_adr_id, @prefixCounter, LEN(@correct_adr_id)), 'Letter', @correct_ctry_name)
            fetch next from users into @correct_adr_id,@correct_adrnam,@correct_ctry_name;
        end;
        close users;
        deallocate users;
        select * from @newAdrmst;
end

/*	select * from adrmst
	exec Procedure_3 ;*/
