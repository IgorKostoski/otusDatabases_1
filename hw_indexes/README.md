# PostgreSQL Indexing Demonstration

This repository demonstrates the creation and usage of various PostgreSQL index types to improve query performance. It provides a ready-to-run Docker environment with sample tables (`products`, `articles`) and pre-defined indexes.

This is useful for learning about:
*   Different types of PostgreSQL indexes (B-Tree, GIN, Partial, Functional, Composite).
*   Analyzing query plans using `EXPLAIN ANALYZE`.
*   Understanding the trade-offs of using indexes.

## Prerequisites

*   [Docker](https://docs.docker.com/get-docker/)
*   [Docker Compose](https://docs.docker.com/compose/install/) (Usually included with Docker Desktop)
*   [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## Getting Started

Follow these steps to get the PostgreSQL database running locally with the pre-defined schema and indexes:

1.  **Clone the repository:**
    ```bash
    git clone <your-repository-url>
    cd <your-repository-directory>
    ```

2.  **Start the PostgreSQL Container:**
    Use Docker Compose to build (if necessary) and start the PostgreSQL service in detached mode (`-d`).
    ```bash
    docker-compose up -d
    ```
    *   On the first run, Docker Compose will pull the official PostgreSQL image.
    *   The entrypoint script within the PostgreSQL image will automatically execute all `.sql` files found in the `./init-scripts` directory. This creates the `products` and `articles` tables and applies all the indexes defined in this project.
    *   A Docker volume named `postgres_data` (or similar, check `docker-compose.yml`) will be created to persist your database data even if the container is stopped or removed.

3.  **Connect to the Database:**
    You can now connect to the running PostgreSQL instance using any standard SQL client (e.g., `psql`, DBeaver, pgAdmin, DataGrip).

    *   **Host:** `localhost` (or `127.0.0.1`)
    *   **Port:** `5432` (or as mapped in `docker-compose.yml`)
    *   **Database:** `postgres` (or the value of `POSTGRES_DB` in `docker-compose.yml`)
    *   **User:** `postgres` (or the value of `POSTGRES_USER` in `docker-compose.yml`)
    *   **Password:** Check the `POSTGRES_PASSWORD` environment variable within the `docker-compose.yml` file for the password.

    Example using `psql` (you might need to install PostgreSQL client tools or run `psql` from within the container):
    ```bash
    # Replace 'your_password' with the actual password from docker-compose.yml
    psql -h localhost -p 5432 -U postgres -W -d postgres
    # Or execute psql inside the running container
    # docker-compose exec -it <service_name_from_compose_yml> psql -U postgres
    ```

4.  **Explore and Experiment:**
    Once connected, you can run `SELECT` queries, use `EXPLAIN ANALYZE` to see how the indexes are used, insert more data, and experiment further.

5.  **Stopping the Container:**
    To stop the running PostgreSQL service:
    ```bash
    docker-compose down
    ```
    This stops and removes the container but leaves the data volume (`postgres_data`) intact. If you run `docker-compose up -d` again, it will reuse the existing data. To remove the data volume as well (use with caution!), run `docker-compose down -v`.

## Indexes Demonstrated

The initialization scripts (`./init-scripts/*.sql`) create the following indexes:

1.  **Simple B-Tree Index:**
    *   `idx_products_category_id ON products (category_id)`
    *   Purpose: Speed up lookups for products based on their `category_id`.

2.  **GIN Index for Full-Text Search:**
    *   `idx_articles_content_fts ON articles USING GIN (to_tsvector('english', content))`
    *   Purpose: Enable efficient keyword searching within the `content` of the `articles` table.

3.  **Partial Index:**
    *   `idx_products_active_category ON products (category_id) WHERE is_active = TRUE`
    *   Purpose: Speed up searches for *active* products within a specific category, using a smaller, more targeted index.

4.  **Functional Index:**
    *   `idx_products_created_month ON products (EXTRACT(MONTH FROM created_at))`
    *   Purpose: Allow efficient filtering of products based on the month they were created, without needing a dedicated `creation_month` column.

5.  **Composite (Multi-column) Index:**
    *   `idx_articles_author_date ON articles (author, published_date DESC)`
    *   Purpose: Efficiently find the latest articles by a specific author, often avoiding a separate sort step.

## Development Process Summary

The setup in this repository was achieved through the following steps:

1.  **Schema Definition:** Created tables (`products`, `articles`) with appropriate data types. Corrected initial schema errors.
2.  **Data Generation (Manual/Example):** While the init scripts don't populate *large* datasets, the indexes were designed and tested assuming significant amounts of data (e.g., using `generate_series` and `random()` locally) to make indexing performance differences noticeable.
3.  **Statistics Update:** Running `ANALYZE` on tables (manually after large data loads, or automatically by PostgreSQL) is crucial for the query planner to make informed decisions about using indexes.
4.  **Identify Use Cases:** Determined common query patterns that could benefit from indexing (lookup by ID, full-text search, filtering on specific subsets, filtering by function results, filtering and ordering).
5.  **Index Creation:** For each use case, created an appropriate index (`CREATE INDEX ...`) specifying the type (default B-Tree, GIN), columns, and conditions (for partial/functional indexes). Added comments explaining the purpose of each index.

## Potential Issues & Considerations When Using Indexes

Be mindful of the following when working with PostgreSQL indexes:

1.  **Index Not Used:** Sometimes PostgreSQL might choose *not* to use an index if:
    *   The table is very small (a sequential scan is faster).
    *   The query retrieves a large percentage of the table rows (the index is not selective enough).
    *   The query uses a function on an indexed column *without* a matching functional index (e.g., `WHERE UPPER(name) = 'PRODUCT 1'` won't use a simple index on `name`).
    *   Statistics are out of date (`ANALYZE` needed).
2.  **Choosing the Wrong Index Type:** Using B-Tree for full-text search would be very inefficient compared to GIN/GiST. Using Hash indexes is less common now as B-Trees handle equality well. BRIN indexes are good for very large tables with physically correlated data, but less general-purpose.
3.  **Composite Index Column Order:** The order matters greatly. An index on `(A, B)` is great for `WHERE A = x` and `WHERE A = x AND B = y`, but much less useful for `WHERE B = y`. Design it based on the most common query patterns.
4.  **Write Performance Overhead:** Every index adds overhead to `INSERT`, `UPDATE`, and `DELETE` operations because the index structures also need to be updated. Over-indexing can slow down writes significantly.
5.  **Disk Space:** Indexes consume disk space, sometimes even more than the table data itself, especially complex indexes like GIN on large text fields.