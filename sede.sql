CREATE TABLE Sede (
    id_sede INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(255),
    region ENUM('Capital', 'Andina', 'Oriental') NOT NULL
);