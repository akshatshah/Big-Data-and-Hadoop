data = LOAD '/dualcore/orders' AS (order_id:int,
             cust_id:int,
             order_dtm:chararray);

/*
 * Include only records where the 'order_dtm' field matches
 * the regular expression pattern:
 *
 *   ^       = beginning of string
 *   2013    = literal value '2013'
 *   0[2345] = 0 followed by 2, 3, 4, or 5
 *   -       = a literal character '-'
 *   \\d{2}  = exactly two digits
 *   \\s     = a single whitespace character
 *   .*      = any number of any characters
 *   $       = end of string
 *
 * If you are not familiar with regular expressions and would
 * like to know more about them, see the Regular Expression 
 * Reference at the end of the Exercise Manual.
 */
recent = FILTER data by order_dtm matches '^2013-0[2345]-\\d{2}\\s.*$';

-- TODO (A): Create a new relation with just the order's year and month
orderym = FOREACH recent GENERATE SUBSTRING(order_dtm,0,7) as ym;

-- TODO (B): Count the number of orders in each month
sort_order = GROUP orderym  BY ym;
order_per_month = FOREACH sort_order GENERATE group, COUNT(orderym.ym);
-- TODO (C): Display the count by month to the screen.
DUMP order_per_month


