use db
go

/*On CardAccount*/
create trigger safety_Card_transfers
on CardAccount
instead of update, insert as
begin
declare
@account_id int = (select CardAccount.AccountId from CardAccount,inserted 
					where inserted.Id=CardAccount.Id),
@transfeer_sum money 

set @transfeer_sum = 
	(select 
		(select sum(CardAccount.balance) 
		from CardAccount join Account on Account.Id=CardAccount.AccountId
		where Account.Id=@account_id and CardAccount.Id != inserted.Id) + inserted.balance 
		from inserted)
			if((select Account.balance 	from Account where Account.Id = @account_id)<@transfeer_sum)
				begin
					print 'Error of transfer'
				end
			else
				begin
					update CardAccount set balance=inserted.balance from inserted where CardAccount.Id = inserted.Id
				end
end


/*On Account*/
create trigger safety_Account_transfers
on Account 
instead of update,insert as
begin 
declare
@transfer_sum money = (select inserted.balance from inserted),
@account_id int = (select inserted.Id from inserted),
@sum_on_cards money = (select sum(CardAccount.balance) from inserted,
CardAccount join Account on Account.Id=CardAccount.AccountId
where Account.Id= inserted.Id)

	if(@sum_on_cards > @transfer_sum)
		begin
			print 'error of transfer'
		end
	else
		begin
			update Account set balance=@transfer_sum where Id=@account_id
		end
end
