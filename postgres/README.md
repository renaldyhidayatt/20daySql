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