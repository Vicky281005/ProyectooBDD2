CREATE TABLE Sesion_Clase (
    id_sesion INT AUTO_INCREMENT PRIMARY KEY,
    id_seccion INT NOT NULL,
    id_aula INT NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    tema_tratado VARCHAR(255),
    estado_sesion ENUM('Programada', 'Realizada', 'Cancelada') DEFAULT 'Programada',
    FOREIGN KEY (id_seccion) REFERENCES Seccion(id_seccion),
    FOREIGN KEY (id_aula) REFERENCES Aula(id_aula),
    INDEX idx_sesion_fecha (fecha, id_seccion)
);