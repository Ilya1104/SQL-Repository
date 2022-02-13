use db
go
create proc add_10_dolars
@StatusName nvarchar(20)
as
if(exists(select Name from SocialStatus where lower(Name)=lower(@StatusName)))
	begin
		update Account set Account.balance+=10
		from Account join SocialStatus on SocialStatus.Id=Account.status_id
		where Social_status.status_id=Account.StatusId  and SocialStatus.Name=@StatusName
		print 'Execution is successful !'
	end
else
	begin
		print 'Status "'+ @StatusName +'" not found'
	end
