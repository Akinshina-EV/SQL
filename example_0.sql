-- преобразуем наименования товаров в таблице products так, чтобы от названий
-- осталось только первое слово, записанное в верхнем регистре. Колонку с новым
-- названием, состоящим из первого слова, назовем first_word.
SELECT name,
       upper(split_part(name, ' ', 1)) as first_word,
       price
FROM   products
ORDER BY name;
-- Изменим тип колонки price из таблицы products на VARCHAR
SELECT name,
       price,
       cast(price as varchar) as price_char
FROM   products
ORDER BY name;
-- Для первых 200 записей из таблицы orders выведем информацию в следующем виде:
-- Заказ № [id_заказа] создан [дата]
-- Полученную колонку назовем order_info.
SELECT concat('Заказ ',
              '№ ',
              order_id,
              ' создан ',
              date(creation_time)) as order_info
FROM   orders limit 200;
-- Выведем id всех курьеров и их годы рождения из таблицы couriers.
SELECT courier_id,
       coalesce(cast(date_part('year', birth_date) as varchar), 'unknown') birth_year
FROM   couriers
ORDER BY birth_year desc, courier_id;
-- Повысим цену на 5% только на те товары, цена которых превышает 100 рублей,
-- за исключением цены на икру, которая и так стоит 800 рублей.
SELECT product_id,
       name,
       price old_price,
       case when price > 100 and
                 name != 'икра' then price * 1.05
            else price end as new_price
FROM   products
ORDER BY new_price desc, product_id;
-- Вычислим НДС каждого товара в таблице products и рассчитаем цену без учёта
-- НДС. Колонки с суммой налога и ценой без НДС назовем соответственно tax и
-- price_before_tax
SELECT product_id,
       name,
       price,
       case when name in ('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное',
                          'виноград', 'масло оливковое', 'арбуз', 'батон', 'йогурт',
                          'сливки', 'гречка', 'овсянка', 'макароны', 'баранина',
                          'апельсины', 'бублики', 'хлеб', 'горох', 'сметана',
                          'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина',
                          'рис', 'масло кунжутное', 'сгущенка', 'ананас', 'говядина',
                          'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки',
                          'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли',
                          'мандарины') then round(price / 110 * 10, 2)
            else round(price / 120 * 20, 2) end as tax,
       case when name in ('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное',
                          'виноград', 'масло оливковое', 'арбуз', 'батон', 'йогурт',
                          'сливки', 'гречка', 'овсянка', 'макароны', 'баранина',
                          'апельсины', 'бублики', 'хлеб', 'горох', 'сметана',
                          'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина',
                          'рис', 'масло кунжутное', 'сгущенка', 'ананас', 'говядина',
                          'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки',
                          'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли',
                          'мандарины') then round(price - price / 110 * 10, 2)
            else round(price - price / 120 * 20, 2) end as price_before_tax
FROM   products
ORDER BY price_before_tax desc, product_id;
-- Назначим скидку 20% на все товары из таблицы products и отберем те, цена на
-- которые с учётом скидки превышает 100 рублей. Колонку со старой ценой
-- назовем old_price, с новой — new_price.
SELECT product_id,
       name,
       price old_price,
       price * 0.8 new_price
FROM   products
WHERE  price * 0.8 > 100
ORDER BY product_id;
-- Отберем из таблицы products все товары, названия которых либо начинаются со
-- слова «чай», либо состоят из пяти символов.
SELECT product_id,
       name
FROM   products
WHERE  split_part(name, ' ', 1) = 'чай'
    or length(name) = 5
ORDER BY product_id;
-- Выбирем из таблицы products все чаи стоимостью больше 60 рублей и вычислим
-- для них цену со скидкой 25%, которую укажем в отдельном столбце. Столбцы со
-- скидкой и новой ценой назовем соответственно discount и new_price.
-- Также "избавимся" от «чайного гриба», который не должен попасть в итоговую
-- выборку.
SELECT product_id,
       name,
       price,
       '25%' discount,
       price * 0.75 new_price
FROM   products
WHERE  name like '%чай%'
   and name not like '%гриб%'
   and price > 60
ORDER BY product_id;
-- Из таблицы user_actions получим id всех заказов, сделанных пользователями
-- сервиса в августе 2022 года.
SELECT order_id
FROM   user_actions
WHERE  date_part('year', time) = '2022'
   and date_part('month', time) = '08'
   and action = 'create_order'
ORDER BY order_id;
-- Из таблицы user_actions получим информацию о всех отменах заказов, которые
-- пользователи совершали в течение августа 2022 года по средам с 12:00 до 15:59.
SELECT user_id,
       order_id,
       action,
       time
FROM   user_actions
WHERE  action = 'cancel_order'
   and date_part('year', time) = 2022
   and date_part('month', time) = 8
   and date_part('dow', time) = 3
   and split_part(cast(time as varchar), ' ', 2) between '12:00'
   and '16:00'
ORDER BY order_id desc;
-- Посчитаем количество всех записей в таблице users и количество только тех записей,
-- для которых в колонке birth_date указана дата рождения. Колонку с общим числом
-- записей назовем dates, а колонку с записями без пропусков — dates_not_null.
SELECT count(*) dates,
       count(birth_date) dates_not_null
FROM   users;



