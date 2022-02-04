select card_number, Card_account.balance, surname,client_name, patronymic,bankName, adress
from Client,Account,Filial,Bank,Card_account
where Bank.bank_id=Filial.bank_id and Filial.id_filial=Account.filial_id and Account.client_id=Client.client_id and Account.acc_id=Card_account.account_id

 
