-- ============================================================
-- Ejercicio individual: Clientes y Promociones
-- Integración de Bases de Datos (TI2017.300) — Tec de Monterrey
-- ============================================================
-- Ejercicio de práctica individual con MySQL: modelado de dos
-- tablas relacionadas (Cliente / Promoción) y consultas con
-- INNER JOIN para responder preguntas de negocio sencillas.
-- ============================================================

DROP TABLE IF EXISTS Extra_Cliente;
DROP TABLE IF EXISTS Extra_Promocion;

CREATE TABLE Extra_Cliente (
    No_Cliente INT PRIMARY KEY,
    Mail VARCHAR(255),
    Telefono VARCHAR(20),
    Direccion VARCHAR(255),
    Num_Promo INT);

-- Insertar datos en la tabla Extra_Cliente
INSERT INTO Extra_Cliente (No_Cliente, Mail, Telefono, Direccion, Num_Promo) VALUES
(1234, 'juan@example.com', '111-222', 'Santa Fe', 1),
(2345, 'luis@example.com', '222-333', 'Santa Lucía', 2),
(3456, 'paco@example.com', '444-555', 'Águilas', 2),
(4567, 'memo@example.com', '666-777', 'Observatorio', 3),
(5678, 'tono@example.com', '777-888', 'Vasco de Quiroga', 1),
(6789, 'angel@example.com', '888-999', 'Los Olmos', 1),
(7890, 'gina@example.com', '999-000', 'Juan Escutia', 2),
(8901, 'ana@example.com', '111-333', 'Francisco Marquez', 2),
(9012, 'lucia@example.com', '222-555', 'Reforma', 3);


CREATE TABLE Extra_Promocion (
No_Promocion INT PRIMARY KEY,
Fecha_Inicio VARCHAR(50),
Fecha_Final VARCHAR(50),
Nombre VARCHAR(255),
Costo INT,
No_Cliente INT,
FOREIGN KEY (No_Cliente) REFERENCES Extra_Cliente(No_Cliente));


INSERT INTO Extra_Promocion (No_Promocion, Fecha_Inicio, Fecha_Final, Nombre, Costo, No_Cliente) VALUES
(111, 'Octubre', 'Diciembre', 'Halloween', 100, 2345),
(222, 'Septiembre', 'Noviembre', 'Mexico', 150, 2345),
(333, 'Octubre', 'Diciembre', 'Halloween', 100, 6789),
(444, 'Octubre', 'Diciembre', 'Halloween', 100, 5678),
(555, 'Septiembre', 'Noviembre', 'Mexico', 150, 8901),
(666, 'Octubre', 'Diciembre', 'Halloween', 100, 5678),
(777, 'Septiembre', 'Noviembre', 'Mexico', 150, 4567),
(888, 'Octubre', 'Diciembre', 'Halloween', 100, 4567),
(999, 'Agosto', 'Octubre', 'Clases', 50, 4567);




SELECT * FROM Extra_Cliente;

SELECT * From Extra_Promocion;

-- CLIENTES CON UNA PROMOCION
SELECT Extra_Cliente.No_Cliente
FROM Extra_Cliente INNER JOIN Extra_Promocion
WHERE (Extra_Cliente.No_Cliente = Extra_Promocion.No_Cliente)
AND Extra_Cliente.Num_Promo = 1;

-- PROMOCIONES DE oct enviadas
SELECT Extra_Promocion.No_Promocion,
Extra_Promocion.Nombre
FROM Extra_Promocion INNER JOIN Extra_Cliente
WHERE (Extra_Cliente.No_Cliente = Extra_Promocion.No_Cliente)
AND Extra_Promocion.Fecha_Inicio = 'Octubre';

-- CLIENTES 1 PROMOCION Y CLASES
SELECT Extra_Cliente.No_Cliente
FROM Extra_Cliente INNER JOIN Extra_Promocion
WHERE (Extra_Cliente.No_Cliente = Extra_Promocion.No_Cliente)
AND Extra_Cliente.Num_Promo = 1
AND Extra_Promocion.Nombre = 'Clases';

-- TEL DE CLIENTES CON 3 PROMOCIONES Y HALLOWEEN
SELECT Extra_Cliente.Telefono
FROM Extra_Cliente INNER JOIN Extra_Promocion
WHERE (Extra_Cliente.No_Cliente = Extra_Promocion.No_Cliente)
AND Extra_Cliente.Num_Promo = 3
AND Extra_Promocion.Nombre = 'Halloween';
