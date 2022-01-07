if exists (select * from sys.databases where name = 'ASM4')
	drop database ASM4
create database ASM4
use ASM4
go
-- Tạo bảng lưu thông tin người chịu trách nhiệm
create table Person (
	PersonID bigint primary key,
	PersonName nvarchar(250) not null
)
go
-- Tạo bảng lưu thông tin loại sản phẩm
create table Product_Type (
	TypeID varchar(50) primary key,
	TypeName nvarchar(400)
)
go
-- Tạo bảng lưu thông tin sản phẩm
create table Product (
	ProductID varchar(50) primary key,
	ProductName nvarchar(300),
	ManufactureDate date,
	TypeID varchar(50) foreign key references Product_Type(TypeID),
	PersionID bigint foreign key references Person(PersonID)
)
go
-- Thêm dữ liệu vào bảng
insert into Person (PersonID, PersonName)
	values
		(123456789, N'Đinh Quang Anh'),
		(123456790, N'Vũ Viết Quý'),
		(123456791, N'Tạ Duy Linh')
go
insert into Product_Type (TypeID, TypeName)
	values
		('LT123', N'Máy tính xách tay'),
		('SMP456', N'Điện thoại thông minh'),
		('REF789', N'Tủ Lạnh')
go
insert into Product (ProductID, ProductName, ManufactureDate, TypeID, PersionID)
	values
		('LT1231', N'Laptop Asus X515 đời 2021', '20210605', 'LT123', 123456789),
		('SMP4561', N'Smartphone SamSung Z Fold 3 mới', '20211012', 'SMP456', 123456789),
		('REF7891', N'Tủ lạnh Panasonic đời 2017', '20170517', 'REF789', 123456789),
		('LT1232', N'Laptop Lenovo ThinkPad 2016', '20160912', 'LT123', 123456790),
		('LT1233', N'Laptop Dell Vostro 2018', '20181112', 'LT123', 123456790),
		('SMP4562', N'SmartPhone XiaoMi redMi Note 10', '20200721', 'SMP456', 123456790),
		('LT1234', N'Laptop Acer Aspire3', '20210920', 'LT123', 123456791),
		('REF7892', N'Tủ Lạnh Panasonic đời 2021', '20210728', 'REF789', 123456791),
		('REF7893', N'Tủ lạnh LG', '20210804', 'REF789', 123456791)
go
-- 4.a, Liệt kê danh sách loại sản phẩm của công ty
select TypeName from Product_Type
go
-- 4.b, Liệt kê danh sách sản phẩm của công ty.
select ProductName from Product
go
-- 4.c, Liệt kê danh sách người chịu trách nhiệm của công ty.
select PersonName from Person
go
-- 5.a, Liệt kê danh sách loại sản phẩm của công ty theo thứ tự tăng dần của tên
select TypeName from Product_Type
order by TypeName ASC
go
-- 5.b, Liệt kê danh sách người chịu trách nhiệm của công ty theo thứ tự tăng dần của tên.
select PersonName from Person
order by PersonName ASC
go
-- 5.c, Liệt kê các sản phẩm của loại sản phẩm có mã số là LT123.
select ProductName from Product
where TypeID = 'LT123'
go
-- 5.d, Liệt kê các sản phẩm Đinh Quang Anh chịu trách nhiệm theo thứ tự giảm đần của mã sản phẩm
select ProductName from Product
where PersionID in (
	select PersonID from Person
	where PersonName = N'Đinh Quang Anh'
)
order by ProductID DESC
-- 6.a, Số sản phẩm của từng loại sản phẩm.
select TypeID, count (ProductID) as 'Số SP'
from Product
group by TypeID
-- 6.c, Hiển thị toàn bộ thông tin về sản phẩm và loại sản phẩm.
select ProductID, ProductName, ManufactureDate, TypeName from Product
join Product_Type
on Product.TypeID = Product_Type.TypeID
-- 6.d, Hiển thị toàn bộ thông tin về người chịu trách nhiêm, loại sản phẩm và sản phẩm.
select ProductID, ProductName, ManufactureDate, TypeName, PersonName from Product
join Product_Type
on Product.TypeID = Product_Type.TypeID
join Person
on Person.PersonID = Product.PersionID
--7.a, Viết câu lệnh để thay đổi trường ngày sản xuất là trước hoặc bằng ngày hiện tại.
alter table Product
	add constraint ck_mnfdate check (ManufactureDate <= getdate())
-- 7.c, Viết câu lệnh để thêm trường phiên bản của sản phẩm.
alter table Product
	add Version nvarchar(250)
go
-- 8.a, Đặt chỉ mục (index) cho cột tên người chịu trách nhiệm
create index IX_Name on Person(PersonName)
go
-- 8.b,
create view View_SanPham as
select Product.ProductID, Product.ProductName, Product.ManufactureDate, Product_Type.TypeName from Product
join Product_Type
on Product_Type.TypeID = Product.TypeID
go
create view View_SanPham_NCTN as
select Product.ProductID, Product.ProductName, Product.ManufactureDate, Person.PersonName from Product
join Person
on Person.PersonID = Product.PersionID
go
create view View_Top_SP as
select top 5 Product.ProductID, Product.ProductName, Product_Type.TypeName, Product.ManufactureDate from Product
join Product_Type
on Product_Type.TypeID = Product.TypeID
order by Product.ManufactureDate DESC