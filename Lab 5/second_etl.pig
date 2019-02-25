data = LOAD '/dualcore/ad_data2.txt' AS (
				campaign_id: chararray,
				date: chararray,
				time: chararray,
				display_site: chararray,
				placement: chararray,
				was_clicked: int,
				cpc: int,
				keyword: chararray
			);

unique_data = DISTINCT data;

output_data = FOREACH unique_data GENERATE
						campaign_id,
						REPLACE(date, '-', '/') AS date: chararray,
						time,
						UPPER(TRIM(keyword)) AS keyword: chararray,
						display_site,
						placement,
						was_clicked,
						cpc;

STORE output_data INTO '/dualcore/ad_data2';
