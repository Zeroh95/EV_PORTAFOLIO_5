# 📌 Base de Datos Relacional en PostgreSQL (Clientes y Pedidos)

Este documento explica los **componentes básicos de una base de datos relacional** y muestra ejemplos prácticos de **consultas SQL** utilizando **PostgreSQL** en **DBeaver**.

---

## 🗂️ Componentes básicos de una base de datos relacional

- **Tablas**: estructuras que almacenan información (ej: `clientes`, `pedidos`).
- **Campos (columnas)**: atributos de cada entidad (ej: nombre, email).
- **Registros (filas)**: instancias de datos en una tabla.
- **Clave primaria (PK)**: identifica de manera única un registro.
- **Clave foránea (FK)**: conecta una tabla con otra, estableciendo relaciones.

---

## ⚙️ Creación de Tablas

```sql
CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20)
);

CREATE TABLE pedidos (
    pedido_id SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    monto_total NUMERIC(10,2) NOT NULL,
    cliente_id INT NOT NULL,
    CONSTRAINT fk_cliente
        FOREIGN KEY (cliente_id) 
        REFERENCES clientes(cliente_id)
        ON DELETE CASCADE
);
```

📌 Relación: **Un cliente puede tener muchos pedidos, pero un pedido pertenece a un solo cliente**.  

---

## 📥 Inserción de Datos de Ejemplo

```sql
INSERT INTO clientes (nombre, email, telefono) VALUES
('Ana Pérez', 'ana.perez@mail.com', '987654321'),
('Luis Gómez', 'luis.gomez@mail.com', '912345678');

INSERT INTO pedidos (fecha, monto_total, cliente_id) VALUES
('2025-09-01', 15000, 1),
('2025-09-02', 25000, 1),
('2025-09-03', 12000, 2);
```

---

## 🔍 Consultas SQL de Ejemplo

### 1. Obtener todos los pedidos de un cliente específico
```sql
SELECT p.pedido_id, p.fecha, p.monto_total, c.nombre
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.cliente_id
WHERE c.nombre = 'Ana Pérez';
```

### 2. Listar clientes con sus pedidos (si tienen)
```sql
SELECT c.nombre, p.pedido_id, p.monto_total
FROM clientes c
LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
ORDER BY c.nombre;
```

### 3. Total gastado por cada cliente
```sql
SELECT c.nombre, SUM(p.monto_total) AS total_gastado
FROM clientes c
JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.nombre
ORDER BY total_gastado DESC;
```

### 4. Pedidos mayores a $20.000
```sql
SELECT pedido_id, fecha, monto_total
FROM pedidos
WHERE monto_total > 20000;
```

### 5. Cantidad de pedidos realizados por cada cliente
```sql
SELECT c.nombre, COUNT(p.pedido_id) AS cantidad_pedidos
FROM clientes c
JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.nombre
ORDER BY cantidad_pedidos DESC;
```

### 6. Clientes sin pedidos
```sql
SELECT c.nombre, c.email
FROM clientes c
LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
WHERE p.pedido_id IS NULL;
```

---

## ✏️ Modificación de Datos (INSERT, UPDATE, DELETE)

### 1. Inserción de nuevos registros
```sql
-- Insertar un nuevo cliente
INSERT INTO clientes (nombre, email, telefono)
VALUES ('Carla Soto', 'carla.soto@mail.com', '945678321');

-- Insertar un pedido para ese cliente (cliente_id = 3)
INSERT INTO pedidos (fecha, monto_total, cliente_id)
VALUES ('2025-09-05', 18000, 3);
```

### 2. Actualización de registros existentes
```sql
-- Actualizar email de un cliente
UPDATE clientes
SET email = 'luis.gomez2025@mail.com'
WHERE nombre = 'Luis Gómez';

-- Actualizar monto total de un pedido
UPDATE pedidos
SET monto_total = 20000
WHERE pedido_id = 3;
```

### 3. Eliminación de registros
```sql
-- Eliminar un pedido no procesado
DELETE FROM pedidos
WHERE pedido_id = 2;

-- Eliminar un cliente y sus pedidos asociados (ON DELETE CASCADE)
DELETE FROM clientes
WHERE cliente_id = 1;
```


---

## ▶️ Cómo ejecutar en DBeaver

1. Abrir **DBeaver** y conectarse a PostgreSQL.  
2. Crear una base de datos nueva (ejemplo: `empresa_db`).  
3. Copiar y pegar el contenido de este archivo en un **SQL Editor**.  
4. Ejecutar primero las secciones de **creación de tablas**, luego **inserción de datos** y finalmente las **consultas**.  
5. Verificar los resultados en la pestaña **Data** de cada tabla.  

---
