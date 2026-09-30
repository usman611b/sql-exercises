create database students
use students

create table info(
First_Name varchar(100),
Second_Name varchar(100),
marks int ,
is_available int
);
insert into info(
First_Name ,
Second_Name ,
marks ,
is_available 
)
values('Usman' , 'ali' , 90 , 1),
('Ahmed' , 'ali' , 80 , 1),
('Uzair' , 'ali' , 70 , 0),
('Daniyal' , 'Ahmed' , 5 , 0),
('Ali' , 'Ahmed' , 235 , 0);


select First_Name + ' ' + Second_Name   as FullName
from info

select First_Name + ' ' + Second_Name + 'have marks = ' + cast(marks AS Varchar(100)) as FullName
from info



SELECT
    CONCAT(
        First_Name,
        ' ',
        Second_Name,
        ' have marks = ',
        marks
    ) AS StudentDetails
FROM info;

select First_Name + ' ' + Second_Name as Full_name ,  
cast(marks AS Varchar(100)) + '0' as add_zero_concat 
from info

select First_Name + ' ' + Second_Name as Full_name , 
cast(marks AS Varchar(100)) + '0' as add_zero_concat ,
 marks * 10 AS add_zero_bymultiply
from info

select First_Name + ' ' + Second_Name as Full_name , marks , 
cast(marks AS Varchar(100)) + '0' as add_zero_concat ,
 marks * 10 AS add_zero_bymultiply
from info

select
    First_Name + ' ' + Second_Name as FullName,
    marks,
    case
        when marks < 10 then marks * 100
        when marks < 100 then marks * 10
        else marks
    end as three_digit_marks
from info;

SELECT
    First_Name,
    marks,
    is_available,
    CASE
        WHEN marks >= 50 AND is_available = 1
            THEN 'Passed and Available'
        WHEN marks >= 50 AND is_available = 0
            THEN 'Passed but Not Available'
        ELSE 'Failed'
    END AS student_status
FROM info;