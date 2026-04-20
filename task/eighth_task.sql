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
			begin tran
			if((select Account.balance 	from Account where Account.Id = @account_id)<@transfeer_sum)
				begin
					print 'Error of transfer'
					rollback tran
				end
			else
				begin
					update CardAccount set balance=inserted.balance from inserted where CardAccount.Id = inserted.Id
					commit tran
				end
end


/*On Account*/
create trigger safety_Account_transfers
on Account 
instead of update,insert as
begin
declare 
        @accountId int,
	@updatedBalance money,
        @accountBalanceOnCards money
		
declare	cursorId cursor for 
select Id from inserted
	open cursorId
		fetch next from cursorId into @accountId
		while @@FETCH_STATUS = 0
			begin
				set @updatedBalance  =  (select inserted.balance from inserted where inserted.Id=@accountId)
				if (@accountBalanceOnCards > @updatedBalance)
					begin
						print 'Error of transfer'
					end
				else
					begin
						update Account
						set balance = @updatedBalance
						where Account.id = @accountId
					end
				fetch next from cursorId into @accountId
			end
	close cursorId
	deallocate cursorId
end
