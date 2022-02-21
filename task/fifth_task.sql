use db
go
create proc add_10_dolars
@StatusName nvarchar(20)
as
if(exists(select Name from SocialStatus where lower(Name)=lower(@StatusName)))
	begin
		select Client.Name, Patronymic, Surname, SocialStatus.Name, (balance) as [Sum before transfer], (balance+10) as [Sum after transfer] 
		from Client join Account on Client.Id=Account.ClientId join SocialStatus on Account.StatusId = SocialStatus.Id
		where SocialStatus.Name=@StatusName
		update Account set Account.balance+=10
		from Account join SocialStatus on SocialStatus.Id=Account.StatusId
		where SocialStatus.Id=Account.StatusId and SocialStatus.Name=@StatusName
		print 'Execution is successful !'
	end
else
	begin
		print 'Status "'+ @StatusName +'" not found'
	end

exec add_10_dolars @StatusName = 'пенсионер'
exec add_10_dolars @StatusName = 'РабоТАЮщий'
exec add_10_dolars @StatusName = 'твмлытмл'
