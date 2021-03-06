CREATE OR REPLACE PROCEDURE EJERCICIO_3
AS
CURSOR C1 IS SELECT APELLIDO, SALARIO FROM EMPLE ORDER BY SALARIO DESC;
I NUMBER(2);
BEGIN
I:=1;
FOR V_REG IN C1 LOOP
DBMS_OUTPUT.PUT_LINE(RPAD(V_REG.APELLIDO,15)||' '||V_REG.SALARIO);
I:=I+1;
EXIT WHEN I > 5;
END LOOP;
END EJERCICIO_3;
-----------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE EJERCICIO_4
AS
CURSOR C1 IS SELECT APELLIDO, OFICIO, SALARIO FROM EMPLE ORDER BY OFICIO, SALARIO;
OFI EMPLE.OFICIO%TYPE;
I NUMBER(2); 
BEGIN
I:=1;
OFI:='*';

FOR V_REG IN C1 LOOP

IF (V_REG.OFICIO <> OFI) THEN 
OFI := V_REG.OFICIO;
I:=1;
END IF;

IF I <=2 THEN 
DBMS_OUTPUT.PUT_LINE(RPAD(V_REG.APELLIDO,15)||' '||RPAD(V_REG.OFICIO,15)||' '||V_REG.SALARIO);
I:=I+1;
END IF;

END LOOP;

END EJERCICIO_4;

BEGIN EJERCICIO_4; END;
--------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE EJERCICIO_4_B
AS
CURSOR C1 IS SELECT DISTINCT OFICIO FROM EMPLE ORDER BY OFICIO;
CURSOR C2(OFI VARCHAR2) IS SELECT APELLIDO, OFICIO, SALARIO FROM EMPLE WHERE OFICIO=OFI
 ORDER BY SALARIO; 

BEGIN
FOR V_REG1 IN C1 LOOP
 
 FOR V_REG2 IN C2(V_REG1.OFICIO) LOOP

   DBMS_OUTPUT.PUT_LINE(RPAD(V_REG2.APELLIDO,15)||' '||RPAD(V_REG2.OFICIO,15)||' '||V_REG2.SALARIO);
   EXIT WHEN C2%ROWCOUNT=2;

 END LOOP;

END LOOP;

END EJERCICIO_4_B;

BEGIN EJERCICIO_4_B; END;
----------------------------------------------------------------------------------------------------------------------------------
5.-

Desarrolla un procedimiento que permita insertar nuevos departamentos seg�n las siguientes especificaciones:
� Se pasar� al procedimiento el nombre del departamento y la localidad.
� El procedimiento insertar� la fila nueva asignando como n�mero de departamento la decena siguiente al n�mero mayor de la tabla.
� Se incluir� la gesti�n de posibles errores.

 

CREATE OR REPLACE PROCEDURE EJERC_10_5(P_NOM VARCHAR2, P_LOC VARCHAR2)
AS
V_DEPT_NO DEPART.DEPT_NO%TYPE;
BEGIN
SELECT TRUNC(MAX(DEPT_NO),-1)+10 INTO V_DEPT_NO FROM DEPART;

INSERT INTO DEPART VALUES (V_DEPT_NO, P_NOM, P_LOC);

EXCEPTION

WHEN OTHERS THEN

DBMS_OUTPUT.PUT_LINE('ERROR GENERAL');
END EJERC_10_5;


-------------------------------------------------------------------------------------------------------------------------
6.- Codifica un procedimiento que reciba como par�metros un n�mero de departamento, un importe y un porcentaje;
y que suba el salario a todos los empleados del departamento indicado en la llamada. La subida ser� el porcentaje 
o el importe que se indica en la llamada (el que sea m�s beneficioso para el empleado en cada caso).


CREATE OR REPLACE PROCEDURE EJERCICIO_1O_6 (P_DEPT_NO NUMBER, P_IMPORTE NUMBER, P_PCT NUMBER)
AS
V_INC NUMBER(6,2);
V_PCT NUMBER(6,2);
CURSOR C1 IS SELECT EMP_NO, APELLIDO, OFICIO, SALARIO, DEPT_NO FROM EMPLE 
WHERE DEPT_NO=P_DEPT_NO FOR UPDATE;
BEGIN

FOR V_REG IN C1 LOOP
V_PCT:= V_REG.SALARIO*(P_PCT/100);
V_INC:= GREATEST(V_PCT,P_IMPORTE);
UPDATE EMPLE SET SALARIO=SALARIO + V_INC WHERE CURRENT OF C1;
END LOOP;

EXCEPTION

WHEN OTHERS THEN 
 DBMS_OUTPUT.PUT_LINE('ERROR');

END EJERCICIO_1O_6;


-- CON ROWID

CREATE OR REPLACE PROCEDURE EJERCICIO_1O_6 (P_DEPT_NO NUMBER, P_IMPORTE NUMBER, P_PCT NUMBER)
AS
V_INC NUMBER(6,2);
V_PCT NUMBER(6,2);
CURSOR C1 IS SELECT ROWID, EMP_NO, APELLIDO, OFICIO, SALARIO, DEPT_NO 
FROM EMPLE WHERE DEPT_NO=P_DEPT_NO;
BEGIN

FOR V_REG IN C1 LOOP
V_PCT:= V_REG.SALARIO*(P_PCT/100);
V_INC:= GREATEST(V_PCT,P_IMPORTE);
UPDATE EMPLE SET SALARIO=SALARIO + V_INC WHERE ROWID=V_REG.ROWID;
END LOOP;

EXCEPTION

WHEN OTHERS THEN 
 DBMS_OUTPUT.PUT_LINE('ERROR');

END EJERCICIO_1O_6;
-----------------------------------------------------------------------------------------------------------------------
7.- Escribe un procedimiento que suba el sueldo de todos los empleados que ganen menos que el salario medio de su oficio. 
La subida ser� del 50 por 100 de la diferencia entre el salario del empleado y la media de su oficio. Se deber� hacer 
que la transacci�n no se quede a medias, y se gestionar�n los posibles errores.

CREATE OR REPLACE PROCEDURE EJERCICIO_10_7
AS
V_INC NUMBER(6,2);
V_SAL_MEDIO NUMBER(6,2);
CURSOR C1 IS SELECT ROWID, EMP_NO, APELLIDO, OFICIO, SALARIO, DEPT_NO FROM EMPLE E 
WHERE SALARIO < (SELECT AVG(SALARIO) FROM EMPLE WHERE OFICIO=E.OFICIO);
BEGIN
FOR V_REG IN C1 LOOP
SELECT AVG(SALARIO) INTO V_SAL_MEDIO FROM EMPLE WHERE OFICIO=V_REG.OFICIO;
UPDATE EMPLE SET SALARIO = SALARIO + (V_SAL_MEDIO - SALARIO)/2 WHERE ROWID=V_REG.ROWID;
END LOOP;
EXCEPTION
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('ERROR');
END EJERCICIO_10_7;

BEGIN EJERCICIO_10_7; END;


-----------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE EJERCICIO_10_8
AS
CURSOR C1 IS SELECT EMP_NO, APELLIDO, FECHA_ALT, OFICIO, SALARIO, NVL(COMISION,0) COM, DEPT_NO FROM EMPLE ORDER BY APELLIDO;
V_TRIENIOS NUMBER(3);
V_COMPLEMENTO NUMBER(6,2);
V_TOTAL NUMBER(6,2);
BEGIN
FOR V_REG IN C1 LOOP
SELECT TRUNC((TO_CHAR(SYSDATE,'YYYY')-TO_CHAR(FECHA_ALT,'YYYY'))/365/3)*50 INTO V_TRIENIOS FROM EMPLE E WHERE EMP_NO=v_reg.EMP_NO;
SELECT COUNT(*) INTO V_COMPLEMENTO FROM EMPLE E WHERE DIR=V_REG.EMP_NO;
V_COMPLEMENTO:=V_COMPLEMENTO*100;
V_TOTAL:=V_REG.SALARIO+V_REG.COM+V_TRIENIOS+V_COMPLEMENTO;
DBMS_OUTPUT.PUT_LINE('*************************************');
DBMS_OUTPUT.PUT_LINE(RPAD('Liquidacion del empleado:',35)||V_REG.APELLIDO);
DBMS_OUTPUT.PUT_LINE(RPAD('Departamento:',35)||V_REG.DEPT_NO);
DBMS_OUTPUT.PUT_LINE(RPAD('Oficio:',35)||V_REG.OFICIO);
DBMS_OUTPUT.PUT_LINE(RPAD('Salario:',35)||V_REG.SALARIO);
DBMS_OUTPUT.PUT_LINE(RPAD('Trienios:',35)||V_TRIENIOS);
DBMS_OUTPUT.PUT_LINE(RPAD('Complemento de responsabilidad:',35)||V_COMPLEMENTO);
DBMS_OUTPUT.PUT_LINE(RPAD('Comision:',35)||V_REG.COM);
DBMS_OUTPUT.PUT_LINE('*************************************');
DBMS_OUTPUT.PUT_LINE(RPAD('Total a liquidar:',35)||V_TOTAL);
DBMS_OUTPUT.PUT_LINE('*************************************');
END LOOP;
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Error General');
END EJERCICIO_10_8;







