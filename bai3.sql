DROP DATABASE IF EXISTS session_11;
CREATE DATABASE session_11;
USE session_11;
-- Bảng Branch (Chi nhánh)
CREATE TABLE Branch (
    BranchID INT PRIMARY KEY AUTO_INCREMENT,
    BranchName VARCHAR(100) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(15) UNIQUE NOT NULL
);
-- Bảng Employees (Nhân viên)
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL,
    BranchID INT NOT NULL,
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);
-- Bảng Customers (Khách hàng)
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Address VARCHAR(255),
    PhoneNumber VARCHAR(15) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    BranchID INT,
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);
-- Bảng Accounts (Tài khoản)
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    AccountType ENUM('Saving', 'Current', 'Fixed Deposit') NOT NULL,
    Balance DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    OpenDate DATE NOT NULL,
    BranchID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);
-- Bảng Transactions (Giao dịch khách hàng)
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT,
    AccountID INT NOT NULL,
    TransactionType ENUM('Deposit', 'Withdrawal', 'Transfer') NOT NULL,
    Amount DECIMAL(15,2) NOT NULL,
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);
-- Bảng Loans (Khoản vay ngân hàng)
CREATE TABLE Loans (
    LoanID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    LoanType ENUM('Home Loan', 'Car Loan', 'Personal Loan', 'Business Loan') NOT NULL,
    LoanAmount DECIMAL(15,2) NOT NULL,
    InterestRate DECIMAL(5,2) NOT NULL,
    LoanTerm INT NOT NULL, 
    StartDate DATE NOT NULL,
    Status ENUM('Active', 'Closed') DEFAULT 'Active',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
-- Thêm mới chi nhánh
INSERT INTO Branch (BranchName, Location, PhoneNumber) VALUES
('Chi nhánh Hà Nội', '123 Trần Hưng Đạo, Hà Nội', '024-12345678'),
('Chi nhánh TP.HCM', '456 Lê Lợi, TP.HCM', '028-87654321'),
('Chi nhánh Đà Nẵng', '789 Nguyễn Văn Linh, Đà Nẵng', '026-576646598');
-- Thêm mới nhân viên
INSERT INTO Employees (EmployeeID, FullName, Position, Salary, HireDate, BranchID) VALUES
(1, 'Nguyễn Văn An', 'Giám đốc', 45000000, '2018-03-10', 1),
(2, 'Trần Thị Hạnh', 'Giao dịch viên', 15000000, '2021-06-20', 2),
(3, 'Lê Minh Tuấn', 'Kế toán', '10000000', '2022-01-05', 3),
(4, 'Phạm Hoàng Kiên', 'Sale', 18000000, '2023-05-12', 1),
(5, 'Đặng Hữu Bình', 'Quản lý', 32000000, '2023-06-12', 2);
-- Thêm mới khách hàng
INSERT INTO Customers (CustomerID, FullName, DateOfBirth, Address, PhoneNumber, Email, BranchID) VALUES
(1, 'Nguyễn Văn Hùng', '1990-07-15', 'Hà Nội', '0901234567', 'hung.nguyen@gmail.com', 1),
(2, 'Phạm Văn Dũng', '1985-09-25', NULL, '0912345678', 'dung.pham@gmail.com', 2),
(3, 'Hoàng Thanh Tùng', '1993-11-30', 'Đà Nẵng', '0922334455', 'tung@gmail.com', 3),
(4, 'Lê Minh Khoa', '1988-04-12', 'Huế', '0945124578', 'khoa.le@gmail.com', 2),
(5, 'Đỗ Hoàng Anh', '1995-07-19', 'Cần Thơ', '0978123456', 'hoanganh.do@gmail.com', 1);
-- Thêm mới tài khoản
INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, OpenDate, BranchID) VALUES
(1, 1, 'Saving', 5000000, '2023-01-01', 1),
(2, 1, 'Current', 15000000, '2023-10-12', 1), 
(3, 2, 'Current', 12000000, '2023-02-15', 2),
(4, 3, 'Saving', 7000000, '2023-05-10', 1),
(5, 4, 'Fixed Deposit', 50000000, '2023-06-20', 2),
(6, 1, 'Fixed Deposit', 80000000, '2023-11-05', 2),
(7, 3, 'Saving', 3000000, '2023-08-14', 3),
(8, 5, 'Current', 1200000, '2024-01-10', 2),
(9, 5, 'Saving', 2000000, '2024-05-20', 1);
-- Thêm mới giao dịch
INSERT INTO Transactions (TransactionID, AccountID, TransactionType, Amount, TransactionDate) VALUES
(1, 1, 'Deposit', 2000000, '2024-02-01 10:15:00'),
(2, 1, 'Withdrawal', 1000000, NULL),
(3, 2, 'Deposit', 5000000, '2024-02-03 09:00:00'),
(4, 3, 'Withdrawal', 3000000, '2024-02-04 14:30:00'),
(5, 4, 'Transfer', 2500000, '2024-02-05 09:45:00'),
(6, 5, 'Deposit', 1000000, '2024-02-06 16:20:00'),
(7, 3, 'Transfer', 2000000, NULL),
(8, 2, 'Withdrawal', 500000, '2024-02-08 11:55:00');
-- Thêm mới khoản vay
INSERT INTO Loans (CustomerID, LoanType, LoanAmount, InterestRate, LoanTerm, StartDate, Status) VALUES
(1, 'Home Loan', 500000000.00, 6.5, 240, '2023-03-01', 'Active'),
(1, 'Car Loan', 300000000.00, 7.0, 120, '2023-04-15', 'Active'),
(2, 'Personal Loan', 150000000.00, 10.0, 36, '2023-07-10', 'Active'),
(3, 'Home Loan', 600000000.00, 5.8, 180, '2023-09-05', 'Active'),
(3, 'Car Loan', 250000000.00, 3.7, 60, '2023-10-10', 'Active'),
(4, 'Personal Loan', 150000000.00, 9.5, 48, '2023-11-20', 'Active'),
(5, 'Home Loan', 700000000.00, 5.9, 42, '2023-12-01', 'Active'),
(1, 'Business Loan', 900000000.00, 8.0, 120, '2024-01-05', 'Active'),
(5, 'Car Loan', 300000000.00, 7.2, 72, '2024-07-25', 'Active');

-- 2) Viết một Stored Procedure có tên GetCustomerByPhone. Sử dụng tham số IN để nhập vào số điện thoại (PhoneNumber_in) của khách hàng.

DELIMITER //
create procedure GetCustomerByPhone(in PhoneNumber_in varchar(15))
begin
	select CustomerID,FullName,DateOfBirth,Address,Email from customers
    where PhoneNumber_in like PhoneNumber;
end //
DELIMITER ;

/*
3) Viết một Stored Procedure có tên GetTotalBalance. Sử dụng tham số IN để nhập vào CustomerID. 
Sử dụng tham số OUT để xuất tổng số dư (TotalBalance) của 
tất cả các tài khoản mà khách hàng sở hữu. Thông tin trả về bao gồm tổng số dư của tất cả tài khoản mà khách hàng sở hữu. 
*/
DELIMITER //
create procedure GetTotalBalance(
	in CustomerID_in int,
	out TotalBalance int
 )
begin
	select sum(a.Balance) into TotalBalance
    from accounts a
    where a.CustomerID = CustomerID_in
    group by a.CustomerID;
end //
DELIMITER ;

-- 4) Viết một Stored Procedure có tên IncreaseEmployeeSalary.
DELIMITER //
create procedure IncreaseEmployeeSalary(
	in EmployeeID_in int,
	out newSalary decimal(10,2)
    )
begin
	update employees 
    set Salary = Salary*1.1
    where EmployeeID_in = EmployeeID;
    
    select salary into newSalary from employees where EmployeeID_in = EmployeeID;
end //
DELIMITER ;

-- 5) Tiến hành gọi thủ tục 
call GetCustomerByPhone ('0901234567');

call GetTotalBalance(1,@TotalBalance);
select @TotalBalance;

call IncreaseEmployeeSalary(4, @newSalary);
select @newSalary;

-- 6) Hãy xóa tất cả các Stored Procedure nếu tồn tại 
drop procedure if exists GetCustomerByPhone;

drop procedure if exists GetTotalBalance;

drop procedure if exists IncreaseEmployeeSalary;