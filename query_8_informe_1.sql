EXPLAIN analyze
SELECT 
    e.nombre, 
    e.apellido, 
    COUNT(a.id_asistencia) AS total_tardanzas
FROM estudiante e
JOIN asistencia a ON e.id_estudiante = a.id_estudiante
WHERE 
    a.estado = 'Tarde'
GROUP BY e.nombre, e.apellido
HAVING 
    total_tardanzas >= 1;