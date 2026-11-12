-- SQL practice: JOIN
-- Темы: INNER JOIN, LEFT JOIN, условие в ON и в WHERE, JOIN + GROUP BY + HAVING
-- Таблицы создаются скриптом create_tables.sql


-- Задача 1: loan_id, имя клиента и сумма по всем кредитам
select l.loan_id, c.name, l.amount
from clients c
inner join loans l on c.client_id = l.client_id;

-- Задача 2: все клиенты и их кредиты, включая клиентов без кредитов
select c.name, l.loan_id
from clients c
left join loans l on c.client_id = l.client_id;

-- Задача 3: клиенты без кредитов
select c.name
from clients c
left join loans l on c.client_id = l.client_id
where l.loan_id is null;

-- Задача 4: имя клиента и количество его кредитов, включая нулевое
select c.client_id, c.name, count(l.loan_id) as loans_cnt
from clients c
left join loans l on c.client_id = l.client_id
group by c.client_id, c.name;

-- Задача 5: сумма кредитов по городам клиентов
select c.city, sum(l.amount) as total_amount
from clients c
inner join loans l on c.client_id = l.client_id
group by c.city;

-- Задача 6: кредиты со статусом 'default': loan_id, имя клиента, город
select l.loan_id, c.name, c.city
from loans l
inner join clients c on c.client_id = l.client_id
where l.status = 'default';

-- Задача 7: условие по правой таблице в ON и в WHERE

-- Вариант 1: условие в ON. Остаются все клиенты, подтягиваются только default-кредиты
select c.name, l.loan_id
from clients c
left join loans l on c.client_id = l.client_id and l.status = 'default';

-- Вариант 2: условие в WHERE. Строки с NULL отфильтровываются, LEFT JOIN работает как INNER JOIN
select c.name, l.loan_id
from clients c
left join loans l on c.client_id = l.client_id
where l.status = 'default';

-- Задача 8 (бонус): клиенты с более чем одним кредитом
-- Группируем по client_id и name: два клиента с одинаковым именем не склеятся
select c.name, count(l.loan_id) as loans_cnt
from clients c
inner join loans l on c.client_id = l.client_id
group by c.client_id, c.name
having count(l.loan_id) > 1;
