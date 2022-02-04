use db
go
select acc_id,  surname,client_name,patronymic, Account.balance - (sum(Card_account.balance)) as Available_funds
from Client join Account on Client.client_id=Account.client_id join Card_account on Account.acc_id=Card_account.account_id
group by acc_id, Account.balance,surname,client_name,patronymic
