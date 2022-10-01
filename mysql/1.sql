CREATE TABLE `customer` (
    `id` INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `contact_name` VARCHAR(255) NOT NULL,
    `address` VARCHAR(255) NOT NULL,
    `city` VARCHAR(255) NOT NULL,
    `postal_code` VARCHAR(255) NOT NULL,
    `country` VARCHAR(255) NOT NULL,
) 

INSERT INTO `customer` (`name`, `contact_name`, `address`, `city`, `postal_code`, `country`) VALUES
('Alfreds Futterkiste', 'Maria Anders', 'Obere Str. 57', 'Berlin', '12209', 'Germany'),
('Ana Trujillo Emparedados y helados', 'Ana Trujillo', 'Avda. de la Constitución 2222', 'México D.F.', '05021', 'Mexico'),
('Antonio Moreno Taquería', 'Antonio Moreno', 'Mataderos  2312', 'México D.F.', '05023', 'Mexico'),
('Around the Horn', 'Thomas Hardy', '120 Hanover Sq.', 'London', 'WA1 1DP', 'UK'),
('Berglunds snabbköp', 'Christina Berglund', 'Berguvsvägen  8', 'Luleå', 'S-958 22', 'Sweden'),
('Blauer See Delikatessen', 'Hanna Moos', 'Forsterstr. 57', 'Mannheim', '68306', 'Germany'),
('Blondel père et fils', 'Frédérique Citeaux', '24, place Kléber', 'Strasbourg', '67000', 'France'),
('Bólido Comidas preparadas', 'Martín Sommer', 'C/ Araquil, 67', 'Madrid', '28023', 'Spain'),
('Bon app', 'Laurence Lebihan', '12, rue des Bouchers', 'Marseille', '13008', 'France'),
('Bottom-Dollar Marketse', 'Elizabeth Lincoln', '23 Tsawassen Blvd.', 'Tsawassen', 'T2F 8M4', 'Canada'),
('Bólido Comidas preparadas', 'Martín Sommer', 'C/ Araquil, 67', 'Madrid', '28023', 'Spain'),
('Cactus Comidas para llevar', 'Patricio Simpson', 'Cerrito 333', 'Buenos Aires', '1010', 'Argentina');

SELECT name, city FROM customer;

SELECT DISTINCT country FROM customer;
SELECT COUNT(*) FROM customer;

SELECT COUNT(DISTINCT country) FROM customer;

SELECT * FROM customer WHERE country = 'Germany';

SELECT * FROM customer WHERE country = 'Germany' AND city = 'Berlin'; 

SELECT * FROM customer WHERE city = 'Berlin' OR city = 'London';

SELECT * FROM customer WHERE NOT city = 'London';

SELECT * FROM customer ORDER BY name;

SELECT * FROM customer ORDER BY name DESC;

SELECT * FROM customer ORDER BY name DESC, city; 

SELECT name, contact_name, address FROM customer WHERE address IS NOT NULL;

UPDATE customer SET name='Dragon', city='JAKARTA' WHERE id=1;

DELETE FROM customer WHERE name='Bon app';

-- https://www.w3schools.com/sql/sql_top.asp
