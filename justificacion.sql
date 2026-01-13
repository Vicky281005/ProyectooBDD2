CREATE TABLE Justificacion (
    id_justificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_asistencia BIGINT NOT NULL,
    fecha_solicitud DATE NOT NULL,
    motivo TEXT NOT NULL,
    estado ENUM('Pendiente', 'Aprobada', 'Rechazada') DEFAULT 'Pendiente',
    FOREIGN KEY (id_asistencia) REFERENCES Asistencia(id_asistencia)
);