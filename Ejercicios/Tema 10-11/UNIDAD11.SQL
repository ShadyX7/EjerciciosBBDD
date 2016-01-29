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