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