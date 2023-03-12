Select max(a.num) as num
from (
        select num, count(*)
        from my_numbers
        group by num
        having count(*) = 1
    ) a