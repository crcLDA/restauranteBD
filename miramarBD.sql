-- Crea tabla categorias
CREATE TABLE categorias (
    id_categoria NUMBER PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL
);

-- Crea tabla productos
CREATE TABLE productos (
    id_producto NUMBER PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    descripcion VARCHAR2(70),
    precio NUMBER(10, 2) NOT NULL,
    id_categoria NUMBER,
    activo CHAR(1),
    CONSTRAINT fk_categoria FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

-- Crea tabla productos
CREATE TABLE ingredientes (
    id_ingrediente NUMBER PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    existencias NUMBER NOT NULL
);

-- Crea tabla proveedores
CREATE TABLE proveedores (
    id_proveedor NUMBER PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    telefono VARCHAR2(15),
    direccion VARCHAR2(100)
);

-- Crea tabla de clientes
CREATE TABLE clientes (
    cedula VARCHAR2(9) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    telefono VARCHAR2(15)
);

-- Crea tabla de ordenes
CREATE TABLE ordenes (
    id_orden NUMBER PRIMARY KEY,
    usuario VARCHAR2(50),
    fecha VARCHAR2(20) NOT NULL
);

-- Crea tabla de detalle de ordenes
CREATE TABLE detalles_ordenes (
    id_detalle NUMBER PRIMARY KEY,
    id_orden NUMBER NOT NULL,
    id_factura NUMBER,
    id_producto NUMBER NOT NULL,
    subtotal NUMBER(10, 2) NOT NULL,
    cancelado CHAR(1),
    CONSTRAINT fk_orden FOREIGN KEY (id_orden) REFERENCES ordenes(id_orden),
    CONSTRAINT fk_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Crea tabla de facturas
CREATE TABLE facturas (
    id_factura NUMBER PRIMARY KEY,
    id_orden NUMBER NOT NULL,
    id_vendedor NUMBER,
    fecha VARCHAR2(20) NOT NULL,
    total NUMBER(10, 2) NOT NULL,
    CONSTRAINT fk_orden_factura FOREIGN KEY (id_orden) REFERENCES ordenes(id_orden)
);