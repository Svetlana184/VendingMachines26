/*create table Users(
	IdUser nvarchar(300) not null primary key,
	Image nvarchar(max),
	FullName nvarchar(500) not null,
	IsManager bit not null,
	IsEngineer bit not null,
	Phone nvarchar(50) not null,
	IsOperator bit not null,
	Role nvarchar(100) not null,
	Email nvarchar(300) not null,
	Password ntext,
	Login nvarchar(200)
);*/

create table VendingMachines(
	IdVendingMachine nvarchar(300) not null primary key,
	SerialNumber int unique not null,
	Name nvarchar(200),
	IdUser nvarchar(300),
	RfidCash nvarchar(100),
	Notes ntext,
	Location ntext,
	WorkMode nvarchar(100),
	RfidLoading nvarchar(100),
	Model nvarchar(200),
	KitOnlineId nvarchar(200) unique not null,
	Company nvarchar(200),
	CriticalThresholdTemplate nvarchar(200),
	ServicePriority nvarchar(200),
	Manager nvarchar(300),
	Status nvarchar(50) not null check (Status in 
	('Работает', 'Сломан', 'Обслуживается')),
	NotificationTemplate nvarchar(50),
	WorkingHours nvarchar(50),
	Engineer nvarchar(300),
	CreatedDate datetime,
	AddDate datetime,
	Place nvarchar(100),
	Operator nvarchar(100),
	Technician nvarchar(300),
	RfidService nvarchar(100),
	Coordinates ntext,
	TotalIncome decimal default 0.00 check 
	(TotalIncome is null or TotalIncome >= 0),
	Timezone nvarchar(40),
	Country NVARCHAR(100) check (Country is null 
	or Country in ('Россия', 'Китай')),


	InstallDate datetime,
	LastMaintenanceDate datetime,
    MaintenanceHours INT,
	InventarizationDate datetime,
	HoursResourse int check (HoursResourse is null or 
	(HoursResourse >= 0)),
	VerificationIntervalMonths int,
	LastVerificationDate date,

	constraint chk_InstallDate check (
		InstallDate >= CreatedDate
	),
	constraint chk_LastMaintenanceDate check (
		LastMaintenanceDate is null or 
		(CreatedDate <= LastMaintenanceDate and LastMaintenanceDate <= getdate())
	),
	constraint chk_MaintenanceHours check (
		MaintenanceHours IS NULL OR 
	(MaintenanceHours >= 1 AND MaintenanceHours <= 20)
	),
	constraint chk_InventarizationDate check (
		InventarizationDate is null or 
	(CreatedDate <= InventarizationDate and InventarizationDate <= getdate())
	)

);

ALTER TABLE VendingMachines
ADD NextVerificationDate AS 
    CASE 
        WHEN LastVerificationDate IS NOT NULL AND VerificationIntervalMonths IS NOT NULL 
        THEN DATEADD(MONTH, VerificationIntervalMonths, LastVerificationDate)
        ELSE NULL
    END;

create table Products(
	IdProduct nvarchar(300) not null primary key,
	Name nvarchar(300) not null,
	Price decimal not null,
	Description ntext,
	MinStock int not null,
	VendingMachineId nvarchar(300) not null,
	QuantityAvaliable int not null,
	SalesTrend float
);

create table Sales(
	IdSale int identity(1,1) not null primary key,
	IdProduct nvarchar(300) not null,
	Quantity int not null,
	Timestamp date not null,
	TotalPrice decimal not null,
	PaymentMethod nvarchar(100) not null
);

create table Maintenances(
	IdMaintenance int identity(1,1) not null primary key,
	IdVendingMachine nvarchar(300) not null,
	IssuesFound ntext,
	IdUser nvarchar(300) not null,
	WorkDescription ntext
);