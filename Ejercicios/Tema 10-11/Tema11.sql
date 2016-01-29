1.	Crea una vista que contenga los siguientes campos
a.	Emple: Emp_no, Apellido, Oficio, Salario.
b.	Depart: Dnombre, Dept_no.

CREATE VIEW VISTAR1 AS
SELECT EMP_NO, APELLIDO, OFICIO, SALARIO, DNOMBRE, DEPART.DEPT_NO FROM EMPLE JOIN DEPART ON (EMPLE.DEPT_NO  = DEPART.DEPT_NO)

Después crea un trigger de sustitución que gestione las operaciones de actualización, inserción y borrado del siguiente modo:
c.	Se insertan datos solamente en la tabla emple, de tal modo que cuando se detecta un insert toma los datos de la sentencia e inserta en la tabla emple los datos necesarios (Emp_no, Apellido, Oficio, Salario, Dept_no)
d.	Se actualizan datos solamente de la tabla emple. Si se detecta una actualización  sólo actualiza la información de la tabla emple, pudiendo cambiar al empleado de departamento.
e.	Se eliminan datos de la tabla emple. Si existe una eliminación de registros  se eliminan los registros de emple, pero no de Depart. (Analiza que sucede si eliminamos el/los registro/s de Depart.

CREATE OR REPLACE TRIGGER EJERR1
INSTEAD OF INSERT OR UPDATE OR DELETE ON VISTAR1
FOR EACH ROW

DECLARE

BEGIN
   IF INSERTING THEN 
      INSERT INTO EMPLE (EMP_NO, APELLIDO, OFICIO, SALARIO, DEPT_NO) VALUES (:NEW.EMP_NO, :NEW.APELLIDO, :NEW.OFICIO, :NEW.SALARIO, :NEW.DEPT_NO);
   ELSIF DELETING THEN 
      DELETE FROM EMPLE WHERE EMP_NO = :OLD.EMP_NO;
   ELSIF UPDATING THEN
      UPDATE EMPLE SET EMP_NO = :NEW.EMP_NO, APELLIDO = :NEW.APELLIDO, OFICIO = :NEW.OFICIO, SALARIO = :NEW.SALARIO, DEPT_NO = :NEW.DEPT_NO WHERE EMP_NO = :OLD.EMP_NO;
   ELSE
      RAISE_APPLICATION_ERROR(-20001,'ERROR');
   END IF;

END EJERR1;

2.	Crea una vista que contenga la información siguiente: 
a.	Artículos: Artículo, Cod_fabricante, Peso, Categoría, Existencias.
b.	Pedidos: Fecha_pedido, Nif, Unidades_pedidas.



Posteriormente crea un trigger de sustitución que realice las siguientes operaciones:
c.	Se insertan datos en la tabla pedidos (no dejando insertar artículos nuevos), con una fecha_pedido, el nif de la tienda y unidades_pedidas.
d.	Se actualizan solo los datos de la tabla Pedidos (Nif, Fecha_pedido, Unidades_pedidas).
e.	Se eliminan datos de la tabla Pedidos.





3.	Crea una vista que muestre la siguiente información: 
a.	Artículos: Artículo, Cod_fabricante, Peso, Categoría, Existencias.
b.	Ventas: Fecha_venta, nif, unidades_vendidas.
c.	Fabricantes: Nombre, País.

Ahora crea un trigger que administre las modificaciones sobre los datos mostrados de esta vista del siguiente modo:
d.	Se insertan datos en la tabla Ventas (se crean nuevas ventas).
e.	Si se inserta un articulo que no existe 
1.	Se da de alta el articulo (articulo, cod_fabricante, peso, categoría) en la tabla Artículos (Obs: el fabricante debe existir previamente)
2.	Se da de alta la venta asociándola el artículo recientemente creado.
f.	Si actualizamos dato sólo se actualizarán de la tabla Ventas (o fecha_venta, Nif, unidades_vendidas).
g.	Si eliminamos datos, igualmente sólo de la tabla Ventas. De este modo estamos eliminando la venta que pasamos en la orden DELETE y no otra
1.	Observación: No servirá solo con pasar en la orden DELETE la clave ajena de la tabla Ventas.


4.	Crea un paquete que gestione todas las operaciones sobre la tabla CENTROS con los siguientes procedimientos:

a.	INSERTAR_CENTRO: Controla que no se repite el nº de centro cuando pasamos el nº  de centro y el nombre como parámetro. Además controla que siempre se inserta en mayúsculas el nombre.
b.	BORRAR_CENTRO: elimina el centro que pasamos como parámetro, pero 1º crea un centro auxiliar del formato: AUX_NOMBRE_CENTRO_ELIMINADO, y con nº la decena mayor que se encuentre, y pasa aquí sus registros subordinados de cualquier tabla (Personal y Profesores). Después elimina el centro pasado como parámetro.
c.	MODIFICA_CENTRO: Modifica el nombre del centro o cualquier otro atributo excepto el COD_CENTRO.


5.	Crea un paquete que realiza las siguientes gestiones sobre la tabla ARTICULOS:
a.	Observación: Necesitamos crear las 3 tablas siguientes:
1.	H_ARTICULOS: Igual que la tabla Artículos, pero vacía.
2.	H_PEDIDOS: Igual que la tabla Pedidos.
3.	H_VENTAS: Igual que la tabla ventas.
b.	ELIMINAR_ARTICULO: Elimina el articulo que pasamos como parámetro (articulo, cod_fabricante, peso, categoría), pero previamente copia este registro en la tabla H_ARTICULOS, y posteriormente pasa a las tablas H_PEDIDOS y H_VENTAS todos sus pedidos y ventas respectivamente. Una vez realizado todo esto podemos eliminar el artículo.
c.	CREAR_ARTICULO: Pasamos todos los parámetros comprobando que son correctos y teniendo en cuenta incidencias del tipo como que no puede ser menor el precio de venta que el precio de coste.
d.	MODIFICAR_ARTICULO: Cambiamos sólo los campos no pertenecientes a la PK  precio venta, precio coste, unidades. Pasamos como parámetro la PK del articulo y los valores a cambiar.

CREATE TABLE H_ARTICULOS AS SELECT * FROM ARTICULOS
DELETE FROM H_ARTICULOS WHERE EXISTENCIAS >  1

CREATE TABLE H_PEDIDOS AS SELECT * FROM PEDIDOS
DELETE FROM H_PEDIDOS WHERE UNIDADES_PEDIDAS >  1

CREATE TABLE H_VENTAS AS SELECT * FROM VENTAS
DELETE FROM H_VENTAS WHERE UNIDADES_VENDIDAS >  1

CREATE OR REPLACE PACKAGE EJR_5

AS
   PROCEDURE B (ART VARCHAR2, CODF NUMBER, PES NUMBER, CAT VARCHAR2);
   PROCEDURE C (ART VARCHAR2, CODF NUMBER, PES NUMBER, CAT VARCHAR2, PV NUMBER, PC NUMBER, EXIST NUMBER);
   PROCEDURE D (ART VARCHAR2, CODF NUMBER, PES NUMBER, CAT VARCHAR2, PV NUMBER, PC NUMBER, EXIST NUMBER);

END EJR_5;

CREATE OR REPLACE PACKAGE BODY EJR_5

AS

PROCEDURE B (ART VARCHAR2, CODF NUMBER, PES NUMBER, CAT VARCHAR2)

AS

BEGIN
   INSERT INTO H_ARTICULOS SELECT * FROM ARTICULOS WHERE ARTICULO = ART AND COD_FABRICANTE = CODF AND PESO = PES AND CATEGORIA = CAT;

   INSERT INTO H_PEDIDOS SELECT * FROM PEDIDOS WHERE ARTICULO = ART AND COD_FABRICANTE = CODF AND PESO = PES AND CATEGORIA = CAT;

   INSERT INTO H_VENTAS SELECT * FROM VENTAS WHERE ARTICULO = ART AND COD_FABRICANTE = CODF AND PESO = PES AND CATEGORIA = CAT;

   DELETE FROM ARTICULOS WHERE ARTICULO = ART AND COD_FABRICANTE = CODF AND PESO = PES AND CATEGORIA = CAT;

END B;

PROCEDURE C (ART VARCHAR2, CODF NUMBER, PES NUMBER, CAT VARCHAR2, PV NUMBER, PC NUMBER, EXIST NUMBER)

AS
   V_FAB NUMBER;
   FAB_NO EXCEPTION;
   PV_PC EXCEPTION;

BEGIN
   SELECT COUNT(*) INTO V_FAB FROM ARTICULOS WHERE COD_FABRICANTE = CODF;

   IF (V_FAB = 0) THEN
      RAISE FAB_NO;
   END IF;

   IF (PV <= PC) THEN
      RAISE PV_PC;
   END IF;

   INSERT INTO H_ARTICULOS
   VALUES(ART, CODF, PES, CAT, PV, PC, EXIST);

EXCEPTION
   WHEN FAB_NO THEN
      DBMS_OUTPUT.PUT_LINE('EL FABRICANTE NO EXISTE');
   WHEN PV_PC THEN
      DBMS_OUTPUT.PUT_LINE('EL PRECIO DE VENTA NO PUEDE SER MENOR QUE EL DE COSTE');   

END C;

PROCEDURE D (ART VARCHAR2, CODF NUMBER, PES NUMBER, CAT VARCHAR2, PV NUMBER, PC NUMBER, EXIST NUMBER)

AS

BEGIN
   UPDATE ARTICULOS 
   SET PRECIO_VENTA = PV, PRECIO_COSTO = PC, EXISTENCIAS = EXIST
   WHERE ARTICULO = ART AND COD_FABRICANTE = CODF AND PESO = PES AND CATEGORIA = CAT;  

END D;

END EJR_5;


6.	Creamos un trigger que nos permite auditar la tabla ARTÍCULOS de tal modo que registramos en una tabla que operación se ha realizado con que artículo, quien la ha hecho y cuando. Esa tabla es:
a.	Auditar_articulos: campos: Articulo, cod_fabricante, peso, categoría, usuario, fecha, tipo_modificación.
b.	Cuando insertamos registros en la tabla Artículos inmediatamente se crea un registro en Auditar_Articulos donde se almacena el registro creado (su PK), el usuario, la fecha y el tipo de modificación.
c.	Cuando eliminamos un registro igual que el caso anterior.
d.	Cuando modificamos un campo del artículo  en el campo correspondiente de Auditar_Articulos se almacena el valor antiguo y el nuevo de ese campo. (Formato: valor_nuevo*valor_antiguo).

CREATE TABLE AUDITAR_ARTICULOS
(
ARTICULO VARCHAR2(20),
COD_FABRICANTE NUMBER(2),
PESO NUMBER(3),
CATEGORIA VARCHAR2(20),
USUARIO VARCHAR2(20),
FECHA DATE,
TIPO_MODIFICACION VARCHAR2(20)
)

CREATE OR REPLACE TRIGGER EJR6
BEFORE INSERT OR UPDATE OR DELETE ON ARTICULOS
FOR EACH ROW

BEGIN

   IF INSERTING THEN
      INSERT INTO AUDITAR_ARTICULOS VALUES(:NEW.ARTICULO, :NEW.COD_FABRICANTE, :NEW.PESO, :NEW.CATEGORIA, USER, SYSDATE, 'INSERTADO');

   ELSIF DELETING THEN
      INSERT INTO AUDITAR_ARTICULOS VALUES(:OLD.ARTICULO, :OLD.COD_FABRICANTE, :OLD.PESO, :OLD.CATEGORIA, USER, SYSDATE, 'BORRADO');

   ELSIF UPDATING THEN
      INSERT INTO AUDITAR_ARTICULOS VALUES(:OLD.ARTICULO||'*'||:NEW.ARTICULO, :OLD.COD_FABRICANTE||'*'||:NEW.COD_FABRICANTE, :OLD.PESO||'*'||:NEW.PESO, :OLD.CATEGORIA||'*'||:NEW.CATEGORIA, :OLD.PRECIO_VENTA||'*'||:NEW.PRECIO_VENTA, :OLD.PRECIO_COSTO||'*'||:NEW.PRECIO_COSTO, :OLD.EXISTENCIAS||'*'||:NEW.EXISTENCIAS);

   ELSE
      DBMS_OUTPUT.PUT_LINE('ERROR');

   END IF;

END EJR6;



7.	Crea 2 triggers que realizan las siguientes acciones: 
a.	Cuando insertamos registros en la tabla NUEVOS (es de alumnos) inserta ese mismo registro en la tabla ALUM.
b.	Cuando eliminamos registros de la tabla ALUM  inserta ese registro en la tabla ANTIGUOS y elimina ese mismo registro de la tabla NUEVOS si existe allí todavía.

CREATE OR REPLACE TRIGGER EJR7_A
BEFORE INSERT ON NUEVOS
FOR EACH ROW

BEGIN 
   INSERT INTO ALUM VALUES(:NEW.NOMBRE, :NEW.EDAD, :NEW.LOCALIDAD);

END EJR7_A;

CREATE OR REPLACE TRIGGER EJR7_B
BEFORE DELETE ON ALUM
FOR EACH ROW

BEGIN 
   INSERT INTO ANTIGUOS VALUES(:OLD.NOMBRE, :OLD.EDAD, :OLD.LOCALIDAD);
   DELETE FROM NUEVOS WHERE NOMBRE=:OLD.NOMBRE AND EDAD=:OLD.EDAD AND LOCALIDAD=:OLD.LOCALIDAD;

END EJR7_B;

8.	Crea un paquete que gestione la tabla TIENDAS:
a.	INSERT_TIENDAS: Pasamos como parámetros los valores de la tienda y damos de alta el registro. Comprueba que el Código Postal no es negativo-
b.	ELIMINAR_TIENDAS: 
1.	Pasamos como parámetro al procedimiento el NIF de la tienda a eliminar. 
2.	Después insertamos ese registro en la tabla H_TIENDAS (Histórico de tiendas. Igual que Tiendas. Vacía) y sus pedidos y ventas en las tablas H_PEDIDOS y H_VENTAS. 
3.	Ahora eliminamos la tienda.
c.	MODIFICAR_TIENDA: Controlamos el cambio de cualquier campo, incluso el de NIF. Si este cambia tenemos que cambiar ese dato en las tablas: TIENDA, PEDIDOS, VENTAS, H_TIENDA, H_PEDIDOS, H_VENTAS.
9.	Sea la vista formada por las siguientes tablas y campos: 
a.	FABRICANTES: Fabricante 
b.	ARTICULOS: Articulo, Cod_fabricante, Peso, categoria 
c.	VENTAS: Unidades_Vendidas, Fecha_venta, Nif.
Se pide crear un trigger que controle las siguientes situaciones:
d.	Se inserta una venta a la vista. Se comprueba si el Articulo existe
1.	Si existe  inserta la venta.
2.	Si no existe  inserta el artículo: 
1.	Al insertar el articulo se comprueba si existe el fabricante:
a.	Si existe  inserta el articulo y después su venta.
b.	Si no existe  se inserta el fabricante, después el artículo y finalmente su venta.
Observación: En las órdenes INSERT sobre la vista siempre pasaremos el cod_fabricante y el Nombre del fabricante y nos aseguramos que se corresponden de modo correcto en la tabla FABRICANTES.
10.	 Crea un paquete que gestiona la tabla PERSONAS y PROVINCIAS (descripción de las tablas en la página 138)
a.	Cuando insertamos registros en la tabla PERSONAS se calcula el nº de personas en esa provincia y estos datos se insertan en la tabla, o se actualizan, dependiendo si ya existen personas en esa provincia.
1.	EST_PROVINCIAS: Cod_prov, nom_prov, num_per.
b.	Cuando eliminamos registros también actualizamos en esta tabla el campo num_per, quedando a 0 el campo num_per, pero no eliminamos el registro de la provincia en la tabla EST_PROVINCIAS.
c.	Cuando actualizamos en la tabla PERSONAS y cambiamos a alguien de provincia  se vuelven a calcular el número de personas en cada provincia y se actualiza en la tabla EST_PROVINCIAS.

11.	Crea un trigger sobre la tabla PROFESORES  de tal modo que cuando se inserte, borre, o actualice un registro de Profesores  se haga lo mismo en la tabla PERSONAL. Es decir, si insertamos un profesor  se inserta en Personal (los datos que procedan),  si se borra  se elimina el registro de personal, y si se actualizan datos controla los cambios en la tabla ‘Personal’ sólo de los datos que tengan en común ambas tablas.

CREATE OR REPLACE TRIGGER EJR11
BEFORE INSERT OR UPDATE OR DELETE ON PROFESORES
FOR EACH ROW

BEGIN
	IF INSERTING THEN
		INSERT INTO PERSONAL VALUES(:NEW.COD_CENTRO, :NEW.DNI, :NEW.APELLIDOS, 'PROFESOR', NULL);
	ELSIF DELETING THEN
		DELETE FROM PERSONAL WHERE DNI = :OLD.DNI;
	ELSIF UPDATING THEN
		UPDATE PERSONAL SET COD_CENTRO = :NEW.COD_CENTRO, DNI = :NEW.DNI, APELLIDOS = :NEW.APELLIDOS WHERE DNI=:OLD.DNI;
	ELSE
		DBMS_OUTPUT.PUT_LINE('ERROR');
	END IF;

END EJR11;




12.	Crea un trigger sobre la tabla PERSONAL  de tal modo que cuando se inserte, borre, o actualice un registro de PERSONAL  se haga lo mismo en la tabla PROFESORES (Sólo si la acción recae sobre un profesor). Es decir, si insertamos un profesor  se inserta en Profesores(los datos que procedan),  si se borra  se elimina el registro de Profesor, y si se actualizan datos controla los cambios en la tabla ‘Profesor’ sólo de los datos que tengan en común ambas tablas.

CREATE OR REPLACE TRIGGER EJR12
BEFORE INSERT OR UPDATE OR DELETE ON PERSONAL
FOR EACH ROW
WHEN (NEW.FUNCION='PROFESOR' OR OLD.FUNCION='PROFESOR')

BEGIN
   IF INSERTING THEN
      INSERT INTO PROFESORES (COD_CENTRO, DNI, APELLIDOS) VALUES (:NEW.COD_CENTRO, :NEW.DNI, :NEW.APELLIDOS);
   ELSIF DELETING THEN
      DELETE FROM PROFESORES WHERE DNI=:OLD.DNI;
   ELSIF UPDATING THEN
      UPDATE PROFESORES SET COD_CENTRO=:NEW.COD_CENTRO, DNI=:NEW.DNI, APELLIDOS=:NEW.APELLIDOS WHERE DNI=:OLD.DNI;
   ELSE
      DBMS_OUTPUT.PUT_LINE('ERROR');
   END IF;

END EJR12;
