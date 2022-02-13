select Bank.Name,City.Name, Filial.Adress 
from Bank 
join Filial on Bank.Id=Filial.Id 
join City on Filial.CityId=City.CityId 
where City.Name = 'Ìèíñê'
