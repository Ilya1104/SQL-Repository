use db
go
/*first realisation*/
select count(SocialStatus.Name)as Count_cards_for_status,SocialStatus.Name
from CardAccount join Account on CardAccount.AccountId=Account.Id join SocialStatus on Account.StatusId=SocialStatus.Id
group by SocialStatus.Name

/*second variant*/

select sS.Name,
       (select count(*) as cards
        from CardAccount cards_acc
             join Account A on A.Id = cards_acc.AccountId
             join SocialStatus s on s.Id = A.StatusId
        where sS.Id = s.Id) as Count_cards_for_status
from SocialStatus sS; 
