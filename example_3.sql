SET
  NAMES 'utf8';
SET
  CHARACTER SET 'utf8';
DROP DATABASE IF EXISTS db3;
CREATE DATABASE IF NOT EXISTS db3;
ALTER DATABASE db3 CHARACTER SET utf8 COLLATE utf8_general_ci;
USE db3;
DROP TABLE IF EXISTS staff;
CREATE TABLE IF NOT EXISTS staff (
    id INT PRIMARY KEY AUTO_INCREMENT,
    firstname VARCHAR(45),
    lastname VARCHAR(45),
    post VARCHAR(45),
    seniority INT,
    salary INT,
    age INT
  );
INSERT INTO
  staff (
    firstname,
    lastname,
    post,
    seniority,
    salary,
    age
  )
VALUES
  ('Вася', 'Васькин', 'Начальник', 40, 100000, 60),
  ('Петр', 'Власов', 'Начальник', 8, 70000, 30),
  ('Катя', 'Катина', 'Инженер', 2, 70000, 25),
  ('Саша', 'Сасин', 'Инженер', 12, 50000, 35),
  ('Иван', 'Петров', 'Рабочий', 40, 30000, 59),
  ('Петр', 'Петров', 'Рабочий', 20, 55000, 60),
  ('Сидр', 'Сидоров', 'Рабочий', 10, 20000, 35),
  ('Антон', 'Антонов', 'Рабочий', 8, 19000, 28),
  ('Юрий', 'Юрков', 'Рабочий', 5, 15000, 25),
  ('Максим', 'Петров', 'Рабочий', 2, 11000, 19),
  ('Юрий', 'Петров', 'Рабочий', 3, 12000, 24),
  ('Людмила', 'Маркина', 'Уборщик', 10, 10000, 49);
DROP TABLE IF EXISTS activity_staff;
CREATE TABLE IF NOT EXISTS activity_staff (
    id INT PRIMARY KEY AUTO_INCREMENT,
    staff_id INT,
    FOREIGN KEY (staff_id) REFERENCES staff (id),
    date_activity DATE,
    count_pages INT
  );
INSERT
  activity_staff (staff_id, date_activity, count_pages)
VALUES
  (1, '2022-01-01', 250),
  (2, '2022-01-01', 220),
  (3, '2022-01-01', 170),
  (1, '2022-01-02', 100),
  (2, '2022-01-01', 220),
  (3, '2022-01-01', 300),
  (7, '2022-01-01', 350),
  (1, '2022-01-03', 168),
  (2, '2022-01-03', 62),
  (3, '2022-01-03', 84);

# Выведем id сотрудников, которые напечатали более 500 страниц за всех дни
SELECT
  staff_id,
  SUM(count_pages) total_pages
FROM
  activity_staff
GROUP BY
  staff_id
HAVING
  total_pages > 500;

# Выведем дни, когда работало более 3 сотрудников
SELECT
  date_activity,
  COUNT(staff_id) count_staff
FROM
  activity_staff
GROUP BY
  date_activity
HAVING
  count_staff > 3;

# Выведем среднюю заработную плату по должностям, которая составляет
  # более 30000
SELECT
  post,
  AVG(salary) average_salary
FROM
  staff
GROUP BY
  post
HAVING
  average_salary > 30000;

# Отсортируем данные по полю заработная плата (salary) в порядке:
  # убывания;
SELECT
  *
FROM
  staff
ORDER BY
  salary DESC;

# возрастания
SELECT
  *
FROM
  staff
ORDER BY
  salary;

# Выведем 5 максимальных заработных плат (salary)
SELECT
  firstname,
  lastname,
  post,
  salary
FROM
  staff
ORDER BY
  salary DESC
LIMIT
  5;

# Посчитаем суммарную зарплату (salary) по каждой специальности (роst)
SELECT
  post,
  SUM(salary) 'ФОТ'
FROM
  staff
GROUP BY
  post;

# Найдем кол-во сотрудников с специальностью (post) «Рабочий»
  # в возрасте от 24 до 49 лет включительно.
SELECT
  post,
  COUNT(id) count_staff
FROM
  staff
WHERE
  age BETWEEN 24
  AND 49
GROUP BY
  post
HAVING
  post = 'Рабочий';

# Найдем количество специальностей
SELECT
  COUNT(DISTINCT post) count_post
FROM
  staff;

# Выведем специальности, у которых средний возраст сотрудников
  # меньше  или равен 30 лет
SELECT
  post,
  AVG(age) average_age
FROM
  staff
GROUP BY
  post
HAVING
  average_age <= 30;