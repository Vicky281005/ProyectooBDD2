CREATE TABLE sede (
    id_sede INT AUTO_INCREMENT PRIMARY KEY,
    nombre_sede VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL CHECK (region IN ('Norte', 'Centro', 'Sur'))
);

INSERT INTO sede (nombre_sede, region) VALUES ('Sede Lima', 'Centro'), ('Sede Piura', 'Norte'), ('Sede Arequipa', 'Sur');

