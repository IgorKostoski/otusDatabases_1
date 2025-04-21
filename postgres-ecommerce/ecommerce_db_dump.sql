--
-- PostgreSQL database dump
--

-- Dumped from database version 15.12 (Homebrew)
-- Dumped by pg_dump version 15.12 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: orders; Type: SCHEMA; Schema: -; Owner: store_admin
--

CREATE SCHEMA orders;


ALTER SCHEMA orders OWNER TO store_admin;

--
-- Name: users; Type: SCHEMA; Schema: -; Owner: store_admin
--

CREATE SCHEMA users;


ALTER SCHEMA users OWNER TO store_admin;

--
-- Name: order_seq; Type: SEQUENCE; Schema: orders; Owner: postgres
--

CREATE SEQUENCE orders.order_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE orders.order_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: orders; Type: TABLE; Schema: orders; Owner: postgres
--

CREATE TABLE orders.orders (
    order_id integer DEFAULT nextval('orders.order_seq'::regclass) NOT NULL,
    customer_id integer,
    order_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    total_amount numeric(10,2)
);


ALTER TABLE orders.orders OWNER TO postgres;

--
-- Name: customers; Type: TABLE; Schema: users; Owner: postgres
--

CREATE TABLE users.customers (
    customer_id integer NOT NULL,
    full_name character varying(100),
    email character varying(100),
    phone character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE users.customers OWNER TO postgres;

--
-- Name: customer_orders; Type: VIEW; Schema: orders; Owner: postgres
--

CREATE VIEW orders.customer_orders AS
 SELECT c.full_name,
    o.order_id,
    o.total_amount
   FROM (users.customers c
     JOIN orders.orders o ON ((c.customer_id = o.customer_id)));


ALTER TABLE orders.customer_orders OWNER TO postgres;

--
-- Name: oreder_seq; Type: SEQUENCE; Schema: orders; Owner: postgres
--

CREATE SEQUENCE orders.oreder_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE orders.oreder_seq OWNER TO postgres;

--
-- Name: sales_summary; Type: MATERIALIZED VIEW; Schema: orders; Owner: postgres
--

CREATE MATERIALIZED VIEW orders.sales_summary AS
 SELECT orders.customer_id,
    count(*) AS total_orders,
    sum(orders.total_amount) AS total_spent
   FROM orders.orders
  GROUP BY orders.customer_id
  WITH NO DATA;


ALTER TABLE orders.sales_summary OWNER TO postgres;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: users; Owner: postgres
--

CREATE SEQUENCE users.customers_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users.customers_customer_id_seq OWNER TO postgres;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: users; Owner: postgres
--

ALTER SEQUENCE users.customers_customer_id_seq OWNED BY users.customers.customer_id;


--
-- Name: customers customer_id; Type: DEFAULT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.customers ALTER COLUMN customer_id SET DEFAULT nextval('users.customers_customer_id_seq'::regclass);


--
-- Data for Name: orders; Type: TABLE DATA; Schema: orders; Owner: postgres
--

COPY orders.orders (order_id, customer_id, order_date, total_amount) FROM stdin;
1000	1	2025-04-21 15:58:49.408344	1245.85
1001	2	2025-04-21 15:58:49.408344	189.55
1002	3	2025-04-21 15:58:49.408344	49.99
1003	1	2025-04-21 16:04:04.83323	599.00
1004	4	2025-04-21 16:04:04.83323	55.00
1005	5	2025-04-21 16:04:04.83323	79.00
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: users; Owner: postgres
--

COPY users.customers (customer_id, full_name, email, phone, created_at) FROM stdin;
1	Alice Johnson	alice@example.com	124-456-7985	2025-04-21 15:57:33.275033
2	Bob Smith	bob@example.com	124-456-4423	2025-04-21 15:57:33.275033
3	Charlie Brown	charlie@example.com	445-555-1234	2025-04-21 15:57:33.275033
4	Diana Prince	diana@example.com	456-789-0124	2025-04-21 16:03:00.616607
5	Ethan Hunt	ethan@example.com	567-444-1245	2025-04-21 16:03:00.616607
\.


--
-- Name: order_seq; Type: SEQUENCE SET; Schema: orders; Owner: postgres
--

SELECT pg_catalog.setval('orders.order_seq', 1005, true);


--
-- Name: oreder_seq; Type: SEQUENCE SET; Schema: orders; Owner: postgres
--

SELECT pg_catalog.setval('orders.oreder_seq', 1000, false);


--
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: users; Owner: postgres
--

SELECT pg_catalog.setval('users.customers_customer_id_seq', 5, true);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: orders; Owner: postgres
--

ALTER TABLE ONLY orders.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: customers customers_email_key; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.customers
    ADD CONSTRAINT customers_email_key UNIQUE (email);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: orders; Owner: postgres
--

ALTER TABLE ONLY orders.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES users.customers(customer_id);


--
-- Name: sales_summary; Type: MATERIALIZED VIEW DATA; Schema: orders; Owner: postgres
--

REFRESH MATERIALIZED VIEW orders.sales_summary;


--
-- PostgreSQL database dump complete
--

