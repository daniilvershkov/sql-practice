-- SQL practice: clients / loans
-- Темы: ORDER BY + LIMIT, IN, LIKE, агрегации, GROUP BY, HAVING, NULL, COUNT DISTINCT
-- Таблицы создаются скриптом create_tables.sql


-- Задача 1: 3 самых крупных кредита
select loan_id, amount
from loans
order by amount desc
limit 3;

-- Задача 2: кредиты 2025 года со статусом active или closed, по дате выдачи
select loan_id, issue_date, status
from loans
where issue_date between '2025-01-01' and '2025-12-31'
  and status in ('active', 'closed')
order by issue_date;

-- Задача 3: клиенты с именем на «Иван», родившиеся до 1990 года
select client_id, name, birth_date
from clients
where name like 'Иван%'
  and birth_date < '1990-01-01';

-- Задача 4: количество клиентов по городам
select city, count(*) as clients_cnt
from clients
group by city;

-- Задача 5: по статусам количество, сумма, средняя ставка; только сумма > 1 500 000
select status, count(*) as loans_cnt, sum(amount) as total_amount, avg(rate) as avg_rate
from loans
group by status
having sum(amount) > 1500000;

-- Задача 6: сумма кредитов по клиентам, выданных с 01.01.2025
select client_id, sum(amount) as total_amount
from loans
where issue_date >= '2025-01-01'
group by client_id;

-- Задача 7: сколько разных клиентов взяли кредит
select count(distinct client_id) as borrowers
from loans;

-- Задача 8: всего клиентов и клиентов с телефоном
select count(*) as all_clients, count(phone) as with_phone
from clients;

-- Задача 9: максимальная и минимальная сумма по статусам, по убыванию максимума
select status, max(amount) as max_amount, min(amount) as min_amount
from loans
group by status
order by max(amount) desc;

-- Задача 10: города, где больше одного клиента
select city, count(*) as clients_cnt
from clients
group by city
having count(*) > 1;

-- Задача 11: средняя ставка по всем кредитам, кроме default
select avg(rate) as avg_rate
from loans
where status <> 'default';