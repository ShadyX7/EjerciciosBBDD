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

