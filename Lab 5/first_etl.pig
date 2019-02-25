
data = LOAD '/dualcore/ad_data1.txt'
			 AS (
				keyword: chararray,
				campaign_id: chararray,
				date: chararray,
				time: chararray,
				display_site: chararray,
				was_clicked: int,
				cpc: int,
				country: chararray,
				placement: chararray
				);
usaData = FILTER data BY NOT (country != 'USA');

output_data = FOREACH usaData GENERATE
						campaign_id,
						date,
						time,
						UPPER(TRIM(keyword)) AS keyword: chararray,
						display_site,
						placement,
						was_clicked,
						cpc;
STORE output_data INTO '/dualcore/ad_data1';

