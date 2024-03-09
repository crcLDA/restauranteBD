CREATE TABLE categorias (
    id_categoria NUMBER PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL
);

CREATE TABLE productos (
    id_producto NUMBER PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    descripcion VARCHAR2(70),
    precio NUMBER(10, 2) NOT NULL,
    id_categoria NUMBER,
    activo Number,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE ingredientes (
    id_ingrediente NUMBER PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    existencias NUMBER NOT NULL
);

CREATE TABLE proveedores (
    id_proveedor NUMBER PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    telefono VARCHAR2(15),
    direccion VARCHAR2(100)
);

CREATE TABLE proveedor_ingredientes (
    id_proveedor NUMBER,
    id_ingrediente NUMBER,
    PRIMARY KEY (id_proveedor, id_ingrediente),
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor),
    FOREIGN KEY (id_ingrediente) REFERENCES ingredientes(id_ingrediente)
);

CREATE TABLE clientes (
    cedula VARCHAR2(9) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    telefono VARCHAR2(15)
);

CREATE TABLE ordenes (
    id_orden NUMBER PRIMARY KEY,
    usuario VARCHAR2(50),
    fecha VARCHAR2(20) NOT NULL
);

CREATE TABLE detalles_ordenes (
    id_detalle NUMBER PRIMARY KEY,
    id_orden NUMBER NOT NULL,
    id_factura NUMBER,
    id_producto NUMBER NOT NULL,
    subtotal NUMBER(10, 2) NOT NULL,
    cancelado Number,
    FOREIGN KEY (id_orden) REFERENCES ordenes(id_orden),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

CREATE TABLE facturas (
    id_factura NUMBER PRIMARY KEY,
    id_orden NUMBER NOT NULL,
    id_vendedor NUMBER,
    fecha VARCHAR2(20) NOT NULL,
    total NUMBER(10, 2) NOT NULL,
    FOREIGN KEY (id_orden) REFERENCES ordenes(id_orden)
);

CREATE TABLE vendedores (
    id_vendedor NUMBER PRIMARY KEY,
    nombre VARCHAR2(50)
);

CREATE SEQUENCE secuencia_categorias START WITH 1;
CREATE SEQUENCE secuencia_detalles_ordenes START WITH 1;
CREATE SEQUENCE secuencia_facturas START WITH 1;
CREATE SEQUENCE secuencia_ingredientes START WITH 1;
CREATE SEQUENCE secuencia_ordenes START WITH 1;
CREATE SEQUENCE secuencia_productos START WITH 1;
CREATE SEQUENCE secuencia_proveedores START WITH 1;
CREATE SEQUENCE secuencia_vendedores START WITH 1;


INSERT INTO categorias (id_categoria, nombre) VALUES (secuencia_categorias.NEXTVAL, 'Bebidas');
INSERT INTO categorias (id_categoria, nombre) VALUES (secuencia_categorias.NEXTVAL, 'Entradas');


INSERT INTO productos (id_producto, nombre, descripcion, precio, id_categoria, activo) VALUES (secuencia_productos.NEXTVAL, 'Natural en agua', 'Guanabana, Carambola, Maracuya, Frutas, Mora, Pi a, Cas, Te fr o', 1000, 1, 1);
INSERT INTO productos (id_producto, nombre, descripcion, precio, id_categoria, activo) VALUES (secuencia_productos.NEXTVAL, 'Natural en leche', 'Guanabana, Carambola, Maracuya, Frutas, Mora, Pi a, Cas, Te fr o', 1200, 1, 1);
INSERT INTO productos (id_producto, nombre, descripcion, precio, id_categoria, activo) VALUES (secuencia_productos.NEXTVAL, 'Gaseosa', 'Coca cola, Fanta naranja, Jet, Fresca', 1000, 1, 1);
INSERT INTO productos (id_producto, nombre, descripcion, precio, id_categoria, activo) VALUES (secuencia_productos.NEXTVAL, 'Palitos de queso', '', 3000, 2, 1);
INSERT INTO productos (id_producto, nombre, descripcion, precio, id_categoria, activo) VALUES (secuencia_productos.NEXTVAL, 'Aros de cebolla', '', 3000, 2, 1);


CREATE OR REPLACE FUNCTION get_orden_by_fecha(p_fecha IN tony.ordenes.fecha%type) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT id_orden
        FROM TONY.ordenes
        WHERE fecha = p_fecha
        FETCH FIRST 1 ROW ONLY;
    RETURN v_cursor;
END get_orden_by_fecha;
/
CREATE OR REPLACE FUNCTION get_factura_by_fecha(p_fecha IN tony.facturas.fecha%type) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT * FROM  TONY.FACTURAS 
        WHERE fecha = p_fecha
        FETCH FIRST 1 ROW ONLY;
    RETURN v_cursor;
END get_factura_by_fecha;
/
CREATE OR REPLACE FUNCTION get_orden_by_cancelado(p_cancelado IN tony.detalles_ordenes.cancelado%type) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT DISTINCT o.id_orden, o.usuario, o.fecha 
        FROM TONY.ordenes o 
        JOIN TONY.detalles_ordenes d ON o.id_orden = d.id_orden 
        WHERE d.cancelado = p_cancelado
        ORDER BY o.id_orden;
    RETURN v_cursor;
END get_orden_by_cancelado;
/
CREATE OR REPLACE FUNCTION get_categoria_by_id(p_id IN tony.categorias.id_categoria%type) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT * FROM  TONY.CATEGORIAS WHERE id_categoria = p_id;
    RETURN v_cursor;
END get_categoria_by_id;
/
CREATE OR REPLACE FUNCTION get_cliente_by_id(p_id IN tony.clientes.cedula%type) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT * FROM  TONY.CLIENTES WHERE cedula = p_id;
    RETURN v_cursor;
END get_cliente_by_id;
/
CREATE OR REPLACE FUNCTION get_detalle_orden_by_id(p_id IN tony.detalles_ordenes.id_detalle%type) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT * FROM  TONY.DETALLES_ORDENES WHERE id_detalle = p_id;
    RETURN v_cursor;
END get_detalle_orden_by_id;
/
CREATE OR REPLACE FUNCTION get_factura_by_id(p_id IN tony.facturas.id_factura%type) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT * FROM  TONY.FACTURAS WHERE id_factura = p_id;
    RETURN v_cursor;
END get_factura_by_id;
/
CREATE OR REPLACE FUNCTION get_ingrediente_by_id(p_id IN tony.ingredientes.id_ingrediente%type) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT * FROM  TONY.INGREDIENTES WHERE id_ingrediente = p_id;
    RETURN v_cursor;
END get_ingrediente_by_id;
/
CREATE OR REPLACE FUNCTION get_orden_by_id(p_id IN tony.ordenes.id_orden%type) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT * FROM  TONY.ORDENES WHERE id_orden = p_id;
    RETURN v_cursor;
END get_orden_by_id;
/
CREATE OR REPLACE FUNCTION get_producto_by_id(p_id IN tony.productos.id_producto%type) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT * FROM  TONY.PRODUCTOS WHERE id_producto = p_id;
    RETURN v_cursor;
END get_producto_by_id;
/
CREATE OR REPLACE FUNCTION get_proveedor_by_id(p_id IN tony.proveedores.id_proveedor%type) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT * FROM  TONY.PROVEEDORES WHERE id_proveedor = p_id;
    RETURN v_cursor;
END get_proveedor_by_id;
/
CREATE OR REPLACE FUNCTION get_vendedor_by_id(p_id IN tony.vendedores.id_vendedor%type) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT * FROM  TONY.VENDEDORES WHERE id_vendedor = p_id;
    RETURN v_cursor;
END get_vendedor_by_id;
/
CREATE OR REPLACE FUNCTION existe_categoria(p_id IN tony.categorias.id_categoria%type)
RETURN NUMBER AS v_cantidad NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cantidad
    FROM TONY.CATEGORIAS 
    WHERE id_categoria = p_id;
    
    IF v_cantidad > 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/
CREATE OR REPLACE FUNCTION existe_cliente(p_cedula IN tony.clientes.cedula%type)
RETURN NUMBER AS v_cantidad NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cantidad
    FROM TONY.CLIENTES 
    WHERE cedula = p_cedula;
    
    IF v_cantidad > 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/
CREATE OR REPLACE FUNCTION existe_detalle_orden(p_id IN tony.detalles_ordenes.id_detalle%type)
RETURN NUMBER AS v_cantidad NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cantidad
    FROM TONY.DETALLES_ORDENES
    WHERE id_detalle = p_id;
    
    IF v_cantidad > 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/
CREATE OR REPLACE FUNCTION existe_factura(p_id IN tony.facturas.id_factura%type)
RETURN NUMBER AS v_cantidad NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cantidad
    FROM TONY.FACTURAS 
    WHERE id_factura = p_id;
    
    IF v_cantidad > 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/
CREATE OR REPLACE FUNCTION existe_ingrediente(p_id IN tony.ingredientes.id_ingrediente%type)
RETURN NUMBER AS v_cantidad NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cantidad
    FROM TONY.INGREDIENTES 
    WHERE id_ingrediente = p_id;
    
    IF v_cantidad > 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/
CREATE OR REPLACE FUNCTION existe_orden(p_id IN tony.ordenes.id_orden%type)
RETURN NUMBER AS v_cantidad NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cantidad
    FROM TONY.ORDENES 
    WHERE id_orden = p_id;
    
    IF v_cantidad > 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/
CREATE OR REPLACE FUNCTION existe_producto(p_id IN tony.productos.id_producto%type)
RETURN NUMBER AS v_cantidad NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cantidad
    FROM TONY.PRODUCTOS 
    WHERE id_producto = p_id;
    
    IF v_cantidad > 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/
CREATE OR REPLACE FUNCTION existe_proveedor(p_id IN tony.proveedores.id_proveedor%type)
RETURN NUMBER AS v_cantidad NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cantidad
    FROM TONY.PROVEEDORES 
    WHERE id_proveedor = p_id;
    
    IF v_cantidad > 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/
CREATE OR REPLACE FUNCTION existe_vendedor(p_id IN tony.vendedores.id_vendedor%type)
RETURN NUMBER AS v_cantidad NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cantidad
    FROM TONY.VENDEDORES 
    WHERE id_vendedor = p_id;
    
    IF v_cantidad > 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/
CREATE OR REPLACE FUNCTION get_orden_and_subtotal_by_fecha_and_producto(p_cancelado IN tony.detalles_ordenes.cancelado%type) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT DISTINCT o.id_orden, o.usuario, o.fecha 
        FROM TONY.ordenes o 
        JOIN TONY.detalles_ordenes d ON o.id_orden = d.id_orden 
        WHERE d.cancelado = p_cancelado
        ORDER BY o.id_orden;
    RETURN v_cursor;
END get_orden_by_cancelado;
/
CREATE OR REPLACE FUNCTION get_detalles_by_orden(p_id_orden IN tony.ordenes.id_orden%type) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT D.id_detalle, P.nombre, D.subtotal, D.cancelado 
        FROM TONY.DETALLES_ORDENES D 
        JOIN TONY.PRODUCTOS P ON D.id_producto = P.id_producto 
        WHERE D.id_orden = p_id_orden;
    RETURN v_cursor;
END get_detalles_by_orden;
/
CREATE OR REPLACE FUNCTION get_detalles_by_factura(p_id_factura IN tony.facturas.id_factura%type) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT p.nombre, p.precio 
        FROM TONY.DETALLES_ORDENES D 
        JOIN TONY.PRODUCTOS P ON D.id_producto = P.id_producto WHERE D.id_factura = p_id_factura;
    RETURN v_cursor;
END get_detalles_by_factura;
/
CREATE OR REPLACE VIEW ordenes_sin_cancelar AS
SELECT DISTINCT o.id_orden, o.usuario, o.fecha 
    FROM TONY.ordenes o 
    JOIN TONY.detalles_ordenes d ON o.id_orden = d.id_orden 
    WHERE d.cancelado = 0
    ORDER BY o.id_orden;
/
CREATE OR REPLACE VIEW get_categorias AS
    SELECT * FROM  TONY.CATEGORIAS
    ORDER BY id_categoria;
/
CREATE OR REPLACE VIEW get_clientes AS
    SELECT * FROM  TONY.CLIENTES
    ORDER BY cedula;
/
CREATE OR REPLACE VIEW get_detalles_ordenes AS
    SELECT D.id_detalle as id_detalle,
           O.usuario as id_orden,
           D.id_factura as id_factura,
           P.nombre as id_producto,
           D.subtotal as subtotal,
           DECODE(D.cancelado, 0, 'no', 1, 'sí', 'otro') AS cancelado
    FROM  TONY.DETALLES_ORDENES D
    INNER JOIN TONY.ORDENES O ON D.id_orden = O.id_orden
    INNER JOIN TONY.PRODUCTOS P ON D.id_producto = P.id_producto
    ORDER BY id_detalle DESC
    FETCH FIRST 100 ROW ONLY;
/
CREATE OR REPLACE VIEW get_facturas AS
    SELECT * FROM  TONY.FACTURAS
    ORDER BY id_factura DESC
    FETCH FIRST 100 ROW ONLY;
/
CREATE OR REPLACE VIEW get_ingredientes AS
    SELECT * FROM  TONY.INGREDIENTES
    ORDER BY id_ingrediente;
/
CREATE OR REPLACE VIEW get_ordenes AS
    SELECT * FROM  TONY.ORDENES 
    ORDER BY id_orden DESC 
    FETCH FIRST 100 ROWS ONLY;
/
CREATE OR REPLACE VIEW get_productos AS
    SELECT P.id_producto as id_producto, 
           P.nombre as nombre,
           P.descripcion as descripcion,
           P.precio as precio,
           C.nombre as id_categoria,
           DECODE(P.activo, 0, 'no', 1, 'sí', 'otro') AS activo
    FROM  TONY.PRODUCTOS P
    INNER JOIN TONY.CATEGORIAS C ON C.id_categoria = P.id_categoria
    ORDER BY id_producto;
/
CREATE OR REPLACE VIEW get_proveedor_ingredientes AS
    SELECT * FROM TONY.PROVEEDOR_INGREDIENTES
    ORDER BY id_ingrediente;
/
CREATE OR REPLACE VIEW get_proveedores AS
    SELECT * FROM TONY.PROVEEDORES
    ORDER BY id_proveedor;
/
CREATE OR REPLACE VIEW get_vendedores AS
    SELECT * FROM TONY.VENDEDORES
    ORDER BY id_vendedor;
/

CREATE OR REPLACE PROCEDURE agregar_categoria (p_nombre IN tony.categorias.nombre%type) 
AS v_id_categoria NUMBER;
BEGIN
    SELECT secuencia_categorias.NEXTVAL INTO v_id_categoria FROM dual;
    
    INSERT INTO TONY.CATEGORIAS (id_categoria, nombre)
    VALUES (v_id_categoria, p_nombre);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE agregar_cliente (p_cedula IN tony.clientes.cedula%type, p_nombre IN tony.clientes.nombre%type, p_telefono IN tony.clientes.telefono%type) 
AS 
BEGIN
    INSERT INTO TONY.CLIENTES (cedula, nombre, telefono)
    VALUES (p_cedula, p_nombre, p_telefono);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE agregar_detalle_orden(p_id_orden IN tony.detalles_ordenes.id_orden%type, p_id_factura IN tony.detalles_ordenes.id_factura%type, p_id_producto IN tony.detalles_ordenes.id_producto%type, p_subtotal IN tony.detalles_ordenes.subtotal%type, p_cancelado IN tony.detalles_ordenes.cancelado%type) 
AS v_id_detalle NUMBER;
BEGIN
    SELECT secuencia_detalles_ordenes.NEXTVAL INTO v_id_detalle FROM dual;
    
    INSERT INTO TONY.DETALLES_ORDENES (id_detalle, id_orden, id_factura, id_producto, subtotal, cancelado)
    VALUES (v_id_detalle, p_id_orden, p_id_factura, p_id_producto, p_subtotal, p_cancelado);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE agregar_factura (p_id_orden IN tony.facturas.id_orden%type, p_id_vendedor IN tony.facturas.id_vendedor%type, p_fecha IN tony.facturas.fecha%type, p_total IN tony.facturas.total%type) 
AS v_id_factura NUMBER;
BEGIN
    SELECT secuencia_facturas.NEXTVAL INTO v_id_factura FROM dual;
    
    INSERT INTO TONY.FACTURAS (id_factura, id_orden, id_vendedor, fecha, total)
    VALUES (v_id_factura, p_id_orden, p_id_vendedor, p_fecha, p_total);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE agregar_ingrediente (p_nombre IN tony.ingredientes.nombre%type, p_existencias IN tony.ingredientes.existencias%type) 
AS v_id_ingrediente NUMBER;
BEGIN
    SELECT secuencia_ingredientes.NEXTVAL INTO v_id_ingrediente FROM dual;
    
    INSERT INTO TONY.INGREDIENTES (id_ingrediente, nombre, existencias)
    VALUES (v_id_ingrediente, p_nombre, p_existencias);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE agregar_orden (p_usuario IN tony.ordenes.usuario%type, p_fecha IN tony.ordenes.fecha%type) 
AS v_id_orden NUMBER;
BEGIN
    SELECT secuencia_ordenes.NEXTVAL INTO v_id_orden FROM dual;
    
    INSERT INTO TONY.ORDENES (id_orden, usuario, fecha)
    VALUES (v_id_orden, p_usuario, p_fecha);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE agregar_producto (p_nombre IN tony.productos.nombre%type, p_descripcion IN tony.productos.descripcion%type, p_precio IN tony.productos.precio%type, p_id_categoria IN tony.productos.id_categoria%type, p_activo IN tony.productos.activo%type) 
AS v_id_producto NUMBER;
BEGIN
    SELECT secuencia_productos.NEXTVAL INTO v_id_producto FROM dual;
    
    INSERT INTO TONY.PRODUCTOS (id_producto, nombre, descripcion, precio, id_categoria, activo)
    VALUES (v_id_producto, p_nombre, p_descripcion, p_precio, p_id_categoria, p_activo);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE agregar_proveedor_ingrediente (p_id_proveedor IN tony.proveedor_ingredientes.id_proveedor%type, p_id_ingrediente IN tony.proveedor_ingredientes.id_ingrediente%type) 
AS
BEGIN
    INSERT INTO TONY.PROVEEDOR_INGREDIENTES (id_proveedor, id_ingrediente)
    VALUES (p_id_proveedor, p_id_ingrediente);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE agregar_proveedor (p_nombre IN tony.proveedores.nombre%type, p_telefono IN tony.proveedores.telefono%type, p_direccion IN tony.proveedores.direccion%type) 
AS v_id_proveedor NUMBER;
BEGIN
    SELECT secuencia_proveedores.NEXTVAL INTO v_id_proveedor FROM dual;
    
    INSERT INTO TONY.PROVEEDORES (id_proveedor, nombre, telefono, direccion)
    VALUES (v_id_proveedor, p_nombre, p_telefono, p_direccion);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE agregar_vendedor (p_nombre IN tony.vendedores.nombre%type) 
AS v_id_vendedor NUMBER;
BEGIN
    SELECT secuencia_vendedores.NEXTVAL INTO v_id_vendedor FROM dual;
    
    INSERT INTO TONY.VENDEDORES (id_vendedor, nombre)
    VALUES (v_id_vendedor, p_nombre);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE modificar_categoria (p_id_categoria IN tony.categorias.id_categoria%type, p_nombre IN tony.categorias.nombre%type) 
AS
BEGIN
    UPDATE TONY.CATEGORIAS
    SET nombre = p_nombre
    WHERE id_categoria = p_id_categoria;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE modificar_cliente (p_cedula IN tony.clientes.cedula%type, p_nombre IN tony.clientes.nombre%type, p_telefono IN tony.clientes.telefono%type) 
AS 
BEGIN
    UPDATE TONY.CLIENTES
    SET nombre = p_nombre,
        telefono = p_telefono
    WHERE cedula = p_cedula;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE modificar_detalle_orden(p_id_detalle IN tony.detalles_ordenes.id_detalle%type, p_id_orden IN tony.detalles_ordenes.id_orden%type, p_id_factura IN tony.detalles_ordenes.id_factura%type, p_id_producto IN tony.detalles_ordenes.id_producto%type, p_subtotal IN tony.detalles_ordenes.subtotal%type, p_cancelado IN tony.detalles_ordenes.cancelado%type) 
AS
BEGIN
    UPDATE TONY.DETALLES_ORDENES
    SET id_orden = p_id_orden,
        id_factura = p_id_factura,
        id_producto = p_id_producto,
        subtotal = p_subtotal,
        cancelado = p_cancelado
    WHERE id_detalle = p_id_detalle;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE modificar_factura (p_id_factura IN tony.facturas.id_factura%type, p_id_orden IN tony.facturas.id_orden%type, p_id_vendedor IN tony.facturas.id_vendedor%type, p_fecha IN tony.facturas.fecha%type, p_total IN tony.facturas.total%type) 
AS
BEGIN
    UPDATE TONY.FACTURAS
    SET id_orden = p_id_orden,
        id_vendedor = p_id_vendedor,
        fecha = p_fecha,
        total = p_total
    WHERE id_factura = p_id_factura;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE modificar_ingrediente (p_id_ingrediente IN tony.ingredientes.id_ingrediente%type, p_nombre IN tony.ingredientes.nombre%type, p_existencias IN tony.ingredientes.existencias%type) 
AS
BEGIN
    UPDATE TONY.INGREDIENTES
    SET nombre = p_nombre,
        existencias = p_existencias
    WHERE id_ingrediente = p_id_ingrediente;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE modificar_orden (p_id_orden IN tony.ordenes.id_orden%type, p_usuario IN tony.ordenes.usuario%type, p_fecha IN tony.ordenes.fecha%type) 
AS
BEGIN
    UPDATE TONY.ORDENES
    SET usuario = p_usuario,
        fecha = p_fecha
    WHERE id_orden = p_id_orden;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE modificar_producto (p_id_producto IN tony.productos.id_producto%type, p_nombre IN tony.productos.nombre%type, p_descripcion IN tony.productos.descripcion%type, p_precio IN tony.productos.precio%type, p_id_categoria IN tony.productos.id_categoria%type, p_activo IN tony.productos.activo%type) 
AS
BEGIN
    UPDATE TONY.PRODUCTOS
    SET nombre = p_nombre,
        descripcion = p_descripcion,
        precio = p_precio,
        id_categoria = p_id_categoria,
        activo = p_activo
    WHERE id_producto = p_id_producto;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE modificar_proveedor (p_id_proveedor IN tony.proveedores.id_proveedor%type, p_nombre IN tony.proveedores.nombre%type, p_telefono IN tony.proveedores.telefono%type, p_direccion IN tony.proveedores.direccion%type) 
AS
BEGIN
    UPDATE TONY.PROVEEDORES
    SET nombre = p_nombre,
        telefono = p_telefono,
        direccion = p_direccion
    WHERE id_proveedor = p_id_proveedor;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE modificar_vendedor (p_id_vendedor IN tony.vendedores.id_vendedor%type, p_nombre IN tony.vendedores.nombre%type) 
AS 
BEGIN
    UPDATE TONY.VENDEDORES
    SET nombre = p_nombre
    WHERE id_vendedor = p_id_vendedor;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE eliminar_categoria (p_id_categoria IN tony.categorias.id_categoria%type) 
AS
BEGIN
    DELETE FROM TONY.CATEGORIAS
    WHERE id_categoria = p_id_categoria;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE eliminar_cliente (p_cedula IN tony.clientes.cedula%type) 
AS 
BEGIN
    DELETE FROM TONY.CLIENTES
    WHERE cedula = p_cedula;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE eliminar_detalle_orden(p_id_detalle IN tony.detalles_ordenes.id_detalle%type) 
AS
BEGIN
    DELETE FROM TONY.DETALLES_ORDENES
    WHERE id_detalle = p_id_detalle;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE eliminar_factura (p_id_factura IN tony.facturas.id_factura%type) 
AS
BEGIN
    DELETE FROM TONY.FACTURAS
    WHERE id_factura = p_id_factura;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE eliminar_ingrediente (p_id_ingrediente IN tony.ingredientes.id_ingrediente%type) 
AS
BEGIN
    DELETE FROM TONY.INGREDIENTES
    WHERE id_ingrediente = p_id_ingrediente;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE eliminar_orden (p_id_orden IN tony.ordenes.id_orden%type) 
AS
BEGIN
    DELETE FROM TONY.ORDENES
    WHERE id_orden = p_id_orden;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE eliminar_producto (p_id_producto IN tony.productos.id_producto%type) 
AS
BEGIN
    DELETE FROM TONY.PRODUCTOS
    WHERE id_producto = p_id_producto;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE eliminar_proveedor_ingrediente (p_id_proveedor IN tony.proveedor_ingredientes.id_proveedor%type, p_id_ingrediente IN tony.proveedor_ingredientes.id_ingrediente%type) 
AS
BEGIN
    DELETE FROM TONY.PROVEEDOR_INGREDIENTES
    WHERE id_proveedor = p_id_proveedor AND id_ingrediente=p_id_ingrediente;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE eliminar_proveedor (p_id_proveedor IN tony.proveedores.id_proveedor%type) 
AS
BEGIN
    DELETE FROM TONY.PROVEEDORES
    WHERE id_proveedor = p_id_proveedor;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE eliminar_vendedor (p_id_vendedor IN tony.vendedores.id_vendedor%type) 
AS 
BEGIN
    DELETE FROM TONY.VENDEDORES
    WHERE id_vendedor = p_id_vendedor;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE eliminar_pedido (p_id_orden IN tony.ordenes.id_orden%type) 
AS
BEGIN
    DELETE FROM TONY.detalles_ordenes WHERE id_orden = p_id_orden;
    DELETE FROM TONY.ordenes WHERE id_orden = p_id_orden;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
CREATE OR REPLACE PROCEDURE pagar_detalle_orden(p_id_detalle IN tony.detalles_ordenes.id_detalle%type, p_id_factura IN tony.detalles_ordenes.id_factura%type) 
AS
BEGIN
    UPDATE TONY.DETALLES_ORDENES
    SET id_factura = p_id_factura,
        cancelado = 1
    WHERE id_detalle = p_id_detalle;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al agregar: ' || SQLERRM);
        ROLLBACK;
END;
/
COMMIT;

//prueba