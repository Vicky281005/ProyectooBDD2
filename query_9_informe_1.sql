SET @Nombre_BD = 'NuevoEsquema'; 

SELECT 
    table_name AS Tabla,
    table_rows AS Filas_Totales,
    avg_row_length AS Bytes_Promedio_Fila,
    data_length AS Tamaño_Datos_Bytes,
    CEILING(data_length / 16384) AS Bloques_Totales_Base
FROM information_schema.tables
WHERE table_schema = @Nombre_BD;