SELECT
    table_name,
    table_rows,           
    data_length,          
    index_length,  
	avg_row_length,
    ROUND(data_length / @@innodb_page_size) AS approx_pages
FROM information_schema.tables
WHERE table_schema = 'proyectobdd2'; 
