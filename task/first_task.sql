select bankName,city_name, adress 
from Bank 
join Filial on Bank.bank_id=Filial.bank_id 
join City on Filial.city_id=City.city_id 
where city_name = 'Минск'