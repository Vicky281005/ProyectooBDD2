SET @Nombre_BD     = 'NuevoEsquema';
SET @Nombre_Tabla  = 'participacion_clase';
SET @Nombre_Indice = 'index_est_tip_part';
SET @Bytes_PK      = 4; 

-- 1. Calcula el promedio de longitud de 'tipo_participacion'
SELECT ROUND(AVG(LENGTH(tipo_participacion))) INTO @Promedio_Tipo FROM participacion_clase;

-- 2. Define Bytes_Columna usando el promedio calculado
-- (Si la tabla está vacía, usa 10 por defecto para no romper la fórmula)
SET @Bytes_Columna = IFNULL(@Promedio_Tipo, 10);

-- 3. Calculadora Maestra
SELECT 
    @Nombre_Indice AS Indice_Analizado,
    CAST(@Bytes_Columna AS UNSIGNED) AS Bytes_Col,
    CAST(@Bytes_PK AS UNSIGNED) AS Bytes_PK,
    CAST((13 + @Bytes_Columna + @Bytes_PK) AS UNSIGNED) AS E_Leaf_Teorico,
    CAST(CEILING((16384 - 154) / (13 + @Bytes_Columna + @Bytes_PK)) AS UNSIGNED) AS b_leaf_Teorico,
    CEILING(T.TABLE_ROWS / CEILING((16384 - 154) / (13 + @Bytes_Columna + @Bytes_PK))) AS Hojas_Teoricas, 
    CAST((13 + @Bytes_Columna + @Bytes_PK + 4) AS UNSIGNED) AS E_Internal_Teorico,
    CAST(CEILING((16384 - 154) / (13 + @Bytes_Columna + @Bytes_PK + 4)) AS UNSIGNED) AS b_Internal_Teorico,
    CEILING(LOG(GREATEST(1, CEILING(T.TABLE_ROWS / CEILING((16384 - 154) / (13 + @Bytes_Columna + @Bytes_PK))))) / LOG((CEILING((16384 - 154) / (13 + @Bytes_Columna + @Bytes_PK + 4)) + 1))) AS Capas_Internas,
    1 + CEILING(LOG(GREATEST(1, CEILING(T.TABLE_ROWS / CEILING((16384 - 154) / (13 + @Bytes_Columna + @Bytes_PK))))) / LOG((CEILING((16384 - 154) / (13 + @Bytes_Columna + @Bytes_PK + 4)) + 1))) AS Altura_Total,
    IFNULL(S_LEAF.stat_value, 0) AS Hojas_Reales_MySQL,
    IFNULL(S_SIZE.stat_value, 0) AS Paginas_Totales_MySQL
FROM information_schema.TABLES T
LEFT JOIN mysql.innodb_index_stats S_LEAF 
    ON T.TABLE_SCHEMA = S_LEAF.database_name AND T.TABLE_NAME = S_LEAF.table_name AND S_LEAF.index_name = @Nombre_Indice AND S_LEAF.stat_name = 'n_leaf_pages'
LEFT JOIN mysql.innodb_index_stats S_SIZE 
    ON T.TABLE_SCHEMA = S_SIZE.database_name AND T.TABLE_NAME = S_SIZE.table_name AND S_SIZE.index_name = @Nombre_Indice AND S_SIZE.stat_name = 'size'
WHERE 
    T.TABLE_SCHEMA = @Nombre_BD AND T.TABLE_NAME = @Nombre_Tabla;