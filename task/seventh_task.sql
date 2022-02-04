use db
go
create proc Secure_money_transfer 
@transfer_sum int,
@number_of_card nvarchar(16)
as
	begin try
begin tran
		if(exists(select card_number from Card_account where card_number=@number_of_card))
			begin			
				select (Account.balance) as [Account balance],
				(Account.balance-@transfer_sum) as [Account balance after transfer],
				(Card_account.balance) as [Card balance before transfer],
				(Card_account.balance+@transfer_sum) as [Card balance after transfer]
				from Account join Card_account on Account.acc_id=Card_account.account_id
				where card_number = @number_of_card 
				update Card_account set Card_account.balance = Card_account.balance+@transfer_sum
				from Account join Card_account on Account.acc_id=Card_account.account_id
				update Account set Account.balance =Account.balance-@transfer_sum
			end
		else 
			begin 
				print 'Wrong number of card'
			end 
	end try
	
	begin catch
		rollback tran
		select error_message() as Error
		return
	end catch
commit tran
