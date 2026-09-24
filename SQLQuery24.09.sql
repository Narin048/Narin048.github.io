--สำรวจข้อมูล Receipts,Details, Emplotee, Product
select * from Receipts
select * from Details
select * from Employees
select * from Products
-- เป้าหมาย ต้องการสร้างรายการจำหน่ายสินค้า ผู้ขายคือ วุฒิศักดิ์
--สินค้าที่ขาย ได้แก่ ดินสอ 5 แท่ง และ ยางลบ 4 ก้อน
--เริ่มต้น Transaction
Begin Transaction

--1. เพิ่มใบเสร็จใหม่ Receipts ยังไม่มียอด TotalCash
Insert into Receipts(ReceiptDate,EmployeeID,TotalCash)
	Values(getdate(), 4, 0)
--2.เพิ่มรายการสินค้าใน  Details 2 รายการ (ก่อนหน้าเปิดดูใบเสร็จล่าสุด)
Insert into Details(ReceiptID,ProductID,UnitPrice,Quantity)
	Values(6, 1, 17, 4)--ดินสอ
Insert into Details(ReceiptID,ProductID,UnitPrice,Quantity)
	Values(6, 2, 17, 4)--ยางลบ
--3.ปรํบปรุงยอดขาย TotalCash
Update Receipts set TotalCash =
	(select sum(unitprice*quantity) from Details
	where ReceiptID = 6)
	where receiptID = 6
--4.ปรับปรุงจำนวนสินค้า ดินสอ -5 ยางลบ -4
update Products set UnitsInStock = UnitsInStock -5 where productID = 1 --ดินสอ
update Products set UnitsInStock = UnitsInStock -5 where productID = 2 --ยางลบ
--จบการทำงาน
commit


--ทดสอบ Roll back -----------------------------
--เริ่มต้น Transaction
Begin Transaction

--1. เพิ่มใบเสร็จใหม่ Receipts ยังไม่มียอด TotalCash
Insert into Receipts(ReceiptDate,EmployeeID,TotalCash)
	Values(getdate(), 4, 0)
--2.เพิ่มรายการสินค้าใน  Details 2 รายการ (ก่อนหน้าเปิดดูใบเสร็จล่าสุด)
Insert into Details(ReceiptID,ProductID,UnitPrice,Quantity)
	Values(8, 1, 17, 4--ดินสอ
Insert into Details(ReceiptID,ProductID,UnitPrice,Quantity)
	Values(8, 2, 17, 4)--ยางลบ

	-- ตรวจสอบดูข้อมมูลที่เกิดขึ้น
	select * from receipts where ReceiptID = 8
	select * from Details where ReceiptID = 8
--หากระบบผิดพลาด เราจะ  Rollback
Rollback
	--ตวจสอบดูข้อมูลว่ายังอยู่หรือไม่
	select * from receipts where ReceiptID = 8
	select * from Details where ReceiptID = 8