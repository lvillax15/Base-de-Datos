-- Creación de las Tablas
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    direccion VARCHAR(100),
    correo_electronico VARCHAR(100),
    telefono VARCHAR(20)
);

CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    descripcion TEXT,
    precio DECIMAL(10, 2),
    categoria VARCHAR(50),
    stock INT
);

CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    fecha DATE,
    estado VARCHAR(20),
    total DECIMAL(10, 2),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);

CREATE TABLE ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    id_producto INT,
    cantidad INT,
    precio_venta DECIMAL(10, 2),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id),
    FOREIGN KEY (id_producto) REFERENCES productos(id)
);

-- Inserción de Datos de Ejemplo
INSERT INTO clientes (nombre, apellido, direccion, correo_electronico, telefono)
VALUES ('Juan', 'Pérez', 'Calle Falsa 123', 'juan.perez@example.com', '1234567890'),
       ('Ana', 'Gómez', 'Avenida Siempreviva 456', 'ana.gomez@example.com', '0987654321');

INSERT INTO productos (nombre, descripcion, precio, categoria, stock)
VALUES ('Camiseta Azul', 'Camiseta de algodón azul', 20.00, 'Camisetas', 50),
       ('Pantalón Negro', 'Pantalón de mezclilla negro', 35.00, 'Pantalones', 30);

INSERT INTO pedidos (id_cliente, fecha, estado, total)
VALUES (1, CURDATE() - INTERVAL 15 DAY, 'Completado', 55.00),
       (2, CURDATE() - INTERVAL 40 DAY, 'Pendiente', 35.00);

INSERT INTO ventas (id_pedido, id_producto, cantidad, precio_venta)
VALUES (1, 1, 2, 40.00),
       (1, 2, 1, 15.00);

-- Consultas Avanzadas con SELECT
-- Consulta 1: Clientes que realizaron pedidos en los últimos 30 días
SELECT c.nombre, c.apellido, c.direccion, c.correo_electronico
FROM clientes c
JOIN pedidos p ON c.id = p.id_cliente
WHERE p.fecha >= CURDATE() - INTERVAL 30 DAY;

-- Consulta 2: Productos con mayor cantidad de ventas en el último mes
SELECT p.nombre, SUM(v.cantidad) AS total_vendido
FROM productos p
JOIN ventas v ON p.id = v.id_producto
WHERE v.id_pedido IN (
    SELECT id FROM pedidos WHERE fecha >= CURDATE() - INTERVAL 1 MONTH
)
GROUP BY p.id
ORDER BY total_vendido DESC;

-- Consulta 3: Clientes con más pedidos en el último año
SELECT c.nombre, c.apellido, COUNT(p.id) AS cantidad_pedidos
FROM clientes c
JOIN pedidos p ON c.id = p.id_cliente
WHERE p.fecha >= CURDATE() - INTERVAL 1 YEAR
GROUP BY c.id
ORDER BY cantidad_pedidos DESC;

-- Actualización con UPDATE
UPDATE productos
SET precio = precio * 1.10
WHERE categoria = 'Camisetas';

-- Eliminación con DELETE
DELETE FROM pedidos
WHERE id NOT IN (SELECT DISTINCT id_pedido FROM ventas);

-- Creación de Vista
CREATE VIEW vista_clientes_pedidos AS
SELECT c.nombre, c.apellido, p.fecha, p.total
FROM clientes c
JOIN pedidos p ON c.id = p.id_cliente;
