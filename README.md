# SQL practice

Практика SQL на тестовой банковской базе: таблицы `clients` и `loans`.

## Файлы
- `00_create_tables.sql`: создание таблиц и тестовые данные
- `01_aggregations.sql`: ORDER BY, LIMIT, IN, LIKE, GROUP BY, HAVING, NULL, COUNT DISTINCT
- `02_joins.sql`: INNER JOIN, LEFT JOIN, условие в ON и в WHERE, JOIN + GROUP BY + HAVING
- `03_case_union.sql`: FULL JOIN, self join, UNION / UNION ALL, CASE WHEN, доля дефолтов
- `04_dates.sql`: DATE_TRUNC, EXTRACT, интервалы, age(), группировка по месяцам и кварталам
- `05_subqueries.sql`: подзапросы (скалярные, IN, NOT EXISTS), CTE, агрегат над агрегатом
- `06_window_functions.sql`: оконные функции (sum/avg over, row_number, rank, lag), нарастающий итог, выбор строки из группы

## Инструменты
PostgreSQL, DBeaver

## План
Дальше: Python (pandas) и проект по кредитному риску на реальных данных.
