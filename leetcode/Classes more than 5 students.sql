CREATE TABLE StudentClass ( student VARCHAR(1), class VARCHAR(10) );

select class
from courses
group by class
having
    count(distinct student) >= 5