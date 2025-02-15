USE session_11;

-- 2) Tạo một VIEW có tên là View_High_Value_Customers để hiển thị danh sách khách hàng có chi tiêu cao.
create view view_high_value_customers 
as
select c.customerid, concat(c.firstname, ' ', c.lastname) as fullname, c.email, sum(i.total) as total_spending
from customer c
join invoice i on c.customerid = i.customerid
where i.invoicedate >= '2010-01-01'
group by c.customerid, fullname, c.email
having sum(i.total) > 200 and c.country != 'brazil';      
  
-- 3) Tạo một VIEW có tên là View_Popular_Tracks để hiển thị danh sách các bài hát phổ biến dựa trên số lượng bán ra.
create view view_popular_tracks 
as
select t.trackid, t.name as track_name, sum(il.quantity) as total_sales
from track t
join invoiceline il on t.trackid = il.trackid
where il.unitprice > 1.00 
group by t.trackid, track_name
having sum(il.quantity) > 15;

-- 4) Tạo một HASH INDEX có tên là idx_Customer_Country trên cột Country trong bảng Customer để tối ưu hóa truy vấn tìm kiếm khách hàng theo quốc gia.
create index idx_customer_country on Customer(Country);

select * from customer where country = 'canada';
explain select * from customer where country = 'canada';

-- 5) Tạo một FULLTEXT INDEX có tên là idx_Track_Name_FT trên cột Name trong bảng Track để tối ưu hóa tìm kiếm bài hát theo tên bằng FULLTEXT SEARCH
alter table track add fulltext index idx_track_name_ft (name);

select * from track where match (name) against ('love');
explain select * from track where match (name) against ('love');

-- 6) Viết một truy vấn sử dụng View_High_Value_Customers để lấy danh sách khách hàng có tổng chi tiêu lớn, kết hợp với idx_Customer_Country để lọc khách hàng theo quốc gia.
select v.customerid, v.fullname, v.email, v.total_spending, c.country
from view_high_value_customers v
join customer c on v.customerid = c.customerid
where c.country = 'canada';
explain select v.customerid, v.fullname, v.email, v.total_spending, c.country
from view_high_value_customers v
join customer c on v.customerid = c.customerid
where c.country = 'canada';

-- 7) Viết một truy vấn sử dụng View_Popular_Tracks để lấy danh sách các bài hát bán chạy nhất, kết hợp với idx_Track_Name_FT để tìm kiếm theo từ khóa trong tên bài hát.
select v.trackid, v.track_name, v.total_sales, t.unitprice
from view_popular_tracks v
join track t on v.trackid = t.trackid
where match (t.name) against ('love');

explain select v.trackid, v.track_name, v.total_sales, t.unitprice
from view_popular_tracks v
join track t on v.trackid = t.trackid
where match (t.name) against ('love');

-- 8) Tạo GetHighValueCustomersByCountry để lấy danh sách khách hàng chi tiêu cao từ một quốc gia cụ thể
DELIMITER //
create procedure get_high_value_customers_by_country (in p_country varchar(255))
begin
    select v.customerid, v.fullname, v.email, v.total_spending, c.country
    from view_high_value_customers v
    join customer c on v.customerid = c.customerid
    where c.country = p_country; 
end //
DELIMITER ;

-- 9) Tạo một stored procedure có tên là UpdateCustomerSpending để cập nhật bảng Invoice 
-- để điều chỉnh tổng chi tiêu của khách hàng(Total = Total + p_Amount ). Sắp xếp theo InvoidDate giảm dần
DELIMITER //
create procedure update_customer_spending (in p_customerid int, in p_amount decimal(10,2))
begin
    update invoice
    set total = total + p_amount
    where customerid = p_customerid
    order by invoicedate desc;
end //
DELIMITER ;

call update_customer_spending(5, 50.00);

select * from view_high_value_customers where customerid = 5;

-- 10) Xóa tất cả các VIEW, INDEX và PROCEDURE vừa khởi tạo trên.
drop view if exists view_high_value_customers;
drop view if exists view_popular_tracks;
drop index idx_customer_country on customer;
drop index idx_track_name_ft on track;
drop procedure if exists get_high_value_customers_by_country;
drop procedure if exists update_customer_spending;