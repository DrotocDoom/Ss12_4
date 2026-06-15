CREATE TABLE products (
                          product_id SERIAL PRIMARY KEY,
                          name VARCHAR(50),
                          price NUMERIC,
                          stock INT
);

CREATE TABLE sales (
                       sale_id SERIAL PRIMARY KEY,
                       product_id INT REFERENCES products(product_id),
                       quantity INT
);

CREATE TABLE orders (
                        order_id SERIAL PRIMARY KEY,
                        product_id INT REFERENCES products(product_id),
                        quantity INT,
                        total_amount NUMERIC
);

INSERT INTO products (name, price, stock) VALUES
('Product A', 10.00, 100),
('Product B', 20.00, 50),
('Product C', 15.00, 75);


CREATE OR REPLACE FUNCTION total_amount()
RETURNS trigger
AS $$
BEGIN
    NEW.total_amount := NEW.quantity * (SELECT price FROM products WHERE product_id = NEW.product_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER calculate_total_amount
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION total_amount();

SELECT * FROM products;
SELECT * FROM orders;

INSERT INTO orders (product_id, quantity) VALUES (1, 2);