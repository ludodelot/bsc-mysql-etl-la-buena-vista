# La Buena Vista — Migración de Excel a MySQL (ETL + SQL)

Trabajo académico del curso **Integración de Bases de Datos (TI2017.300)**,
Licenciatura en Inteligencia de Negocios (LIN), **Tecnológico de Monterrey**,
Escuela de Negocios — Campus Culiacán (CSF), Semestre 4 (S4).

## Contexto del reto

"La Buena Vista" es una microempresa ficticia que vende productos de higiene
industrial. El negocio administraba sus ventas en hojas de cálculo de Excel,
lo que generaba inconsistencias de captura, duplicados y limitaba cualquier
análisis. El reto consistió en **migrar ese modelo a una base de datos
relacional en MySQL**: diseñar el modelo entidad-relación, construir el
esquema, hacer el proceso ETL (extracción, transformación y carga) sobre los
datos crudos de Excel, y construir consultas SQL que respondieran preguntas
de negocio reales.

Este repositorio conserva dos entregables SQL del curso:

| Archivo | Descripción |
|---|---|
| [`sql/01_individual_exercise.sql`](sql/01_individual_exercise.sql) | Ejercicio individual de práctica: modelado de dos tablas relacionadas (`Extra_Cliente` / `Extra_Promocion`) con `INNER JOIN` para responder preguntas de negocio simples (clientes con cierta promoción, promociones enviadas en un mes, etc.). |
| [`sql/02_team_master_script.sql`](sql/02_team_master_script.sql) | Script maestro del proyecto de equipo: limpieza y transformación (ETL) de las tres entidades del negocio — `producto`, `venta` y `cliente` — normalización de catálogos, cálculo de columnas derivadas, deduplicación, generación de llaves primarias/foráneas y respaldo de tablas. |

## Modelo entidad-relación

El modelo final quedó compuesto por tres entidades:

- **`cliente`** (PK `rfc`): nombre, tipo de persona (Física/Moral), email,
  teléfono, fecha de registro.
- **`producto`** (PK `id_producto`): nombre del producto, precio unitario,
  unidad de medida.
- **`venta`** (PK `id_venta`, FK `rfc` → cliente, FK `id_producto` →
  producto): número de factura, cantidad, subtotal.

Relaciones: `cliente` 1:N `venta`, y `venta` N:1 `producto` (cada venta
pertenece a un solo cliente y a un solo producto; un cliente o un producto
pueden aparecer en muchas ventas).

![Modelo entidad-relación de La Buena Vista](docs/modelo_er_la_buena_vista.png)

*Diagrama tomado del reporte final del equipo (reverse engineering del
esquema construido en MySQL Workbench).*

## Consultas de negocio

Sobre el esquema ya migrado se construyeron consultas SQL para responder
preguntas de negocio, entre ellas:

1. Top 5 productos que más se venden (por cantidad).
2. Productos que más se venden por tipo de persona (Física vs. Moral).
3. Productos con mayor ingreso promedio por venta.
4. Los 5 productos con menos ventas.
5. Ventas totales (ingresos) por producto.
6. Top 5 clientes que más han comprado.
7. Top 5 facturas (tickets) con el monto más alto.
8. Correos de clientes que compraron un producto específico (segmentación
   para campañas de marketing).
9. Top 3 productos más caros del catálogo.

Cada consulta se justificó en el reporte final en términos del beneficio de
negocio que aporta (priorización de inventario, segmentación de clientes,
estrategias de precio y marketing, etc.).

## Herramienta

El equipo migró la base de datos a **MySQL Workbench** en lugar de Microsoft
Access, por su capacidad para manejar mayores volúmenes de datos, su
compatibilidad multiplataforma, su lenguaje SQL estándar en la industria y
por ser la herramienta más relevante para el desarrollo profesional en
inteligencia de negocios.

## Notas sobre los datos

- Los datos de clientes son sintéticos/de práctica escolar. Los nombres de
  clientes individuales en `sql/02_team_master_script.sql` fueron
  reemplazados por identificadores genéricos (`Cliente Uno`, `Cliente Dos`,
  ...) para no exponer datos personales de compañeros de clase que se
  usaron originalmente como datos de prueba ("dummy data"). La estructura,
  tipos de dato y lógica de transformación del script son las originales
  del ejercicio.
- No se incluyen credenciales de conexión a base de datos en ninguno de los
  dos scripts.

## Autoría

Proyecto colaborativo desarrollado en equipo (Equipo 2, Grupo 300) para la
materia Integración de Bases de Datos, bajo la supervisión de la profesora
Martha Verónica Legarda Zapien:

- Ludovic Delot Bravo
- Gonzalo González Méndez
- Oswaldo López Rico

`sql/01_individual_exercise.sql` es trabajo individual de Ludovic Delot
Bravo. `sql/02_team_master_script.sql` es el entregable final de equipo.
