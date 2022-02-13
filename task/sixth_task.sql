use db
go
select Account.Id,  Client.Surname,Client.Name,Client.Patronymic, Account.balance - (sum(CardAccount.balance)) as Available_funds
from Client join Account on Client.Id=Account.ClientId join CardAccount on Account.Id=CardAccount.AccountId 
group by Account.Id, Account.balance,Client.Surname,Client.Name,Client.Patronymic
