-- 1.
SELECT products.product_name, products.standard_cost, products.list_price
FROM products
ORDER BY products.standard_cost desc, products.list_price asc;

-- 2.
SELECT products.product_name, products.description, products.list_price - products.standard_cost AS products_price_difference
FROM products
WHERE products.product_name LIKE 'Intel%';

-- 3.
ALTER TABLE order_items
DROP COLUMN unit_price;

-- 4.
UPDATE locations
SET city = city||' ('||state||')'
WHERE state IS NOT NULL;

rollback;

commit;

-- 5.
SELECT DISTINCT employees.first_name, employees.last_name
FROM employees, orders
WHERE employees.employee_id = orders.salesman_id
AND orders.status = 'Canceled';

-- 6.
SELECT employees.employee_id, employees.first_name, employees.last_name, employees.job_title
FROM employees
WHERE employees.employee_id NOT IN (
    SELECT employees.manager_id
    FROM employees
    WHERE employees.manager_id IS NOT NULL
);
-- 7.
SELECT locations.address, warehouses.warehouse_name
FROM locations, warehouses
WHERE warehouses.location_id = locations.location_id
AND locations.country_id != 'US';

-- 8.
WITH priceinfo (product_id, product_price_diff) AS (
    SELECT product_id, products.list_price - products.standard_cost
    FROM products
)
SELECT orders.order_id, orders.order_date, SUM(priceinfo.product_price_diff) 
FROM order_items
LEFT OUTER JOIN orders
ON order_items.order_id = orders.order_id
LEFT OUTER JOIN priceinfo
ON order_items.product_id = priceinfo.product_id
GROUP BY orders.order_id, orders.order_date
HAVING COUNT(priceinfo.product_id) < 4;

-- 9.
CREATE OR REPLACE VIEW
sales_impact (employee_id, first_name, last_name, total_income) AS (
    SELECT DISTINCT employees.employee_id, employees.first_name, employees.last_name, NVL(SUM((products.list_price - products.standard_cost) * order_items.quantity), 0)
    FROM employees
    LEFT OUTER JOIN orders
    ON employees.employee_id = orders.salesman_id
    LEFT OUTER JOIN order_items
    ON orders.order_id = order_items.order_id
    LEFT OUTER JOIN products
    ON order_items.product_id = products.product_id
    WHERE employees.job_title = 'Sales Representative'
    GROUP BY employees.employee_id, employees.first_name, employees.last_name
);

-- 10.
WITH catinfo (cid, cname) AS(
    SELECT product_categories.category_id, product_categories.category_name
    FROM product_categories
),
    wareinfo (wid, wname) AS (
    SELECT warehouses.warehouse_id, warehouses.warehouse_name
    FROM warehouses
)
SELECT wareinfo.wname, catinfo.cname, SUM(products.list_price) / count(*) avg_price
FROM wareinfo
LEFT OUTER JOIN inventories
ON wareinfo.wid = inventories.warehouse_id
LEFT OUTER JOIN products
ON inventories.product_id = products.product_id
LEFT OUTER JOIN catinfo
ON catinfo.cid = products.category_id
GROUP BY wareinfo.wname, catinfo.cname
ORDER BY wareinfo.wname ASC;

with kategorije (cid, cname) as (
select c.category_id, c.category_name 
from product_categories c
),
skladista (wid, wname) as (
select w.warehouse_id, w.warehouse_name
from warehouses w
)
select k.cname, s.wname, avg(p.list_price)*count(p.product_id) Kolicina_Inventara
from kategorije k inner join products p on k.cid = p.category_id
inner join inventories i on i.product_id = p.product_id
inner join skladista s on s.wid = i.warehouse_id
group by s.wname, k.cname
having avg(p.list_price) <= (select avg(sum(p.list_price)) from products)
union all
select k.cname, s.wname, round(avg(p.list_price)*count(p.product_id), 3) Kolicina_Inventara
from kategorije k inner join products p on k.cid = p.category_id
inner join inventories i on i.product_id = p.product_id
inner join skladista s on s.wid = i.warehouse_id
group by s.wname, k.cname
having avg(p.list_price) > (select avg(sum(p.list_price)) from products)
;

drop view sales_impact;

