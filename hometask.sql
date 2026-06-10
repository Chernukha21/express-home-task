/**
    Розробіть таблицю products, яка зберігатиме інформацію про товари, та наповніть її щонайменше трьома записами.

Атрибути таблиці:
Назва. Обов’язковий атрибут. Унікальне значення (кожен товар має мати унікальну назву). Максимальна довжина — 64 символи.
Ціна. Обов’язковий атрибут. Позитивне число з двома знаками після крапки (наприклад, 123.45). Максимальне значення — 10,000 гривень.
Дата створення. Необов’язковий атрибут. Значення не може бути у майбутньому.
Кількість. Обов’язковий атрибут. Ціле додатнє число від 0 до 1000. Значення за замовчуванням — 0.
Валюта. Обов’язковий атрибут. Рядок із трьох символів (наприклад, uah, usd, eur). Значення за замовчуванням — 'uah'.
На розпродажі. Обов’язковий атрибут. Логічний тип (true/false). Значення за замовчуванням — false.


  CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE,
    price NUMERIC(7, 2) NOT NULL CHECK (price > 0 AND price <= 10000),
    date_of_creation DATE CHECK (date_of_creation <= CURRENT_DATE),
    quantity INTEGER NOT NULL DEFAULT 0 CHECK (quantity >= 0 AND quantity <= 1000),
    currency CHAR(3) NOT NULL DEFAULT 'uah',
    on_sale BOOLEAN NOT NULL DEFAULT false
);
  INSERT INTO products (
    name,
    price,
    date_of_creation,
    quantity,
    currency,
    on_sale
)
VALUES
    ('Keyboard', 1200.50, '2026-06-01', 10, 'uah', false),
    ('Mouse', 799.99, '2026-05-20', 25, 'uah', true),
    ('Monitor', 9999.99, '2026-04-15', 5, 'uah', false);



  Створити базу даних та таблицю за наступною схемою:
    STUDENTS(id, first_name, last_name, birthday, phone_number, group, avg_mark, gender, entered_at, department)

  CREATE TABLE students (
                          id SERIAL PRIMARY KEY,
                          first_name VARCHAR(64) NOT NULL,
                          last_name VARCHAR(64) NOT NULL,
                          birthday DATE CHECK (birthday <= CURRENT_DATE),
                          phone_number VARCHAR(20) NOT NULL UNIQUE,
                          "group" VARCHAR(20) NOT NULL,
                          avg_mark NUMERIC(5, 2) CHECK (avg_mark >= 0 AND avg_mark <= 100),
                          gender VARCHAR(10) CHECK (gender IN ('male', 'female')),
                          entered_at SMALLINT NOT NULL CHECK (entered_at >= 1900 AND entered_at <= 2026),
                          department VARCHAR(100) NOT NULL
);

INSERT INTO students (
    first_name,
    last_name,
    birthday,
    phone_number,
    "group",
    avg_mark,
    gender,
    entered_at,
    department
)
VALUES
    ('Ivan', 'Petrenko', '2004-05-12', '+380671112233', 'FE-101', 87.50, 'male', 2021, 'Computer Science'),
    ('Anna', 'Shevchenko', '2005-09-03', '+380501234567', 'FE-101', 92.30, 'female', 2022, 'Computer Science'),
    ('Oleh', 'Bondarenko', '2003-11-21', '+380931112244', 'ME-202', 76.80, 'male', 2020, 'Mechanical Engineering');

Поміняв довжину телефонного номера
  ALTER TABLE students
    ALTER COLUMN phone_number TYPE CHAR(13),
    ALTER COLUMN phone_number SET NOT NULL,
    ADD CONSTRAINT students_phone_number_unique UNIQUE (phone_number);
  */
