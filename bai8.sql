use sakila;

-- 2) Hãy tạo một VIEW có tên view_long_action_movies để hiển thị danh sách các bộ phim thuộc thể loại "Action" và có thời lượng trên 100 phút.
create view view_long_action_movies as
select f.film_id, f.title, f.length, c.name as category_name
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
where c.name = 'action' and f.length > 100;

-- 3) Hãy tạo một VIEW có tên view_texas_customers để hiển thị danh sách khách hàng sống tại Texas và đã từng thuê phim ít nhất một lần.
create view view_texas_customers as
select c.customer_id, c.first_name, c.last_name, a.district as city 
from customer c
join address a on c.address_id = a.address_id
join rental r on c.customer_id = r.customer_id
where a.district = 'texas'
group by c.customer_id, c.first_name, c.last_name, a.district;

-- 4) Hãy tạo một VIEW có tên view_high_value_staff để hiển thị danh sách nhân viên đã xử lý các giao dịch thanh toán có tổng giá trị trên 100$
create view view_high_value_staff as
select s.staff_id, s.first_name, s.last_name, sum(p.amount) as total_payment
from staff s
join payment p on s.staff_id = p.staff_id
group by s.staff_id, s.first_name, s.last_name
having sum(p.amount) > 100;

-- 5) Hãy tạo một FULLTEXT INDEX có tên idx_film_title_description trên cột title và description trong bảng film.
create fulltext index idx_film_title_description on film (title, description);

-- 6) Hãy tạo một HASH INDEX có tên idx_rental_inventory_id trên cột inventory_id trong bảng rental.
alter table rental add index idx_rental_inventory_id ((inventory_id));

-- 7) Tìm danh sách các bộ phim thuộc thể loại "Action" có thời lượng trên 100 phút và trong tiêu đề 
-- hoặc mô tả phim phải chứa từ khóa "War" không (dùng view_long_action_movies và FULLTEXT INDEX).
select film_id, title, length, category_name
from view_long_action_movies
where match (title, description) against ('war');

-- 8) Hãy viết một Stored Procedure có tên GetRentalByInventory để tìm các giao dịch thuê phim (rental) dựa trên inventory_id.
DELIMITER //
create procedure get_rental_by_inventory (in p_inventory_id int)
begin
    select *
    from rental
    where inventory_id = p_inventory_id;
end //
DELIMITER ;

-- 9) Hãy xóa hết các index, store procedure, và view vừa khởi tạo ở trên
alter table rental drop index idx_rental_inventory_id;  
drop procedure if exists get_rental_by_inventory;
drop view if exists view_long_action_movies;
drop view if exists view_texas_customers;
drop view if exists view_high_value_staff;
drop index idx_film_title_description on film;
