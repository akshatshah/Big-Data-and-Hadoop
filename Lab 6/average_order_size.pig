orders = LOAD '/dualcore/orders' AS (order_id:int,
             cust_id:int,
             order_dtm:chararray);

details = LOAD '/dualcore/order_details' AS (order_id:int,
             prod_id:int);


-- TODO (A): Include only records from during the ad campaign
recent = FILTER orders BY order_dtm matches '2013-05-.*$';


-- TODO (B): Find all the orders containing the advertised product
tablets = FILTER details BY prod_id == 1274348;


-- TODO (C): Get the details for each of those orders
order_tablets = JOIN tablets BY order_id, details BY order_id;


-- TODO (D): Count the number of items in each order
group_orders = GROUP order_tablets BY tablets::order_id;
num_items = FOREACH group_orders GENERATE group, COUNT(order_tablets) AS num_tab;
grouped = GROUP num_items ALL;

-- TODO (E): Calculate the average number of items in each order
average = FOREACH grouped GENERATE AVG(num_items.num_tab);

-- Display the final result to the screen
DUMP average;
