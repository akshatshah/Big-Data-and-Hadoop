
data = LOAD '/dualcore/ad_data[1-2]/part*' AS
		(campaign_id:chararray,
		 date:chararray,
		 time:chararray,
		 keyword:chararray,
		 display_site:chararray,
		 placement:chararray,
		 was_clicked:int,
		 cpc:int);

clicked = FILTER data BY was_clicked == 1;

grouped = GROUP clicked ALL;

total = FOREACH grouped GENERATE COUNT(clicked.was_clicked);

DUMP total;

