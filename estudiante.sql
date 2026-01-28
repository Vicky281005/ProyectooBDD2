CREATE TABLE estudiante (
    id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_registro DATE ,
    id_escuela INT,
    FOREIGN KEY (id_escuela) REFERENCES escuela(id_escuela)
);

