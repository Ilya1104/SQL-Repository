use db
go
create proc add_10_dolars1 as
update Account set Account.balance = Account.balance+10
from Account join Social_status on Social_status.status_id=Account.status_id
where Social_status.status_id=Account.status_id