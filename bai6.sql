use sakila;

-- 3) tạo view view_film_category để lấy danh sách phim và thể loại
create view view_film_category 
as
select f.film_id, f.title, c.name as category_name from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id;

-- 4) tạo view view_high_value_customers để lấy danh sách khách hàng có tổng thanh toán > 100$
create view view_high_value_customers 
as
select c.customer_id,c.first_name,c.last_name,sum(p.amount) as total_payment from customer c
join payment p on c.customer_id = p.customer_id
group by c.customer_id, c.first_name, c.last_name
having total_payment > 100;

-- 5) tạo index idx_rental_rental_date trên cột rental_date trong bảng rental
create index idx_rental_rental_date on rental(rental_date);

-- truy vấn tìm kiếm các giao dịch thuê phim vào ngày "2005-06-14"
explain select * from rental where rental_date = '2005-06-14';

-- 6) tạo stored procedure count_customer_rentals
DELIMITER //
create procedure count_customer_rentals(
	in customer_id int, 
    out rental_count int)
begin
    select count(*) into rental_count
    from rental
    where customer_id = customer_id;
end //
DELIMITER ;

-- gọi stored procedure count_customer_rentals với một customer_id bất kỳ
set @rental_count = 0;
call count_customer_rentals(1, @rental_count);
select @rental_count as rental_count;

-- 7) tạo stored procedure get_customer_email
DELIMITER //
create procedure get_customer_email(in customer_id int, out customer_email varchar(50))
begin
    select email into customer_email
    from customer
    where customer_id = customer_id;
end //
DELIMITER ;

-- gọi stored procedure get_customer_email với một customer_id bất kỳ
set @customer_email = '';
call get_customer_email(1, @customer_email);
select @customer_email as customer_email;

-- 8) xóa các index, view và stored procedure vừa tạo
drop view if exists view_film_category;
drop view if exists view_high_value_customers;
drop index idx_rental_rental_date on rental;
drop procedure if exists count_customer_rentals;
drop procedure if exists get_customer_email;
