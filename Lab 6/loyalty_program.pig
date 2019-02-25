--loading the data sets used for the script

orders = LOAD '/dualcore/orders' AS (order_id:int,
             cust_id:int,
             order_dtm:chararray);

details = LOAD '/dualcore/order_details' AS (order_id:int,
             prod_id:int);

products = LOAD '/dualcore/products' AS (prod_id:int,
             brand:chararray,
             name:chararray,
             price:int,
             cost:int,
             shipping_wt:int);


/*
 * TODO: Find all customers who had at least five orders
 *       during 2012. For each such customer, calculate 
 *       the total price of all products he or she ordered
 *       during that year. Split those customers into three
 *       new groups based on the total amount:
 *
 *        platinum: At least $10,000
 *        gold:     At least $5,000 but less than $10,000
 *        silver:   At least $2,500 but less than $5,000
 *
 *       Write the customer ID and total price into a new
 *       directory in HDFS. After you run the script, use
 *       'hadoop fs -getmerge' to create a local text file
 *       containing the data for each of these three groups.
 *       Finally, use the 'head' or 'tail' commands to check 
 *       a few records from your results, and then use the  
 *       'wc -l' command to count the number of customers in 
 *       each group.
 */
orders_2012 = FILTER orders by order_dtm matches '^2012.*$';

groupByCustomer = GROUP orders BY cust_id;
countPerCustomer = FOREACH groupByCustomer Generate group, COUNT(orders)AS num_orders;
MoreThan5 = FILTER countPerCustomer BY num_orders >=5;

ordersIn2012 = JOIN MoreThan5 BY group, orders_2012 BY cust_id;

orderDetail = JOIN ordersIn2012 BY orders_2012::order_id, details by order_id; 

orderProduct = JOIN orderDetail BY details::prod_id, products BY prod_id;

productPrices = FOREACH orderProduct GENERATE MoreThan5::group AS cust_id, products::price AS price;

groupTotal = GROUP productPrices BY cust_id;

customerTotal = FOREACH groupTotal GENERATE group, SUM(productPrices.price) AS total;

SPLIT customerTotal INTO 
silver IF total >=2500 AND total<5000,
gold IF total>5000 AND total <10000,
platinum IF total>=10000;

STORE silver INTO '/dualcore/loyalty/silver';
STORE gold INTO '/dualcore/loyalty/gold';
STORE platinum INTO '/dualcore/loyalty/platinum';
