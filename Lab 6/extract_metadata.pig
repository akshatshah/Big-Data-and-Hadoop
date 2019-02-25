-- Define an alias for the supplied Python script we 
-- use to parse the metadata from the MP3 files
DEFINE tagreader `readtags.py`;

-- load the list of MP3 files to analyze
calls = LOAD 'call_list.txt' AS (file:chararray);

-- Use the STREAM keyword to invoke our script, and parse
-- MP3 metadata, returning the fields shown here
metadata = STREAM calls THROUGH tagreader AS (path:chararray,
           category:chararray,
           agent_id:chararray,
           customer_id:chararray,
           timestamp:chararray);


-- TODO (A): Replace the hardcoded '2013-04' with
-- a parameter specified on the command line
by_month = FILTER metadata BY SUBSTRING(timestamp, 0, 7)=='$MONTH';


-- TODO (B): Count calls by category
groupCategory = GROUP by_month BY category;
countCategory = FOREACH groupCategory GENERATE group AS category,
COUNT(by_month) AS totaln; 
-- TODO (C): Display the top three categories to the screen
sort1 = ORDER countCategory by totaln DESC;
top3 = LIMIT sort1 3;
DUMP top3; 
