CREATE TABLE Estudiante (
    id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    cedula VARCHAR(20) UNIQUE NOT NULL,
    id_escuela INT,
    FOREIGN KEY (id_escuela) REFERENCES Escuela(id_escuela)
);