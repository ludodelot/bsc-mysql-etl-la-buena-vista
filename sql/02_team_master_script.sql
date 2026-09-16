-- ============================================================
-- EVIDENCIA: SCRIPT MAESTRO ETL — PROYECTO "LA BUENA VISTA"
-- INTEGRACIÓN DE BASES DE DATOS (TI2017.300) — EQUIPO 2
-- TEC DE MONTERREY
-- ============================================================
-- Migra las tablas crudas importadas desde Excel (producto,
-- venta, cliente) hacia un esquema relacional normalizado en
-- MySQL: limpieza de duplicados y errores de captura, corrección
-- de catálogos, cálculo de columnas derivadas, generación de
-- llaves primarias/foráneas y datos de referencia de respaldo.
--
-- NOTA: el bloque "DUMMY DATA" reemplaza los nombres originales
-- por identificadores genéricos (Cliente Uno, Cliente Dos, ...)
-- para no exponer datos personales de compañeros de clase; la
-- estructura, tipos de dato y lógica de transformación son las
-- originales del ejercicio.
--
-- CÓDIGO COMPLETO (SE TIENE QUE CORRER CADA QUERY POR SEPARADO)
-- ============================================================

-- TRANSFORMACION TABLA PRODUCTO

CREATE TABLE tabla_producto_temp AS
SELECT * FROM producto
GROUP BY id_producto;

SELECT * FROM tabla_producto_temp;

TRUNCATE TABLE producto;

INSERT INTO producto
SELECT * FROM tabla_producto_temp;

DROP TABLE tabla_producto_temp;

SELECT * FROM producto;

UPDATE producto
SET Unidad = 'Kilogramo'
WHERE Unidad = 'kg';

UPDATE producto
SET Unidad = 'Paquete de 3'
WHERE Unidad = 'Pakete de 3';

UPDATE producto
SET Unidad = 'Litro'
WHERE Unidad = 'Litr';

UPDATE producto
SET Unidad = 'Pieza'
WHERE Unidad = 'Pieza';

UPDATE producto
SET Unidad = 'Metro cuadrado'
WHERE Unidad = 'Metro cuadrado';

UPDATE producto
SET Precio_Unitario = 73
WHERE Producto = 'Plumer' AND Precio_Unitario = 73000000;

DELETE FROM producto
WHERE ID_producto = 1400000 AND Producto = 'Toalla' AND Precio_Unitario = 55;

UPDATE producto
SET producto = 'Plumero'
WHERE id_producto = 9;

UPDATE producto
SET producto = 'Recogedor'
WHERE id_producto = 12;

SELECT * FROM producto;

-- TRANSFORMACIÓN TABLA VENTA

ALTER TABLE venta ADD COLUMN rfc VARCHAR(255);

UPDATE venta
JOIN cliente ON venta.num_fact = cliente.numero_de_factura
SET venta.rfc = cliente.rfc;

-- TRANSFORMACIÓN TABLA CLIENTE

SELECT * FROM cliente;

DELETE FROM cliente
WHERE numero_de_factura IS NULL;

SELECT * FROM cliente;

UPDATE cliente
SET tipo_de_persona = 'Moral'
WHERE tipo_de_persona IN ('Mora', 'Moka', 'Morra', 'Moka', 'Moral');

UPDATE cliente
SET tipo_de_persona = 'Física'
WHERE tipo_de_persona IN ('Fisica', 'Físika', 'Fisika', 'Físika', 'Fisica', 'Física');

UPDATE cliente
SET email = 'dummy@example.com'
WHERE email IS NULL OR email = '';

SELECT * FROM cliente;

ALTER TABLE tabla_venta_v2 RENAME TO venta;

SELECT * FROM venta;
SELECT * FROM producto;

SELECT * FROM venta;
ALTER TABLE venta DROP COLUMN precio_unitario;

SELECT * FROM venta;

ALTER TABLE venta ADD COLUMN subtotal DECIMAL(10, 2);

UPDATE venta, producto
SET venta.subtotal = venta.cantidad * producto.precio_unitario
WHERE venta.id_producto = producto.id_producto;

CREATE TABLE cliente_temp AS
SELECT DISTINCT rfc, nombre, tipo_de_persona, email, telefono
FROM cliente;

DROP TABLE cliente;

ALTER TABLE cliente_temp RENAME TO cliente;




CREATE TABLE cliente_temp (
    rfc VARCHAR(255),
    nombre VARCHAR(255),
    tipo_de_persona VARCHAR(255),
    email VARCHAR(255),
    telefono VARCHAR(255)
);

INSERT INTO cliente_temp (rfc, nombre, tipo_de_persona, email, telefono)
SELECT rfc, MAX(nombre) AS nombre, tipo_de_persona, email, telefono
FROM cliente
GROUP BY rfc, tipo_de_persona, email, telefono;

DROP TABLE cliente;

ALTER TABLE cliente_temp RENAME TO cliente;


ALTER TABLE venta DROP COLUMN id_venta;

ALTER TABLE venta ADD COLUMN id_venta VARCHAR(255);

UPDATE venta
SET id_venta = CONCAT(num_fact, '-', LPAD(id_producto, 2, '0'));

ALTER TABLE venta MODIFY COLUMN id_venta VARCHAR(255) FIRST;

CREATE TABLE venta_temp AS
SELECT * FROM venta
GROUP BY id_venta;

SELECT id_venta, COUNT(*) AS cnt
FROM venta
GROUP BY id_venta
HAVING cnt > 1;

SELECT * FROM venta_temp;

DROP TABLE venta;

ALTER TABLE venta_temp RENAME TO venta;



CREATE TEMPORARY TABLE rfc_info (
    rfc VARCHAR(255),
    nombre VARCHAR(255),
    tipo_de_persona VARCHAR(255),
    email VARCHAR(255),
    telefono VARCHAR(255)
);


UPDATE venta
JOIN rfc_info ON venta.rfc = rfc_info.nombre
SET venta.rfc = rfc_info.rfc
WHERE venta.rfc IS NULL;


SELECT * FROM venta WHERE rfc IS NULL;

DROP TEMPORARY TABLE rfc_info;

SELECT * FROM venta;

DESCRIBE venta;


-- DUMMY DATA 

INSERT INTO cliente (rfc, nombre, tipo_de_persona, email, telefono, fecha_de_registro, numero_de_factura) VALUES
('BFRAFR', 'Cliente Uno', 'Física', 'cliente.uno@example.com', '5550000001', '310566', 501),
('DAAARG', 'Cliente Dos', 'Física', 'cliente.dos@example.com', '5550000002', '310566', 502),
('RATORE', 'Cliente Tres', 'Física', 'cliente.tres@example.com', '5550000003', '310566', 503),
('MFAMAG', 'Cliente Cuatro', 'Física', 'cliente.cuatro@example.com', '5550000004', '310566', 504),
('DAAARZ', 'Cliente Cinco', 'Física', 'cliente.cinco@example.com', '5550000005', '310566', 505),
('CAACOR', 'Cliente Seis', 'Física', 'cliente.seis@example.com', '5550000006', '310566', 506),
('CCMMAR', 'Cliente Siete', 'Física', 'cliente.siete@example.com', '5550000007', '310566', 507),
('LDBRAV', 'Cliente Ocho', 'Física', 'cliente.ocho@example.com', '5550000008', '310566', 508),
('PDFRAN', 'Cliente Nueve', 'Física', 'cliente.nueve@example.com', '5550000009', '310566', 509),
('CESTIX', 'Cliente Diez', 'Física', 'cliente.diez@example.com', '5550000010', '310566', 510),
('PEREYN', 'Cliente Once', 'Física', 'cliente.once@example.com', '5550000011', '310566', 511),
('MEMMON', 'Cliente Doce', 'Física', 'cliente.doce@example.com', '5550000012', '310566', 512),
('AFFFRE', 'Cliente Trece', 'Física', 'cliente.trece@example.com', '5550000013', '310566', 513),
('GGMEND', 'Cliente Catorce', 'Física', 'cliente.catorce@example.com', '5550000014', '310566', 514),
('AGVVAL', 'Cliente Quince', 'Física', 'cliente.quince@example.com', '5550000015', '310566', 515),
('MHBAUT', 'Cliente Dieciseis', 'Física', 'cliente.dieciseis@example.com', '5550000016', '310566', 516),
('FLAABU', 'Cliente Diecisiete', 'Física', 'cliente.diecisiete@example.com', '5550000017', '310566', 517),
('MVZLEG', 'Cliente Dieciocho', 'Física', 'cliente.dieciocho@example.com', '5550000018', '310566', 518),
('OLRICO', 'Cliente Diecinueve', 'Física', 'cliente.diecinueve@example.com', '5550000019', '310566', 519),
('AMCUEN', 'Cliente Veinte', 'Física', 'cliente.veinte@example.com', '5550000020', '310566', 520),
('DMCCAT', 'Cliente Veintiuno', 'Física', 'cliente.veintiuno@example.com', '5550000021', '310566', 521),
('PMGLAS', 'Cliente Veintidos', 'Física', 'cliente.veintidos@example.com', '5550000022', '310566', 522),
('JMMMAC', 'Cliente Veintitres', 'Física', 'cliente.veintitres@example.com', '5550000023', '310566', 523),
('VMLLEO', 'Cliente Veinticuatro', 'Física', 'cliente.veinticuatro@example.com', '5550000024', '310566', 524),
('IODVEC', 'Cliente Veinticinco', 'Física', 'cliente.veinticinco@example.com', '5550000025', '310566', 525),
('TOGGUZ', 'Cliente Veintiseis', 'Física', 'cliente.veintiseis@example.com', '5550000026', '310566', 526),
('GRVVIL', 'Cliente Veintisiete', 'Física', 'cliente.veintisiete@example.com', '5550000027', '310566', 527),
('RSIIBA', 'Cliente Veintiocho', 'Física', 'cliente.veintiocho@example.com', '5550000028', '310566', 528),
('ESVVAZ', 'Cliente Veintinueve', 'Física', 'cliente.veintinueve@example.com', '5550000029', '310566', 529),
('AVAALE', 'Cliente Treinta', 'Física', 'cliente.treinta@example.com', '5550000030', '310566', 530),
('AZDJAD', 'Cliente Treintayuno', 'Física', 'cliente.treintayuno@example.com', '5550000031', '310566', 531);

CREATE TEMPORARY TABLE rfc_info (
    rfc VARCHAR(255),
    nombre VARCHAR(255),
    tipo_de_persona VARCHAR(255),
    email VARCHAR(255),
    telefono VARCHAR(255)
);

INSERT INTO rfc_info (rfc, nombre, tipo_de_persona, email, telefono) VALUES
('ALMFR', 'Almacenes del Fruto', 'Moral', 'delfruto@gmail.com', '6677723432'),
('LIGO', 'Libia Gómez Sánchez', 'Física', 'dummy@example.com', '6677009933'),
('PARU', 'Patricia Alvarado Rueda', 'Física', 'dummy@example.com', '6675767888'),
('CIENPRO', 'Cienfuego Produccions', 'Moral', 'cienfuego@gmail.com', '6674447825'),
('BICGUE', 'Bicicletas Guerrero', 'Moral', 'bicis_gro@gmail.com', '6674328368'),
('JUCA', 'Julián Carrizosa', 'Física', 'julian@hotmail.com', '6673445566'),
('LURI', 'Luz María Del Río', 'Física', 'lmrio@hotmail.com', '6672347777'),
('JOSEPRO', 'JoseMary Productos', 'Moral', 'jmary@gmail.com', '6671123409'),
('ABESQ', 'Abarrotes de la esquina', 'Moral', 'esquina@hotmail.com', '6671116307'),
('AZDJAD', 'Cliente Treintayuno', 'Física', 'cliente.treintayuno@example.com', '5550000031'),
('AVAALE', 'Cliente Treinta', 'Física', 'cliente.treinta@example.com', '5550000030'),
('ESVVAZ', 'Cliente Veintinueve', 'Física', 'cliente.veintinueve@example.com', '5550000029'),
('RSIIBA', 'Cliente Veintiocho', 'Física', 'cliente.veintiocho@example.com', '5550000028'),
('GRVVIL', 'Cliente Veintisiete', 'Física', 'cliente.veintisiete@example.com', '5550000027'),
('TOGGUZ', 'Cliente Veintiseis', 'Física', 'cliente.veintiseis@example.com', '5550000026'),
('IODVEC', 'Cliente Veinticinco', 'Física', 'cliente.veinticinco@example.com', '5550000025'),
('VMLLEO', 'Cliente Veinticuatro', 'Física', 'cliente.veinticuatro@example.com', '5550000024'),
('JMMMAC', 'Cliente Veintitres', 'Física', 'cliente.veintitres@example.com', '5550000023'),
('PMGLAS', 'Cliente Veintidos', 'Física', 'cliente.veintidos@example.com', '5550000022'),
('DMCCAT', 'Cliente Veintiuno', 'Física', 'cliente.veintiuno@example.com', '5550000021'),
('AMCUEN', 'Cliente Veinte', 'Física', 'cliente.veinte@example.com', '5550000020'),
('OLRICO', 'Cliente Diecinueve', 'Física', 'cliente.diecinueve@example.com', '5550000019'),
('MVZLEG', 'Cliente Dieciocho', 'Física', 'cliente.dieciocho@example.com', '5550000018'),
('FLAABU', 'Cliente Diecisiete', 'Física', 'cliente.diecisiete@example.com', '5550000017'),
('MHBAUT', 'Cliente Dieciseis', 'Física', 'cliente.dieciseis@example.com', '5550000016'),
('AGVVAL', 'Cliente Quince', 'Física', 'cliente.quince@example.com', '5550000015'),
('GGMEND', 'Cliente Catorce', 'Física', 'cliente.catorce@example.com', '5550000014'),
('AFFFRE', 'Cliente Trece', 'Física', 'cliente.trece@example.com', '5550000013'),
('MEMMON', 'Cliente Doce', 'Física', 'cliente.doce@example.com', '5550000012'),
('PEREYN', 'Cliente Once', 'Física', 'cliente.once@example.com', '5550000011'),
('CESTIX', 'Cliente Diez', 'Física', 'cliente.diez@example.com', '5550000010'),
('PDFRAN', 'Cliente Nueve', 'Física', 'cliente.nueve@example.com', '5550000009'),
('LDBRAV', 'Cliente Ocho', 'Física', 'cliente.ocho@example.com', '5550000008'),
('CCMMAR', 'Cliente Siete', 'Física', 'cliente.siete@example.com', '5550000007'),
('CAACOR', 'Cliente Seis', 'Física', 'cliente.seis@example.com', '5550000006'),
('DAAARZ', 'Cliente Cinco', 'Física', 'cliente.cinco@example.com', '5550000005'),
('MFAMAG', 'Cliente Cuatro', 'Física', 'cliente.cuatro@example.com', '5550000004'),
('RATORE', 'Cliente Tres', 'Física', 'cliente.tres@example.com', '5550000003'),
('DAAARG', 'Cliente Dos', 'Física', 'cliente.dos@example.com', '5550000002'),
('BFRAFR', 'Cliente Uno', 'Física', 'cliente.uno@example.com', '5550000001');

UPDATE venta SET rfc = 'ALMFR' WHERE num_fact = 500;
UPDATE venta SET rfc = 'ALMFR' WHERE num_fact = 532;
UPDATE venta SET rfc = 'LIGO' WHERE num_fact = 533;
UPDATE venta SET rfc = 'PARU' WHERE num_fact = 534;
UPDATE venta SET rfc = 'CIENPRO' WHERE num_fact = 535;
UPDATE venta SET rfc = 'BICGUE' WHERE num_fact = 536;
UPDATE venta SET rfc = 'JUCA' WHERE num_fact = 537;
UPDATE venta SET rfc = 'LURI' WHERE num_fact = 538;
UPDATE venta SET rfc = 'JOSEPRO' WHERE num_fact = 539;
UPDATE venta SET rfc = 'ABESQ' WHERE num_fact = 540;
UPDATE venta SET rfc = 'AZDJAD' WHERE num_fact = 541;
UPDATE venta SET rfc = 'AVAALE' WHERE num_fact = 542;
UPDATE venta SET rfc = 'ESVVAZ' WHERE num_fact = 543;
UPDATE venta SET rfc = 'RSIIBA' WHERE num_fact = 544;
UPDATE venta SET rfc = 'GRVVIL' WHERE num_fact = 545;
UPDATE venta SET rfc = 'TOGGUZ' WHERE num_fact = 546;
UPDATE venta SET rfc = 'IODVEC' WHERE num_fact = 547;
UPDATE venta SET rfc = 'VMLLEO' WHERE num_fact = 548;
UPDATE venta SET rfc = 'JMMMAC' WHERE num_fact = 549;
UPDATE venta SET rfc = 'PMGLAS' WHERE num_fact = 550;
UPDATE venta SET rfc = 'DMCCAT' WHERE num_fact = 551;
UPDATE venta SET rfc = 'AMCUEN' WHERE num_fact = 552;
UPDATE venta SET rfc = 'OLRICO' WHERE num_fact = 553;
UPDATE venta SET rfc = 'MVZLEG' WHERE num_fact = 554;
UPDATE venta SET rfc = 'FLAABU' WHERE num_fact = 555;
UPDATE venta SET rfc = 'MHBAUT' WHERE num_fact = 556;
UPDATE venta SET rfc = 'AGVVAL' WHERE num_fact = 557;
UPDATE venta SET rfc = 'GGMEND' WHERE num_fact = 558;
UPDATE venta SET rfc = 'AFFFRE' WHERE num_fact = 559;
UPDATE venta SET rfc = 'MEMMON' WHERE num_fact = 560;
UPDATE venta SET rfc = 'PEREYN' WHERE num_fact = 561;
UPDATE venta SET rfc = 'CESTIX' WHERE num_fact = 562;
UPDATE venta SET rfc = 'PDFRAN' WHERE num_fact = 563;
UPDATE venta SET rfc = 'LDBRAV' WHERE num_fact = 564;
UPDATE venta SET rfc = 'CCMMAR' WHERE num_fact = 565;
UPDATE venta SET rfc = 'CAACOR' WHERE num_fact = 566;
UPDATE venta SET rfc = 'DAAARZ' WHERE num_fact = 567;
UPDATE venta SET rfc = 'MFAMAG' WHERE num_fact = 568;
UPDATE venta SET rfc = 'RATORE' WHERE num_fact = 569;
UPDATE venta SET rfc = 'DAAARG' WHERE num_fact = 570;
UPDATE venta SET rfc = 'BFRAFR' WHERE num_fact = 571;
UPDATE venta SET rfc = 'ALMFR' WHERE num_fact = 572;
UPDATE venta SET rfc = 'LIGO' WHERE num_fact = 573;
UPDATE venta SET rfc = 'PARU' WHERE num_fact = 574;
UPDATE venta SET rfc = 'CIENPRO' WHERE num_fact = 575;
UPDATE venta SET rfc = 'BICGUE' WHERE num_fact = 576;
UPDATE venta SET rfc = 'JUCA' WHERE num_fact = 577;
UPDATE venta SET rfc = 'LURI' WHERE num_fact = 578;
UPDATE venta SET rfc = 'JOSEPRO' WHERE num_fact = 579;
UPDATE venta SET rfc = 'ABESQ' WHERE num_fact = 580;
UPDATE venta SET rfc = 'AZDJAD' WHERE num_fact = 581;
UPDATE venta SET rfc = 'AVAALE' WHERE num_fact = 582;
UPDATE venta SET rfc = 'ESVVAZ' WHERE num_fact = 583;
UPDATE venta SET rfc = 'RSIIBA' WHERE num_fact = 584;
UPDATE venta SET rfc = 'GRVVIL' WHERE num_fact = 585;
UPDATE venta SET rfc = 'TOGGUZ' WHERE num_fact = 586;
UPDATE venta SET rfc = 'IODVEC' WHERE num_fact = 587;
UPDATE venta SET rfc = 'VMLLEO' WHERE num_fact = 588;
UPDATE venta SET rfc = 'JMMMAC' WHERE num_fact = 589;
UPDATE venta SET rfc = 'PMGLAS' WHERE num_fact = 590;
UPDATE venta SET rfc = 'DMCCAT' WHERE num_fact = 591;
UPDATE venta SET rfc = 'AMCUEN' WHERE num_fact = 592;
UPDATE venta SET rfc = 'OLRICO' WHERE num_fact = 593;
UPDATE venta SET rfc = 'MVZLEG' WHERE num_fact = 594;
UPDATE venta SET rfc = 'FLAABU' WHERE num_fact = 595;
UPDATE venta SET rfc = 'MHBAUT' WHERE num_fact = 596;
UPDATE venta SET rfc = 'AGVVAL' WHERE num_fact = 597;
UPDATE venta SET rfc = 'GGMEND' WHERE num_fact = 598;
UPDATE venta SET rfc = 'AFFFRE' WHERE num_fact = 599;
UPDATE venta SET rfc = 'MEMMON' WHERE num_fact = 600;

INSERT INTO venta (num_fact, id_producto, cantidad) VALUES
(500, 2, 6),
(501, 7, 2),
(502, 5, 8),
(503, 3, 7),
(504, 8, 9),
(505, 10, 4),
(506, 6, 3),
(507, 1, 10),
(508, 4, 2),
(509, 12, 1),
(510, 11, 7),
(511, 14, 5),
(512, 9, 6),
(513, 13, 3),
(514, 6, 2),
(515, 2, 1),
(516, 7, 10),
(517, 8, 4),
(518, 3, 3),
(519, 1, 8),
(520, 5, 2),
(521, 4, 5),
(522, 2, 9),
(523, 7, 3),
(524, 12, 2),
(525, 6, 1),
(526, 10, 8),
(527, 5, 7),
(528, 3, 4),
(529, 1, 6),
(530, 8, 10),
(531, 11, 5),
(532, 7, 9),
(533, 4, 6),
(534, 9, 2),
(535, 6, 3),
(536, 10, 4),
(537, 14, 1),
(538, 3, 5),
(539, 2, 7),
(540, 1, 6),
(541, 5, 9),
(542, 7, 2),
(543, 12, 8),
(544, 8, 4),
(545, 6, 3),
(546, 3, 2),
(547, 2, 5),
(548, 7, 6),
(549, 1, 7),
(550, 4, 8),
(551, 9, 3),
(552, 5, 2),
(553, 6, 4),
(554, 3, 7),
(555, 1, 8),
(556, 7, 5),
(557, 8, 9),
(558, 6, 2),
(559, 2, 1),
(560, 3, 4),
(561, 9, 6),
(562, 1, 10),
(563, 7, 8),
(564, 4, 2),
(565, 3, 5),
(566, 5, 3),
(567, 2, 7),
(568, 8, 4),
(569, 9, 1),
(570, 6, 10),
(571, 7, 3),
(572, 1, 5),
(573, 2, 6),
(574, 5, 4),
(575, 3, 8),
(576, 6, 9),
(577, 7, 2),
(578, 8, 3),
(579, 1, 4),
(580, 2, 5),
(581, 3, 6),
(582, 5, 7),
(583, 7, 8),
(584, 1, 9),
(585, 6, 1),
(586, 8, 2),
(587, 2, 3),
(588, 7, 4),
(589, 3, 5),
(590, 5, 6),
(591, 1, 7),
(592, 8, 8),
(593, 4, 9),
(594, 3, 10),
(595, 2, 1),
(596, 5, 2),
(597, 6, 3),
(598, 1, 4),
(599, 3, 5),
(600, 7, 6);

-- BACKUPS

CREATE TABLE venta_backup AS SELECT * FROM venta;
CREATE TABLE cliente_backup AS SELECT * FROM cliente;
CREATE TABLE producto_backup AS SELECT * FROM producto;

-- QUERIES DE COMPROBACIÓN

DESCRIBE cliente;
DESCRIBE venta;
DESCRIBE producto;

SELECT * FROM venta;
SELECT * FROM producto;
SELECT * FROM cliente;

-- JOINS

ALTER TABLE cliente ADD PRIMARY KEY (rfc);
ALTER TABLE venta ADD PRIMARY KEY (id_venta);
ALTER TABLE producto ADD PRIMARY KEY (id_producto);

ALTER TABLE venta 
ADD CONSTRAINT fk_rfc 
FOREIGN KEY (rfc) REFERENCES cliente(rfc);

ALTER TABLE venta 
ADD CONSTRAINT fk_id_producto 
FOREIGN KEY (id_producto) REFERENCES producto(id_producto);

-- QUERIES DE ELIMINACION

-- QUERIES DE PREGUNTAS DETONADORAS

