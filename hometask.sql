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


    CREATE TYPE gender_enum AS ENUM ('male', 'female');

    ALTER TABLE students
    DROP CONSTRAINT IF EXISTS students_gender_check;

    ALTER TABLE students
    ALTER COLUMN gender TYPE gender_enum
    USING gender::gender_enum;

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

    ALTER TABLE students
    ALTER COLUMN avg_mark TYPE NUMERIC(5, 2)
        USING avg_mark::NUMERIC(5, 2);
*/

//PostgreSQL. Запити на вибірку. Оновлення даних і таблиць

/**
  Отримати інформацію про студентів (ім'я+прізвище *через пробіл, дата народження) у порядку від найстаршого до наймолодшого.
  SELECT first_name || ' ' || last_name AS full_name,birthday FROM students ORDER BY birthday;

Отримати список шифрів груп, що не повторюються.
  SELECT DISTINCT "group" FROM students;

Отримати рейтинговий список студентів (ім'я (*або ініціал)+прізвище, середній бал): спочатку студентів із найвищим середнім балом, наприкінці з найменшим.
SELECT LEFT(first_name,1) || '. ' || last_name, avg_mark from students ORDER BY avg_mark desc;

Отримати другу сторінку списку студентів під час перегляду по 6 студентів на сторінці.
SELECT * from students LIMIT 6 OFFSET 6

Отримати список 3-х найуспішніших студентів (ім'я, прізвище, середній бал, група).
SELECT first_name, last_name, avg_mark, "group" from students ORDER BY avg_mark desc LIMIT 3;

* Отримати максимальний середній бал серед усіх студентів.
SELECT MAX(avg_mark) as max_rate from students;

* Отримати інфо про студентів (ініціал+прізвище, номер телефону), де номер телефону буде частково прихований та представлений у форматі: +38012******* (тобто видно код оператора, але не сам номер).
SELECT LEFT(first_name,1) || '. ' || last_name, LEFT(phone_number, 6) || '*******' from students;

Відобразити студентів на ім'я Anton та прізвище Antonov.
  SELECT * from students WHERE first_name='Anton' AND last_name='Antonov';

Відобразити студентів, які народилися в період із 2005 по 2008 рік.
SELECT * from students WHERE extract(YEAR from birthday) BETWEEN 2005 AND 2008;

Відобразити студентів на ім'я Mykola із середніми балами більше 4.5.
SELECT * from students WHERE first_name='Mykola' AND avg_mark > 4.5;

Відобразити кількість студентів, які навчаються у кожній групі.
SELECT "group", COUNT(id) FROM students GROUP BY "group";

Відобразити загальну кількість студентів, які вступили 2018 року.
SELECT COUNT(id) from students  WHERE entered_at=2018

Відобразити, коли відбувся перший набір (мінімальний рік вступу).
SELECT MIN(entered_at) AS first_enrollment_year from students;

*Відобразити студентів, які користуються послугами оператора Київстар. (тобто код 098 або 096 або ...)
SELECT *
FROM students
WHERE phone_number LIKE '+38067_______'
   OR phone_number LIKE '+38096_______'
   OR phone_number LIKE '+38097_______'
   OR phone_number LIKE '+38098_______'
   OR phone_number LIKE '+38068_______';


*Відобразити середній (середній) бал студентів жіночої статі кожного факультету. Список впорядкувати за зменшенням середнього балу. Стовпчик із середнім балом назвати avg_avg_mark.
SELECT
    department,
    AVG(avg_mark) AS avg_avg_mark
FROM students
WHERE gender = 'female'
GROUP BY department
ORDER BY avg_avg_mark DESC;

*Відобразити мінімальний середній бал студентів факультету інформаційних технологій, що народилися влітку, залежно від року вступу. Виводити інформацію лише про ті роки вступу, де мінімальний середній бал вищий за 3,5.
SELECT
    entered_at,
    MIN(avg_mark) AS min_avg_mark
FROM students
WHERE department = 'Information Technology'
  AND EXTRACT(MONTH FROM birthday) BETWEEN 6 AND 8
GROUP BY entered_at
HAVING MIN(avg_mark) > 3.5
ORDER BY entered_at;


Для всіх студентів з ім'ям Vasya змінити написання імені Vasia.
UPDATE students
SET first_name = 'Vasia'
WHERE first_name = 'Vasya';

*Додати до таблиці стовпець з інформацією про номер студентського білету студента (2 букви - 5 цифр 1 буква: AA-00000A). Додати дані в цей стовпець (мінімум в один рядок).
ALTER table students
    ADD COLUMN student_card_number VARCHAR(9)
    CHECK (student_card_number ~ '^[A-Z]{2}-[0-9]{5}[A-Z]$');

Видалити інформацію про студентів, що вступили 2010 року.
  DELETE from students WHERE entered_at=2010
  */