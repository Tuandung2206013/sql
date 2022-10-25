USE master
GO
IF EXISTS (SELECT * FROM sys.databases WHERE Name='AZBank')
DROP DATABASE AZBank
GO
CREATE DATABASE AZBank
GO
USE AZBank
GO

USE AZBank
Create table Customer(
CustomerId  int PRIMARY KEY,
Name nvarchar(50),
City nvarchar(50),
Country nvarchar(50),
Phone nvarchar(15),
Email nvarchar(50),
)
Create table CustomerAccount(
AccountNumber char(9)PRIMARY KEY,
CustomerId int,
Balance money,
MinAccount money,
	CONSTRAINT FK_CustomerAccount_CustomerId
		FOREIGN KEY (customerId)
		REFERENCES Customer (customerId)
)
Create table CustomerTransaction(
TransactionId int primary key,
AccountNumber char(9),
TransactionDate smalldatetime,
Amount money,
DepositorWithdraw bit,
	CONSTRAINT FK_CustomerTransaction_AccountNumber
		FOREIGN KEY (AccountNumber)
		REFERENCES  CustomerAccount (AccountNumber)
)
--Nhập dữ liệu--
--dữ liệu vào bảng customer--
INSERT INTO Customer values (1,'Ngo VAn Tien','HN','VN','9876','NVT@gmail.com')
INSERT INTO Customer values (2,'Dinh Ba Dat','HN','VN','96803216','DBD@gmail.com')
INSERT INTO Customer values (3,'Vu Minh Sang','HN','VN','9123324','VMS@gmail.com')
SELECT * FROM Customer
--Dữ liệu bảng CustomerAccount
INSERT INTO CustomerAccount VALUES('CA1',1,2000,100)
INSERT INTO CustomerAccount VALUES('CA2',2,100000,100)
INSERT INTO CustomerAccount VALUES('CA3',3,4000,100)
SELECT * FROM CustomerAccount
--Dữ liệu bảng CustomerTransaction
INSERT INTO CustomerTransaction VALUES(1,'CA1','2019-07-17',2000,3)
INSERT INTO CustomerTransaction VALUES(2,'CA2','2022-07-12',100000,5)
INSERT INTO CustomerTransaction VALUES(3,'CA3','2021-02-12',6000,3)
SELECT * FROM CustomerTransaction
--4. Viết truy vấn để lấy tất cả khách hàng từ bảng Khách hàng sống ở ‘Hà Nội’.
SELECT * FROM Customer WHERE City = 'HN'
--5. Viết câu truy vấn lấy thông tin tài khoản của khách hàng (Tên, Điện thoại, Email, Số tài khoản, Số dư).
SELECT [Name],Phone,Email,AccountNumber,Balance FROM Customer
join CustomerAccount ON
Customer.CustomerId = CustomerAccount.CustomerId
--6. Ngân hàng A-Z có một quy tắc kinh doanh rằng mỗi giao dịch (rút tiền hoặc gửi tiền) sẽ không được vượt quá $ 1000000 (Một triệu USD).
--Tạo ràng buộc KIỂM TRA trên cột Số tiền của bảng Giao dịch Khách hàng để kiểm tra xem mỗi số tiền giao dịch có lớn hơn 0 và nhỏ hơn hoặc bằng $ 1000000 hay không.
ALTER TABLE CustomerTransaction
ADD CONSTRAINT CK_Checkwithdrawal CHECK (DepositorWithdraw > 0 and DepositorWithdraw <= 1000000)
--7Tạo một dạng xem có tên vCustomerTransactions hiển thị Tên, Số tài khoản, Ngày giao dịch, Số tiền và Người gửi tiền Rút từ các bảng Khách hàng, Tài khoản Khách hàng và Giao dịch Khách hàng.
CREATE VIEW vCustomerTransactions 
AS
SELECT [Name],CustomerAccount.AccountNumber,TransactionDate,Amount,DepositorWithdraw FROM Customer
join CustomerAccount ON
Customer.CustomerId = CustomerAccount.CustomerId
Join CustomerTransaction ON
CustomerTransaction.AccountNumber = CustomerAccount.AccountNumber

SELECT * FROM vCustomerTransactions