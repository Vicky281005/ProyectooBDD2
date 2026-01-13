CREATE TABLE Participacion_Clase (
    id_participacion INT AUTO_INCREMENT PRIMARY KEY,
    id_sesion INT NOT NULL,
    id_estudiante INT NOT NULL,
    tipo_participacion ENUM('Pregunta', 'Aporte', 'Exposicion') NOT NULL,
    puntos_extra DECIMAL(4,2) DEFAULT 0.00,
    FOREIGN KEY (id_sesion) REFERENCES Sesion_Clase(id_sesion),
    FOREIGN KEY (id_estudiante) REFERENCES Estudiante(id_estudiante)
);