# 📦 Delivery System Database (PostgreSQL)

This repository contains the schema definition for a delivery/order management system built with PostgreSQL. It includes support for customers, products, couriers, orders, pricing, stock, and delivery tracking.

---

## 📚 Contents

- [About](#-about)
- [Schema Overview](#-schema-overview)
- [Entity Relationship Diagram](#-entity-relationship-diagram)
- [PostgreSQL Features Used](#-postgresql-features-used)
- [Getting Started](#-getting-started)
- [Tables and Types](#-tables-and-types)
- [Business Use Case Examples](#-business-use-case-examples)
- [License](#-license)

---

## 📖 About

This database schema is designed to support a scalable and normalized backend for an e-commerce or delivery-focused system. It manages:

- Product catalogs
- Supplier and manufacturer data
- Customer profiles and delivery addresses
- Courier tracking
- Orders and items
- Inventory and pricing

---

## 🧠 Schema Overview

The schema contains the following key modules:

- **Products & Pricing**: Including suppliers, manufacturers, categories, and historical pricing
- **Inventory**: Stock tracking per product
- **Customers**: Profiles, addresses, and preferences
- **Orders**: Order headers and item lines
- **Delivery**: Courier management and delivery tracking

---

## 🧭 Entity Relationship Diagram

> You can regenerate this diagram using tools like [dbdiagram.io](https://dbdiagram.io), [SQLDBM](https://sqldbm.com), or [pgModeler](https://pgmodeler.io/).

![Schema Diagram](docs/schema_diagram.pdf)

---

## 🛠 PostgreSQL Features Used

This schema leverages the following PostgreSQL-specific features:

- `ENUM` types for `order_status` and `currency_code`
- `SERIAL` primary keys
- `CHECK` constraints (e.g., stock quantities)
- `DEFAULT` values (e.g., timestamps, currency)
- `UNIQUE` and `FOREIGN KEY` constraints for data integrity

---

## ⚙️ Getting Started

1. **Clone this repo**:
   ```bash
   git clone https://github.com/your-username/delivery-system-db.git
   cd delivery-system-db

2. **Start PostgreSQL(e.g., via Docker)**:
docker run --name delivery-db -e POSTGRES_PASSWORD=pass -p 5432:5432 -d postgres:14

3. **Run schema**:
psql -h localhost -U postgres -d postgres -f schema.sql


## 🧾 Tables and Types
| Name              | Description                                      |
|-------------------|--------------------------------------------------|
| order_status      | Enum for order tracking                         |
| currency_code     | Enum for supported currencies                   |
| categories        | Product categories                               |
| manufacturers     | Manufacturer info                                |
| suppliers         | Supplier contact and address                    |
| products          | Product catalog                                  |
| product_suppliers | Many-to-many linking products and suppliers     |
| prices            | Historical pricing info                          |
| stock             | Product inventory levels                         |
| customers         | Customer profiles                                |
| addresses         | Delivery addresses                               |
| couriers          | Delivery personnel                               |
| orders            | Orders and statuses                              |
| order_items       | Line items per order                             |



## 💼 Business Use Case Examples

## 🛒 Order Processing

--Place a new order
INSERT INTO orders (...) VALUES (...);
INSERT INTO order_items (...) VALUES (...);

--Check stock
SELECT quantity FROM stock WHERE product_id = ?;

--Calculate total
SELECT price_value FROM prices WHERE product_id = ? AND start_date <= NOW() ORDER BY start_date DESC LIMIT 1;

## 🚚 Delivery Management

--Orders ready for dispatch
SELECT * FROM orders WHERE status = 'processing';

--Asign a courier
UPDATE orders SET courier_id = ?, status = 'assigned' WHERE order_id = ?;

--Track delivery progress
UPDATE orders SET status = 'shipped' WHERE order_id = ?;


## 📊 Reporting & Analytics

--Total sales for time range
SELECT SUM(total_value) 
FROM orders 
WHERE order_date BETWEEN ? AND ? status = 'delivered';

## 📄 License
This project is licensed under the MIT License.See LICENSE file for details.
