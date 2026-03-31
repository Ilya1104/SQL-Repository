select login_id, usr_sts, first_name, last_name, count(wh_id) as wh_ids
from adrmst inner join les_usr_ath ON adrmst.adr_id = les_usr_ath.adr_id inner join
                         usropr ON les_usr_ath.usr_id = usropr.usr_id
where super_usr_flg=0 and locale_id='RUSSIAN'
group by login_id,usr_sts,first_name,last_name,wh_id