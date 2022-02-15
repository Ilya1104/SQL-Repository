use db
go
create proc Safe_money_transfer
@transfer_sum int,
@number_of_card nvarchar(16)
as
begin tran
		if(exists(select Number from CardAccount where Number=@number_of_card))
			begin		
			select (Account.balance) as [Account balance],
				(Account.balance-@transfer_sum) as [Account balance after transfer],
				(CardAccount.balance) as [Card balance before transfer],
				(CardAccount.balance+@transfer_sum) as [Card balance after transfer]
				from Account join CardAccount on Account.Id=CardAccount.AccountId
				where CardAccount.Number = @number_of_card		
				update CardAccount set CardAccount.balance +=@transfer_sum where Number=@number_of_card
				update Account set Account.balance -=@transfer_sum 
				from Account join CardAccount on Account.Id=CardAccount.AccountId where CardAccount.Number=@number_of_card
			end
		else 
			begin
				print 'Wrong number of card'
			end 
commit tran
