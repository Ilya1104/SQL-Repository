select Bank.Name,City.Name, Filial.Adress 
from Bank 
join Filial on Bank.Id=Filial.Id 
join City on Filial.CityId=City.Id 
where City.Name = N'Минск'
