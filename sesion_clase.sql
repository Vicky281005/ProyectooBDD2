CREATE TABLE sesion_clase (
    id_sesion INT AUTO_INCREMENT PRIMARY KEY,
    id_escuela INT,
    fecha_sesion DATE NOT NULL,      
    hora_inicio TIME,                
    hora_fin TIME,                   
    tema VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_escuela) REFERENCES escuela(id_escuela)
);