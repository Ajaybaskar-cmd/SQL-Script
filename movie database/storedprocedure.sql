use gkg;
show tables;
select *from employee;

delimiter $$
create procedure employee()
begin
	select *from employee;
end $$
delimiter ;
select *from employee;
drop procedure cnt;
delimiter $$
create procedure cnt(in r varchar(30) )
begin 
	declare total int;
    select count(id) into total from employee where role=r;
    select total;
end $$
delimiter ;
call cnt('data analyst');

delimiter $$
create procedure ct(out total int)
begin 
	select count(id) into total from employee;
end $$
delimiter ;

call ct(@total);
select @total;
