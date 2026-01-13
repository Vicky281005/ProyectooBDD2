CREATE TABLE Incidencia (
    id_incidencia INT AUTO_INCREMENT PRIMARY KEY,
    id_sesion INT NOT NULL,
    tipo ENUM('Infraestructura', 'Conducta', 'Emergencia', 'Otro') NOT NULL,
    descripcion TEXT NOT NULL,
    FOREIGN KEY (id_sesion) REFERENCES Sesion_Clase(id_sesion)
);