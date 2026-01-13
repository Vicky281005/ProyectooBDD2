CREATE TABLE Escuela (
    id_escuela INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_facultad INT NOT NULL,
    FOREIGN KEY (id_facultad) REFERENCES Facultad(id_facultad)
);