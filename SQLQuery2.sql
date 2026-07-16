Create Database CSMinimart
Alter Database CSminimart Collate Thai_BIN;
Create Table Employees(
	EmployeesID int identity(1,1) Primary Key,
	title varchar(20) null,
	firstname varchar(50) not null,
	lastname varchar (50),
	Position varchar (50),
	Username varchar (50) Unique,
	PasswordHash varchar (225) not null,
	IsActive BIT not null Default 1
)
INSERT INTO Employees 
   (title, firstname, lastname, Position, Username, PasswordHash)
VALUES 
   ('นางสาว', 'กาญจนา', 'พวงแก้ว', 'Sale Manager', 'user1', 'hashed1');
Select * from Employees

INSERT INTO Employees 
   (title, firstname, lastname, Position, Username, PasswordHash)
VALUES 
   ('นาย', 'นรินทร์', 'ทองศรี', 'Sale Manager', 'user2', 'hashed2');

Create table Categories (
    CategoryID int identity (1,1) Primary key,
    Categoryname varchar(50) not null Unique,
    Description varchar(200)
	);

INSERT INTO Categories (Categoryname, Description)
VALUES   ('เครื่องปรุง', 'ผงชูรส รสดี น้ำตาล');

INSERT INTO Categories (Categoryname, Description)
VALUES   ('เครื่องดื่ม', 'น้ำดื่ม น้ำผลไม้ ชาและกาแฟ');

INSERT INTO Categories (Categoryname, Description)
VALUES   ('อาหารสำเร็จรูป', 'มาม่า ไวไว ยำยำ');

INSERT INTO Categories (Categoryname, Description)
VALUES   ('เครื่องสำอาง', 'ครีมหน้า ครีมตัว ครีมผม');

INSERT INTO Categories (Categoryname, Description)
VALUES   ('เวชภัณฑ์', 'ยาแก้ปวด ยาแก้อักเสบ ยาคลายกล้ามเนื้อ');

select * from Categories

create table products (
    productid varchar(13) Primary key,
    productname varchar(100) not null,
    unitprice decimal(10,2) not null default 0,
    unitsinstock int not null default 0,
    CategoryID int not null,
    discontinued bit not null default 0,

constraint ck_products_unitprice
check (unitprice >= 0),

constraint ck_products_unitsinstock
check (unitsinstock >= 0),

constraint fk_products_Categories
foreign Key (CategoryID)
references Categories(CategoryID)

)


insert into products
    (productid, productname, unitprice, unitsinstock, CategoryID)
values
    ('8858757001948', 'โค้ก', 15.00, 290, 1);
insert into products
    (productid, productname, unitprice, unitsinstock, CategoryID)
values
    ('8854757002011', 'เป๊ปซี่', 15.00, 150, 1);

insert into products
    (productid, productname, unitprice, unitsinstock, CategoryID)
values
    ('8850999111222', 'น้ำปลาแท้', 28.50, 80, 2);

insert into products
    (productid, productname, unitprice, unitsinstock, CategoryID)
values
    ('8850002034056', 'บะหมี่กึ่งสำเร็จรูป รสต้มยำกุ้ง', 7.00, 400, 3);

insert into products
    (productid, productname, unitprice, unitsinstock, CategoryID)
values
    ('8851932371234', 'สบู่ก้อนสูตรเย็น', 45.00, 60, 4);

insert into products
    (productid, productname, unitprice, unitsinstock, CategoryID)
values
    ('8858757009999', 'สินค้าทดสอบ', -10.00, 20, 1)

    select * from products

--สร้างตารางใบเสร็จ
create table receipts (
    receiptID int identity(1,1) Primary Key,
    receiptdate datetime not null
        default getdate(),
    employeeID int not null,
    totalcash decimal(10,2) not null default 0,

    constraint ck_receipts_totalcash
        check (totalcash >= 0),

    constraint fk_receipts_employees
        foreign Key (employeeID)
        references employees(employeesID)
)
-- กล่องสีเขียว: ข้อมูลถูกต้อง
insert into receipts
    (employeeID, totalcash)
values
    (1, 115.00);

select * from receipts;

-- กล่องสีแดง: ข้อมูลผิด (ไม่มี employeeid = 99)
insert into receipts
    (employeeID, totalcash)
values
    (99, 100.00);

create table details (
    receiptid int not null,
    productid varchar(13) not null,
    unitprice decimal(10,2) not null,
    quantity int not null,

    constraint pk_details
        primary key (receiptid, productid),

    constraint ck_details_unitprice
        check (unitprice >= 0),

    constraint ck_details_quantity
        check (quantity > 0),

    constraint fk_details_receipts
        foreign key (receiptid)
        references receipts(receiptid),

    constraint fk_details_products
        foreign key (productid)
        references products(productid)
);