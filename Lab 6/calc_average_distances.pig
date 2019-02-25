-- Register DataFu and define an alias for the function
REGISTER '/usr/lib/pig/datafu-*.jar';
DEFINE DIST datafu.pig.geo.HaversineDistInMiles;


cust_locations = LOAD '/dualcore/distribution/cust_locations/'
                   AS (zip:chararray,
                       lat:double,
                       lon:double);

warehouses = LOAD '/dualcore/distribution/warehouses.tsv'
                   AS (zip:chararray,
                       lat:double,
                       lon:double);
             


-- Create a record for every combination of customer and
-- proposed distribution center location.
combination = CROSS cust_locations, warehouses;

-- Calculate the distance from the customer to the warehouse
distance = FOREACH combination GENERATE warehouses::zip AS zip, DIST(cust_locations::lat, cust_locations::lon, warehouses::lat, warehouses::lon)AS dist;

-- Calculate the average distance for all customers to each warehouse
groupZip= GROUP distance BY zip;
avgZip = FOREACH groupZip GENERATE group AS zip, AVG(distance.dist) AS average;
-- Display the result to the screen
DUMP avgZip;
