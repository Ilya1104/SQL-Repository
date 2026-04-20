select CardAccount.Number, CardAccount.balance, Client.Surname,Client.Name, Patronymic,Bank.Name, Adress
from Client,Account,Filial,Bank,CardAccount
where Bank.Id=Filial.BankId and Filial.Id=Account.FilialId and Account.ClientId =Client.Id and Account.Id=CardAccount.AccountId
