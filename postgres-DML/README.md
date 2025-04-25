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
