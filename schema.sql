-- Sakila Schema for PostgreSQL

DROP SCHEMA IF EXISTS sakila CASCADE;
CREATE SCHEMA sakila;
SET search_path = sakila;

-- Table: actor
CREATE TABLE actor (
    actor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT now()
);

-- Table: language
CREATE TABLE language (
    language_id SERIAL PRIMARY KEY,
    name CHAR(20) NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT now()
);

-- Table: film
CREATE TABLE film (
    film_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    release_year INT,
    language_id INT NOT NULL,
    original_language_id INT,
    rental_duration INT NOT NULL DEFAULT 3,
    rental_rate NUMERIC(4,2) NOT NULL DEFAULT 4.99,
    length INT,
    replacement_cost NUMERIC(5,2) NOT NULL DEFAULT 19.99,
    rating VARCHAR(10) DEFAULT 'G',
    last_update TIMESTAMP NOT NULL DEFAULT now(),
    special_features TEXT[],
    fulltext tsvector
);

ALTER TABLE film
    ADD CONSTRAINT fk_film_language FOREIGN KEY (language_id) REFERENCES language(language_id),
    ADD CONSTRAINT fk_film_original_language FOREIGN KEY (original_language_id) REFERENCES language(language_id);

-- Table: category
CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(25) NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT now()
);

-- Table: film_category
CREATE TABLE film_category (
    film_id INT NOT NULL,
    category_id INT NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT now(),
    PRIMARY KEY (film_id, category_id),
    FOREIGN KEY (film_id) REFERENCES film(film_id),
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);

-- Table: film_actor
CREATE TABLE film_actor (
    actor_id INT NOT NULL,
    film_id INT NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT now(),
    PRIMARY KEY (actor_id, film_id),
    FOREIGN KEY (actor_id) REFERENCES actor(actor_id),
    FOREIGN KEY (film_id) REFERENCES film(film_id)
);

-- Table: country
CREATE TABLE country (
    country_id SERIAL PRIMARY KEY,
    country VARCHAR(50) NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT now()
);

-- Table: city
CREATE TABLE city (
    city_id SERIAL PRIMARY KEY,
    city VARCHAR(50) NOT NULL,
    country_id INT NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT now(),
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

-- Table: address
CREATE TABLE address (
    address_id SERIAL PRIMARY KEY,
    address VARCHAR(50) NOT NULL,
    address2 VARCHAR(50),
    district VARCHAR(20) NOT NULL,
    city_id INT NOT NULL,
    postal_code VARCHAR(10),
    phone VARCHAR(20) NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT now(),
    FOREIGN KEY (city_id) REFERENCES city(city_id)
);

-- Table: store
CREATE TABLE store (
    store_id SERIAL PRIMARY KEY,
    manager_staff_id INT NOT NULL,
    address_id INT NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT now(),
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);

-- Table: staff
CREATE TABLE staff (
    staff_id SERIAL PRIMARY KEY,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    address_id INT NOT NULL,
    email VARCHAR(50),
    store_id INT NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    username VARCHAR(16) NOT NULL,
    password VARCHAR(40),
    last_update TIMESTAMP NOT NULL DEFAULT now(),
    picture BYTEA,
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (store_id) REFERENCES store(store_id)
);

ALTER TABLE store
    ADD CONSTRAINT fk_store_manager FOREIGN KEY (manager_staff_id) REFERENCES staff(staff_id);

-- Table: customer
CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    store_id INT NOT NULL,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    email VARCHAR(50),
    address_id INT NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    create_date TIMESTAMP NOT NULL DEFAULT now(),
    last_update TIMESTAMP NOT NULL DEFAULT now(),
    FOREIGN KEY (store_id) REFERENCES store(store_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);

-- Table: inventory
CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    film_id INT NOT NULL,
    store_id INT NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT now(),
    FOREIGN KEY (film_id) REFERENCES film(film_id),
    FOREIGN KEY (store_id) REFERENCES store(store_id)
);

-- Table: rental
CREATE TABLE rental (
    rental_id SERIAL PRIMARY KEY,
    rental_date TIMESTAMP NOT NULL,
    inventory_id INT NOT NULL,
    customer_id INT NOT NULL,
    return_date TIMESTAMP,
    staff_id INT NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT now(),
    FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- Table: payment
CREATE TABLE payment (
    payment_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    staff_id INT NOT NULL,
    rental_id INT,
    amount NUMERIC(5,2) NOT NULL,
    payment_date TIMESTAMP NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
    FOREIGN KEY (rental_id) REFERENCES rental(rental_id)
);
