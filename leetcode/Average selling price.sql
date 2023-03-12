CREATE TABLE
    Prices (
        product_id INT,
        start_date DATE,
        end_date DATE,
        price INT
    );

CREATE TABLE
    UnitsSold (
        product_id INT,
        purchase_date DATE,
        units INT
    );

Select
    d.product_id,
    round( (sum(price * units) + 0.00) / (sum(units) + 0.00),
        2
    ) as average_price
from(
        Select *
        from prices p
            natural join unitssold u
        where
            u.purchase_date between p.start_date
            and p.end_date
    ) d
group by d.product_id