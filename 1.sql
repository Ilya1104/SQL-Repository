	select locale_id,max(cast(lst_dat as time)) as max_time, usr_sts, count(usr_id) as qty_row 
	from les_usr_ath
	where locale_id = 'RUSSIAN' and usr_sts='A'
		group by  locale_id, usr_sts

		