if exists (select * from sys.databases where name = 'ASM3')
	drop database ASM3
create database ASM3
use ASM3

-- Tạo bảng lưu trữ thông tin khách hàng
create table Customer (
	CustomerID int primary key,
	CustomerName nvarchar(250) not null,
	Address nvarchar(400),
	SCMT bigint
)

-- Tạo bảng lưu các số thuê bao
create table Telephone_Number (
	TelID int primary key,
	TelNum varchar(50),
	TelType nvarchar(200),
	RegistrationDate date,
	CustomerID int foreign key references Customer(CustomerID)
)

-- Thêm dữ liệu vào các bảng
insert into Customer (CustomerID, CustomerName, Address, SCMT)
	values 
		(1, N'Nguyễn Nguyệt Nga', N'Thanh Xuân - Hà Nội', 123456789),
		(2, N'Đinh Quang Anh', N'Nho Quan - Ninh Bình', 164647554),
		(3, N'Vũ Viết Quý', N'Thái Thịnh - Thái Bình', 987654321)
insert into Telephone_Number (TelID, TelNum, TelType, RegistrationDate, CustomerID)
	values
		(1, 123456789, N'Trả Sau', '20021212', 1),
		(2, 123456798, N'Trả Trước', '20170917', 2),
		(3, 123456987, N'Trả Sau', '20180115', 2),
		(4, 123456978, N'Trả Trước', '20210911', 3)

-- 4.a, Hiển thị thông tin của các khách hàng
select * from Customer
-- 4.b, Hiển thị toàn bộ thông tin của các số thuê bao của công ty.
select * from Telephone_Number
-- 5.a, Hiển thị toàn bộ thông tin của thuê bao có số: 0123456789
select * from Telephone_Number 
where TelNum = '123456789'
-- 5.b, Hiển thị thông tin về khách hàng có số CMTND: 123456789
select * from Customer
where  SCMT = '123456789'
-- 5.c, Hiển thị các số thuê bao của khách hàng có số CMTND:123456789
select TelNum from Telephone_Number
where CustomerID in (
	select CustomerID from Customer
	where SCMT = '123456789'
)
-- 5.d, Liệt kê các thuê bao đăng ký vào ngày 12/12/09
select TelNum from Telephone_Number
where RegistrationDate = '20091212'
-- 5.e, Liệt kê các thuê bao có địa chỉ tại Hà Nội
select TelNum from Telephone_Number
where CustomerID in (
	select CustomerID from Customer
	where Address like N'Hà Nội%'
)
-- 6.a, Tổng số khách hàng của công ty.
select count (distinct CustomerID)
from Customer
-- 6.b, Tổng số thuê bao của công ty.
select count (distinct TelID)
from Telephone_Number
-- 6.c, Tổng số thuê bao đăng ký ngày 12/12/09.
select count (distinct TelID)
from Telephone_Number where RegistrationDate = '20091212'
-- 6.d, Hiển thị toàn bộ thông tin về khách hàng và thuê bao của tất cả các số thuê bao.
select * from Customer , Telephone_Number
where Customer.CustomerID = Telephone_Number.CustomerID
-- 7.a, Viết câu lệnh để thay đổi trường ngày đăng ký là not null.
alter table Telephone_Number
	alter column RegistrationDate date not null
-- 7.b, Viết câu lệnh để thay đổi trường ngày đăng ký là trước hoặc bằng ngày hiện tại.
alter table Telephone_Number
	add constraint ck_rgtdate check (RegistrationDate <= getdate())
-- 7.c, Viết câu lệnh để thay đổi số điện thoại phải bắt đầu 09
alter table Telephone_Number
	add constraint ck_telNum check (left(telNum,2) = '09')
-- 7.d, Viết câu lệnh để thêm trường số điểm thưởng cho mỗi số thuê bao.
alter table Telephone_Number
	add BonusPoints int
go
-- 8.a, Đặt chỉ mục (Index) cho cột Tên khách hàng của bảng chứa thông tin khách hàng
create index IX_CusName on Customer(CustomerName)
go
-- 8.b,
create view View_KhachHang as
select Customer.CustomerID, Customer.CustomerName, Customer.Address from Customer
go
create view View_KhachHang_ThueBao as
select Customer.CustomerID, Customer.CustomerName, Telephone_Number.TelNum from Customer
join Telephone_Number
on Telephone_Number.CustomerID = Customer.CustomerID