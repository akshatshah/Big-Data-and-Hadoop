-- TODO (A): Replace 'FIXME' to load the test_ad_data.txt file.

 data = LOAD '/dualcore/ad_data[1-2]/part*'
			AS (
				campaign_id:chararray,
				date:chararray,
				time:chararray,
				keyword:chararray,
				display_site:chararray,
				placement:chararray,
				was_clicked:int,
				cpc:int
			);

-- TODO (B): Include only records where was_clicked has a value of 1
clicked_data = FILTER data BY was_clicked == 1;

-- TODO (C): Group the data by the appropriate field
group_by_kw = GROUP clicked_data BY keyword;

/* TODO (D): Create a new relation which includes only the 
 *           display site and the total cost of all clicks 
 *           on that site
 */
totalcost = FOREACH group_by_kw GENERATE group AS keyword, SUM(clicked_data.cpc) AS total;

-- TODO (E): Sort that new relation by cost (ascending)
totalcost = ORDER totalcost BY total DESC; 

-- TODO (F): Display just the first three records to the screen
top_5 = LIMIT totalcost 5;
DUMP top_5;
