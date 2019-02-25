orders = LOAD '/dualcore/orders' AS (order_id:int,
             cust_id:int,
             order_dtm:chararray);

details = LOAD '/dualcore/order_details' AS (order_id:int,
             prod_id:int);

-- include only the months we want to analyze
recent = FILTER orders by order_dtm matches '^2013-0[2345]-\\d{2}\\s.*$';

-- include only the product we're advertising
tablets = FILTER details BY prod_id == 1274348;

-- TODO (A): Join the two relations on the order_id field
join_relations = JOIN recent BY order_id, tablets BY order_id;
groups = GROUP join_relations BY recent::order_dtm;
--joined = FOREACH join_relations GENERATE tablets::order_id;

-- TODO (B): Create a new relation containing just the month
order_year_month = FOREACH join_relations GENERATE SUBSTRING(order_dtm,0,7) AS year_month;

-- TODO (C): Group by month and then count the records in each group
group_order = GROUP order_year_month BY year_month;
order_per_month = FOREACH group_order GENERATE group, COUNT(order_year_month.year_month);
-- TODO (D): Display the results to the screen
DUMP order_per_month;
