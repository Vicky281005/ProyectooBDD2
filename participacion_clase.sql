CREATE TABLE participacion_clase (
    id_participacion INT AUTO_INCREMENT PRIMARY KEY,
    id_sesion INT,
    id_estudiante INT,
    tipo_participacion VARCHAR(50) CHECK (
        tipo_participacion IN ('Pregunta', 'Aporte', 'Ejercicio', 'Otro')
    ),
    puntos_puntuacion INT,
    comentario VARCHAR(200),
    FOREIGN KEY (id_sesion) REFERENCES sesion_clase(id_sesion),
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante)
);

-- select* from participacion_clase;