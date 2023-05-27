--1)
INSERT INTO users (role, name)
VALUES ('Storekeeper', 'Vasya Pupkin');

--2)
INSERT INTO clients (role, name, description)
VALUES ('Provider', 'Evgeniy Borovoy', 'Important man');

--3)
BEGIN;
INSERT INTO products (name, weight)
VALUES ('Ketchup', 1.2)
RETURNING id;
INSERT INTO product_price (product_id, date_start)
--получить id из прошлого запроса
VALUES (id, now());
COMMIT;

--4)
BEGIN;
--провайдер и адресат в юзерах (у них разные id и разные роли)
INSERT INTO shipments (provider_id, addressee_id, date)
VALUES (1, 2, now());
INSERT INTO shipment_info (shipment_id, product_id, amount)
VALUES (1, 1, 4);
COMMIT;

--5)
SELECT id
FROM products
WHERE name = 'Ketchup';

--6)
SELECT *
FROM tasks
WHERE executor_id = 1
  AND date_finish IS NULL
  AND date_start < now()
LIMIT 5 OFFSET 5;

--7)
INSERT INTO tasks (owner_id, executor_id, shipment_id, date_start, description, status)
VALUES (1, 1, 1, now(), 'Work hard', 'Received');

--8)
UPDATE tasks
SET status = 'Taken to work'
WHERE id = 1
  and executor_id = 1;

--9)
SELECT *
FROM shipments
WHERE provider_id = 1
  AND addressee_id = 2
  AND date = '';

--10)
UPDATE users
SET deleted_at = now()
WHERE id = 1
  AND (role = 'Operator' OR role = 'Storekeeper');
