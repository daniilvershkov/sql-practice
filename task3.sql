-- Темы: FULL JOIN, self join, UNION / UNION ALL, CASE WHEN
-- Таблицы создаются скриптом create_tables.sql


-- Задача 1: FULL JOIN клиентов и кредитов (имя и loan_id)
select c.name, l.loan_id
from clients c
full join loans l on c.client_id = l.client_id;


-- Задача 2: пары клиентов из одного города
select a.name as client_1,
       b.name as client_2,
       a.city
from clients a
inner join clients b on a.city = b.city and a.client_id < b.client_id;


-- Задача 3: пары кредитов одного клиента
select a.client_id, a.loan_id, b.loan_id, a.amount, b.amount from loans a
inner join loans b on a.loan_id > b.loan_id and a.client_id = b.client_id;


-- Задача 4: кредиты от 900 000 и выше или со статусом default
select loan_id from loans
where amount >= 900000
union
select loan_id from loans
where status = 'default';

-- Вариант 2: UNION ALL (оставляет дубли). Ожидается: 4 строки, кредит 6 повторяется
select loan_id from loans
where amount >= 900000
union all
select loan_id from loans
where status = 'default';


-- Задача 5: размер каждого кредита
-- small: до 500 000, medium: до 1 000 000, large: от 1 000 000
select loan_id, amount,
case when amount < 500000 then 'small'
when amount < 1000000 then 'medium'
else 'large'
end as size
from loans;


-- Задача 6: количество кредитов в каждой категории размера
select case when amount < 500000 then 'small'
            when amount < 1000000 then 'medium'
            else 'large'
       end as size,
       count(*) as loans_cnt
from loans
group by size;


-- Задача 7: доля default-кредитов в процентах (до одного знака)
select round(100.0 * sum(case when status = 'default' then 1 else 0 end) / count(loan_id), 1) as default_share
from loans;


-- Задача 8 (бонус): клиент, число кредитов, число default-кредитов
select name, count(loan_id) as loans, sum(case when loans.status = 'default' then 1 else 0 end) as defaults from clients
left join loans on clients.client_id = loans.client_id
group by clients.name, clients.client_id;