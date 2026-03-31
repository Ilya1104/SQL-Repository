use OMA01;
go
create procedure Procedure_2
as
begin
	 declare
        @usr_id         int,
        @login_id       nvarchar(100),
        @locale_id      nvarchar(50),
        @usr_sts        nvarchar(50),
        @super_usr_flg  nvarchar(1),
        @adr_id         nvarchar(200),
        @lst_dat        datetime,
        @lst_logout_dte datetime;

    create table #Temp (
        usr_id          int,
        login_id        nvarchar(100),
        locale_id       nvarchar(50),
        usr_sts         nvarchar(50),
        super_usr_flg   nvarchar(1),
        adr_id          nvarchar(200),
        lst_dat         datetime,
        lst_logout_dte  datetime
    );

   

    begin try 
    declare users cursor for
    select usr_id, login_id, locale_id, usr_sts,super_usr_flg, adr_id, lst_dat, lst_logout_dte
    from les_usr_ath
    where usr_id NOT LIKE '%[^0-9]%';
        open users;
        fetch next from users into
            @usr_id, @login_id, @locale_id, @usr_sts,
            @super_usr_flg, @adr_id, @lst_dat, @lst_logout_dte;

        while @@FETCH_STATUS=0
        begin
            if @usr_id % 3 = 0
            insert into #Temp (usr_id, login_id, locale_id, usr_sts,super_usr_flg, adr_id, lst_dat, lst_logout_dte)
                   values (@usr_id, @login_id, @locale_id, @usr_sts,@super_usr_flg, @adr_id, @lst_dat, @lst_logout_dte);
            fetch next from users into
                @usr_id, @login_id, @locale_id, @usr_sts,
                @super_usr_flg, @adr_id, @lst_dat, @lst_logout_dte;
        end;
        close users;
        deallocate users;
        select * from #Temp
    end try
    begin catch
        print 'Error ' + CONVERT(VARCHAR, ERROR_NUMBER()) + ':' + ERROR_MESSAGE()
    end catch
end

/*	drop table #Temp;
	exec Procedure_2 ;*/
