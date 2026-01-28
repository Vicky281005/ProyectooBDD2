SELECT index_name,stat_name,stat_value
FROM mysql.innodb_index_stats
Where LOWER(database_name)=LOWER('NuevoEsquema') AND 
stat_name in ('size','n_leaf_pages') AND 
table_name='participacion_clase'