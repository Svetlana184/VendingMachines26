create table Users(
	user_id nvarchar(200) primary key,
	email nvarchar(100) not null,
	full_name nvarchar(500) not null,
	is_manager bit,
	is_engineer bit,
	phone nvarchar(20),
	is_operator bit,
	role nvarchar(100) not null,
	image varbinary(max)
);

create table Products(
	product_id nvarchar(200) primary key,
	name nvarchar(300) not null,
	price decimal not null,
	min_stock int not null,
	vending_machine_id nvarchar(300) not null,
	description ntext,
	quantity_available int,
	sales_trend decimal
);

create table Sales(
	sale_id int identity(1,1) primary key,
	timestamp datetime not null,
	product_id nvarchar(200) not null,
	quantity int not null,
	payment_method nvarchar(100) not null check (payment_method in 
	('Наличные', 'Карта', 'Qr-код' ))
);

create table Maitenances(
	maitenance_id int identity(1,1) primary key,
	date datetime,
	issues_found nvarchar(500),
	vending_machine_id nvarchar(300),
	user_id nvarchar(200),
	work_description ntext
);

create table VendingMachines(
	vending_machine_id nvarchar(300) primary key,
	serial_number int unique not null,

	invent_number int unique,

	name nvarchar(200),
	user_id nvarchar(200),
	rfid_cash nvarchar(100),
	notes ntext,
	location ntext,
	work_mode nvarchar(200),
	rfid_loading nvarchar(200),
	model nvarchar(200) not null,
	kit_online_id nvarchar(200),
	company nvarchar(200),
	payment_method nvarchar(200),
	critical_threshold_template nvarchar(200),
	service_priority nvarchar(200),
	manager nvarchar(200),
	status nvarchar(200),
	notification_template nvarchar(200),
	working_hours nvarchar(200),
	engineer nvarchar(200),

	create_date datetime not null,

	install_date datetime,
	place nvarchar(200),
	operator nvarchar(200),
	technician nvarchar(200),
	last_maintenance_date datetime,

	maitanence_interval int,
	hours_resourse int 
	check (hours_resourse is null or hours_resourse>=0),
	maitanence_time int 
	check (maitanence_time is null or 
	(maitanence_time>=1 and maitanence_time <= 20)),
	country nvarchar(200),
	invent_date datetime,

	rfid_service nvarchar(200),
	coordinates nvarchar(200),
	total_income decimal,
	timezone nvarchar(200),

	constraint check_install_date check (
		install_date is null or install_date >= create_date
		),
	constraint check_last_maintenance_date check (
		last_maintenance_date is null or 
		(last_maintenance_date >= create_date 
		and last_maintenance_date <= getdate())
	),
	constraint check_invent_date check (
		invent_date is null or invent_date<=getdate()
	),
);

alter table VendingMachines
add next_maintenance_date as
case 
when last_maintenance_date is not null and 
maitanence_interval is not null 
then dateadd(month, maitanence_interval, last_maintenance_date)
else null
end;