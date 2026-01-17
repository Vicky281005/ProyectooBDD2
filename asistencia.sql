CREATE TABLE asistencia (
    id_asistencia INT AUTO_INCREMENT PRIMARY KEY,
    id_sesion INT,
    nombre_estudiante VARCHAR(150) NOT NULL, 
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Presente', 'Ausente', 'Tarde', 'Justificado')),
    hora_llegada TIME,               -- Cambiado de VARCHAR a TIME
    FOREIGN KEY (id_sesion) REFERENCES sesion_clase(id_sesion)
);