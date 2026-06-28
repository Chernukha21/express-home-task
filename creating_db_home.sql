CREATE TABLE students (
                          id_stud SERIAL PRIMARY KEY,
                          name VARCHAR(50) NOT NULL,
                          surname VARCHAR(50) NOT NULL,
                          birthday DATE NOT NULL,
                          phone_number VARCHAR(20),
                          "group" VARCHAR(20),
                          gender VARCHAR(10),
                          entered_at DATE,
                          department VARCHAR(100)
);

CREATE TABLE courses (
                         id_course SERIAL PRIMARY KEY,
                         title VARCHAR(100) NOT NULL,
                         description TEXT,
                         hours INT NOT NULL CHECK (hours > 0)
);

CREATE TABLE exams (
                       id_exam SERIAL PRIMARY KEY,
                       id_stud INT NOT NULL,
                       id_course INT NOT NULL,
                       mark NUMERIC(3,2),

                       UNIQUE (id_stud, id_course),

                       FOREIGN KEY (id_stud)
                           REFERENCES students(id_stud),

                       FOREIGN KEY (id_course)
                           REFERENCES courses(id_course)
);

INSERT INTO students (
    name,
    surname,
    birthday,
    phone_number,
    "group",
    gender,
    entered_at,
    department
)
VALUES
    ('Petro', 'Petrenko', '2001-05-14', '+380501111111', 'PD-21', 'male', '2020-09-01', 'Computer Science'),
    ('Anna', 'Ivanova', '2002-03-10', '+380502222222', 'PD-21', 'female', '2020-09-01', 'Computer Science'),
    ('Oleh', 'Shevchenko', '2000-11-22', '+380503333333', 'KN-20', 'male', '2019-09-01', 'Software Engineering'),
    ('Maria', 'Kovalenko', '2001-05-14', '+380504444444', 'KN-20', 'female', '2019-09-01', 'Software Engineering');

INSERT INTO courses (
    title,
    description,
    hours
)
VALUES
    ('Основи програмування', 'Базовий курс програмування', 120),
    ('Information Technologies', 'Основи інформаційних технологій', 90),
    ('Databases', 'Робота з реляційними базами даних', 100),
    ('Web Development', 'Основи веброзробки', 140);

INSERT INTO exams (
    id_stud,
    id_course,
    mark
)
VALUES
    (1, 1, 4.5),
    (1, 2, 4.0),
    (2, 1, 3.0),
    (2, 3, NULL),
    (3, 2, 5.0),
    (3, 4, 4.5);

/* (З’єднання таблиць:)*/
/*Відобразити імена та прізвища студентів та назви курсів, що ними вивчаються.*/
SELECT students.name, students.surname, courses.title FROM students
INNER JOIN exams ON students.id_stud = exams.id_stud
INNER JOIN courses ON exams.id_course = courses.id_course;
/* Відобразити бали студента Петра Петренка з дисципліни «Основи програмування». */
SELECT exams.mark FROM exams
                           INNER JOIN students ON exams.id_stud = students.id_stud
                           INNER JOIN courses ON exams.id_course = courses.id_course
WHERE students.name='Petro' AND students.surname='Petrenko' AND courses.title='Основи програмування';
/*Відобразити студентів, які мають бали нижче 3.5.*/
SELECT DISTINCT students.name, students.surname FROM students INNER JOIN exams
                    ON students.id_stud = exams.id_stud
                        WHERE exams.mark < 3.5;
/* Відобразити студентів, які прослухали дисципліну «Основи програмування» та мають за неї оцінку*/
SELECT students.name, students.surname FROM students
                                                INNER JOIN exams ON students.id_stud = exams.id_stud
                                                INNER JOIN courses ON exams.id_course = courses.id_course
WHERE courses.title='Основи програмування' AND exams.mark IS NOT NULL;
/*Відобразити середній бал та кількість курсів, які відвідав кожен студент.*/
SELECT
    students.id_stud,
    students.name,
    students.surname,
    AVG(exams.mark) AS average_mark,
    COUNT(exams.id_course) AS courses_count
FROM students
         LEFT JOIN exams
                   ON students.id_stud = exams.id_stud
GROUP BY
    students.id_stud,
    students.name,
    students.surname;

/*Відобразити студентів, які мають середній бал вище 4.0.*/
SELECT
    students.name,
    students.surname,
    AVG(exams.mark) AS average_mark
FROM students
         INNER JOIN exams
                    ON students.id_stud = exams.id_stud
GROUP BY
    students.id_stud,
    students.name,
    students.surname
HAVING AVG(exams.mark) > 4.0;
/**Відобразити дисципліни, які ще не прослухав жоден студент.*/
SELECT courses.title
FROM courses
         LEFT JOIN exams
                   ON courses.id_course = exams.id_course
WHERE exams.id_course IS NULL;

/*Підзапити*/
/*Отримати список студентів, у яких день народження збігається із днем народження Петра Петренка.*/
SELECT
    students.name,
    students.surname
FROM students
WHERE students.birthday = (
    SELECT birthday
    FROM students
    WHERE name = 'Petro'
      AND surname = 'Petrenko'
);
/*Відобразити студентів, які мають середній бал вище, ніж Петро Петренко.*/
SELECT
    students.name,
    students.surname,
    AVG(exams.mark) AS average_mark
FROM students
         INNER JOIN exams
                    ON students.id_stud = exams.id_stud
GROUP BY
    students.id_stud,
    students.name,
    students.surname
HAVING AVG(exams.mark) > (
    SELECT AVG(exams.mark)
    FROM students
             INNER JOIN exams
                        ON students.id_stud = exams.id_stud
    WHERE students.name = 'Petro'
      AND students.surname = 'Petrenko'
);
/*Отримати список предметів, у яких кількість годин більше, ніж у «Information Technologies».*/
SELECT courses.title
FROM courses
WHERE hours > (
    SELECT hours
    FROM courses
    WHERE title = 'Information Technologies'
);
/*Отримати список
студент | предмет | оцінка
де оцінка має бути більшою за будь-яку оцінку Петра Петренка.*/
SELECT
    students.name || ' ' || students.surname AS student,
    courses.title AS subject,
    exams.mark AS mark
FROM students
         JOIN exams
              ON students.id_stud = exams.id_stud
         JOIN courses
              ON exams.id_course = courses.id_course
WHERE exams.mark > (
    SELECT MAX(exams.mark)
    FROM exams
             JOIN students
                  ON exams.id_stud = students.id_stud
    WHERE students.name = 'Petro'
      AND students.surname = 'Petrenko'
);
/*Отримати перелік студентів, які ще не вивчали жодного предмету*/
SELECT
    students.name,
    students.surname
FROM students
WHERE NOT EXISTS (
    SELECT 1
    FROM exams
    WHERE exams.id_stud = students.id_stud
);

SELECT
    students.name,
    students.surname
FROM students
         LEFT JOIN exams
                   ON students.id_stud = exams.id_stud
WHERE exams.id_stud IS NULL;

/* Вивести студент | предмет | оцінка,
   щоб оцінка виводилася у літерному вигляді
   «відмінно», «добре» або «задовільно». */
SELECT
    students.name || ' ' || students.surname AS student,
    courses.title AS subject,
    CASE
        WHEN exams.mark >= 4.5 THEN 'відмінно'
        WHEN exams.mark >= 3.5 THEN 'добре'
        WHEN exams.mark IS NOT NULL THEN 'задовільно'
        ELSE 'іспит ще не складено'
        END AS mark
FROM students
         JOIN exams
              ON students.id_stud = exams.id_stud
         JOIN courses
              ON exams.id_course = courses.id_course;

/*Представлення*/
CREATE VIEW student_courses AS
SELECT
    students.name || ' ' || students.surname AS student,
    courses.title AS course,
    exams.mark
FROM students
         JOIN exams
              ON students.id_stud = exams.id_stud
         JOIN courses
              ON exams.id_course = courses.id_course;