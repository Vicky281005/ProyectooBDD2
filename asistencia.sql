CREATE TABLE asistencia (
    id_asistencia INT AUTO_INCREMENT PRIMARY KEY,
    id_sesion INT,
    id_estudiante INT,
    estado VARCHAR(20) NOT NULL CHECK (
        estado IN ('Presente', 'Ausente', 'Tarde', 'Justificado')
    ),
    hora_llegada TIME,
    FOREIGN KEY (id_sesion) REFERENCES sesion_clase(id_sesion),
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante),
    UNIQUE (id_sesion,id_estudiante)
);
