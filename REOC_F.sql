-- Segment
CREATE TABLE Segment (
    segment_id INT IDENTITY(1,1) PRIMARY KEY,
    segment_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX) NULL,
	target_income_range NVARCHAR(100) NULL
);
GO

-- Customer
CREATE TABLE Customer (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    gender NVARCHAR(10) NULL,
    age INT NULL CHECK (age >= 0),
    phone NVARCHAR(20) NULL UNIQUE,
	email NVARCHAR(100) NULL,
    avg_income DECIMAL(12,2) NULL,
    customer_type NVARCHAR(30) NULL,
	is_ReferenceOnly CHAR(1) DEFAULT 'F' CHECK (is_ReferenceOnly IN ('T','F')),
    segment_id INT NULL,
	Employee_id INT NULL,
    CONSTRAINT FK_Customer_Segment FOREIGN KEY (segment_id) REFERENCES Segment(segment_id),
	CONSTRAINT FK_Employee_Customer FOREIGN KEY (Employee_id) REFERENCES Employee (Employee_id)
);
GO

-- Owner
CREATE TABLE Owner (
    owner_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(50) NULL,
    last_name NVARCHAR(50) NULL,
    address NVARCHAR(200) NULL,
    phone NVARCHAR(20) NULL,
    email NVARCHAR(100) NULL,
    type NVARCHAR(50) NULL,
    registration_date DATE NULL,
	unit_id INT NULL,
	CONSTRAINT FK_Owner_Unit FOREIGN KEY (unit_id) REFERENCES Unit(unit_id)
);

GO

-- Unit 
CREATE TABLE Unit(
    unit_id INT IDENTITY(1,1) PRIMARY KEY,
    type NVARCHAR(50) NULL,
    area DECIMAL(10,2) NULL,
    status NVARCHAR(20) NULL,
    price DECIMAL(18,2) NULL,
    location NVARCHAR(200) NULL,
    floor_number INT NULL,
    transaction_id INT NULL,
    customer_id INT NULL,
	portfolio_id INT NULL,
    --CONSTRAINT FK_Unit_Transactions FOREIGN KEY (transaction_id) REFERENCES Transactions (transaction_id),
	--CONSTRAINT FK_Unit_Customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
	CONSTRAINT FK_Unit_Portfolio FOREIGN KEY (portfolio_id) REFERENCES Portfolio(portfolio_id)
	--PRIMARY KEY (transaction_id,customer_id)
);
GO

ALTER TABLE Unit
ADD CONSTRAINT FK_Unit_Transactions 
FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id);
GO

ALTER TABLE Unit
ADD CONSTRAINT FK_Unit_Customer 
FOREIGN KEY (customer_id) REFERENCES Customer(customer_id);
GO
----------------------------------
--Anthor Adding 
ALTER TABLE Unit
ADD monthly_rent DECIMAL(18,2);


-- Payment_Method
CREATE TABLE Payment_Method (
    payment_method_number INT IDENTITY(1,1) PRIMARY KEY,
    type NVARCHAR(50) NULL
);

GO

-- Contractor
CREATE TABLE Contractor (
    contractor_id INT IDENTITY(1,1) PRIMARY KEY,
    contractor_name NVARCHAR(100) NULL,
    phone NVARCHAR(20) NULL,
    email NVARCHAR(100) NULL,
    project_cost DECIMAL(18,2) NULL,
    start_date DATE NULL,
    end_date DATE NULL,
    project_count INT NULL,
    payment_terms NVARCHAR(200) NULL,
	project_id INT NULL,
	CONSTRAINT FK_Contractor_Project FOREIGN KEY (project_id) REFERENCES Project(project_id)
);

GO

-- Project
CREATE TABLE Project (
    project_id INT IDENTITY(1,1) PRIMARY KEY,
    project_name NVARCHAR(100) NULL,
    start_date DATE NULL,
    end_date DATE NULL,
    location NVARCHAR(200) NULL,
	unit_id INT NULL,
	CONSTRAINT FK_Project_Unit FOREIGN KEY (unit_id) REFERENCES Unit(unit_id)
);
GO

-- ÑÈØ Owner - Unit (ÌÏæá æÓíØ)
CREATE TABLE Owner_Ship (
    Owner_id INT NOT NULL,
    Unit_id INT NOT NULL,
    PRIMARY KEY (Owner_id, Unit_id),
    CONSTRAINT FK_PC_Owner FOREIGN KEY (Owner_id) REFERENCES Owner(Owner_id),
    CONSTRAINT FK_PC_Unit FOREIGN KEY (Unit_id) REFERENCES Unit(Unit_id)
);
GO

-- Investor 
CREATE TABLE Investor (
    investor_id INT IDENTITY(1,1) PRIMARY KEY,
    investor_name NVARCHAR(100) NULL,
    phone NVARCHAR(20) NULL,
    email NVARCHAR(100) NULL,
    company_name NVARCHAR(100) NULL,
	portfolio_id INT NULL,
	CONSTRAINT FK_Investor_Portfolio FOREIGN KEY (portfolio_id) REFERENCES Portfolio (portfolio_id)
);
GO

--Portfolio
CREATE TABLE Portfolio (
    portfolio_id INT IDENTITY(1,1) PRIMARY KEY,
    portfolio_name NVARCHAR(100) NULL,
    description NVARCHAR(MAX) NULL,
    Due_Date DATE NULL,
	Fine_Amount DECIMAL(10,2) NULL DEFAULT 0
    
);

----- Drop Portfolio coulm
ALTER TABLE Portfolio
DROP CONSTRAINT DF__Portfolio__Fine___4316F928;
------------------------------------------------------------------
ALTER TABLE Portfolio
DROP COLUMN Fine_Amount;

-- Add Portfolio 2 coulm
ALTER TABLE Portfolio
ADD escrow DECIMAL(10,2),
    estate_cost DECIMAL(10,2);

GO

-- Employee
CREATE TABLE Employee (
    Employee_id INT IDENTITY(1,1) PRIMARY KEY,
    Employee_name NVARCHAR(100) NULL,
	role  NVARCHAR(20) NULL,
    phone NVARCHAR(20) NULL,
    email NVARCHAR(100) NULL,
	project_id INT NULL,
	CONSTRAINT FK_Employee_Project FOREIGN KEY (project_id) REFERENCES Project(project_id)
);
GO

-- Transactions 
CREATE TABLE Transactions (
    transaction_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NULL,
    transaction_date DATE NULL,
    amount DECIMAL(18,2) NULL CHECK (amount > 0),
    tax DECIMAL(10,2) NULL DEFAULT 0,
    discount_amount DECIMAL(10,2) NULL DEFAULT 0,
    payment_status NVARCHAR(50) NULL CHECK (payment_status IN ('Paid', 'Pending', 'Cancelled')),
    transaction_type NVARCHAR(50) NULL,
    customer_id INT NULL,
    payment_method_number INT NULL,
    employee_id INT NULL,
    CONSTRAINT FK_Trans_Customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CONSTRAINT FK_Trans_Payment FOREIGN KEY (payment_method_number) REFERENCES Payment_Method(payment_method_number),
    CONSTRAINT FK_Trans_Employee FOREIGN KEY (Employee_id) REFERENCES Employee(Employee_id)
);
GO



