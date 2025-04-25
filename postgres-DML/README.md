# PostgreSQL Homework: Database Design and Implementation
This repository contains the solution to the homework assigment where we designed and imoplemented a PostgreSQL 
database for an **e-commerce system**.
- **Introduction to the Homework**: Describes the objective and key tasks.
- **Step-by-Step Breakdown**: Explains each task in detail (database creation, tablespaces, roles, sequences, etc.).
- **How to Run the Project**: Explains how to run the Docker container and connect to the database.
- **Conclusion**: Summarizes the purpose and outcome of the homework.



## How to Set Up and Use the Project
### Prerequisites
- Docker installed on your machine.
- pgAdmin or any PostgreSql client can be used to interact with the database.

### 1. **Clone the Repository**

''bash
git clone https://github.com/IgorKostoski/otusDatabases_1.git
cd otusDatabase_1/postgres-ecommerce


### 2. ** Start the Docker Container**

docker-compose up -d

### 3. ** Restore Database from SQL Dump**
1. Copy the dump file into the container:
docker cp ecommerce_db_dump.sql postgres-db:/ecommerce_db_dump.sql
2. Access the PostgreSQL container:
docker exec -it postgres-db bash
3. Restore the database using the psql command:
psql -U postgres ecommerce < ecommerce_db_dump.sql
4. Connect to PostSQL suing pgAdmin
- Open pgAdmin 
- Add a new server
* Host: localhost
* Port: 5432
* Username: postgres
* Password: abcdf
5. Interact with the Database
- Open the ecommerce database
- Run SQL queries to perform CRUD operations
- Use the ecommerce database schema as a reference


## Docker Configuraion
- The docker-compose.yml defines the PostgreSQL container setup. I uses the official posgres:17 image and exposes port 5432.




# Домашнее задание: SQL запросы и объяснения

## 1. Запрос с использованием регулярных выражений (SELECT)

Запрос с регулярным выражением позволяет искать шаблоны в строковых полях.

### Запрос:
```sql
SELECT customer_id, full_name, email
FROM users.customers
WHERE email ~ '^a.*com$';

```

### Объяснение:

-   `~` используется для сопоставления с регулярным выражением в PostgreSQL.
    
-   `^a.*com$` ищет адреса электронной почты, которые начинаются с 'a' (`^a`), имеют любые символы между ними (`.*`), и заканчиваются на 'com' (`com$`).
    

### Результат:

```sql
ecommerce_db=# 
SELECT customer_id, full_name, email
FROM users.customers
WHERE email ~ '^a.*com$';
 customer_id |   full_name   |       email
-------------+---------------+-------------------
           1 | Alice Johnson | alice@example.com
(1 row)

```

----------

## 2. Запросы с использованием LEFT JOIN и INNER JOIN

### Запрос с LEFT JOIN:

```sql
SELECT o.order_id, o.customer_id, o.total_amount, c.full_name
FROM orders.orders o
LEFT JOIN users.customers c ON o.customer_id = c.customer_id;

```

### Объяснение:

-   **LEFT JOIN**: Возвращает все заказы, даже если некоторые заказы не имеют соответствующего покупателя (в таких случаях значения будут NULL).
    

### Результат:

```sql
ecommerce_db=# 
SELECT o.order_id, o.customer_id, o.total_amount, c.full_name
FROM orders.orders o
LEFT JOIN users.customers c ON o.customer_id = c.customer_id;
 order_id | customer_id | total_amount |   full_name
----------+-------------+--------------+---------------
     1000 |           1 |      1245.85 | Alice Johnson
     1001 |           2 |       189.55 | Bob Smith
     1002 |           3 |        49.99 | Charlie Brown
     1003 |           1 |       599.00 | Alice Johnson
     1004 |           4 |        55.00 | Diana Prince
     1005 |           5 |        79.00 | Ethan Hunt
     1006 |           1 |        99.99 | Alice Johnson

```

----------

### Запрос с INNER JOIN:

```sql
SELECT o.order_id, o.customer_id, o.total_amount, c.full_name
FROM orders.orders o
INNER JOIN users.customers c ON o.customer_id = c.customer_id;

```

### Объяснение:

-   **INNER JOIN**: Возвращает только заказы, которые имеют соответствующего покупателя в таблице покупателей.
    

### Результат:

```sql
ecommerce_db=# 
SELECT o.order_id, o.customer_id, o.total_amount, c.full_name
FROM orders.orders o
INNER JOIN users.customers c ON o.customer_id = c.customer_id;
 order_id | customer_id | total_amount |   full_name
----------+-------------+--------------+---------------
     1000 |           1 |      1245.85 | Alice Johnson
     1001 |           2 |       189.55 | Bob Smith
     1002 |           3 |        49.99 | Charlie Brown
     1003 |           1 |       599.00 | Alice Johnson
     1004 |           4 |        55.00 | Diana Prince
     1005 |           5 |        79.00 | Ethan Hunt
     1006 |           1 |        99.99 | Alice Johnson
(7 rows)

```

### Объяснение порядка соединений:

-   **INNER JOIN**: Возвращает только те строки, которые совпадают в обеих таблицах.
    
-   **LEFT JOIN**: Возвращает все строки из левой таблицы (заказы), даже если нет совпадений в правой таблице (покупатели), при этом для не совпавших строк будут NULL значения в правой таблице.
    

----------

## 3. Запрос INSERT с возвращаемой информацией

### Запрос:

```sql
INSERT INTO orders.orders (customer_id, total_amount)
VALUES (1, 99.99)
RETURNING order_id, customer_id, total_amount;

```

### Объяснение:

Этот запрос вставляет новый заказ с `customer_id` равным 1 и `total_amount` равным 99.99, а затем возвращает `order_id`, `customer_id` и `total_amount` только что вставленного заказа.

### Результат:

```sql
ecommerce_db=# 
INSERT INTO orders.orders (customer_id, total_amount)
VALUES (1, 99.99)
RETURNING order_id, customer_id, total_amount;
 order_id | customer_id | total_amount
----------+-------------+--------------
     1007 |           1 |        99.99
(1 row)

INSERT 0 1

```

----------

## 4. Обновление данных с использованием `UPDATE FROM`

### Запрос:

```sql
UPDATE orders.orders o
SET total_amount = total_amount * 1.1  -- Увеличение total_amount на 10%
FROM users.customers c
WHERE o.customer_id = c.customer_id AND c.full_name = 'Ethan Hunt';

```

### Объяснение:

Этот запрос увеличивает `total_amount` на 10% для всех заказов, принадлежащих клиенту 'Ethan Hunt'.

### Результат:

```sql
ecommerce_db=# 
UPDATE orders.orders o
SET total_amount = total_amount * 1.1  -- Увеличение total_amount на 10%
FROM users.customers c
WHERE o.customer_id = c.customer_id AND c.full_name = 'Ethan Hunt';
UPDATE 1

```

----------

## 5. Удаление данных с использованием JOIN и оператора `USING`

### Запрос:

```sql
DELETE FROM orders.orders o
USING users.customers c
WHERE o.customer_id = c.customer_id
AND c.status = 'inactive';

```

### Объяснение:

Этот запрос удаляет заказы, у которых клиент имеет статус 'inactive'. Оператор `USING` используется для обращения ко второй таблице (customers) при выполнении операции DELETE.

### Результат:

```sql
ecommerce_db=# DELETE FROM orders.orders o
ecommerce_db-# USING users.customers c
ecommerce_db-# WHERE o.customer_id = c.customer_id
ecommerce_db-# AND c.full_name = 'Alice Johnson';
DELETE 4
ecommerce_db=#

