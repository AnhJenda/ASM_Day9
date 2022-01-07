if exists (select * from sys.databases where name = 'ASM6')
	drop database ASM6
create database ASM6
use ASM6

-- Tạo bảng lưu thông tin nhà xuất bản
create table PublishingCompany (
	CompanyID int primary key,		-- Mã nxb
	CompanyName nvarchar(300),		-- Tên nxb
	CompanyAddress nvarchar(400)	-- Địa chỉ nxb
)
-- Tạo bảng lưu thông tin Sách
create table Book (
	BookID int primary key,			-- Mã quyển sách
	BookName nvarchar(400),			-- Tên sách
	BookType nvarchar(300),			-- Loại sách
	Author nvarchar(200),			-- Tác Giả
	ShortReview nvarchar(1000),		-- Tóm tắt nội dung
	PublishYear date,				-- Năm xuất bản
	TimesPublish int,				-- Số lần xuất bản
	Price money,					-- Giá tiền
	Quantity int,					-- Số lượng trong kho sách
	CompanyID int foreign key references PublishingCompany(CompanyID) -- Khoá phụ tới bảng lưu thông tin chi tiết về nxb
)

-- thêm dữ liệu vào các bảng
insert into PublishingCompany (CompanyID, CompanyName, CompanyAddress)
	values 
		(1, N'Tri Thức', N'53 Nguyễn Du, Hai Bà Trưng, Hà Nội'),
		(2, N'Giáo Dục Việt Nam', N'81 Trần Hưng Đạo, Hoàn Kiếm, Hà Nội'),
		(3, N'ABC', N'27 Nguyễn Trãi, Thanh Xuân, Hà Nội')
insert into Book 
	values
		(1, N'Trí tuệ Do Thái', N'Khoa học xã hội', N'Eran Katz', N'Bạn có muốn biết: Người Do Thái sáng tạo ra cái gì và nguồn gốc
			trí tuệ của họ xuất phát từ đâu không? Cuốn sách này sẽ dần hé lộ những bí ẩn về sự thông thái của người Do Thái, của một dân tộc
			thông tuệ với những phương pháp và kỹ thuật phát triển tầng lớp trí thức đã được giữ kín hàng nghìn năm như một bí ẩn mật mang tính
			văn hóa.', '20100101', 1, 79000, 100, 1),
		(2, N'Tiếng Việt Lớp 1', N'Sách Giáo Khoa', N'Đỗ Việt Hùng', N'Sách dạy cơ bản nhất về Tiếng Việt', '20190202', 5, 35000, 200, 2),
		(3, N'Toán Lớp 1', N'Sách Giáo Khoa', N'GS.TSKH. Đinh Thế Lục', N'Mở từng trang sách, các em sẽ thấy những bức tranh thật đẹp,
		 những hình ảnh quen thuộc và vui mắt. Các em sẽ thấy Toán là những điều gần gũi trong cuộc sống hằng ngày và rất thú vị.',
		 '20150303', 4, 35000, 200, 2),
		(4, N'Phàm Nhân Tu Tiên', N'Tiên Hiệp', N'Nhĩ Căn', N'Phàm Nhân Tu Tiên là một câu chuyện Tiên Hiệp kể về Hàn Lập - Một người bình thường
		 nhưng lại gặp vô vàn cơ duyên để bước đi trên con đường tu tiên, không phải anh hùng - cũng chẳng phải tiểu nhân,
		  Hàn Lập từng bước khẳng định mình... Liệu Hàn Lập và người yêu có thể cùng bước trên con đường tu tiên và có một cái kết hoàn mỹ?
		   Những thử thách nào đang chờ đợi bọn họ?', '20070404', 2, 120000, 10, 3)
-- 3. Liệt kê các cuốn sách có năm xuất bản từ 2008 đến nay
select BookName from Book
where year(PublishYear) >= '2008'
-- 4. Liệt kê 2 cuốn sách có giá bán cao nhất
select BookName, Price from Book
where Price in (
	select top 2 Price from Book
	order by Price desc
)
order by Price desc
-- 5. Tìm những cuốn sách có tên chứa từ “Tiếng”
select BookName from Book
where BookName like N'Tiếng%'
-- 6. Liệt kê các cuốn sách có tên bắt đầu với chữ “T” theo thứ tự giá giảm dần
select BookName from Book
where BookName like N'T%'
order by Price desc
-- 7. Liệt kê các cuốn sách của nhà xuất bản Tri thức
select BookName from Book
where CompanyID in (
	select CompanyID from PublishingCompany
	where CompanyName = N'Tri Thức'
)
-- 8. Lấy thông tin chi tiết về nhà xuất bản xuất bản cuốn sách “Trí tuệ Do Thái”
select * from PublishingCompany
where CompanyID in (
	select CompanyID from Book
	where BookName = N'Trí Tuệ Do Thái'
)
-- 9. Hiển thị các thông tin sau về các cuốn sách: Mã sách, Tên sách, Năm xuất bản, Nhà xuất bản, Loại sách
select Book.BookID, Book.BookName, Book.PublishYear, Book.BookType, PublishingCompany.CompanyName from Book
join PublishingCompany
on PublishingCompany.CompanyID = Book.CompanyID
-- 10. Tìm cuốn sách có giá bán đắt nhất
select top 1 Book.BookName from Book
order by Price desc
-- 11. Tìm cuốn sách có số lượng lớn nhất trong kho
select top 1 Book.BookName from Book
order by Quantity desc
-- 12. Tìm các cuốn sách của tác giả “Eran Katz”
select Book.BookName from Book
where Author = N'Eran Katz'
-- 13. Giảm giá bán 10% các cuốn sách xuất bản từ năm 2008 trở về trước
update Book
	set Price = Price * 90 / 100 where year(PublishYear) <= '2008'
-- 14. Thống kê số đầu sách của mỗi nhà xuất bản
select CompanyID, count (BookID) as NumOfTitle from Book
group by CompanyID
-- 15. Thống kê số đầu sách của mỗi loại sách
select BookType , count (BookID)from Book
group by BookType
go
-- 16. Đặt chỉ mục (Index) cho trường tên sách
create index IX_Book on Book(BookName)
go
-- 17. Viết view lấy thông tin gồm: Mã sách, tên sách, tác giả, nhà xb và giá bán
create view View_BookInfo as
select Book.BookID, Book.BookName, Book.Author, PublishingCompany.CompanyName, Book.Price from Book
join PublishingCompany
on PublishingCompany.CompanyID = Book.CompanyID