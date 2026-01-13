CREATE TABLE Asistencia (
    id_asistencia BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_sesion INT NOT NULL,
    id_estudiante INT NOT NULL,
    hora_llegada TIME,
    estado ENUM('Presente', 'Ausente', 'Justificado', 'Retirado') NOT NULL,
    FOREIGN KEY (id_sesion) REFERENCES Sesion_Clase(id_sesion),
    FOREIGN KEY (id_estudiante) REFERENCES Estudiante(id_estudiante),
    UNIQUE KEY uk_asistencia_estudiante (id_sesion, id_estudiante)
);