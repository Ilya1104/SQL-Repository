use db
go
/*first realisation*/
select count(status_name)as Count_cards_for_status,status_name
from Card_account join Account on Card_account.account_id=Account.acc_id join Social_status on Account.status_id=Social_status.status_id
group by status_name

/*second variant*/

select sS.status_name,
       (select count(*) as cards
        from Card_account cards_acc
             join Account A on A.acc_id = cards_acc.account_id
             join Social_status s on s.status_id = A.status_id
        where sS.status_id = s.status_id) as Count_cards_for_status
from Social_status sS;
 