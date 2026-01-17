CREATE TABLE facultad (
    id_facultad INT AUTO_INCREMENT PRIMARY KEY,
    nombre_facultad VARCHAR(150) NOT NULL,
    id_sede INT,
    FOREIGN KEY (id_sede) REFERENCES sede(id_sede)
);

