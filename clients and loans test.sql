CREATE TABLE clients (client_id INT PRIMARY KEY, name TEXT, city TEXT, birth_date DATE, phone TEXT);
CREATE TABLE loans (loan_id INT PRIMARY KEY, client_id INT REFERENCES clients(client_id),
                    issue_date DATE, amount NUMERIC, status TEXT, rate NUMERIC);

INSERT INTO clients VALUES
(1,'Иван Петров','Москва','1990-03-12','+79001112233'),
(2,'Мария Ивченко','Казань','1985-07-01',NULL),
(3,'Ирина Орлова','Москва','1992-11-23','+79004445566'),
(4,'Иван Соколов','Самара','1988-01-30',NULL),
(5,'Олег Ким','Казань','1995-05-05','+79007778899');

INSERT INTO loans VALUES
(1,1,'2025-02-10',600000,'active',14.5),
(2,1,'2025-05-20',750000,'closed',13.9),
(3,2,'2025-03-15',300000,'default',18.0),
(4,3,'2025-06-30',900000,'closed',12.5),
(5,3,'2025-08-01',550000,'active',13.0),
(6,4,'2024-12-12',1200000,'default',16.0);