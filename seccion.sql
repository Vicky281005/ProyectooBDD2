CREATE TABLE Seccion (
    id_seccion INT AUTO_INCREMENT PRIMARY KEY,
    codigo_seccion VARCHAR(10) NOT NULL,
    id_asignatura INT NOT NULL,
    id_docente INT NOT NULL,
    periodo_academico VARCHAR(10) NOT NULL,
    FOREIGN KEY (id_asignatura) REFERENCES Asignatura(id_asignatura),
    FOREIGN KEY (id_docente) REFERENCES Docente(id_docente)
);