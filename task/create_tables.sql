use db
go
create table Bank
(
	bank_id int primary key identity(1,1),
	bankName nvarchar(50)
)
create table City
(
	city_id int primary key identity(1,1),
	city_name nvarchar(20),
	citizen_count int
)
create table Filial
(
	id_filial int primary key identity(1,1),
	bank_id int not null foreign key references Bank(bank_id),
	city_id int not null foreign key references City(city_id),
	adress nvarchar(30) not null
)
create table Client
(
	client_id int primary key identity(1,1),
	surname nvarchar(20),
	client_name nvarchar(20),
	patronymic nvarchar(20),
	age int check((age > 0) and (age >= 16))  not null,
	phone_number nvarchar(20)
)
create table Social_status
(
	status_id int primary key identity(1,1),
	status_name nvarchar(20)
)
create table Account
(
	acc_id int primary key identity(1,1),
	client_id int not null foreign key references Client(client_id),
	filial_id int not null foreign key references Filial(id_filial),	
	status_id int not null foreign key references Social_status(status_id),
	balance money not null default(0) check(balance >= 0),
	account_number nvarchar(20) not null
)
create table Card_account
(
	card_id int primary key identity(1,1),
	account_id int foreign key references Account(acc_id),
	balance money  not null default(0) check(balance >= 0),
	card_number nvarchar(16) not null
)