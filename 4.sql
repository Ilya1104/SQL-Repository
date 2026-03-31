select usr_id, convert(int,login_id)*2 as login_id_x2,
format(dateadd(year,1,lst_dat), 'dd.MM.yyyy') as lst_dat_correct,
format(dateadd(day,-14,lst_logout_dte),'dd-MM-yyyy') as lst_logout_dte_correct
from les_usr_ath
where login_id NOT LIKE '%[^0-9]%'