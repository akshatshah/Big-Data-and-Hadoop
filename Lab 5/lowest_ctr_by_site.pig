
data = LOAD '/dualcore/ad_data[1-2]/part*' AS 
		(campaign_id:chararray,
		 date:chararray,
		 time:chararray,
		 keyword:chararray,
		 display_site:chararray,
		 placement:chararray,
		 was_clicked:int,
		 cpc:int);

groupedby = GROUP data BY display_site;
ctr_by_site = FOREACH groupedby {
  click = FILTER data BY was_clicked == 1;
  times_clicked = COUNT(click);
  total = COUNT(data);
   ctr = times_clicked*100.0/total;
   GENERATE group, ctr AS ctr;
}

-- sort the records in ascending order of clickthrough rate
ordered = ORDER ctr_by_site BY ctr ASC;

top_3 =LIMIT ordered 3;

grouped_by_kW = GROUP data BY keyword;

ctr_by_kw = FOREACH grouped_by_kW {
	click = FILTER data BY was_clicked == 1;
	times_clicked = COUNT(click);
	total = COUNT(data);
	ctr = times_clicked*100.0/total;
	GENERATE group, ctr AS ctr;
}

ordered_by_kw = ORDER ctr_by_kw BY ctr DESC;

top_3_kw = LIMIT ordered_by_kw 3;
DUMP top_3;
DUMP top_3_kw;


