CREATE TABLE incidencia (
    id_incidencia INT AUTO_INCREMENT PRIMARY KEY,
    id_sesion INT,
    nombre_estudiante VARCHAR(150) NOT NULL, -- Se cambió ID por Nombre
    descripcion VARCHAR(1000) NOT NULL,
    FOREIGN KEY (id_sesion) REFERENCES sesion_clase(id_sesion)
);

