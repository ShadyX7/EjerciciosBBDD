/* **********************************************************************
TEMA 11. TRIGGERS
************************************************************************* */
/*
Escribe un disparador que inserte en la tabla auditaremple(col1
(VARCHAR2(200)) cualquier cambio que supere el 5% del salario del
empleado indicando la fecha y hora, el empleado, y el salario anterior y
posterior.
*/

CREATE TABLE auditaremple(
  COL1 VARCHAR2 (200)
);

CREATE OR REPLACE TRIGGER audit_AUMENTO_SALAIO
BEFORE UPDATE OF SALARIO ON EMPLE
FOR EACH ROW
BEGIN
 IF(:NEW.SALARIO > :OLD.SALARIO * 1.05) THEN
  insert INTO auditaremple
   VALUES ('SUELDO AUMENTADO' || '*' ||:old.emp_no ||'*'
   ||:old.apellido || '*ANTERIOR.' ||:old.SALARIO|| '*NUEVO.' ||:NEW.SALARIO
   || '*FECHA.' ||TO_CHAR(SYSDATE, 'HH:MI DD/MM/YYYY'));
 END IF;
END audit_AUMENTO_SALAIO;


/*
Actividades complementarias
1. Escribe un disparador de base de datos que permita auditar las operaciones de inserción o borrado de
datos que se realicen en la tabla EMPLE según las siguientes especificaciones:
– Se creará desde SQL*Plus la tabla auditaremple con la columna col1 VARCHAR2(200).
– Cuando se produzca cualquier manipulación, se insertará una fila en dicha tabla que contendrá: fecha y
hora, número de empleado, apellido y la operación de actualización INSERCIÓN o BORRADO.
*/
--LA TABLA YA ESTÁ CREADA
CREATE OR REPLACE TRIGGER audit_CAMBIO_TABLA
BEFORE INSERT OR DELETE ON EMPLE
FOR EACH ROW
BEGIN
IF INSERTING THEN 
 insert INTO auditaremple
   VALUES (TO_CHAR(SYSDATE, 'HH:MI DD/MM/YYYY') || '*' ||:NEW.emp_no ||'*'
   ||:NEW.apellido || '*INSERCIÓN.');
END IF;
IF DELETING THEN 
 insert INTO auditaremple
   VALUES (TO_CHAR(SYSDATE, 'HH:MI DD/MM/YYYY') || '*' ||:OLD.emp_no ||'*'
   ||:OLD.apellido || '*BORRADO.');
END IF;
END audit_CAMBIO_TABLA;

/*
2. Escribe un trigger que permita auditar las modificaciones
en la tabla EMPLEADOS, insertando los siguientes
datos en la tabla auditaremple: fecha y hora, número de
empleado, apellido, la operación de actualización MODIFICACIÓN
y el valor anterior y el valor nuevo de cada
columna modificada (sólo en las columnas modificadas).
*/
CREATE OR REPLACE TRIGGER audit_CAMBIO_TABLA
BEFORE UPDATE ON EMPLE
FOR EACH ROW
DECLARE
 V_CAD_INSERT auditaremple.COL1%TYPE;
BEGIN
 V_CAD_INSERT := TO_CHAR(SYSDATE, 'HH:MI DD/MM/YYYY') || OLD.EMP_NO ||'* MODIFICACION *';
IF UPDATING('EMP_NO') THEN
 V_CAD_INSERT := V_CAD_INSERT
 || OLD.EMP_NO||'*'||:NEW.EMP_NO;
END IF;
IF UPDATING('APELLIDO') THEN
 V_CAD_INSERT := V_CAD_INSERT
 || OLD.APELLIDO||'*'||:NEW.APELLIDO;
END IF;
IF UPDATING('OFICIO') THEN
 V_CAD_INSERT := V_CAD_INSERT
 || OLD.OFICIO||'*'||:NEW.OFICIO;
END IF;
IF UPDATING('DIR') THEN
 V_CAD_INSERT := V_CAD_INSERT
 || OLD.DIR||'*'||:NEW.DIR;
END IF;

insert INTO auditaremple
   VALUES(V_CAD_INSERT);

END audit_CAMBIO_TABLA;

/*
3.Suponiendo que disponemos de la vista:
CREATE VIEW DEPARTAM AS
SELECT DEPART.DEPT_NO, DNOMBRE, LOC,
COUNT(EMP_NO) TOT_EMPLE
FROM EMPLE, DEPART
WHERE EMPLE.DEPT_NO (+) =
DEPART.DEPT_NO
GROUP BY DEPART.DEPT_NO, DNOMBRE, LOC;
Construye un disparador que permita realizar actualizaciones
en la tabla depart a partir de la vista departam,
de forma similar al ejemplo del trigger t_ges_emplead. Se
contemplarán las siguientes operaciones:
– Insertar y borrar departamento.
– Modificar la localidad de un departamento.
*/

/*
4.Escribe un paquete para gestionar los departamentos.
Se llamará gest_depart e incluirá, al menos, los
siguientes subprogramas:
– insertar_nuevo_depart: inserta un departamento
nuevo. Recibe el nombre y la localidad del nuevo
departamento. Creará el nuevo departamento comprobando
que el nombre no se duplique y le asignará
como número de departamento la decena siguiente al
último número de departamento utilizado.
– borrar_depart: borra un departamento. Recibirá dos
números de departamento: el primero corresponde
al departamento que queremos borrar y el segundo, al
departamento al que pasarán los empleados del departamento
que se va a eliminar. El procedimiento se
encargará de realizar los cambios oportunos en los
números de departamento de los empleados correspondientes.
– modificar_loc_depart: modifica la localidad del
departamento. Recibirá el número del departamento
que se modifica y la nueva localidad, y realizará el
cambio solicitado.
– visualizar_datos_depart: visualizará los datos de un
departamento cuyo número se pasará en la llamada.
Además de los datos relativos al departamento, se
visualizará el número de empleados que pertenecen
actualmente al departamento.
– visualizar_datos_depart: versión sobrecargada del
procedimiento anterior que, en lugar del número del
departamento, recibirá el nombre del departamento.
Realizará una llamada a la función buscar_depart_
por_nombre que se indica en el apartado siguiente.
– buscar_depart_por_nombre: función local al
paquete. Recibe el nombre de un departamento y
devuelve el número del mismo.
*/
/*
5. Crea un procedimiento que permita consultar todos los
datos de la tabla depart a partir de una condición que
se indicará en la llamada al procedimiento.
*/