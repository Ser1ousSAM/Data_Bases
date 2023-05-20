BEGIN;

--Постащики и адресаты
CREATE TABLE Clients
(
    id          SERIAL PRIMARY KEY,
    role        VARCHAR CHECK ( role = 'Provider' OR role = 'Addressee') NOT NULL,
    name        VARCHAR(255)                                            NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE Users
(
    id         SERIAL PRIMARY KEY,
    role       VARCHAR(255) CHECK ( role = 'Admin' OR role = 'Operator' OR role = 'Storekeeper') NOT NULL,
    name       VARCHAR(255)                                                                      NOT NULL,
    deleted_at TIMESTAMP
);

CREATE TABLE Products
(
    id     SERIAL PRIMARY KEY,
    name   VARCHAR(255) NOT NULL,
    weight float
);

CREATE TABLE Product_price
(
    product_id  INTEGER   NOT NULL REFERENCES Products (id),
    date_start  TIMESTAMP NOT NULL,
    date_finish TIMESTAMP
);

--Наличие товаров на складе
CREATE TABLE Inventory
(
    product_id INTEGER      NOT NULL REFERENCES Products (id),
    name       VARCHAR(255) NOT NULL,
    amount     integer      NOT NULL
);

CREATE TABLE Shipments
(
    id        SERIAL PRIMARY KEY,
    client_id INTEGER   NOT NULL REFERENCES Clients (id),
    date      TIMESTAMP NOT NULL
);

CREATE TABLE Shipment_info
(
    shipment_id INTEGER NOT NULL REFERENCES Shipments (id),
    product_id  INTEGER NOT NULL REFERENCES Products (id),
    amount      integer NOT NULL
);


CREATE TABLE Tasks
(
    id          SERIAL PRIMARY KEY,
    owner_id    INTEGER NOT NULL REFERENCES Users (id), --ограничение на role = operator
    executor_id INTEGER NOT NULL REFERENCES Users (id), --ограничение на role = storekeeper
    shipment_id INTEGER NOT NULL REFERENCES Shipments (id),
    date_start  TIMESTAMP NOT NULL,
    date_finish TIMESTAMP,
    description VARCHAR(255)                                            NOT NULL,
    status      VARCHAR(255) CHECK ( status = 'Received' OR status = 'Taken to work' OR status = 'Finished') NOT NULL
);

COMMIT;
