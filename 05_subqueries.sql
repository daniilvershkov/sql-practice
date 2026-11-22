-- SQL practice: подзапросы и CTE
-- Таблицы создаются скриптом 00_create_tables.sql


-- Задача 1: кредиты с суммой выше средней
-- Идея: скалярный подзапрос возвращает одно число (среднюю сумму),
-- и внешний запрос сравнивает с ним каждый кредит.
-- Для сравнения через >, <, = подзапрос должен вернуть ровно одно значение.
select loan_id, amount
from loans
where amount > (select avg(amount) from loans);


-- Задача 2: клиенты, у которых есть хотя бы один default-кредит
-- Идея: подзапрос возвращает список client_id, а IN проверяет, входит ли клиент в этот список.
-- Если подзапрос может вернуть несколько строк, используем IN, а не =.
select name
from clients
where client_id in (select client_id from loans where status = 'default');


-- Задача 3: клиенты без default-кредитов
-- Идея: NOT EXISTS проверяет, что для клиента не нашлось ни одной подходящей строки.
-- Подзапрос привязан к внешнему через l.client_id = c.client_id,
-- без этой привязки он проверял бы всю таблицу сразу.
-- select 1: важен сам факт наличия строки, а не её содержимое.
select c.name
from clients c
where not exists (
    select 1
    from loans l
    where l.client_id = c.client_id and l.status = 'default'
);


-- Задача 4: клиенты, у которых общая сумма кредитов больше средней суммы на клиента
-- Идея в три шага:
--   1) CTE считает сумму кредитов по каждому клиенту;
--   2) подзапрос берёт среднее от этих сумм (среднее считается по CTE, а не по loans);
--   3) основной запрос оставляет клиентов выше среднего и подтягивает имена через JOIN.
-- Агрегат нельзя писать в WHERE напрямую, поэтому среднее вынесено в подзапрос.
with client_totals as (
    select client_id, sum(amount) as totalamount
    from loans
    group by client_id
)
select clients.name, client_totals.totalamount
from clients
inner join client_totals on clients.client_id = client_totals.client_id
where client_totals.totalamount > (select avg(totalamount) from client_totals);


-- Задача 5: самый крупный кредит каждого клиента (его сумма)
-- Идея: группируем по клиенту и берём max суммы.
-- Ограничение: так получаем только число, без номера кредита и даты.
-- Для строки целиком нужны оконные функции (см. 06_window_functions.sql, задача 7).
select name, max(amount) as max_amount
from loans l
join clients c on l.client_id = c.client_id
group by c.client_id
order by max(amount);


-- Задача 6: города, где сумма кредитов выше средней суммы на город
-- Тот же шаблон, что в задаче 4, меняется только группировка (по городу).
-- Перед группировкой спрашиваем себя: чем будет одна строка в CTE? Здесь городом.
with citysum as (
    select c.city, sum(l.amount) as summ
    from clients c
    join loans l on c.client_id = l.client_id
    group by c.city
)
select city, summ
from citysum
where summ > (select avg(summ) from citysum);


-- Задача 7: кварталы, где сумма выданных кредитов выше средней суммы на квартал
-- Тот же шаблон, группировка по кварталу выдачи.
-- Колонки quarter и summ создала CTE, поэтому основной запрос берёт данные из неё (from quartersum), а не из loans.
with quartersum as (
    select sum(amount) as summ,
           date_trunc('quarter', issue_date)::date as quarter
    from loans
    group by quarter
)
select quarter, summ
from quartersum
where summ > (select avg(summ) from quartersum)
order by quarter;
