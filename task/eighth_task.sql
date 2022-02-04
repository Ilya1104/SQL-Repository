use db
go
/*On Account*/

create trigger safety_Account_transfers
on Account 
instead of update,insert as
begin 
declare
@transfer_sum money = (select inserted.balance from inserted),
@account_id int = (select inserted.acc_id from inserted),
@sum_on_cards money = (select sum(Card_account.balance) from inserted,
Card_account join Account on Account.acc_id=Card_account.account_id
where Account.acc_id= inserted.acc_id)
	begin tran
		begin try
			if(@sum_on_cards > @transfer_sum)
				begin
					print 'error of transfer'
				end

			else
				begin
					update Account set balance=@transfer_sum where acc_id=@account_id
				end
		end try

		begin catch
				rollback tran
				select error_message() as Error
				return
		end catch
	commit tran	
end

/* On Card_account*/

create trigger safety_Card_transfers
on Card_account
instead of update, insert as
begin
	declare
	@account_id int = (select Card_account.account_id from Card_account,inserted 
	where inserted.card_id=Card_account.card_id),
	@transfeer_sum money 

	set @transfeer_sum = 
	(select 
		(select sum(Card_account.balance) 
		from Card_account join Account on Account.acc_id=Card_account.account_id
		where Account.acc_id=@account_id and Card_account.card_id != inserted.card_id) + inserted.balance 
		from inserted)
	begin tran	
		begin try
			if((select Account.balance 	from Account where Account.acc_id = @account_id)<@transfeer_sum)
				begin
					print 'Error of transfer'
				end
			else
				begin
					update Card_account set balance=@transfeer_sum from inserted where Card_account.card_id = inserted.card_id
				end
		end try

		begin catch
			rollback tran
			select error_message() as Error
			return
		end catch
	commit tran
end
