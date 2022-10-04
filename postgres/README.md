### Practice Postgresql
PostgreSQL adalah sebuah sistem basis data yang disebarluaskan secara bebas menurut Perjanjian lisensi BSD. Peranti lunak ini merupakan salah satu basis data yang paling banyak digunakan saat ini, selain MySQL dan Oracle.

#### SELECT
The statement is used to select data from a database.SELECT

```sql 
    SELECT book_ref FROM bookings;
    SELECT airport_code,airport_name,city FROM airports WHERE city->>'en' = 'Moscow';
    SELECT * FROM aircrafts WHERE aircraft_code = '773';
    SELECT * FROM airports WHERE timezone='Asia/Yakutsk';

    -- Operation Used
    SELECT * FROM bookings WHERE total_amount > 200000;

    -- Operation Logic
    SELECT * FROM seats WHERE aircraft_code = '319' AND fare_conditions = 'Business';

    SELECT * FROM seats WHERE aircraft_code = '319' OR fare_conditions = 'Business';


    -- Where LIKE
    SELECT * FROM aircrafts WHERE model ->> 'en' NOT LIKE 'Airbus%' AND model ->> 'en' NOT LIKE 'Boeing%';

    SELECT * FROM aircrafts WHERE model ->> 'en' NOT LIKE '_Airbus%' AND model ->> 'en' NOT LIKE 'Boeing%';

    -- Where Between & IN
    SELECT * FROM tickets WHERE ticket_no BETWEEN '000543200100' AND '0005432002000';
    
    SELECT * FROM tickets WHERE ticket_no >= '000543200100' AND ticket_no '0005432002000';

    SELECT * FROM bookings WHERE book_date IN ('2017-7-10%');

    SELECT b.book_date as date_of_booking, b.total_amount as total FROM bookings as b WHERE book_date IN ('2017-7-10%','2017-7-15%','2017-7-20%','2017-7-25%');

```

#### SELECT DISTINCT
The following SQL statement selects all (including the duplicates) values from the "book_date" column in the "bookings";
```sql 
    SELECT DISTINCT book_date FROM bookings;
```


#### LIMIT & ORDER BY
The ORDER BY keyword is used to sort the result-set in ascending or descending order.
PostgreSQL is an optional clause of the SELECT statement that constrains the number of rows returned by the query.

```sql 
    SELECT ticket_no, fare_conditions FROM ticket_flights WHERE fare_conditions = 'Business' limit 10;
    -- asc
    SELECT passenger_name, contact_data FROM tickets order by passenger_name limit 50;  
    -- desc
    SELECT passenger_name, contact_data FROM tickets order by passenger_name desc limit 50;

    SELECT * FROM tickets WHERE passenger_name = 'ZULFIYA ZOTOVA' order by passenger_name desc limit 10;
```

#### NOT IN
```sql
SELECT * FROM aircrafts WHERE aircraft_code NOT IN('SU9','320','733');

SELECT flight_id, flight_no, departure_airport,arrival_airport,status FROM flights WHERE status IN('On Time', 'Departed','Arrived');
```

#### TEST

```sql 
    SELECT DISTINCT a.city ->> 'en' as city FROM airports a WHERE a.city ->> 'en' <> 'Moscow' ORDER BY city;

    SELECT * FROM airports WHERE timezone IN('Asia/Novokuznetsk','Asia/Krasnoyarsk');

    SELECT * FROM aircrafts WHERE range BETWEEN 3000 AND 6000;

    SELECT model, range, round(range/1.609, 2) as miles FROM aircrafts;

    SELECT *, round(range/1.69, 2) AS range_in_miles FROM aircrafts WHERE aircraft_code = 'SU9';
```


#### Count
The function returns the number of rows that matches a specified criterion.

```sql
SELECT COUNT(model) FROM aircrafts;

SELECT COUNT(DISTINCT passenger_name) FROM tickets;
```

#### SUM
The SUM() function returns the total sum of a numeric column. 

```sql 
SELECT SUM(total_amount) FROM bookings;
```

#### AVG
The function returns the average value of a numeric column.
```sql 
SELECT
```

#### MIN
The MIN() function returns the smallest value of the selected column.
```sql
SELECT MIN(total_amount) FROM bookings;
```

#### MAX
The MAX() function returns the largest value of the selected column.
```sql 
SELECT MAX(total_amount) FROM bookings;
```

#### GROUP BY
The statement groups rows that have the same values into summary rows

```sql
SELECT city, COUNT(*) FROM airports GROUP BY city;

```

#### HAVING
The clause was added to SQL because the keyword cannot be used with aggregate functions.

```sql 
SELECT city ->> 'en', COUNT(*) FROM airports GROUP BY city HAVING COUNT(*) > 1;
```

#### TEST

```sql
SELECT AVG(total_amount) as sales FROM bookings;

SELECT count(*) FROM seats WHERE aircraft_code = 'CN1';

SELECT count (*) FROM seats WHERE aircraft_code = 'SU9';

SELECT aircraft_code, COUNT(*) FROM seats GROUP BY aircraft_code ORDER BY COUNT;

SELECT aircraft_code, fare_conditions, COUNT(*) FROM seats GROUP BY aircraft_code,fare_conditions ORDER BY aircraft_code, fare_conditions;

SELECT book_date, SUM(total_amount) as sales FROM bookings GROUP BY 1 ORDER BY 2 LIMIT 1;

```

#### TEST Aggregation

```sql
SELECT(SELECT city ->> 'en' FROM airports WHERE airport_code = departure_airport) AS departure_city, COUNT(*) FROm flights GROUP BY(SELECT city ->> 'en' FROM airports WHERE airport_code = departure_airport) HAVING count(*) >= 50 ORDER BY COUNT DESC;

SELECT f.flight_no,f.scheduled_departure :: time AS dep_time,
f.departure_airport AS departures,f.arrival_airport AS arrivals,
count (flight_id)AS flight_count
FROM flights f
WHERE f.departure_airport = 'KZN'
AND f.scheduled_departure >= '2017-08-28' :: date
AND f.scheduled_departure <'2017-08-29' :: date
GROUP BY 1,2,3,4,f.scheduled_departure
ORDER BY flight_count DESC,f.arrival_airport,f.scheduled_departure;
```


#### CASE
The CASE expression goes through conditions and returns a value when the first condition is met (like an if-then-else statement).


```sql
SELECT DATE_PART('month', book_date) as month,SUM(total_amount) as bookings,CASE WHEN SUM(total_amount) > 6958118400.00 THEN 'the most' WHEN SUM(total_amount) < 6958118400.00 THEN 'the least' ELSE 'the medium' END booking_qt FROM bookings GROUP BY month;

SELECT *, CASE WHEN age >= 50 THEN 'old' WHEN age isnull THEN 'unknown' ELSE 'young' END is_old FROM pilots;

```
#### NULL IF
This tutorial shows you how to use PostgreSQL NULLIF function to handle null values. We will show you some examples of using the NULLIF function.
```sql
SELECT COUNT(*) - COUNT(NULLIF(actual_departure, null)) non_cnt_1, COUNT(*) - COUNT(NULLIF(actual_arrival, null)) non_cnt_2 FROM flights
```

#### COALESCE
COALESCE function that returns the first non-null argument.

```sql
SELECT status, COALESCE(actual_departure, current_timestamp), COALESCE(actual_arrival, current_timestamp) FROM flights;
```

#### TEST

```sql
SELECT model, range, CASE WHEN range < 2000 THEN 'Short' WHEN range < 5000 THEN 'middle' ELSE 'Long' END AS range FROM aircrafts ORDER BY model;
```

#### TIMESTAMP EXTRACT

```sql
SELECT EXTRACT('day' FROM book_date) as day, SUM(total_amount) as sales FROM bookings GROUP BY 1 ORDER BY 2;

SELECT EXTRACT('day' FROM book_date) as day, EXTRACT('month' FROM book_date) AS month, sum(total_amount) as SALES FROM bookings GROUP BY 1,2 ORDER BY 3;
```

#### DATE TRUNC

```sql
SELECT DATE_TRUNC('day', book_date) as day, COUNT(total_amount) as total_bookings FROM bookings GROUP BY DATE_TRUNC('day', book_date);

SELECT DATE_PART('day', book_date) as day, DATE_PART('month', book_date) as month, SUM(total_amount) AS bookings FROM bookings GROUP BY day, month HAVING DATE_PART('month', book_date) = 6;
```

#### INNER JOIN
The INNER JOIN keyword selects records that have matching values in both tables.

```sql
SELECT s.seat_no, s.fare_conditions, a.model ->> 'en' AS model, flight_no,departure_airport, arrival_airport, status FROM seats s INNER JOIN aircrafts a ON s.aircraft_code = a.aircraft_code INNER JOIN flights f ON a.aircraft_code = f.aircraft_code
```

#### LEFT JOIN
The LEFT JOIN keyword returns all records from the left table (table1), and the matching records from the right table (table2). The result is 0 records from the right side, if there is no match.

```sql
SELECT t.passenger_name, t.ticket_no, tf.fare_conditions, DATE_PART('day', book_date) AS day, DATE_PART('month', book_date) as month FROM tickets t LEFT join bookings b ON t.book_ref = b.book_ref LEFT JOIN ticket_flights tf ON t.ticket_no = tf.ticket_no WHERE fare_conditions = 'Business' ORDER BY month, day;

SELECT DISTINCT t.passenger_name, t.ticket_no, tf.fare_conditions, DATE_PART('day', book_date) AS day, DATE_PART('month', book_date) as month FROM tickets t LEFT join bookings b ON t.book_ref = b.book_ref LEFT JOIN ticket_flights tf ON t.ticket_no = tf.ticket_no WHERE fare_conditions = 'Business' ORDER BY month, day;
```

#### RIGHT JOIN
The RIGHT JOIN keyword returns all records from the right table (table2), and the matching records from the left table (table1). The result is 0 records from the left side, if there is no match.

```sql
SELECT t.passenger_name, t.ticket_no, tf.fare_conditions, DATE_PART('day', book_date) AS day, DATE_PART('month', book_date) as month FROM bookings b RIGHT JOIN tickets t ON b.book_ref = t.book_ref RIGHT JOIN ticket_flights tf ON tf.ticket_no = t.ticket_no ORDER BY month, day;

SELECT DISTINCT t.passenger_name, t.ticket_no, tf.fare_conditions, DATE_PART('day', book_date) AS day, DATE_PART('month', book_date) as month FROM bookings b RIGHT JOIN tickets t ON b.book_ref = t.book_ref RIGHT JOIN ticket_flights tf ON tf.ticket_no = t.ticket_no ORDER BY month, day;
```

#### FULL OUTER
The FULL OUTER JOIN keyword returns all records when there is a match in left (table1) or right (table2) table records.

```sql
SELECT * FROM boarding_passes b FULL JOIN flights f ON b.flight_id = f.flight_id
```

#### CROSS JOIN
A CROSS JOIN clause allows you to produce a Cartesian Product of rows in two or more tables.
```sql
SELECT * FROM aircrafts CROSS JOIN airports;
```

#### UNION
The operator combines result sets of two or more statements into a single result set.

```sql
SELECT * FROM aircrafts WHERE range > 4500 UNION SELECT * FROM aircrafts WHERE range < 7500

SELECT * FROM aircrafts WHERE range > 4500 UNION ALL SELECT * FROM aircrafts WHERE range < 7500

SELECT * FROM aircrafts WHERE range > 4500 INTERSECT SELECT * FROM aircrafts WHERE range < 7500;

SELECT * FROM aircrafts WHERE range > 4500 EXCEPT SELECT * FROM aircrafts WHERE range < 7500
```

#### SELF JOIN
A self-join is a regular join that joins a table to itself. In practice, you typically use a self-join to query hierarchical data or to compare rows within the same table.

#### USING
```sql
SELECT t.ticket_no, t.passenger_name,  t.contact_data, b.total_amount, b.book_date FROM tickets t JOIN bookings b USING(book_ref)
```

#### NATURAL JOIN
A natural join is a join that creates an implicit join based on the same column names in the joined tables.

```sql 
SELECT * FROM aircrafts a NATURAL JOIN seats s
```

#### TEST

```sql
-- Who traveled from Moscow (SVO) to Novosibirsk (OVB) on seat 1A yesterday, and when was the ticket booked?

SELECT t.passenger_name, b.book_date FROM bookings b JOIN tickets t ON t.book_ref = b.book_ref JOIN boarding_passes bp ON bp.ticket_no = t.ticket_no JOIN flights f ON f.flight_id = bp.flight_id WHERE f.departure_airport = 'SVO' AND f.arrival_airport = 'OVB' AND f.scheduled_departure::date = public.now()::date - INTERVAL '2 day' AND bp.seat_no = '1A';

-- Find the most disciplined passengers who checked in first for all their flights. Take into account only those passengers who took at least two flights ?
SELECT t.passenger_name, t.ticket_no FROM tickets t JOIN boarding_passes bp ON bp.ticket_no = t.ticket_no GROUP BY t.passenger_name, t.ticket_no HAVING max(bp.boarding_no) = 1 AND count(*) > 1

-- Calculate the number of passengers and number of flights departing from one airport (SVO) during each hour on the indicated day 2017-08-02 ?

SELECT DATE_PART('hour', f.scheduled_departure) "hour", count(ticket_no) passengers_cnt, COUNT(DISTINCT f.flight_id) flights_cnt FROM flights f JOIN ticket_flights t ON f.flight_id = t.flight_id WHERE f.departure_airport = 'SVO' AND f.scheduled_departure >= '2017-08-02'::date AND f.scheduled_departure < '2017-08-03'::date GROUP BY DATE_PART('hour', f.scheduled_departure);

```

#### TEST JOIN

```sql
-- Use SQL  joins to  return unique city name, flight_no, airport and timezone?
SELECT DISTINCT a.city, f.flight_no, a.airport_name, AS airport, a.timezone FROM flights f JOIN airports_eng a ON a.airport_code = f.departure_airport;

```

#### TEST SUBQUERY

```sql
-- How many people can be included into a single booking according to the available data?
SELECT tt.bookings_no,count(*)passengers_no
FROM (SELECT t.book_ref, count(*) bookings_no FROM tickets t GROUP BY t.book_ref) tt
GROUP BY tt.bookings_no
ORDER BY tt.bookings_no;


-- Which combinations of first and last names occur most often? What is the ratio of the passengers with such names to the total number of passengers?
SELECT passenger_name, round( 100.0 * cnt / sum(cnt) OVER (), 2) AS percent
FROM (SELECT passenger_name, count(*) cnt  FROM tickets GROUP BY passenger_name) sub
ORDER BY percent DESC;

```

#### TEST SUBQUERY CTE

```sql
-- What are the maximum and minimum ticket prices in all directions?

SELECT (SELECT city ->> 'en' FROM airports WHERE airport_code = f.departure_airport) AS departure_city, (SELECT city ->> 'en' FROM airports WHERE airport_code = f.arrival_airport) AS arrival_city, max (tf.amount), min (tf.amount)
FROM flights f
JOIN ticket_flights tf
ON f.flight_id = tf.flight_id
GROUP BY 1, 2
ORDER BY 1, 2;

-- Get a list of airports in cities with more than one airport ?
SELECT aa.city ->> 'en'AS city, aa.airport_code, aa.airport_name ->> 'en' AS airport
FROM (SELECT city, count (*)FROM airports GROUP BY city HAVING count (*)> 1) AS a
JOIN airports AS aa
ON a.city = aa.city
ORDER BY aa.city, aa.airport_name;

-- What will be the total number of different routes that are theoretically can be laid between all cities?

SELECT count (*)
FROM (SELECT DISTINCT city FROM airports) AS a1
JOIN (SELECT DISTINCT city FROM airports) AS a2
ON a1.city <> a2.city;

```

#### TEST 

```sql 
-- For each ticket, display all the included flight segments, together with connection time. Limit the result to the tickets booked a week ago?

SELECT tf.ticket_no, f.departure_airport, f.arrival_airport, f.scheduled_arrival,
lead(f.scheduled_departure) OVER w AS next_departure,
lead(f.scheduled_departure) OVER w - f.scheduled_arrival AS gap
FROM bookings b
JOIN tickets t
ON t.book_ref = b.book_ref
JOIN ticket_flights tf
ON tf.ticket_no = t.ticket_no
JOIN flights f
ON tf.flight_id = f.flight_id
WHERE b.book_date = public.now()::date - INTERVAL '7 day'
WINDOW w AS (PARTITION BY tf.ticket_no
                            ORDER BY f.scheduled_departure);

-- Find the most disciplined passengers who checked in first for all their flights. Take into account only those passengers who took at least two flights?
SELECT t.passenger_name, t.ticket_no
FROM tickets t
JOIN boarding_passes bp
ON bp.ticket_no = t.ticket_no
GROUP BY t.passenger_name,t.ticket_no
HAVING max(bp.boarding_no) = 1 AND count(*) > 1;

-- Which flights had the longest delays?
SELECT f.flight_no,  f.scheduled_departure, f.actual_departure,
(f.actual_departure - f.scheduled_departure) AS delay
FROM  flights f
WHERE f.actual_departure IS NOT NULL
ORDER BY f.actual_departure - f.scheduled_departure;

--  How many seats remained free on flight PG0404 in the day before the last in the airlines database?
SELECT count(*)
FROM (SELECT s.seat_no FROM  seats s
  WHERE s.aircraft_code = (SELECT aircraft_code
   FROM  flights
   WHERE flight_no = 'PG0404'
   AND scheduled_departure::date = public.now()::date - INTERVAL '1 day')
      EXCEPT
      SELECT bp.seat_no
      FROM boarding_passes bp
      WHERE bp.flight_id = (SELECT flight_id
                                          FROM  flights                                     
                                  WHERE flight_no = 'PG0404'                                     
                                  AND scheduled_departure::date = public.now()::date - INTERVAL '1 day')) ;
-- How many seats remained free on flight PG0404 in the day before the last in the airlines database? 
SELECT count(*)
FROM flights f
JOIN seats s
ON s.aircraft_code = f.aircraft_code
WHERE f.flight_no = 'PG0404'
AND f.scheduled_departure::date = public.now()::date - INTERVAL '1 day'
AND NOT EXISTS (SELECT NULL FROM boarding_passes bp
WHERE bp.flight_id = f.flight_id
                                 AND bp.seat_no = s.seat_no);

-- what is the different between the tables created using VIEWS and the tables
-- created using SELECT INTO ?

```