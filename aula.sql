CREATE TABLE Aula (
    id_aula INT AUTO_INCREMENT PRIMARY KEY,
    codigo_salon VARCHAR(20) NOT NULL,
    capacidad TINYINT UNSIGNED,
    id_sede INT NOT NULL,
    FOREIGN KEY (id_sede) REFERENCES Sede(id_sede)
);