/* 1.  Crea un procedimiento que recibe los datos de un profesor:
a.  Comprueba que el centro existe.
b.  Comprueba que su clave no se repite.
c.  Si los datos son correctos  el registro se inserta.
d.  Gestiona posibles excepciones.*/ 
CREATE OR REPLACE PROCEDURE INSERTA_PROFE 
(CODCENTRO NUMBER, D NUMBER, APELL VARCHAR2, ESPCLIDAD VARCHAR2)
AS 
V_CENTROS NUMBER(2);
V_PROFESOR (2);

BEGIN
SELECT COUNT(*) INTO V_CENTROS FROM CENTROS WHERE COD_CENTRO = CODCENTRO;
SELECT COUNT(*) INTO V_PROFESOR FROM PROFESORES WHERE DNI = D;
IF(V_CENTROS=1 AND V_PROFESOR=0) THEN
 INSERT INTO PROFESORES VALUES(CODCENTRO, D , APELL , ESPCLIDAD );
 DBMS_OUTPUT.PUT_LINE('PROFESOR INSERTADO');
 ELSE
 DBMS_OUTPUT.PUT_LINE('EL CENTRO NO EXISTE O EL DNI SE REPITE');
 END IF;
EXCEPTION
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('ERROR GENERAL');
END INSERTA_PROFE;

BEGIN INSERTA_PROFE(10, 1548, 'PEREZ', 'MATES'); END;

/*
2.  Crea un procedimiento que recibe los datos de un empleado y realiza las siguientes acciones:
a.  Comprueba que existe el dir y el departamento del empleado.
b.  Comprueba que el salario es positivo.
c.  Si todos los datos son correctos  inserta el empleado.
d.  Muestra por pantalla el gasto total en salarios del departamento del nuevo empleado.
e.  Gestiona posibles excepciones.*/ 
CREATE OR REPLACE PROCEDURE INSERTA_EMPLE
(NRO NUMBER, APE VARCHAR2, OFIC VARCHAR2, DR NUMBER, FECHAALT DATE, SALARIO NUMBER, COM NUMBER, DEPTO NUMBER)
AS
V_EXIS_DIR NUMBER(2);
V_EXIS_DEPTO NUMBER(2);
V_TOTAL_DEPTO NUMBER(8);
BEGIN
SELECT COUNT(*) INTO V_EXIS_DIR FROM EMPLE WHERE EMP_NO = DR; --TIENE QUE DAR UNO PARA VALIDO
SELECT COUNT(*) INTO V_EXIS_DEPTO FROM EMPLE WHERE DEPT_NO = DEPTO;--UNO PARA VALIDO
  IF(V_EXIS_DIR=1 AND V_EXIS_DEPTO>0) THEN
    IF(SALARIO>0) THEN
      INSERT INTO EMPLE 
      VALUES(NRO, APE, OFIC, DR, FECHAALT, SALARIO, COM, DEPTO);
      SELECT SUM(SALARIO) INTO V_TOTAL_DEPTO FROM EMPLE WHERE DEPT_NO = DEPTO;
      DBMS_OUTPUT.PUT_LINE('EL GASTO EN SALARIOS 
        DEL DEPARTAMENTO DEL EMPLEADO INSERTADO ES: '||V_TOTAL_DEPTO);
    ELSE
      DBMS_OUTPUT.PUT_LINE('EL SALARIO NO ES POSITIVO');
    END IF;
  ELSE
      DBMS_OUTPUT.PUT_LINE('EL DIRECTOR O EL DEPARTAMENTO NO EXISTE');
  END IF;
  EXCEPTION
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('ERROR GENERAL');
END INSERTA_EMPLE;

BEGIN INSERTA_EMPLE(1458, 'LOPEZ', 'EMPLEADO', 7900, SYSDATE, 2049, 0, 99); END;

/*
3.  Crea un procedimiento que recibe los datos de un pedido y realiza las siguientes acciones:
a.  Comprueba que el artículo existe en la tabla padre.
b.  Comprueba que la tienda existe.
c.  Si las unidades del pedido es superior a las de la venta, sólo asigna al pedido el 20% de 
las existencias.
d.  La fecha de pedido es la actual.
e.  Una vez insertado el pedido resta las unidades pedidas a las existencias del artículo.
*/
CREATE OR REPLACE PROCEDURE INSERTA_PEDIDO
(NF VARCHAR2, ARTIC VARCHAR2, CODFABRI NUMBER, PES NUMBER, CATEG VARCHAR2, FECHA DATE, PEDID NUMBER)
AS
V_ARTI_EXIST NUMBER(1);
V_TIEN_EXIST NUMBER(1);
V_VENTAS NUMBER(6);
V_TOTALAPEDIR NUMBER(6);
BEGIN
IF(FECHA = SYSDATE)THEN
  SELECT COUNT(*) INTO V_ARTI_EXIST FROM ARTICULOS WHERE
   ARTICULO = ARTIC AND COD_FABRICANTE = CODFABRI AND PESO = PES AND CATEGORIA = CATEG;

  SELECT COUNT(*) INTO V_TIEN_EXIST FROM TIENDAS WHERE NIF = NF;
  
  IF(V_TIEN_EXIST=1 AND V_ARTI_EXIST=1) THEN
    SELECT SUM(UNIDADES_VENDIDAS) INTO V_VENTAS FROM VENTAS WHERE
      ARTICULO = ARTIC AND COD_FABRICANTE = CODFABRI AND PESO = PES AND CATEGORIA = CATEG;

    IF (V_VENTAS > PEDID) THEN
     V_TOTALAPEDIR := PEDID;
     ELSE
      SELECT TRUNC(EXISTENCIAS*0.2) INTO V_TOTALAPEDIR FROM ARTICULOS WHERE
       ARTICULO = ARTIC AND COD_FABRICANTE = CODFABRI AND PESO = PES AND CATEGORIA = CATEG;
    END IF;--DE V VENTAS
      --HACE EL INSERT
      INSERT INTO PEDIDOS VALUES (NF, ARTIC, CODFABRI, PES, CATEG, FECHA, V_TOTALAPEDIR);
      --CAMBIA LOS DATOS DE EXISTENCIA
      UPDATE ARTICULOS
      SET EXISTENCIAS = EXISTENCIAS - V_TOTALAPEDIR
      WHERE ARTICULO = ARTIC AND COD_FABRICANTE = CODFABRI AND PESO = PES AND CATEGORIA = CATEG;
  ELSE
    DBMS_OUTPUT.PUT_LINE('EL ARTICULO O LA TIENDA NO EXISTEN');
  END IF;-- DEL TIEN EXIST Y ARTI EXIST  
ELSE
  DBMS_OUTPUT.PUT_LINE('TIENE QUE SER DE LA FECHA ACTUAL');
END IF;--DE LA FECHA ACTUAL
 
 EXCEPTION
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('ERROR GENERAL');
END INSERTA_PEDIDO;

BEGIN INSERTA_PEDIDO('5555-B','Atún', 10, 3,'Segunda', SYSDATE, 4); END;
SELECT * FROM PEDIDOS WHERE ARTICULO = 'Atún';
SELECT EXISTENCIAS FROM ARTICULOS WHERE ARTICULO = 'Atún';

/*
4.  Crea un procedimiento que al recibir los datos de una venta realiza las siguientes acciones:
a.  Muestra la facturación de la tienda (en ventas) antes de insertarse la venta.
b.  Se comprueba que todos los datos de la venta son correctos, como en el ejercicio 3.
c.  Se inserta la venta.
d.   Vuelve a mostrar la facturación de la tienda una vez insertada la venta.
e.  Gestiona las posibles excepciones.
*/
CREATE OR REPLACE PROCEDURE INSERTA_VENTA
(NF VARCHAR2, ARTIC VARCHAR2, CODFABRI NUMBER, PES NUMBER, CATEG VARCHAR2, FECHA DATE, VENDIDOS NUMBER)
AS
FACT NUMBER(6);
V_TIENDA_EXIST NUMBER(1);
V_ARTI_EXIST NUMBER(1);
--TOMA DATOS
SELECT COUNT(*) INTO V_ARTI_EXIST FROM ARTICULOS WHERE
  ARTICULO = ARTIC AND COD_FABRICANTE = CODFABRI AND PESO = PES AND CATEGORIA = CATEG;
SELECT COUNT(*) INTO V_TIENDA_EXIST FROM TIENDAS WHERE
  NIF = NF; 

--VERIFICA
IF(V_TIENDA_EXIST != 1) THEN
  DBMS_OUTPUT.PUT_LINE('LA TIENDA NO EXISTE');
  GOTO LOULTIMO;
END IF;

--FACTURACION
SELECT SUM(PRECIO_VENTA * UNIDADES_VENDIDAS) INTO FACT FROM ARTICULOS A, VENTAS V
WHERE A.ARTICULO = V.ARTICULO 
AND A.PESO = V.PESO
AND A.CATEGORIA = V.CATEGORIA
AND A.COD_FABRICANTE = V.COD_FABRICANTE
AND V.NIF = NF
GROUP BY V.NIF;
DBMS_OUTPUT.PUT_LINE('LA FACTURACION ACTUAL ES:'||FACT);

IF(V_ARTI_EXIST != 1) THEN
  DBMS_OUTPUT.PUT_LINE('EL ARTICULO NO EXISTE');
  GOTO LOULTIMO;
END IF;


<<LOULITMO>>
END INSERTA_VENTA;
--MUESTRA FACTURACION PREVIA




/*
5.  Crea un procedimiento que recibe 2 fechas, y muestra la facturación de la venta y los 
pedidos de todas las tiendas entre esas dos fechas.
*/
CREATE OR REPLACE PROCEDURE FACT_TOTAL_ENTRE(PRIMERO DATE, SEGUNDO DATE)
AS
V_TOTAL_FACTURACION NUMBER(6,2);
BEGIN
SELECT SUM(UNIDADES_VENDIDAS * PRECIO_VENTA) INTO V_TOTAL_FACTURACION FROM ARTICULOS A,VENTAS V
WHERE A.ARTICULO = V.ARTICULO
AND A.COD_FABRICANTE = V.COD_FABRICANTE
AND A.PESO = V.PESO
AND A.CATEGORIA = V.CATEGORIA
AND FECHA_VENTA BETWEEN PRIMERO AND SEGUNDO;
 DBMS_OUTPUT.PUT_LINE('FACTURACION TOTAL:'|| V_TOTAL_FACTURACION);
 EXCEPTION
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('ERROR GENERAL');
END FACT_TOTAL_ENTRE;

BEGIN FACT_TOTAL_ENTRE('11/03/06','11/03/10'); END;


/*
6.  Crea una función que recibe como parámetro el número de departamento y nos devuelve el 
número de empleados que existen en ese departamento. Después crea un procedimiento que realiza 
una llamada a esa función.
*/
CREATE OR REPLACE FUNCTION EMPLE_DEPART(DEPT NUMBER)
RETURN NUMBER
AS
V_EMPLE NUMBER(10);
BEGIN
SELECT COUNT(*) INTO V_EMPLE FROM EMPLE WHERE DEPT_NO = DEPT;
RETURN V_EMPLE;
 EXCEPTION
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('ERROR GENERAL');
END EMPLE_DEPART;

SELECT  DEPT_NO,EMPLE_DEPART(DEPT_NO) FROM EMPLE;


/*
7.  Escribe una función que toma la PK de un artículo y nos devuelve la suma de unidades 
pedidas de ese artículo.
*/
CREATE OR REPLACE FUNCTION UNI_PEDID(ART VARCHAR2, CODFABRI NUMBER, PES NUMBER, CAT VARCHAR2)
RETURN NUMBER
AS
V_TOTAL_PEDIDOS NUMBER(10);
BEGIN
SELECT SUM(UNIDADES_PEDIDAS) INTO V_TOTAL_PEDIDOS FROM PEDIDOS 
WHERE ARTICULO = ART
AND COD_FABRICANTE = CODFABRI
AND PESO = PES
AND CATEGORIA = CAT;
RETURN V_TOTAL_PEDIDOS;
 EXCEPTION
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('ERROR GENERAL');
END UNI_PEDID; 

SELECT UNI_PEDID('Macarrones', 20, 1, 'Primera') FROM DUAL;

/*
8.  Crea un procedimiento que actualiza las existencias de un artículo que recibe como 
parámetro, restando a las existencias la suma de unidades pedidas de ese artículo. Utiliza 
la función del ejercicio anterior.
*/
CREATE OR REPLACE PROCEDURE ACT_EXISTENCIAS(ART VARCHAR2, CODFABRI NUMBER, PES NUMBER, CAT VARCHAR2)
AS
V_TOTAL_PEDIDAS NUMBER(4);
BEGIN
SELECT UNI_PEDID(ART, CODFABRI, PES, CAT)INTO V_TOTAL_PEDIDAS FROM DUAL;
UPDATE ARTICULOS
SET EXISTENCIAS = EXISTENCIAS - V_TOTAL_PEDIDAS
WHERE ARTICULO = ART
AND COD_FABRICANTE = CODFABRI
AND PESO = PES
AND CATEGORIA = CAT;
 EXCEPTION
WHEN NO_DATA_FOUND
 DBMS_OUTPUT.PUT_LINE('NO HAY INFO');  
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('ERROR GENERAL');
END ACT_EXISTENCIAS;

/*
9.  Crea un programa que recibe los datos de un artículo. Este programa tiene las 
siguientes funcionalidades:
a.  Tiene un procedimiento local almacenado que recibe los datos del artículo y devuelve por 
pantalla su facturación.
b.  Tiene un procedimiento almacenado local que calcula el número de pedidos de ese artículo 
y lo muestra por pantalla.
c.  Finalmente el procedimiento principal realiza una llamada a cada uno de los 
procedimientos locales.
*/

/*
10. Crea un procedimiento que recibe el numero de un departamento y tiene los 
siguientes especificaciones:
a.  Función local que con el departamento nos devuelve el número de empleados.
b.  Función local que con el departamento nos devuelve el gasto en salario.
c.  El procedimiento realiza llamadas a las funciones locales y muestra el resultado 
por pantalla.
*/

/*
11. Crea un procedimiento con los siguientes especificaciones:
a.  Recibe un nombre de centro y especialidad.
b.  Tiene un procedimiento local que nos indica cuantos profesores hay con esa 
especialidad y en ese centro.
c.  Tiene una función local que nos devuelve el número de profesores en total con 
esa especialidad.
d.  El procedimiento principal realiza llamadas a ambos programas locales.
*/

/*
12. Crea un procedimiento que recibe los datos de un pedido con las siguientes identificaciones:
a.  Crea una función local que devuelve las Existencias de ese artículo.
b.  Si existencias es menor que unidades_pedidas, las unidades pedidas serán ½ de las e
xistencias (Parámetro de E/S).
c.  Inserta el pedido y actualiza las unidades pedidas.
d.  Se vuelve a llamar a la función para que muestre las existencias actuales.
*/

/*
13. Crea un procedimiento que recibe todos los datos de un pedido (Simétrico con ventas) 
que pedirá:
a.  Si en la llamada los recibe todos o no hará lo siguiente:
 i.  Si no recibe todos inserta un articulo.
 ii. Si recibe todos pregunta al usuario si quiere insertar un pedido o una venta.
 iii.  Una vez insertado, actualiza el stock del artículo. (Sólo si es pedido) y en la 
 tabla T_FABRICANTES suma las unidades pedidas totales de los artículos de ese fabricante.
 iv. Si es una venta en la tabla T_VENTAS incrementa las unidades vendidas de esa tienda.
T_FABRICANTES (cod_fabricante, nombre, cantidad)
T_VENTAS (Nif, Nombre, Cantidad)
*/