CREATE TABLE sede (
    id_sede INT AUTO_INCREMENT PRIMARY KEY,
    nombre_sede VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL CHECK (region IN ('Norte', 'Centro', 'Sur'))
);

CREATE TABLE facultad (
    id_facultad INT AUTO_INCREMENT PRIMARY KEY,
    nombre_facultad VARCHAR(150) NOT NULL,
    id_sede INT,
    FOREIGN KEY (id_sede) REFERENCES sede(id_sede)
);

CREATE TABLE escuela (
    id_escuela INT AUTO_INCREMENT PRIMARY KEY,
    nombre_escuela VARCHAR(150) NOT NULL,
    id_facultad INT,
    FOREIGN KEY (id_facultad) REFERENCES facultad(id_facultad)
);

CREATE TABLE sesion_clase (
    id_sesion INT AUTO_INCREMENT PRIMARY KEY,
    id_escuela INT,
    fecha_sesion DATE NOT NULL,      
    hora_inicio TIME,                
    hora_fin TIME,                   
    tema VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_escuela) REFERENCES escuela(id_escuela)
    );
    
CREATE TABLE asistencia (
    id_asistencia INT AUTO_INCREMENT PRIMARY KEY,
    id_sesion INT,
    nombre_estudiante VARCHAR(150) NOT NULL, 
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Presente', 'Ausente', 'Tarde', 'Justificado')),
    hora_llegada TIME,               -- Cambiado de VARCHAR a TIME
    FOREIGN KEY (id_sesion) REFERENCES sesion_clase(id_sesion)
);
    
CREATE TABLE participacion_clase (
    id_participacion INT AUTO_INCREMENT PRIMARY KEY,
    id_sesion INT,
    nombre_estudiante VARCHAR(150) NOT NULL,
    tipo_participacion VARCHAR(50) CHECK (tipo_participacion IN ('Pregunta', 'Aporte', 'Ejercicio', 'Otro')),
    puntos_puntuacion INT,
    comentario VARCHAR(1000),
    FOREIGN KEY (id_sesion) REFERENCES sesion_clase(id_sesion)
);

CREATE TABLE justificacion (
    id_justificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_asistencia INT,
    motivo VARCHAR(1000) NOT NULL,
    FOREIGN KEY (id_asistencia) REFERENCES asistencia(id_asistencia)
);

CREATE TABLE incidencia (
    id_incidencia INT AUTO_INCREMENT PRIMARY KEY,
    id_sesion INT,
    nombre_estudiante VARCHAR(150) NOT NULL, -- Se cambió ID por Nombre
    descripcion VARCHAR(1000) NOT NULL,
    FOREIGN KEY (id_sesion) REFERENCES sesion_clase(id_sesion)
);


