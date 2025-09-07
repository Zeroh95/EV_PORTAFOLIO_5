
/* 1. Distinguir las características, rol y elementos fundamentales de una base de datos relacional para la gestión de la información en una organización.

	Componentes básicos de una base de datos relacional

		Tablas
		
			Son la estructura principal donde se almacenan los datos.
		
			Cada tabla representa una entidad del mundo real (ejemplo: Clientes, Pedidos).
		
		Campos (columnas)
		
			Son los atributos o características de la entidad.
		
			Ejemplo: en Clientes podemos tener nombre, email, telefono.
		
		Registros (filas o tuplas)
		
			Cada fila en la tabla representa una instancia concreta de la entidad.
		
			Ejemplo: un cliente específico con su información personal.
		
		Clave primaria (Primary Key, PK)
		
			Es un campo (o combinación de campos) que identifica de manera única a cada registro.
		
			Ejemplo: cliente_id en la tabla Clientes.
		
		Clave foránea (Foreign Key, FK)
		
			Es un campo en una tabla que hace referencia a la clave primaria de otra tabla.
		
			Permite establecer relaciones entre tablas.
		
			Ejemplo: en la tabla Pedidos, cliente_id se relaciona con cliente_id de la tabla Clientes.
			
			
	Gestión y almacenamiento de datos en tablas

		Los datos se almacenan en filas dentro de tablas.
		
		Cada tabla suele modelar una entidad distinta.
		
		Las relaciones entre tablas se establecen mediante claves foráneas.
		
		Esto permite:
		
			Evitar duplicación de información (normalización).
		
			Garantizar consistencia e integridad (no se pueden crear pedidos de un cliente que no exista).
		
			Facilitar consultas y reportes con JOIN entre tablas.*/

CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY,   -- Clave primaria autoincremental
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20)
);

CREATE TABLE pedidos (
    pedido_id SERIAL PRIMARY KEY,       -- Clave primaria
    fecha DATE NOT NULL,
    monto_total NUMERIC(10,2) NOT NULL,
    cliente_id INT NOT NULL,            -- Clave foránea
    CONSTRAINT fk_cliente
        FOREIGN KEY (cliente_id) 
        REFERENCES clientes(cliente_id) -- Relación con clientes
        ON DELETE CASCADE               -- Si se elimina un cliente, se borran sus pedidos
);

-- Insertar clientes
INSERT INTO clientes (nombre, email, telefono) VALUES
('Ana Pérez', 'ana.perez@mail.com', '987654321'),
('Luis Gómez', 'luis.gomez@mail.com', '912345678');

-- Insertar pedidos
INSERT INTO pedidos (fecha, monto_total, cliente_id) VALUES
('2025-09-01', 15000, 1),
('2025-09-02', 25000, 1),
('2025-09-03', 12000, 2);

SELECT p.pedido_id, p.fecha, p.monto_total, c.nombre AS cliente
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.cliente_id;


-- Ejemplos de consultas en PostgreSQL

-- Obtener todos los pedidos de un cliente específico

SELECT p.pedido_id, p.fecha, p.monto_total, c.nombre
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.cliente_id
WHERE c.nombre = 'Ana Pérez';

-- Listar todos los clientes con sus pedidos (si tienen)

SELECT c.nombre, p.pedido_id, p.monto_total
FROM clientes c
LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
ORDER BY c.nombre;

-- Total gastado por cada cliente

SELECT c.nombre, SUM(p.monto_total) AS total_gastado
FROM clientes c
JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.nombre
ORDER BY total_gastado DESC;

-- Pedidos mayores a $20.000

SELECT pedido_id, fecha, monto_total
FROM pedidos
WHERE monto_total > 20000;

-- Cantidad de pedidos realizados por cada cliente

SELECT c.nombre, COUNT(p.pedido_id) AS cantidad_pedidos
FROM clientes c
JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.nombre
ORDER BY cantidad_pedidos DESC;

-- Clientes sin pedidos

SELECT c.nombre, c.email
FROM clientes c
LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
WHERE p.pedido_id IS NULL;