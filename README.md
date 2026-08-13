-- Lab ในชั้นเรียนวันที่ 13 สิงหาคม 2569
--ใช้ฐานข้อมูล Northwind
--1. ต้องการข้อมูล รหัสใบสั่งซื่อ ยอดเงินรวมที่หักส่วนลดแล้ว จากแต่ละใบสั่ง ทั้งหมด เรียงลำดับตามยอดเงิน จากมากไปน้อย
select OrderId, Format(sum(UnitPrice * Quantity*(1 -Discount)),'N2')as TotalCash
from [Order Details]
group by orderID
order by sum(UnitPrice * quantity*(1 -Discount)) Desc
--วิธีที่2 ชิลๆ
select OrderId, Format(sum(UnitPrice * Quantity*(1 -Discount)),'N2')as TotalCash
from [Order Details]
group by orderID
order by 2 Desc

--2. ต้องการ ชื่อประเทศ ของผู้แทนจำหน่าย ( suppliers) และจำนวนผู้แทนจำหน่วยในแต่ละประเทศ
--  แสดงมาเฉพาะรายชื่อที่ผู้แทนจำหน่ายมีมากกว่า 1 ราย
select Country,count(*) TotalSuppliers
from Suppliers
group by country
having count (*)>1

--3. รหัสสินค้า จำนวนรวมทั้งหมดที่รายได้ ราคาสูงสุดที่รายได้ ราคาต่ำสุดที่ขายได้
--   แสดงเฉพาะสินค้าที่ขายได้รวมมากกว่า 1500 ชื้น
select ProductID , sum(Quantity) TotalQuantity
from [Order Details]
group by ProductID
having sum(quantity) > 1500
order by sum(Quantity) Desc
--เพิ่มเติมข้อ3 ต้องการเฉพาะ จำนวนสินค้าที่ไม่มีส่วนลด
select ProductID , sum(Quantity) TotalQuantity
from [Order Details]
where Discount >0
group by ProductID
having sum(Quantity)>500
order by ProductID

--  การQuery ข้อมูล จากหลายตาราง ( join Table)

select * from Products
select * from Categories
--Inner Join
select *
from products inner join Categories
			  on products.categoryID = Categories.CategoryID
--ตัวอย่าง ต้องการชื่อหมวดหมูสินค้า รหัาสินค้า ชื่อสินค้า ราคา โดยเรียงลำดับตามหมวดหมูสินค้า และ ราคาสูงไปต่ำ
select products.CategoryID, CategoryName,ProductID, ProductName,UnitPrice
from products inner join Categories
			  on products.categoryID = Categories.CategoryID
order by CategoryID asc ,UnitPrice desc
--แบบที่2 ย่อเฉยๆ 
select p.CategoryID, CategoryName,ProductID, ProductName,UnitPrice
from products as p inner join Categories as c
			  on p.categoryID = C.CategoryID
order by CategoryID asc ,UnitPrice desc

--ต้องการชื่อผู้รับผิดชอบการสั่งซื้อแต่ละรายการ
select * from Orders
select * from Employees
--รหัสใบสั่งซื้อ วันที่สั่งซื้อ วันที่รับสินค้า ประเทศปลายทาง ชื่อ-นามสกุล พนักงานผู้รับผิดชอบ
select o.OrderID,format(o.OrderDate,'d', 'en-gb') as [Order Date],
			format(o.ShippedDate,'d', 'en-gb') as [Shipped Date],
			o.ShipCountry ,
	e.FirstName + space(2) + e.LastName SaleMan
from Orders o inner join  Employees e on o.EmployeeID = e.EmployeeID

--ตัวอย่าง ต้องการรหัสหมวดหมู่ ชื่อหวมดหมู่สินค้า รหัาสินค้า ราคา ประเทศสินค้า
--โดยเรียงลำดับตามประเทศ และ ราคาสูงไปต่ำ และ สินค้ามาจากประเทศ USA MEXICO CANADA
select c.CategoryID, c.CategoryName, p.ProductID,p.ProductName,p.UnitPrice, s.Country
from Products p inner join Categories c on p.CategoryID = c.CategoryID
				inner join Suppliers  s on p.SupplierID = s.SupplierID
where s.Country in ('USA','Mexico','Canada')
order by Country
--
select * from Products
select * from Categories
select * from Shippers


--แบบฝึกหัดการ Join ตาราง

-- 1. ต้องการ รหัสบริษัทขนส่ง, ชื่อบริษัทขนส่ง, จำนวนใบสั่งซื้อที่เกี่ยวข้อง, ยอดรวมค่าขนส่ง
select s.SupplierID,CompanyName, count(*) totalOrders, sum(o.Freight) sumFreight
from Suppliers s join Orders o on s.SupplierID = o.ShipVia
group by s.SupplierID, CompanyName

-- 2. หาใบสั่งซื้อ วันที่สั่งซื้อ ชื่อบริษัทลูกค้า ให้แสดงเฉพาะ ลูกค้าที่อยู่ในประเทศ USA
select orderID,format(o.orderDate,'d','en-gb') as [Order date], c.companyName
from Orders o join Customers c on o.CustomerID = c.CustomerID
where c.country = 'USA'

-- 3. หาสพนักงาน ชื่อนามสกุล จำนวนใบสั่งซื้อที่เกี่ยวข้อง
select *
from orders o join Customers c on o.CustomerID = c.CustomerID
where c.Country = 'USA'

-- 4. หาใบสั่งซื้อ วันที่สั่งซื้อ ชื่อพนักงาน ชื่อบริษัทลูกค้า ชื่อบริษัทขนส่ง
-- ยอดรวมในใบสั่งซื้อ เฉพาะรายการที่ขายในปี 1997 เรียงตามลำดับ ยอดเงินจากมากไปน้อย
SELECT o.OrderID, 
       FORMAT(o.OrderDate,'d','en-gb') OrderDay,
       e.FirstName SalesmanName, 
       c.CompanyName customerCompany,
       s.CompanyName ShipperCompany,
       SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) totalCash
from Orders o 
    INNER JOIN Employees e on o.EmployeeID = e.EmployeeID
    INNER JOIN Customers c on o.CustomerID = c.CustomerID
    INNER JOIN [Order Details] od on o.OrderID = od.OrderID
    INNER JOIN Shippers s on o.ShipVia = s.ShipperID
where YEAR(o.OrderDate) = 1997
GROUP BY o.OrderID, FORMAT(o.OrderDate,'d','en-gb'),
         e.FirstName, c.CompanyName, s.CompanyName
ORDER BY totalCash DESC;

--ต้องการ รหัสสินค้า ชื่อสินค้า จำนวนสินค้า เฉพาะสินค้าที่ขายดีที่สุด 5 อันดับแรก ในปี1997

select Top 5
	   p.ProductID,p.ProductName,
	   sum(od.quantity)
from Products p inner join [Order Details] od on p.ProductID = p.ProductID
				inner join Orders o on o.OrderID = od.OrderID
where year(orderdate) =1997
group by p.ProductID,p.ProductName
order by 3 desc

--ข้อมูล บริษัทลูกค้า และ ประเทศลูกค้า ที่ซื้อสินค้าที่มาจากบริษัทชื่อ Exotic Liquids
--sub Query (Query ซ้อนกัน)
-- ชื่อพนักงานที่มีตำแหน่งเดียวกัน Nancy (nancy ตำแหน่งอะไร)
select firstname
from Employees
where Title = (select Title from Employees where FirstName = 'nancy')  -- ตำแหน่ง nancy

select title from Employees where FirstName = 'nancy'


-- ชื่อพนักงานที่มีอายุน้อยกว่า Robert เกิดเมื่อใด
select firstname
from Employees
where BirthDate >(select Title from Employees where FirstName = 'Robert') --วันเกิดของ Rodert

select BirthDate from Employees where FirstName = 'Robert'

--รหัสสินค้า ชื่อสินค้า ที่มีราคาสูงกว่าค่าเฉลี่ยทั้งหมดของราคาสินค้า (ค่าฌแลี่ยของราคาสินค้าคืออะไร)

select ProductID , ProductName , Unitprice
from Products
where UnitPrice > (select Avg(UnitPrice)from Products) --ราคาเฉลี่ยของสินค้าทั้งหมด

-- ชื่อ นามสกุล พนักงานที่ อายุมากที่สุด
select firstname, LastName
from Employees
where BirthDate = (select MIN(BirthDate) from Employees)
--ชื่อ นามสกุม พนักงานที่ เข้าทำงานหลังสุด
select FirstName, LastName
FROM Employees
where HireDate = (select MAX(HireDate) from Employees);

