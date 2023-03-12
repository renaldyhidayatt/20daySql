CREATE TABLE Seats( seat_id INT PRIMARY KEY, free INT );

Select seat_id
from(
        select
            seat_id,
            free,
            lead(free, 1) over() as next,
            lag(free, 1) over() as prev
        from cinema
    ) a
where
    a.free = True
    and (
        next = True
        or prev = True
    )
order by seat_id