-- SQL practice: оконные функции
-- Таблицы создаются скриптом 00_create_tables.sql
--
-- Как читать любую оконную функцию, три вопроса:
--   1) Что считаем?             функция до over: sum, avg, row_number, lag
--   2) По кому считаем?         partition by внутри over (если не нужен, окно это вся таблица)
--   3) В каком порядке строки?  order by внутри over
-- Отличие от GROUP BY: строки не схлопываются, результат приписывается к каждой строке.
-- Оконную функцию нельзя писать в WHERE, для фильтра по ней нужен CTE.


-- Задача 1: каждый кредит и общая сумма всех кредитов портфеля
-- over () с пустыми скобками: окно это вся таблица, итог одинаков в каждой строке.
select loan_id, amount, sum(amount) over () as total_all
from loans;


-- Задача 2: каждый кредит и средняя сумма кредитов этого клиента
-- partition by client_id: окно только из кредитов своего клиента.
select loan_id, client_id, amount,
       avg(amount) over (partition by client_id) as averageloan
from loans;


-- Задача 3: порядковый номер кредита у каждого клиента по дате выдачи
-- row_number() всегда с пустыми скобками. Порядок нумерации задаёт order by внутри over,
-- а не в конце запроса (внешний order by влияет только на вывод).
select client_id, loan_id, issue_date,
       row_number() over (partition by client_id order by issue_date) as loannumber
from loans
order by client_id, issue_date;


-- Задача 4: сумма предыдущего кредита клиента и разница с текущим
-- lag(колонка) берёт значение из предыдущей строки окна. У первого кредита клиента
-- предыдущего нет, поэтому NULL.
-- partition by client_id не даёт заглянуть в чужого клиента, order by issue_date задаёт, что считать «предыдущим».
select loan_id, amount,
       lag(amount) over (partition by client_id order by issue_date) as prev_loan,
       amount - lag(amount) over (partition by client_id order by issue_date) as diff
from loans;


-- Задача 5: нарастающий итог по сумме кредитов в порядке выдачи
-- sum с order by внутри over накапливается строка за строкой.
-- Без partition by: считаем по всему портфелю.
select loan_id, issue_date, amount,
       sum(amount) over (order by issue_date) as running_total
from loans;


-- Задача 6: место каждого кредита по сумме, от самого крупного к самому мелкому
-- desc обязателен, иначе самый мелкий кредит получит место 1.
-- Когда суммы разные, rank, dense_rank и row_number дают одно и то же.
-- Разница видна при равных значениях: rank 1,2,2,4; dense_rank 1,2,2,3; row_number 1,2,3,4.
select loan_id, amount,
       rank() over (order by amount desc) as place
from loans;


-- Задача 7: самый крупный кредит каждого клиента целой строкой (номер, сумма, дата)
-- Идея: нумеруем кредиты внутри клиента от крупного к мелкому и оставляем первое место.
-- Оконную функцию нельзя писать в WHERE, поэтому нумерация в CTE, а фильтр rn = 1 снаружи.
-- В отличие от max, получаем не только число, но и всю строку.
-- Тот же шаблон даёт первый кредит (order by issue_date) и последний (order by issue_date desc).
with ranked as (
    select client_id, loan_id, amount, issue_date,
           row_number() over (partition by client_id order by amount desc) as rn
    from loans
)
select client_id, loan_id, amount, issue_date
from ranked
where rn = 1;