-- Темы: DATE_TRUNC, EXTRACT, интервалы, age(), группировка по периодам
-- Таблицы создаются скриптом create_tables.sql


-- Задача 1: количество кредитов по месяцам выдачи
select count(*), date_trunc('month', issue_date) as month from loans
group by month
order by month;


-- Задача 2: сумма выданных кредитов по годам
select sum(amount) as total, date_trunc('year', issue_date) as yr from loans l
group by yr
order by total;


-- Задача 3: кредиты, выданные во втором квартале 2025 (апрель-июнь)
select loan_id from loans
where issue_date between '2025-04-01' and '2025-06-30';


-- Задача 4: дата выдачи и дата погашения (выдача + 12 месяцев)
select loan_id, issue_date, (issue_date + interval '12 months')::date as maturity_date from loans;


-- Задача 5: возраст клиентов в полных годах на 1 января 2026
select name,
       extract(year from age('2026-01-01', birth_date)) as age
from clients;


-- Задача 6: по кварталам выдачи: кредиты, default-кредиты, доля default в процентах
-- date_trunc('quarter', ...) возвращает первый день квартала
select count(loan_id) as totalloans, sum(case when status = 'default' then 1 else 0 end) as totaldefaults,
round(100.00 * sum(case when status = 'default' then 1 else 0 end) / count(loan_id), 1) as defaultrate,
date_trunc('quarter', issue_date)::date as quarter from loans
group by quarter
order by quarter;


-- Задача 7 (бонус): по клиентам: дата первого кредита и дни между первым и последним
select client_id, min(issue_date) as first_loan, (max(issue_date) - min(issue_date)) as days from loans
group by client_id
order by client_id;


-- Задача 8 (бонус): статус кредита по сроку погашения на отчётную дату 2026-01-01
-- ended: срок прошёл, ending soon: погашение в ближайшие 90 дней, later: позже
-- Отчётная дата фиксированная, чтобы результат не менялся день ото дня
select loan_id,
       (issue_date + interval '12 months')::date as maturity_date,
       case when (issue_date + interval '12 months')::date < date '2026-01-01' then 'ended'
            when (issue_date + interval '12 months')::date < date '2026-01-01' + 90 then 'ending soon'
            else 'later'
       end as loan_status
from loans;
