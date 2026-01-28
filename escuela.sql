CREATE TABLE escuela (
    id_escuela INT AUTO_INCREMENT PRIMARY KEY,
    nombre_escuela VARCHAR(150) NOT NULL,
    id_facultad INT,
    FOREIGN KEY (id_facultad) REFERENCES facultad(id_facultad)
);

-- select * from escuela;

