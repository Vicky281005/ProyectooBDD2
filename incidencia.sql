CREATE TABLE incidencia (
    id_incidencia INT AUTO_INCREMENT PRIMARY KEY,
    id_sesion INT,
    id_estudiante INT,
    descripcion VARCHAR(1000) NOT NULL,
    FOREIGN KEY (id_sesion) REFERENCES sesion_clase(id_sesion),
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante)
);


