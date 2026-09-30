create table student4( id int , name varchar(20), marks int)
insert into student4(id , name , marks) values (1,'Ali',3),
(2,'Ahmad' ,4);

create  table Dim_Student( name varchar(20), marks int);
select * from Dim_Student order by marks
with studt_cte as (
 
select name , marks , 1 as counter  from student4 
union all 
select name , marks , counter + 1  from studt_cte where marks > counter  
)
select * from studt_cte
insert into Dim_Student(name , marks) select  name , marks from studt_cte