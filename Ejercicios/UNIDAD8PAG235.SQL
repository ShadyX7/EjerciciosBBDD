--1. Construye un bloque PL/SQL que escriba el texto 'Hola'.

DECLARE
 BEGIN
  DBMS_OUTPUT.PUT_LINE('HOLA');
 END;

--2. ¿Qué hace el siguiente bloque PL/SQL?
-- SQL>DECLARE
--2 v_num NUMBER;
--3 BEGIN
--4 SELECT count(*) INTO v_num
--5 FROM productos;
--6 DBMS_OUTPUT.PUT_LINE(v_num);
--7 END;
--8 /

--MUESTRA CUANTOS PRODUCTOS HAY


--3. Introduce el bloque anterior desde SQL*Plus y guardarlo en un fichero.
DECLARE
 v_num NUMBER;
 BEGIN
  SELECT count(*) INTO v_num
  FROM productos;
  DBMS_OUTPUT.PUT_LINE(v_num);
END;

--4. Ejecuta la orden SELECT especificada en el bloque anterior desde SQL*Plus sin la cláusula INTO.

  SELECT count(*)
  FROM productos;


--5. Carga y ejecuta el bloque de nuevo, y comprueba que el resultado aparece en pantalla.

-- ORA-06550: línea 4, columna 3:
-- PLS-00428: se espera una cláusula INTO en esta sentencia SELECT


--6. Escribe desde SQL*Plus el ejemplo número 1 del epígrafe «Uso de subprogramas almacenados» y prueba a
--ejecutarlo con distintos valores.

CREATE OR REPLACE
PROCEDURE ver_depart (numdepart NUMBER)
AS
v_dnombre VARCHAR2(14);
v_localidad VARCHAR2(14);
BEGIN
SELECT dnombre, loc INTO v_dnombre, v_localidad
FROM depart
WHERE dept_no = numdepart;
 DBMS_OUTPUT.PUT_LINE('Num depart:'||numdepart|| ' * Nombre dep:'|| v_dnombre ||
 ' * Localidad:'||v_localidad);
 EXCEPTION
 WHEN NO_DATA_FOUND THEN
 DBMS_OUTPUT.PUT_LINE('No encontrado departamento ');
 END ver_depart;


--SQL> EXECUTE VER_DEPART(10)
--Num depart:10 * Nombre dep:CONTABILIDAD * Localidad:SEVILLA
--
--Procedimiento PL/SQL terminado correctamente.

--7. Identifica en el ejemplo número 2 del epígrafe «Uso  de subprogramas almacenados» los siguientes elementos:
-- – La cabecera del procedimiento.
-- – El nombre del procedimiento.
-- – Los parámetros del procedimiento.
-- – Las variables locales.
-- – El comienzo y el final del bloque PL/SQL.
-- – El comienzo y el final de las secciones declarativa, ejecutable y de gestión de excepciones.
-- – ¿Qué hace la cláusula INTO?
-- – ¿Qué hace WHEN NO_DATA_FOUND?
-- – ¿Por qué no tiene la cláusula DECLARE? ¿Qué tiene en su lugar?


 CREATE OR REPLACE                           -- EN LUGAR DE DECLARE, QUE ES ANONIMO LE PONE UN NOMBRE Y CREA 
 PROCEDURE ver_precio(v_num_producto NUMBER)  --CABECERA, NOMBRE: VER_PRECIO; PARAMETROS: V_NUM_PRODUCTO
 AS
 v_precio NUMBER;                      --VARIABLE LOCAL
 BEGIN                                 --INICIO DE PROCEDIMIENTO
 SELECT precio_actual INTO v_precio    --INTO LE PONE EL VALOR DEL SELECT A LA VARIABLE LOCAL
 FROM productos
 WHERE producto_no = v_num_producto;
 DBMS_OUTPUT.PUT_LINE('Precio = '||v_precio);
 END;                                   --FIN DE PROCEDIMIENTO 