if exists (select * from sys.databases where name = 'ASM5')
	drop database ASM5
create database ASM5
use ASM5

-- Tạo bảng lưu thông tin người dùng, địa chỉ,..
create table Person (
	PersonID int primary key,
	PersonName nvarchar(250),
	Address nvarchar(400),
	DateOfBirth date
)
-- Tạo bảng lưu số điện thoại
create table Telephone (
	TelID int primary key,
	TelNum varchar(50),
	PersonID int foreign key references Person(PersonID)
)
-- Thêm dữ liệu vào các bảng
insert into Person (PersonID, PersonName, Address, DateOfBirth)
	values
		(1, N'Đinh Quang Anh', N'Nho Quan, Ninh Bình', '19990711'),
		(2, N'Vũ Viết Quý', N'Thái Thịnh, Thái Bình', '20030109'),
		(3, N'Tạ Duy Linh', N'Thái Nguyên', '20030615')
insert into Telephone (TelID, TelNum, PersonID)
	values
		(1, '0395100761', 1),
		(2, '0394294314', 1),
		(3, '0394271107', 1),
		(4, '0916167136', 2),
		(5, '0933816333', 2),
		(6, '0173183113', 3),
		(7, '0191831342', 3)
-- 4.a, Liệt kê danh sách những người trong danh bạ
select distinct PersonName from Person
join Telephone
on Person.PersonID = Telephone.PersonID
-- 4.b, Liệt kê danh sách số điện thoại có trong danh bạ
select TelNum from Telephone
-- 5.a, Liệt kê danh sách người trong danh bạ theo thứ thự alphabet.
select distinct PersonName from Person
join Telephone
on Person.PersonID = Telephone.PersonID
order by PersonName ASC
-- 5.b, Liệt kê các số điện thoại của người có tên là Đinh Quang Anh.
select TelNum from Telephone
where PersonID in (
	select PersonID from Person
	where PersonName = N'Đinh Quang Anh'
)
-- 5.c, Liệt kê những người có ngày sinh là 11/07/1999
select PersonName from Person
where DateOfBirth = '19990711'
-- 6.a, Tìm số lượng số điện thoại của mỗi người trong danh bạ
select PersonID, count(TelNum) from Telephone
group by PersonID
-- 6.b, Tìm tổng số người trong danh bạ sinh vào thang 12.
select count (PersonID) from Person
where month(DateOfBirth) = '12'
-- 6.c, Hiển thị toàn bộ thông tin về người dùng của từng số điện thoại.
select * from Person
join Telephone
on Telephone.PersonID = Person.PersonID
-- 6.d, Hiển thị toàn bộ thông tin về người, của số điện thoại 0395100761.
select * from Person
where PersonID in (
	select PersonID from Telephone
	where TelNum = '0395100761'
)
-- 7.a, Viết câu lệnh để thay đổi trường ngày sinh là trước ngày hiện tại.
alter table Person
	add constraint ck_dateOfBirth check (DateOfBirth < getdate())
-- 7.c, Viết câu lệnh để thêm trường ngày bắt đầu liên lạc.
alter table Telephone
	add StartDate date 
go
-- 8.a, 
create index IX_HoTen on Person(PersonName)
go
create index IX_SoDienThoai on Telephone(TelNum)
go
-- 8.b,
create view View_SoDienThoai as
select Person.PersonName, Telephone.TelNum from Person
join Telephone
on Telephone.PersonID = Person.PersonID
go
create view View_SinhNhat as
select Person.PersonName, Person.DateOfBirth, Telephone.TelNum from Person
join Telephone
on Telephone.PersonID = Person.PersonID
where Month(Person.DateOfBirth) = month(getdate())