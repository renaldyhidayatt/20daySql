CREATE TABLE
    Country (
        name VARCHAR(255),
        continent VARCHAR(255),
        area INT,
        population INT,
        gdp BIGINT
    );

Select name, population, area
from world
where
    population > 25000000
    OR area > 3000000