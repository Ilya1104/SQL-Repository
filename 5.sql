SELECT ROW_NUMBER() over (order by usr_id desc) as row_id, first_name, last_name, lst_logout_dte
FROM adrmst inner join les_usr_ath 
ON adrmst.adr_id = les_usr_ath.adr_id
where (LEFT(last_name,1) between 'А' and 'Е') 
and (right(last_name,2) !='ИЧ') 
and (DATEPART(dw, lst_logout_dte)!=2)