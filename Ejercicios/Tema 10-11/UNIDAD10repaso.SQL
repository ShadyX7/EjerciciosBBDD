/* **********************************************************************
REFUERZO TEMA 10. GESTION DE BASES DE DATOS.
************************************************************************* */

/*
1.  Crea un procedimiento que elimina los empleados de un departamento, pero previamente toma los datos 
iniciales de los empleados y los inserta en una tabla de histórico.
Observación: Crea una tabla como EMPLE y la llamas EMPLE_H. */
CREATE TABLE EMPLE_H 
 AS (SELECT * FROM EMPLE WHERE 1 = 0);

CREATE OR REPLACE PROCEDURE ELIMINA_EMPLE(DEPTO NUMBER)
AS
BEGIN
 INSERT INTO EMPLE_H
  SELECT * FROM EMPLE WHERE DEPT_NO = DEPTO;
DELETE FROM EMPLE 
 WHERE DEPT_NO = DEPTO;
EXCEPTION
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('ERROR');
END ELIMINA_EMPLE;

/*
2.  Crea un procedimiento al que le pasamos el nombre de un departamento. Con este dato halla el 
salario medio del departamento y a todos los empleados que no superan esa media se los pasa al 
departamento de VENTAS. Igualmente que en el ejercicio anterior a todos estos empleados los insertamos 
en la tabla EMPLE_H con sus datos originales.
*/
CREATE OR REPLACE PROCEDURE MENOS_Q_MEDIA(DEPTO VARCHAR2)
AS
V_SMEDIO NUMBER(6,2);
V_NRODEPTO NUMBER(4);
BEGIN
SELECT DEPT_NO INTO V_NRODEPTO FROM DEPART WHERE DNOMBRE = DEPTO;
SELECT AVG(SALARIO) INTO V_SMEDIO FROM EMPLE WHERE DEPT_NO = V_NRODEPTO;
INSERT INTO EMPLE_H 
 SELECT * FROM EMPLE WHERE DEPT_NO = V_NRODEPTO AND SALARIO < V_SMEDIO;

UPDATE EMPLE
 SET DEPT_NO = (SELECT DEPT_NO FROM DEPART WHERE DNOMBRE = 'VENTAS')
 WHERE DEPT_NO = V_NRODEPTO AND SALARIO < V_SMEDIO;

EXCEPTION
WHEN NO_DATA_FOUND THEN
 DBMS_OUTPUT.PUT_LINE('NO HAY DATOS');

WEN TOO_MANY_ROWS THEN
 DBMS_OUTPUT.PUT_LINE('DEMASIADOS DATOS');

WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('ERROR');
END MENOS_Q_MEDIA;

BEGIN MENOS_Q_MEDIA('CONTABILIDAD'); END;

SELECT * FROM EMPLE_H

/*CON CURSOR*/
CREATE OR REPLACE PROCEDURE MENOS_Q_MEDIA2(DEPTO VARCHAR2)
AS
V_SMEDIO NUMBER(6,2);
V_NRODEPTO NUMBER(4);
 CURSOR C1 (DEP NUMBER, SAL NUMBER) IS SELECT * FROM EMPLE
 WHERE DEPT_NO=DEP AND SALARIO < SAL FOR UPDATE;

BEGIN
SELECT DEPT_NO INTO V_NRODEPTO FROM DEPART WHERE DNOMBRE = DEPTO;
SELECT AVG(SALARIO) INTO V_SMEDIO FROM EMPLE WHERE DEPT_NO = V_NRODEPTO;

FOR V_REG IN C1 (V_SMEDIO, V_NRODEPTO) LOOP
 INSERT INTO EMPLE_H VALUES(V_REG.EMP_NO, V_REG.APELLIDO, V_REG.OFICIO, V_REG.DIR,
  V_REG.FECHA_ALT, V_REG.SALARIO, V_REG.COMISION, V_REG.DEPT_NO);
  UPDATE EMPLE SET DEPT_NO=(SELECT DEPT_NO FROM DEPART WHERE DNOMBRE='VENTAS')
  WHERE CURRENT OF C1;
END LOOP;

EXCEPTION
WHEN NO_DATA_FOUND THEN
 DBMS_OUTPUT.PUT_LINE('NO HAY DATOS');

WEN TOO_MANY_ROWS THEN
 DBMS_OUTPUT.PUT_LINE('DEMASIADOS DATOS')

WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('ERROR');
END MENOS_Q_MEDIA2;

/*
3.  Desarrolla un procedimiento que nos permita crear nuevos ARTICULOS (pasamos como parámetros los datos
 de artículos) controlando posibles fallos como que el fabricante no exista, precio_venta < precio_coste 
 o cualquiera de estos es negativo o las existencias negativas.
*/
CREATE OR REPLACE PROCEDURE INSERTA_ARTI(ARTICULO VARCHAR2, COD_FABRICAN NUMBER, PESO NUMBER, CATEGORIA
 VARCHAR2, PRECIO_VENTA NUMBER, PRECIO_COSTE NUMBER, existencias NUMBER)
AS
V_FABRI NUMBER(3);

NO_EXISTE_VENDEDOR EXCEPTION;
VAL_NEGATIVOS EXCEPTION;
PRECIO_VENTA_BAJO EXCEPTION;

BEGIN
SELECT COUNT(*) INTO V_FABRI FROM FABRICANTES  WHERE COD_FABRICANTE = COD_FABRICAN;
IF (V_FABRI <> 1) THEN
 RAISE NO_EXISTE_VENDEDOR;
END IF;

IF(PESO <= 0 OR PRECIO_VENTA <= 0 OR PRECIO_COSTE <= 0 OR existencias <= 0) THEN
 RAISE VAL_NEGATIVOS;
END IF;

IF(PRECIO_VENTA <= PRECIO_COSTE) THEN
 RAISE PRECIO_VENTA_BAJO;
END IF;

INSERT INTO ARTICULOS
VALUES(ARTICULO, COD_FABRICAN, PESO, CATEGORIA, PRECIO_VENTA, PRECIO_COSTE, existencias);

DBMS_OUTPUT.PUT_LINE('ARTICULO INSERTADO');

EXCEPTION
WHEN PRECIO_VENTA_BAJO THEN
 DBMS_OUTPUT.PUT_LINE('PRECIO DE VENTA BAJO');

WHEN VAL_NEGATIVOS THEN
 DBMS_OUTPUT.PUT_LINE('DEBE INSERTAR VALORES POSITIVOS');

WHEN NO_EXISTE_VENDEDOR THEN
 DBMS_OUTPUT.PUT_LINE('FABRICANTE INCORRECTO');

WHEN TOO_MANY_ROWS THEN
 DBMS_OUTPUT.PUT_LINE('DEMASIADOS DATOS');

WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('ERROR');
END INSERTA_ARTI;

BEGIN INSERTA_ARTI('FIDEOS',20,3,'Primera', 2, 1, 0); END;
/*
4.  Codifica un procedimiento que nos diga cuales son los tres empleados que ganan más en su departamento.
*/
CREATE OR REPLACE PROCEDURE TRES_Q_MAS(DEPART NUMBER)
AS 
CURSOR MI_CURSOR IS 
 SELECT * FROM EMPLE WHERE DEPT_NO = DEPART
-- INCOMPLETO --



/*
5.  Crea un procedimiento sube el precio de venta de los artículos de un fabricante. Pasamos como 
parámetros un nuevo precio y un porcentaje (subida porcentual con respecto a precio inicial) y 
subiremos la cantidad más pequeña. Controlamos que ninguno de los dos parámetros es negativo y que 
el fabricante existe. Crea excepciones y asócialas con errores que defines. 
(observación: Cursores For Update)
*/
CREATE OR REPLACE PROCEURE ACTUALIZA_VENTA(COD_FABRI NUMBER, PVP NUMBER, PCT NUMBER)
AS
CURSOR C1(COD_FAB NUMBER) IS SELECT * FROM ARTICULOS WHERE COD_FABRICANTE=COD_FAB FOR UPDATE;
V_PVP NUMBER(4,2);
V_COD NUMBER(1);
NO_FAB EXCEPTION;
PVP_NEG EXCEPTION;
PCT_NEG EXCEPTION;

BEGIN
 SELECT COUNT(*) INTO V_COD FROM FABRICANTES WHERE COD_FABRICANTE=COD;

IF V_COD=0 THEN RAISE NO_FAB; END IF;
IF PVP<0 THEN RAISE PVP_NEG; END IF;
IF PCT<0 THEN RAISE PCT_NEG; END IF;

FOR V_REG IN C1(COD) LOOP
 V_PVP:=LEAST(PVP, V_REG.PRECIO_VENTA*(1+PCT/100));
 UPDATE ARTICULOS SET PRECIO_VENTA=V_PVP WHERE CURRENT OF C1;
END LOOP;

EXCEPTION
WHEN NO_FAB THEN DBMS_OUTPUT.PUT_LINE('NO EXISTE EL FABRICANTE');
WHEN PVP_NEG THEN DBMS_OUTPUT.PUT_LINE('PVP NEGATIVO');
WHEN PCT_NEG THEN DBMS_OUTPUT.PUT_LINE('PCT NEGATIVO');

END ACTUALIZA_VENTA;


/*
6.  Crea un procedimiento que calcule la suma de las unidades vendidas y la suma de las unidades 
pedidas de un artículo que pasamos como parámetro, y entre dos fechas predeterminadas. Con estos 
dos valores calculados los insertamos en una tabla T_ARTICULO, que tendrá los campos: Articulo, 
Cod_fabricante, Peso, Categoría, Unidades_Vendidas, Unidades_Pedidas; Observación: Si un artículo 
no tiene unidades vendidas o pedidas esa suma tendrá como resultado 0. Gestiona las posibles excepciones.
*/

/*
7.  Crea un procedimiento que pasando como parámetro el nombre de un departamento calcula el salario medio,
 máximo y mínimo (incluyendo la comisión) de ese departamento. Además inserta en la tabla T_DEPART los 
 valores: dept_no, salario_medio, salario_máximo, salario_minimo y número de empleados. Gestiona las 
 posibles excepciones.
*/

/*
8.  Crea un procedimiento que inserta valores en la tabla EMPLE y que actualiza los datos de la tabla 
T_DEPART. Es decir: si insertamos un empleado en CONTABILIDAD calculamos de nuevo todos los datos del 
procedimiento anterior y con esos datos actualizamos en T_DEPART.
*/

/*
9.  Crea un procedimiento que a partir de la tabla de artículos crea un resumen  contando el número de 
pedidos de cada uno de los artículos. La información se muestra por pantalla. Si algún producto no tiene 
pedidos debe aparecer 0. (Observación: Declara 2 cursores, uno para recorrer los artículos y otro los 
pedidos. El de los pedidos está anidado dentro del cursor de los artículos.
*/

/*
10. Ídem con Artículos y Ventas.
*/

/*
11. Ídem con Empleados y departamentos.
*/

/*
12. Crea un procedimiento que muestre por cada uno de los centros el dinero gastado en salarios de sus 
empleados (Centros y Personal)
*/

/*
13. Crea la tabla TIENDA_FACT_PEDIDOS en la que tienes los siguientes campos (NIF, Facturación) . 
Esta tabla guarda la información acerca de la facturación en pedidos de cada una de las tiendas. 
Ahora crea un procedimiento que recibe todos los datos de un pedido y los inserta en la tabla pedidos. 
Después calcula la facturación de la tienda en pedidos y hace lo siguiente: inserta el NIF de la tienda 
y su facturación en la tabla TIENDA_FACT_PEDIDOS. Si la tienda ya existía en la tabla TIENDA_FACT_PEDIDOS
  sólo realizas una actualización de su facturación, sin realizar INSERT. De este modo se observa que la
  tabla TIENDA_FACT_PEDIDOS sólo tiene un registro por cada NIF distinto de la tabla TIENDAS.
*/

/*
14. Ídem con TIENDA_FACT_VENTAS. Es decir, crea un procedimiento que recibe todos los datos de una VENTA
 y haces lo mismo que en el procedimiento anterior. Las tablas TIENDA_FACT_pedidos y TIENDA_FACT-_ventas 
 tienen los mismos campos.
*/