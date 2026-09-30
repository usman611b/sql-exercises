Create table employee(
employee_id int ,
employee_name varchar(100),
employeeFatherName varchar(100),
employee_onboarded TINYINT
);
insert into employee(
employee_id  ,
employee_name ,
employeeFatherName ,
employee_onboarded 
)
values(  1 , 'Usman' , 'Ali' , 1),
(2 , 'Zubair' , 'Khalid' , 1 );

select 
2 AS employee_id  ,
employee_name ,
employeeFatherName ,
employee_onboarded
from employee

insert into employee(
employee_id  ,
employee_name ,
employeeFatherName ,
employee_onboarded 
)
select 3,'Ahmed' ,'Dar',  employee_onboarded
from employee
where employee_name = 'Usman'

select * from employee
--Alter Command 
Alter table employee 
add curr_date datetime
/*
 Alter table employee 
add curr_date datetime default getdate()
*/
insert into employee(
employee_id  ,
employee_name ,
employeeFatherName ,
employee_onboarded ,
curr_date
)
values(  4 , 'Junaid ' , 'Ali' , 1 , getdate());

--Uppdate Commands 
Update employee
set employee_onboarded = 0
where employee_name = 'Ahmed'

UPDATE employee
SET curr_date = GETDATE()
WHERE curr_date IS NULL;

--------
select * from employee
where 1 = 1 --Universal true case 

