--Lab ในชั้นเรียนวันที่ 6 สืงหาคม 2569
--ใช้ ฐานข้อมูล Northwind เพื่อ Query ข้อมุลต่อไปนี้

--1.ต้องการ คำนำหน้า ชื่อ นามสกุล พนักงาน ที่อยู่ในเมือง London
select titleOfCourtesy,Firstname,lastname, from Employees where city = 'london'

--2.ข้อมูล รหัสสินค้า ชื่อสินค้า ราคา จำนวน ของสินค้าที่มีจำนวนน้อยกว่า 30
select ProductID,
ProductName,
Unitprice,
UnitsInStock from Products
where
Unitprice < 30
--3.รหัสลูกค้า ชื่อบริษัท เบอร์โทรศัพท์ ของลูกค้าที่อยู่ในประเทศต่อไปนี้
--Sweden, Germany, France, Spain, UK
select customerID,companyname,phone from customers where contry in ('sweden','germany','france','spain','uk');
--4.ข้อมูลลูกค้าที่ไม่มีหมายเลขโทรสาร (Fax)
select * from Customers where Fax is null;
--5.ข้อมูลสินค้าที่มีจำนวนสินค้าต่ำกว่าจุดสั่งซื้อ และ มีจำนวนที่สั่งซื้อแล้ว
select * from Products where UnitsInStock < ReorderLevel And UnitsOnOrder > 0;
--6.ชื่อ นามสกุล พนักงานที่เข้าทำงานในปี 1992
select Firsname,LastName from Employees where YEAR(HireDate) = 1992
--7.ต้องการข้อมูลสินค้าที่มีราคาตั้งแต่ 20-70
select * from Products where UnitPrice between 20 and 70;
--8.ข้อมูลลูกค้าที่มีชื่อบริษัทขึ้นต้นด้วย S และอยู่ประเทศ Mexico
select customerID, companyname,country from dbo.Customers like 's%' and country = 'mexico';
--9.ข้อมูลลูกค้าที่มีตำแหน่งของผู้ที่ประสารงานเป็น manager 
select * from Customers where ContactTitle like 'manager%'
