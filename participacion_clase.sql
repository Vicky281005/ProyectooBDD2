CREATE TABLE participacion_clase (
    id_participacion INT AUTO_INCREMENT PRIMARY KEY,
    id_sesion INT,
    nombre_estudiante VARCHAR(150) NOT NULL,
    tipo_participacion VARCHAR(50) CHECK (tipo_participacion IN ('Pregunta', 'Aporte', 'Ejercicio', 'Otro')),
    puntos_puntuacion INT,
    comentario VARCHAR(1000),
    FOREIGN KEY (id_sesion) REFERENCES sesion_clase(id_sesion)
);

select* from participacion_clase;