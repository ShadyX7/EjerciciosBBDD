--Declaracion de variables.
--Para cada variable se debe especificar el tipo. No se puede, como en otros lenguajes, indicar
--una lista de variables del mismo tipo y, a continuación, el tipo. PL/SQL no lo permite.
DECLARE
importe NUMBER(8,2);
contador NUMBER(2,0) := 0;
nombre CHAR(20) NOT NULL := "MIGUEL";
BEGIN
end;

DECLARE
 Num1 NUMBER(8,2) := 0 --falta el punto y coma
 Num2 NUMBER(8,2) NOT NULL := 0; --nunca puede ser null
 Num3 NUMBER(8,2) NOT NULL; --Falta un valor
 Cantidad INTEGER(3); --PL/SQL dispone de subtipos de NUMBER que se utilizan por compatibilidad y/o 
 --para establecer restricciones. Son DECIMAL, NUMERIC, INTEGER, REAL, SMALLINT, etcétera.
 Precio, Descuento NUMBER(6); --no se puede declarar en grupo
 Num4 Num1%ROWTYPE; --siempre y cuando num1 fuera una tabla
 Dto CONSTANT INTEGER;
BEGIN
...
END;

/*Página 251*/

DECLARE
 v_empleado_no NUMBER(4,0); -- emple al que subir salario
 v_c_empleados NUMBER(2); -- cantidad empl dependen de él
 v_aumento NUMBER(7) DEFAULT 0; -- importe que vamos a aumentar.
 v_oficio VARCHAR2(10);
BEGIN
 v_empleado_no := &vt_empno; -- var de sustitución lee nºemple
 SELECT oficio INTO v_oficio FROM emple
  WHERE emp_no = v_empleado_no;
  IF v_oficio = 'PRESIDENTE' THEN -- alternativa simple
   v_aumento := 30;
  END IF;
 SELECT COUNT(*) into v_c_empleados FROM emple
  WHERE dir = v_empleado_no;
   IF v_c_empleados = 0 THEN -- alternativa múltiple
    v_aumento := v_aumento + 50;
   ELSIF v_c_empleados = 1 THEN
    v_aumento := v_aumento + 80;
   ELSIF v_c_empleados = 2 THEN
    v_aumento := v_aumento + 100;
   ELSE
    v_aumento := v_aumento + 110;
   END IF;
UPDATE emple SET salario = salario + v_aumento WHERE emp_no = v_empleado_no;
DBMS_OUTPUT.PUT_LINE(v_aumento);
END;
/


DECLARE
 v_apellidos VARCHAR2(25);
 v_1apel VARCHAR2(25);
 v_caracter CHAR;
 v_posicion INTEGER :=1;
BEGIN
 v_apellidos := '&vs_apellidos';
 v_caracter := SUBSTR(v_apellidos,v_posicion,1);
WHILE v_caracter BETWEEN 'A' AND 'Z' LOOP
 v_1apel := v_1apel || v_caracter;
 v_posicion := v_posicion + 1;
 v_caracter := SUBSTR(v_apellidos,v_posicion,1);
END LOOP;
DBMS_OUTPUT.PUT_LINE('1er Apellido:'||v_1apel||'*');
END;
/
/*
1. Escribe un procedimiento que reciba dos números y visualice su suma.
2. Codifica un procedimiento que reciba una cadena y la visualice al revés.
3. Reescribe el código de los dos ejercicios anteriores para convertirlos en funciones que retornen los valores
que mostraban los procedimientos.
4. Escribe una función que reciba una fecha y devuelva el año, en número, correspondiente a esa fecha.
5. Escribe un bloque PL/SQL que haga uso de la función anterior.
6. Desarrolla una función que devuelva el número de años completos que hay entre dos fechas que se pasan
como parámetros.
7. Escribe una función que, haciendo uso de la función anterior, devuelva los trienios que hay entre dos
fechas (un trienio son tres años).
8. Codifica un procedimiento que reciba una lista de hasta cinco números y visualice su suma.
9. Escribe una función que devuelva solamente caracteres alfabéticos sustituyendo cualquier otro carácter
por blancos a partir de una cadena que se pasará en la llamada.
10. Codifica un procedimiento que permita borrar un empleado cuyo número se pasará en la llamada.
11. Escribe un procedimiento que modifique la localidad de un departamento. El procedimiento recibirá como
parámetros el número del departamento y la nueva localidad.
12. Visualiza todos los procedimientos y funciones del usuario almacenados en la base de datos y su situación
(valid o invalid).
*/
--1.
CREATE OR REPLACE PROCEDURE SUMADOR(PRIMERO NUMBER, SEGUNDO NUMBER)
 AS
SUMA NUMBER(10);
BEGIN
 SUMA := PRIMERO + SEGUNDO;
 DBMS_OUTPUT.PUT_LINE('EL TOTAL ES:'||SUMA);
END;

--2.
CREATE OR REPLACE PROCEDURE REVES(PALABRA VARCHAR2)
AS
V_INVERSO VARCHAR(30);
v_posicion INTEGER :=1;
v_CARACTER CHAR;
BEGIN
v_CARACTER := SUBSTR(PALABRA ,v_posicion,1);
WHILE v_caracter BETWEEN 'A' AND 'z' LOOP
 v_INVERSO := v_CARACTER ||v_INVERSO;
 v_posicion := v_posicion + 1;
 v_CARACTER := SUBSTR(PALABRA ,v_posicion,1);
END LOOP;
 DBMS_OUTPUT.PUT_LINE('LA CADENA INVERSA ES:'||V_INVERSO);
END;
/

--3.
CREATE OR REPLACE FUNCTION SUMADOR_FUNCTION (PRIMERO NUMBER, SEGUNDO NUMBER)
RETURN INTEGER
AS
 V_SUMA NUMBER(10);
BEGIN
 V_SUMA := PRIMERO + SEGUNDO;
RETURN V_SUMA;
END SUMADOR_FUNCTION;

CREATE OR REPLACE FUNCTION REVES_FUNCTION (PALABRA VARCHAR2)
AS
V_INVERSO VARCHAR(30);
v_posicion INTEGER :=1;
v_CARACTER CHAR;
BEGIN
v_CARACTER := SUBSTR(PALABRA ,v_posicion,1);
WHILE v_caracter BETWEEN 'A' AND 'z' LOOP
 v_INVERSO := v_CARACTER ||v_INVERSO;
 v_posicion := v_posicion + 1;
 v_CARACTER := SUBSTR(PALABRA ,v_posicion,1);
END LOOP;
RETURN V_INVERSO;
END REVES_FUNCTION;

--4.
CREATE OR REPLACE FUNCTION ANIO(FECHA DATE)
RETURN NUMBER
AS 
V_ANIO NUMBER(4);
BEGIN
V_ANIO:=TO_NUMBER(TO_CHAR(FECHA, 'YYYY'));
RETURN V_ANIO;
END ANIO;

--5.
--BLOQUE DE SQL QUE UTILICE LA FUNCION ANTERIOR!!!
BEGIN DBMS_OUTPUT.PUT_LINE(ANIO(SYSDATE)); END;

/*6.Desarrolla una función que devuelva el número de años completos que hay entre dos fechas que se pasan
como parámetros.*/
CREATE OR REPLACE FUNCTION ANIOS(PRIMERO DATE, SEGUNDO DATE)
RETURN NUMBER
AS
V_ANIOS NUMBER(10);
BEGIN
V_ANIOS := TRUNC((MONTHS_BETWEEN(PRIMERO, SEGUNDO))/12);
-- V_ANIOS := TRUNC((SEGUNDO - PRIMERO)/365.25);
RETURN V_ANIOS;
END ANIOS;
/
BEGIN DBMS_OUTPUT.PUT_LINE(ANIOS(SYSDATE, '15/05/2010')); END;

/*7. Escribe una función que, haciendo uso de la función anterior, devuelva los trienios que hay entre dos
fechas (un trienio son tres años).*/
CREATE OR REPLACE FUNCTION TRIENIOS(PRIMERO DATE, SEGUNDO DATE)
RETURN NUMBER
AS
V_TRIENIOS NUMBER(10);
BEGIN
V_TRIENIOS := TRUNC(ANIOS(PRIMERO, SEGUNDO)/3);
RETURN V_TRIENIOS;
END TRIENIOS;
/
BEGIN DBMS_OUTPUT.PUT_LINE(TRIENIOS(SYSDATE, '15/05/2000')); END;

/*8. Codifica un procedimiento que reciba una lista de hasta cinco números y visualice su suma.*/
CREATE OR REPLACE PROCEDURE SUMANDO(N1 NUMBER DEFAULT 0, N2 NUMBER DEFAULT 0, N3 NUMBER DEFAULT 0, N4 NUMBER DEFAULT 0, N5 NUMBER DEFAULT 0)
AS
V_SUMA NUMBER(10);
BEGIN
 V_SUMA := N1 + N2 + N3 + N4 + N5;
 DBMS_OUTPUT.PUT_LINE(V_SUMA);
END;

--10.Codifica un procedimiento que permita borrar un empleado cuyo número se pasará en la llamada.
CREATE OR REPLACE PROCEDURE BORRANDO_EMPLE(NROEMPLE NUMBER)
AS
BEGIN
 DELETE FROM EMPLE
WHERE EMP_NO = NROEMPLE;
EXCEPTION
WHEN OTHERS THEN
 DBMS_OTUPUT.PUT_LINE('ERROR');
END BORRANDO_EMPLE; 
--11. Escribe un procedimiento que modifique la localidad de un departamento. El procedimiento recibirá
--como parámetros el número del departamento y la nueva localidad
CREATE OR REPLACE PROCEDURE CAMBIAR_LOCALIDAD(PDEPT NUMER, PLOC VARCHAR2)
AS
BEGIN
UPDATE DEPART SET LOC=PLOC WHERE DEPT_NO=PDEPT;
IF(SQL%ROWCOUNT=1) THEN
  DBMS_OTUPUT.PUT_LINE('DEPARTAMENTO MODIFICADO');
ELSE
  DBMS_OTUPUT.PUT_LINE('EL DEPARTAMENTO NO EXISTE');
END IF;
EXCEPTION
 WHEN OTHERS THEN
   DBMS_OTUPUT.PUT_LINE('ERROR');
END CAMBIAR_LOCALIDAD;
--12. Visualiza todos los procedimientos y funciones del usuario almacenados en la base de datos y su situacion(valid o invalid)

--Utiliza un bucle for para encontrar la suma de los n numero naturales, ingresado por parametro
CREATE OR REPLACE PROCEDURE SUMATORIAS(N NUMBER)
AS
 i INTEGER;
 V_TOTAL NUMBER(10) DEFAULT 0;
BEGIN
FOR i IN 1..N LOOP
V_TOTAL := V_TOTAL + i;
END LOOP;
 DBMS_OUTPUT.PUT_LINE(V_TOTAL);
END SUMATORIAS; 

BEGIN SUMATORIAS(10); END;

DECLARE
 r_cadena VARCHAR2(10);
 BEGIN
 FOR i IN REVERSE 1..LENGTH('HOLA') LOOP
  r_cadena := r_cadena||SUBSTR('HOLA',i,1);
 END LOOP;
 DBMS_OUTPUT.PUT_LINE(r_cadena);
END;

DECLARE
 r_cadena VARCHAR2(10);
 i BINARY_INTEGER;
 BEGIN
 i := LENGTH('HOLA');
 WHILE i >= 1 LOOP
 r_cadena:=r_cadena||SUBSTR('HOLA',i,1);
 i := i - 1;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE(r_cadena);
 END;

CREATE OR REPLACE PROCEDURE SUMATORIA_FRAC(N NUMBER)
AS
 i INTEGER;
 V_TOTAL NUMBER(30,20);
 V_FRACCION NUMBER(30,20);
BEGIN
V_TOTAL := 0;
V_FRACCION :=0;
FOR i IN 1..N LOOP
 V_FRACCION := 1/ (i * i);
 V_TOTAL := V_TOTAL + V_FRACCION;
 DBMS_OUTPUT.PUT_LINE(V_TOTAL);
END LOOP;
 DBMS_OUTPUT.PUT_LINE(V_TOTAL);
END SUMATORIA_FRAC;

BEGIN SUMATORIA_FRAC(10); END;
