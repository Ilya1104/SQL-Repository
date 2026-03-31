select  adrmst.adr_id,right(login_id,3)  as '3_characters_login', concat(adrtyp,' - ',last_name,' ', left(first_name,1),'.' ) as 'description'
from adrmst inner join les_usr_ath ON adrmst.adr_id = les_usr_ath.adr_id
where login_id NOT LIKE '%[^0-9]%'