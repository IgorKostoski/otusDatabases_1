CREATE TYPE order_status as ENUM('pendening', 'processing', 'assigned', 'shipped','delivered','cancelled');
CREATE TYPE currency_code as ENUM('RUB','USD','EUR');

CREATE TABLE categories (
	category_id SERIAL PRIMARY KEY,
	name VARCHAR NOT NULL UNIQUE,
	description TEXT
);

CREATE TABLE manufacturers (
	manufacturer_id SERIAL PRIMARY KEY,
	name VARCHAR NOT NULL,
	contact_info TEXT
);

CREATE TABLE suppliers (
	supplier_id SERIAL PRIMARY KEY,
	name VARCHAR NOT NULL,
	contact_info TEXT NOT NULL,
	adress VARCHAR
);

CREATE TABLE products (
	product_id SERIAL PRIMARY KEY,
	name VARCHAR NOT NULL,
	description TEXT,
	sku VARCHAR UNIQUE,
	category_id INT REFERENCES categories(category_id),
	manufacturer_id INT REFERENCES manufacturers(manufacturer_id)
);

CREATE TABLE product_suppliers (
	product_id INT REFERENCES products(product_id),
	supplier_id INT REFERENCES suppliers(supplier_id),
	cost_price DECIMAL,
	PRIMARY KEY(product_id, supplier_id)
);

CREATE TABLE prices(
	price_id SERIAL PRIMARY KEY,
	product_id INT REFERENCES products(product_id),
	price_value DECIMAL NOT NULL,
	start_date TIMESTAMP NOT NULL,
	end_date TIMESTAMP,
	currenct currency_code DEFAULT 'RUB'
);

CREATE TABLE stock (
	stock_id SERIAL PRIMARY KEY,
	product_id INT UNIQUE REFERENCES products(product_id),
	quantity INT NOT NULL DEFAULT 0 CHECK (quantity >= 0),
	last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE customers (
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	email VARCHAR NOT NULL UNIQUE,
	phone VARCHAR NOT NULL UNIQUE,
	registration_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	preferences TEXT
);


CREATE TABLE addresses (
	address_id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customers(customer_id),
	streeet VARCHAR NOT NULL,
	city VARCHAR NOT NULL,
	postal_code VARCHAR NOT NULL,
	country VARCHAR NOT NULL DEFAULT 'Russia',
	address_label VARCHAR,
	is_default BOOLEAN DEFAULT false
);


CREATE TABLE couriers(
	courier_id SERIAL PRIMARY KEY,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	phone VARCHAR NOT NULL UNIQUE,
	vehicle_info VARCHAR,
	is_active BOOLEAN DEFAULT true
);

CREATE TABLE orders (
	order_id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customers(customer_id),
	delivery_address_id INT REFERENCES addresses(address_id),
	courier_id INT REFERENCES couriers(courier_id),
	order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	status order_status NOT NULL,
	total_amount DECIMAL NOT NULL,
	estimated_delivery_time TIMESTAMP,
	actual_delivery_time TIMESTAMP,
	deliver_notes TEXT
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    price_per_unit DECIMAL NOT NULL
);





