use OMA01;
go
create procedure Procedure_1
@table_name nvarchar(50) ,@usr_id nvarchar(50)
as
  if OBJECT_ID(@table_name) is null
   begin
        print 'table <'+@table_name+'> not  exists. Start creating.';
        declare @queryCreating nvarchar(MAX);

        set @queryCreating = N'
            create table ' + QUOTENAME(@table_name) + N' (
                id int identity(1,1) primary key,
                first_name nvarchar(100),
                last_name nvarchar(100),
                date_action datetime2,
                 usr_id nvarchar(100) not null
            );
            insert into ' + QUOTENAME(@table_name) + N' (date_action, usr_id)
            values (getdate(), ''' + @usr_id + N''');
        ';

        exec sp_executesql @queryCreating;
    end    


   else
    begin
        print 'Table <'+@table_name+'> already exists. Start updating';
        declare @createdFirstName nvarchar(100), 
                @createdLastName nvarchar(100);

        declare @querySelect nvarchar(MAX), 
                @params nvarchar(MAX);

        set @querySelect = N'select @out_first = first_name,@out_last = last_name
                             from ' + QUOTENAME(@table_name) + N'
                             where usr_id = @usr_id';

        set @params = N'@usr_id nvarchar(50),
                        @out_first nvarchar(100) output,
                        @out_last  nvarchar(100) output';
        exec sp_executesql @querySelect,@params,@usr_id= @usr_id,@out_first = @createdFirstName output, @out_last  = @createdLastName  output;
        if (QUOTENAME(@createdFirstName) is null and QUOTENAME(@createdLastName)is null)
            begin
                 print 'First name and last not exists . Start updating names';
                 declare @firstNameFromId nvarchar(100), 
                         @lastNameFromId nvarchar(100);
                 declare @queryGetNames nvarchar(MAX), 
                         @insertingParams nvarchar(MAX);

                set @queryGetNames = N'select @out_first = first_name,
                                              @out_last  = last_name
                                       FROM adrmst INNER JOIN les_usr_ath ON adrmst.adr_id = les_usr_ath.adr_id
                                       WHERE les_usr_ath.usr_id = @usr_id';

                set @insertingParams = N'@usr_id    nvarchar(50),
                                         @out_first nvarchar(100) output,
                                         @out_last  nvarchar(100) output';

                exec sp_executesql  @queryGetNames,
                                    @params,
                                    @usr_id = @usr_id,
                                    @out_first = @firstNameFromId output,
                                    @out_last  = @lastNameFromId  output;

                declare @queryInserting nvarchar(MAX);
                set @queryInserting = N'insert into ' + QUOTENAME(@table_name) + N' (first_name, last_name, date_action, usr_id)
                                        values (@first_name, @last_name, getdate(), @usr_id);';

                exec sp_executesql @queryInserting,
                                   N'@first_name nvarchar(100), @last_name nvarchar(100), @usr_id nvarchar(50)',
                                   @first_name = @firstNameFromId,
                                   @last_name = @lastNameFromId,
                                   @usr_id = @usr_id;
            end
        else
            begin
                print 'First name and last already exists. Start updating action date';
                /* print 'First name: '+QUOTENAME(@createdFirstName)+' Last name: '+QUOTENAME(@createdLastName);*/
                    declare @queryUpdating nvarchar(MAX);
                    set @queryUpdating = N'
                        update ' + QUOTENAME(@table_name) + N'
                        set date_action = getdate()
                        where usr_id = ''' + @usr_id + N''';';

                    exec sp_executesql @queryUpdating;
            end
end

    /*	use OMA01
	
	exec Procedure_1 @table_name= 'test', @usr_id='0106822'*/