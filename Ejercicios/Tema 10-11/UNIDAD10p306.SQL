/* 
1. Desarrolla un procedimiento que visualice el apellido
y la fecha de alta de todos los empleados ordenados
por apellido.*/


/*
2. Codifica un procedimiento que muestre el nombre de
cada departamento y el número de empleados que tiene.*/

/*
3. Escribe un programa que visualice el apellido y el salario
de los cinco empleados que tienen el salario más alto.*/
CREATE OR REPLACE PROCEDURE MAYORES_SALARIOS(CUANTOS NUMBER)
AS 
 CURSOR MI_CURSOR IS
  SELECT APELLIDO, SALARIO, DEPT_NO FROM EMPLE ORDER BY SALARIO DESC;
 v_DATOS MI_CURSOR%ROWTYPE;
 BEGIN
  OPEN MI_CURSOR;
  FETCH MI_CURSOR INTO v_DATOS;
FOR i IN 1..CUANTOS LOOP
  DBMS_OUTPUT.PUT_LINE(v_DATOS.APELLIDO||' '||v_DATOS.SALARIO||' '||v_DATOS.DEPT_NO);
  FETCH MI_CURSOR INTO v_DATOS;
END LOOP;
END MAYORES_SALARIOS;

BEGIN MAYORES_SALARIOS(4); END;

CREATE OR REPLACE PROCEDURE MAYORES_SALARIOS(CUANTOS NUMBER)
AS 
 CURSOR MI_CURSOR IS
  SELECT APELLIDO, SALARIO, DEPT_NO FROM EMPLE ORDER BY SALARIO DESC;
 v_reg MI_CURSOR%ROWTYPE;
 BEGIN
FOR v_reg IN MI_CURSOR LOOP
  DBMS_OUTPUT.PUT_LINE(v_reg.APELLIDO||' '||v_reg.SALARIO||' '||v_reg.DEPT_NO);
  EXIT WHEN MI_CURSOR%ROWCOUNT = CUANTOS;
END LOOP;
END MAYORES_SALARIOS;

/*
4. Codifica un programa que visualice los dos empleados que ganan menos de cada oficio.*/


CREATE OR REPLACE PROCEDURE MENORES_POR_OF
AS 
 CURSOR MI_CURSOR IS
  SELECT APELLIDO, OFICIO, SALARIO FROM EMPLE ORDER BY OFICIO, SALARIO;
 v_reg MI_CURSOR%ROWTYPE;
 V_OFICIO v_reg.OFICIO%TYPE;
 CONTADOR NUMBER(2);
 BEGIN
CONTADOR := 0;
 FOR v_reg IN MI_CURSOR LOOP
    IF V_OFICIO = v_reg.OFICIO THEN
  	  CONTADOR := CONTADOR + 1;
    ELSE
      CONTADOR := 0;
    END IF;
   V_OFICIO := v_reg.OFICIO;
  IF CONTADOR<2 THEN
    DBMS_OUTPUT.PUT_LINE(v_reg.APELLIDO||' '||v_reg.SALARIO||' '||v_reg.OFICIO);
  END IF;
 END LOOP;
END MENORES_POR_OF;

BEGIN MENORES_POR_OF; END;

/*VERSION DEL PROFESOR*/
CREATE OR REPLACE PROCEDURE MENORES_POR_OF
AS 
 CURSOR MI_CURSOR IS
  SELECT APELLIDO, OFICIO, SALARIO FROM EMPLE ORDER BY OFICIO, SALARIO;
 v_reg MI_CURSOR%ROWTYPE;
 V_OFICIO v_reg.OFICIO%TYPE;
 CONTADOR NUMBER(2);
 BEGIN
CONTADOR := 1;
V_OFICIO := '*';

 FOR v_reg IN MI_CURSOR LOOP
    IF (V_OFICIO <> v_reg.OFICIO) THEN
      V_OFICIO := v_reg.OFICIO;
      CONTADOR := 0;
    END IF;
   
  IF CONTADOR<=2 THEN
    DBMS_OUTPUT.PUT_LINE(RPAD(v_reg.APELLIDO, 15)||' '||RPAD(v_reg.SALARIO,15)||' '||RPAD(v_reg.OFICIO,15));
    CONTADOR := CONTADOR + 1;
  END IF;
 END LOOP;
END MENORES_POR_OF;

/*EJEMPLO DEL PROFESOR*/
CREATE OR REPLACE PROCEDURE MUESTRA_SUELDOS
AS
 CURSOR C1 IS SELECT DISTINCT OFICIO FROM EMPLE ORDER BY OFICIO;
 CURSOR C2(OFI VARCHAR2) IS SELECT APELLIDO, OFICIO, SALARIO FROM EMPLE WHERE OFICIO=OFI
 ORDER BY SALARIO;

BEGIN
FOR V_REG1 IN C1 LOOP
 FOR V_REG2 IN C2 (V_REG1.OFICIO) LOOP
  DBMS_OUTPUT.PUT_LINE(RPAD(V_REG2.APELLIDO, 15)||' '||RPAD(V_REG2.SALARIO,15)||' '||RPAD(V_REG2.OFICIO,15));
  EXIT WHEN C2%ROWCOUNT=2;
 END LOOP;
END LOOP;
END MUESTRA_SUELDOS;

BEGIN MUESTRA_SUELDOS; END;

/*
5. Desarrolla un procedimiento que permita insertar nuevos
departamentos según las siguientes especificaciones:
 – Se pasará al procedimiento el nombre del departamento y la localidad.
 – El procedimiento insertará la fila nueva asignando como número de 
  departamento la decena siguiente al número mayor de la tabla.
 – Se incluirá la gestión de posibles errores.*/
CREATE OR REPLACE PROCEDURE INS_DEPT(NOMBRE VARCHAR2, LOCALIDAD VARCHAR2)
AS
BEGIN
  INSERT INTO DEPART
	VALUES((SELECT TRUNC(MAX(DEPT_NO),-1)+10 FROM DEPART), NOMBRE, LOCALIDAD);
	--EL -1 DEL TRUNC ES PARA LA DECENA
EXCEPTION
WHEN OTHERS
DBMS_OUTPUT.PUT_LINE('ERROR GENERAL');
END INS_DEPT;

BEGIN INS_DEPT('LOGIS', 'ROMA'); END;

/*
6. Codifica un procedimiento que reciba como parámetros
un número de departamento, un importe y un porcentaje;
y que suba el salario a todos los empleados
del departamento indicado en la llamada. La subida
será el porcentaje o el importe que se indica en la llamada
(el que sea más beneficioso para el empleado en
cada caso).
*/

CREATE OR REPLACE PROCEDURE subir_salario_dpto2( vp_num_dpto NUMBER, vp_pct_subida NUMBER, vp_import NUMBER)
AS
 CURSOR c_emple IS SELECT oficio, salario 
  FROM emple WHERE dept_no = vp_num_dpto FOR UPDATE; --FOR UPDATE

 vc_reg_emple c_emple%ROWTYPE;
 v_inc NUMBER(8,2);
BEGIN
 OPEN c_emple;
 FETCH c_emple INTO vc_reg_emple;
 WHILE c_emple%FOUND LOOP
  IF(((vc_reg_emple.salario / 100) * vp_pct_subida) > vp_import )
  v_inc := (vc_reg_emple.salario / 100) * vp_pct_subida;
  ELSE
  v_inc := vp_import;
  END IF;
  UPDATE emple SET salario = salario + v_inc WHERE CURRENT OF c_emple; -- (al actual)
  FETCH c_emple INTO vc_reg_emple;
END LOOP;
END subir_salario_dpto2;

--VERSION DEL PROFESOR
CREATE OR REPLACE PROCEDURE EJERCICIO_10_6(P_DEPT_NO NUMBER, P_IMPORTE NUMBER, P_PCT NUMBER)
AS
V_INC NUMBER(6,2);
V_PCT NUMBER(6,2);

CURSOR C1 IS SELECT EMP_NO, APELLIDO, OFICIO, SALARIO, DEPT_NO FROM EMPLE WHERE
DEPT_NO = P_DEPT_NO FOR UPDATE;

BEGIN
FOR V_REG IN C1 LOOP
 V_PCT := V_REG.SALARIO * (P_PCT/100);
 V_INC := GREATEST(V_PCT, P_IMPORTE);
 UPDATE EMPLE SET SALARIO=SALARIO + V_INC WHERE CURRENT OF C1;
END LOOP;

EXCEPTION
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('ERROR');
END EJERCICIO_10_6;



-- CON ROWID
CREATE OR REPLACE PROCEDURE EJERCICIO_10_6ROW(P_DEPT_NO NUMBER, P_IMPORTE NUMBER, P_PCT NUMBER)
AS
V_INC NUMBER(6,2);
V_PCT NUMBER(6,2);

CURSOR C1 IS SELECT EMP_NO, APELLIDO, OFICIO, SALARIO, DEPT_NO, ROWID FROM EMPLE WHERE
DEPT_NO = P_DEPT_NO;

BEGIN
FOR V_REG IN C1 LOOP
 V_PCT := V_REG.SALARIO * (P_PCT/100);
 V_INC := GREATEST(V_PCT, P_IMPORTE);
 UPDATE EMPLE SET SALARIO=SALARIO + V_INC WHERE ROWID = V_REG.ROWID;
END LOOP;

EXCEPTION
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('ERROR');
END EJERCICIO_10_6ROW;



/*
7. Escribe un procedimiento que suba el sueldo de todos
los empleados que ganen menos que el salario medio
de su oficio. La subida será del 50 por 100 de la diferencia
entre el salario del empleado y la media de su
oficio. Se deberá hacer que la transacción no se quede
a medias, y se gestionarán los posibles errores.
*/
CREATE OR REPLACE PROCEDURE SUBESUELDOS
AS 
 CURSOR MIS_EMPLES IS 
  SELECT EMP_NO, APELLIDO, OFICIO, SALARIO, (SELECT AVG(SALARIO) FROM EMPLE 
  	WHERE E.OFICIO = OFICIO) MEDIA FROM EMPLE E WHERE SALARIO < 
  		(SELECT AVG(SALARIO) FROM EMPLE WHERE OFICIO = E.OFICIO) FOR UPDATE;
 
 V_CADA_EMPLE MIS_EMPLES%ROWTYPE;
 V_INC NUMBER(8,2);

 BEGIN 
  OPEN MIS_EMPLES;
  FETCH MIS_EMPLES INTO V_CADA_EMPLE;
  WHILE MIS_EMPLES%FOUND LOOP
    V_INC := (V_CADA_EMPLE.MEDIA - V_CADA_EMPLE.SALARIO) * 0.5;
    UPDATE EMPLE SET SALARIO = SALARIO + V_INC WHERE CURRENT OF MIS_EMPLES;
    FETCH MIS_EMPLES INTO V_CADA_EMPLE;
  END LOOP;
 END SUBESUELDOS;

BEGIN SUBESUELDOS; END;


/*
8. Diseña una aplicación que simule un listado de liquidación
de los empleados según las siguientes especificaciones:
– El listado tendrá el siguiente formato para cada
empleado:
**********************************
Liquidación del empleado : (1)
Dpto : (2)
Oficio : (3)
Salario : (4)
Trienios : (5)
Comp. responsabilidad : (6)
Comisión : (7)
**********************************
Total : (8)
**********************************
Donde:
– 1, 2, 3 y 4 corresponden a apellido, departamento,
oficio y salario del empleado.
– 5 es el importe en concepto de trienios. Un trienio
son tres años completos, desde la fecha de alta hasta
la de emisión, y supone 50 €.
– 6 es el complemento por responsabilidad. Será de 100 €
por cada empleado que se encuentre directamente a
cargo del empleado en cuestión.
– 7 es la comisión. Los valores nulos serán sustituidos
por ceros.
– 8 es la suma de todos los conceptos anteriores.
El listado irá ordenado por Apellido.
*/

CREATE OR REPLACE PROCEDURE LISTA_LIQUI
AS
 CURSOR MIS_EMPLES IS
 	SELECT EMP_NO, APELLIDO, (SELECT DNOMBRE FROM DEPART WHERE DEPT_NO = E.DEPT_NO) DEPARTAMENTO, 
 	 OFICIO, SALARIO, FECHA_ALT, COMISION, (SELECT COUNT(*) FROM EMPLE WHERE E.EMP_NO = DIR)RESPONSABLE_DE
 	 FROM EMPLE E;
V_TRIENIO NUMBER(6,2);
V_RESPONSA NUMBER(6);
V_COMISION NUMBER(4);
V_TOTAL NUMBER(6); 

BEGIN
FOR V_CADA_EMPLE IN MIS_EMPLES LOOP
 --CALCULOS
 V_TRIENIO := (TRUNC((SYSDATE - V_CADA_EMPLE.FECHA_ALT) / 365.25))* 50;
 V_RESPONSA := 100 * V_CADA_EMPLE.RESPONSABLE_DE;
 V_COMISION := NVL(V_CADA_EMPLE.COMISION, 0);
 V_TOTAL := V_CADA_EMPLE.SALARIO + V_COMISION + V_RESPONSA + V_TRIENIO;
 DBMS_OUTPUT.PUT_LINE('*****************************************');
 DBMS_OUTPUT.PUT_LINE(RPAD('LIQUIDACION DE EMPLEADO', 25, ' ')||LPAD(V_CADA_EMPLE.APELLIDO, 15, ' '));
 DBMS_OUTPUT.PUT_LINE(RPAD('DEPTO', 25, '.')||LPAD(V_CADA_EMPLE.DEPARTAMENTO, 15, '.'));
 DBMS_OUTPUT.PUT_LINE(RPAD('OFICIO', 25, '.')||LPAD(V_CADA_EMPLE.OFICIO, 15, '.'));
 DBMS_OUTPUT.PUT_LINE(RPAD('SALARIO', 25, '.')||LPAD(V_CADA_EMPLE.SALARIO, 15, '.'));
 DBMS_OUTPUT.PUT_LINE(RPAD('ANTIGÜEDAD', 25, '.')||LPAD(V_TRIENIO, 15, '.'));
 DBMS_OUTPUT.PUT_LINE(RPAD('RESPONSABILIDAD', 25, '.')||LPAD(V_RESPONSA, 15, '.'));
 DBMS_OUTPUT.PUT_LINE(RPAD('COMISION', 25, '.')||LPAD(V_COMISION, 15, '.'));
 DBMS_OUTPUT.PUT_LINE('*****************************************');
 DBMS_OUTPUT.PUT_LINE(RPAD('TOTAL', 25, '.')||LPAD(V_TOTAL, 15, '.'));
 DBMS_OUTPUT.PUT_LINE('*****************************************');
 DBMS_OUTPUT.PUT_LINE(' ');
END LOOP;

EXCEPTION
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('ERROR');
END LISTA_LIQUI;


BEGIN LISTA_LIQUI; END;



/*
9. Crea la tabla T_liquidacion con las columnas apellido, departamento, oficio, salario, trienios, 
comp_responsabilidad, comisión y total; y modifica la aplicación anterior para que, en lugar de 
realizar el listado directamente en pantalla, guarde los datos en la tabla. Se controlarán todas 
las posibles incidencias que puedan ocurrir durante el proceso.
*/
--LA TABLA HAY QUE CREARLA PRIMERO, Y LUEGO METER LOS DATOS.
drop table T_liquidacion;
CREATE TABLE  T_liquidacion
( APELLIDO VARCHAR2(30) NOT NULL , 
  DEPARTAMENTO VARCHAR2(30) NOT NULL, 
  OFICIO VARCHAR2(30) NOT NULL, 
  SALARIO NUMBER(8,2) NOT NULL, 
  TRIENIOS NUMBER(8,2) NOT NULL, 
  comp_responsabilidad NUMBER(8,2) NOT NULL, 
  COMISION NUMBER(8,2) NOT NULL, 
  TOTAL NUMBER(8,2) NOT NULL );

CREATE OR REPLACE PROCEDURE tabla_LIQUI
AS
 CURSOR MIS_EMPLES IS
  SELECT EMP_NO, APELLIDO, (SELECT DNOMBRE FROM DEPART WHERE DEPT_NO = E.DEPT_NO) DEPARTAMENTO, 
   OFICIO, SALARIO, FECHA_ALT, COMISION, (SELECT COUNT(*) FROM EMPLE WHERE E.EMP_NO = DIR)RESPONSABLE_DE
   FROM EMPLE E;
V_TRIENIO NUMBER(6,2);
V_RESPONSA NUMBER(6);
V_COMISION NUMBER(4);
V_TOTAL NUMBER(6); 

BEGIN

FOR V_CADA_EMPLE IN MIS_EMPLES LOOP
 --CALCULOS
 V_TRIENIO := (TRUNC((SYSDATE - V_CADA_EMPLE.FECHA_ALT) / 365.25))* 50;
 V_RESPONSA := 100 * V_CADA_EMPLE.RESPONSABLE_DE;
 V_COMISION := NVL(V_CADA_EMPLE.COMISION, 0);
 V_TOTAL := V_CADA_EMPLE.SALARIO + V_COMISION + V_RESPONSA + V_TRIENIO;
 
 INSERT INTO T_liquidacion
  VALUES(V_CADA_EMPLE.APELLIDO,V_CADA_EMPLE.DEPARTAMENTO, V_CADA_EMPLE.OFICIO, V_CADA_EMPLE.SALARIO,
    V_TRIENIO, V_RESPONSA, V_COMISION, V_TOTAL);

END LOOP;

EXCEPTION
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('ERROR');
END tabla_LIQUI;


BEGIN tabla_LIQUI; END;

/*
10. Escribe un programa para introducir nuevos pedidos según las siguientes especificaciones:
– Recibirá como parámetros PEDIDO_NO, PRODUCTO_NO, CLIENTE_NO, UNIDADES y la FECHA_PEDIDO (opcional,
por defecto la del sistema). Verificará todos estos datos así como las unidades disponibles del
producto y el límite de crédito del cliente y fallará enviado un mensaje de error en caso de que alguno
sea erróneo.
– Insertará el pedido y actualizará la columna DEBE de clientes incrementándola el valor del pedido 
(UNIDADES * PRECIO_ACTUAL). También actualizará las unidades disponibles del producto e incrementará la
comisión para el empleado correspondiente al cliente en un 5% del valor total del pedido. Todas
estas operaciones se realizarán como una única transacción.
*/
CREATE OR REPLACE PROCEDURE NUEVOS_PEDIDOS(PEDIDO_NO, PRODUCTO_NO, CLIENTE_NO, UNIDADES, 
  FECHA_PEDIDO DATE DEFAULT SYSDATE)