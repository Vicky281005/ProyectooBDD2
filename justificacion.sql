CREATE TABLE justificacion (
    id_justificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_asistencia INT,
    motivo VARCHAR(200) NOT NULL,
    FOREIGN KEY (id_asistencia) REFERENCES asistencia(id_asistencia)
);