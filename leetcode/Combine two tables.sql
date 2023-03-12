CREATE TABLE
    Person(
        PersonId INT PRIMARY KEY,
        FirstName VARCHAR,
        LastName VARCHAR
    );

CREATE TABLE
    Address(
        AddressId INT PRIMARY KEY,
        PersonId INT,
        City VARCHAR,
        State VARCHAR,
        FOREIGN KEY (PersonId) REFERENCES Person(PersonId)
    );

select
    FirstName,
    LastName,
    City,
    State
from Person P
    left join Address A on P.PersonId = A.PersonId