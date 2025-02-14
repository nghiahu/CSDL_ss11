use chinook;

-- 2) Tạo một VIEW có tên là View_Track_Details để hiển thị thông tin chi tiết về các bài hát.
-- Chỉ hiển thị những bài hát có giá lớn hơn 0.99. VIEW này phải kết hợp thông tin từ bảng Track, Album, và Artist.
create view view_track_details 
as
select t.trackid, t.name as track_name, a.title as album_title, ar.name as artist_name, t.unitprice from track t
join album a on t.albumid = a.albumid
join artist ar on a.artistid = ar.artistid
where t.unitprice > 0.99;

select * from view_track_details;

-- 3) Tạo một VIEW có tên là View_Customer_Invoice 
-- để hiển thị danh sách khách hàng cùng tổng tiền các hóa đơn của họ, chỉ hiển thị những khách hàng có tổng tiền chi tiêu lớn hơn 50.
create view view_customer_invoice 
as
select c.customerid, concat(c.lastname, ' ', c.firstname) as fullname,c.email, sum(i.total) as total_spending, concat(e.lastname, ' ', e.firstname) as support_rep
from customer c
join invoice i on c.customerid = i.customerid
join employee e on c.supportrepid = e.employeeid
group by c.customerid
having total_spending > 50;

select * from view_customer_invoice;

-- 4) Tạo một VIEW có tên là View_Top_Selling_Tracks để hiển thị danh sách các bài hát có tổng số lượng bán ra trên 10.
create view view_top_selling_tracks 
as
select t.trackid,t.name as track_name,g.name as genre_name,sum(il.quantity) as total_sales
from track t
join invoiceline il on t.trackid = il.trackid
join genre g on t.genreid = g.genreid
group by t.trackid
having total_sales > 10;

select * from view_top_selling_tracks;

-- 5) Tạo một BTREE INDEX có tên là idx_Track_Name trên cột Name trong bảng Track để tối ưu hóa tìm kiếm bài hát theo tên.
create index idx_track_name on track (name);

-- tìm kiếm bài hát có từ khóa "love"
select * from track where name like '%love%';

-- kiểm tra hiệu suất
explain select * from track where name like '%love%';

-- 6) Tạo một INDEX có tên là idx_Invoice_Total trên cột Total trong bảng Invoice để tối ưu hóa truy vấn lọc hóa đơn theo tổng tiền.
create index idx_invoice_total on invoice (total);

select * from invoice where total between 20 and 100;

explain select * from invoice where total between 20 and 100;

/*
7) Tạo một stored procedure có tên là GetCustomerSpending nhận vào tham số đầu vào CustomerId (ID của khách hàng). 
Stored procedure này phải thực hiện truy vấn và trả về tổng số tiền mà khách hàng đó đã chi tiêu, lấy dữ liệu từ VIEW View_Customer_Invoice.
*/
DELIMITER //
create procedure get_customer_spending(in customerid int)
begin
    select coalesce(total_spending, 0) as totalspent 
    from view_customer_invoice 
    where customerid = customerid;
end //
DELIMITER ;

call get_customer_spending(1);

-- 8) Tạo một stored procedure có tên là SearchTrackByKeyword để tìm kiếm bài hát có tên chứa một từ khóa.
DELIMITER //
create procedure search_track_by_keyword(in p_keyword varchar(255))
begin
    select * from track where name like concat('%', p_keyword, '%');
end //
DELIMITER ;

call search_track_by_keyword('lo');

-- 9) Tạo một STORED PROCEDURE có tên là GetTopSellingTracks để trả về danh sách các bài hát có tổng số lượng bán nằm trong khoảng xác định, sử dụng View_Top_Selling_Tracks.
DELIMITER //
create procedure get_top_selling_tracks(in p_minsales int, in p_maxsales int)
begin
    select * from view_top_selling_tracks 
    where total_sales between p_minsales and p_maxsales;
end //
DELIMITER ;

call get_top_selling_tracks(15, 50);

-- 10) xóa tất cả view, index, procedure
drop view view_track_details;
drop view view_customer_invoice;
drop view view_top_selling_tracks;
drop index  idx_track_name on track;
drop index idx_invoice_total on invoice;
drop procedure if exists get_customer_spending;
drop procedure if exists search_track_by_keyword;
drop procedure if exists get_top_selling_tracks;
