use db
go
create table Bank
(
	Id int primary key identity(1,1),
	Name nvarchar(50)
)
create table City
(
	Id int primary key identity(1,1),
	Name nvarchar(50),
	CitizenCount int
)
create table Filial
(
	Id int primary key identity(1,1),
	BankId int not null foreign key references Bank(Id),
	CityId int not null foreign key references City(Id),
	Adress nvarchar(30) not null
)
create table Client
(
	Id int primary key identity(1,1),
	Surname nvarchar(20),
	Name nvarchar(20),
	Patronymic nvarchar(20),
	Age int check((age > 0) and (age >= 16))  not null,
	PhoneNumber nvarchar(20)
)
create table Social_status
(
	Id int primary key identity(1,1),
	Name nvarchar(20)
)
create table Account
(
	Id int primary key identity(1,1),
	ClientId int not null foreign key references Client(Id),
	FilialId int not null foreign key references Filial(Id),	
	StatusId int not null foreign key references Social_status(Id),
	balance money not null default(0) check(balance >= 0),
	Number nvarchar(20) not null
)
create table Card_account
(
	Id int primary key identity(1,1),
	AccountId int foreign key references Account(Id),
	balance money  not null default(0) check(balance >= 0),
	Number nvarchar(16) not null
)
