REM ****************** TABLAS UNIDAD VIII ************
REM ****************** TABLASUNI8.SQL ************

REM ****************** TABLAS TVENTAS Y TARTICULOS:

DROP TABLE TARTICULOS CASCADE CONSTRAINTS;
DROP TABLE TVENTAS CASCADE CONSTRAINTS;

Create table TARTICULOS
(
  CODIGO NUMBER(3)   PRIMARY KEY,
  DENOM VARCHAR2(18) NOT NULL,
  EXIS NUMBER(5),
  PVP NUMBER(6,2)       
) ;

Create table TVENTAS
(
  CODIGO NUMBER(3)  REFERENCES TARTICULOS,
  FECHA_VENTA DATE ,
  UNI_VEND NUMBER(4),
  PRIMARY KEY (CODIGO, FECHA_VENTA) 
) ;


INSERT INTO TARTICULOS VALUES(100,'NARANJAS', 100,1.2);
INSERT INTO TARTICULOS VALUES(101,'PATATAS', 200,0.7);
INSERT INTO TARTICULOS VALUES(102,'CEBOLLAS', 50,0.92);
INSERT INTO TARTICULOS VALUES(103,'SAND�AS', 200,1.2);
INSERT INTO TARTICULOS VALUES(104,'NUECES', 300,2);
INSERT INTO TARTICULOS VALUES(105,'PERAS', 50,2.5);
INSERT INTO TARTICULOS VALUES(106,'MANZANAS', 55,2.5);
INSERT INTO TARTICULOS VALUES(107,'JUD�AS VERDES', 600,5.2);
INSERT INTO TARTICULOS VALUES(108,'GARBANZOS', 300,2.2);
INSERT INTO TARTICULOS VALUES(109,'LENTEJAS', 250,1.9);
INSERT INTO TARTICULOS VALUES(110,'JUD�AS BLANCAS',178,2.3);

ALTER SESSION SET NLS_DATE_FORMAT='DD/MM/YYYY';

INSERT INTO TVENTAS VALUES(100,TO_DATE('14/04/2005'),5);
INSERT INTO TVENTAS VALUES(100,TO_DATE('18/04/2005'),6);
INSERT INTO TVENTAS VALUES(100,TO_DATE('19/05/2005'),10);
INSERT INTO TVENTAS VALUES(100,TO_DATE('26/05/2005'),10);

INSERT INTO TVENTAS VALUES(101,TO_DATE('22/04/2005'),20);
INSERT INTO TVENTAS VALUES(101,TO_DATE('25/05/2005'),15);
INSERT INTO TVENTAS VALUES(101,TO_DATE('27/05/2005'),16);

INSERT INTO TVENTAS VALUES(102,TO_DATE('07/04/2005'),10);
INSERT INTO TVENTAS VALUES(102,TO_DATE('09/04/2005'),11);
INSERT INTO TVENTAS VALUES(102,TO_DATE('10/05/2005'),5);
INSERT INTO TVENTAS VALUES(102,TO_DATE('28/05/2005'),6);
INSERT INTO TVENTAS VALUES(102,TO_DATE('30/05/2005'),14);

INSERT INTO TVENTAS VALUES(108,TO_DATE('06/04/2005'),10);
INSERT INTO TVENTAS VALUES(108,TO_DATE('07/05/2005'),11);
INSERT INTO TVENTAS VALUES(108,TO_DATE('10/05/2005'),5);

INSERT INTO TVENTAS VALUES(109,TO_DATE('06/04/2005'),10);
INSERT INTO TVENTAS VALUES(109,TO_DATE('28/05/2005'),6);
INSERT INTO TVENTAS VALUES(109,TO_DATE('29/05/2005'),18);
INSERT INTO TVENTAS VALUES(109,TO_DATE('30/05/2005'),14);
INSERT INTO TVENTAS VALUES(109,TO_DATE('31/05/2005'),18);

INSERT INTO TVENTAS VALUES(110,TO_DATE('21/05/2005'),20);
INSERT INTO TVENTAS VALUES(110,TO_DATE('31/05/2005'),54);

Commit;
REM *************************************************************
REM   ****** TABLAS CLIENTES08, PEDIDOS08, PRODUCTOS08
REM******************************************************

REM ## TABLA CLIENTES08
DROP TABLE CLIENTES08 CASCADE CONSTRAINTS;
CREATE TABLE CLIENTES08
(CLIENTE_NO		NUMBER(4),
 NOMBRE 		VARCHAR(25),
 LOCALIDAD         	VARCHAR(14),
 VENDEDOR_NO       	NUMBER(4),
 DEBE			NUMBER(9),
 HABER			NUMBER(9),
 LIMITE_CREDITO    	NUMBER(9),
 CONSTRAINT PK_CLIENTE_NO PRIMARY KEY(CLIENTE_NO)
);

REM ## TABLA PRODUCTOS08
DROP TABLE PRODUCTOS08 CASCADE CONSTRAINTS;
CREATE TABLE PRODUCTOS08
(PRODUCTO_NO  		NUMBER(4),
 DESCRIPCION  		VARCHAR(30),
 PRECIO_ACTUAL 		NUMBER(8),
 STOCK_DISPONIBLE	NUMBER(9),
CONSTRAINT PK_PRODUCTO_NO PRIMARY KEY (PRODUCTO_NO) 
);

REM ## TABLA PEDIDOS08
DROP TABLE PEDIDOS08 CASCADE CONSTRAINTS;
CREATE TABLE PEDIDOS08
(PEDIDO_NO         	NUMBER(4),
 PRODUCTO_NO		NUMBER(4),
 CLIENTE_NO 		NUMBER(4),
 UNIDADES 	        NUMBER(4),
 FECHA_PEDIDO      	DATE,
CONSTRAINT PK_PEDIDO_NO PRIMARY KEY (PEDIDO_NO),
CONSTRAINT FK_PEDIDOS_PRODUCTO_NO FOREIGN KEY (PRODUCTO_NO)
		REFERENCES PRODUCTOS08(PRODUCTO_NO) ON DELETE CASCADE,
CONSTRAINT FK_PEDIDOS_CLIENTE_NO FOREIGN KEY (CLIENTE_NO)
		REFERENCES CLIENTES08(CLIENTE_NO) ON DELETE CASCADE 
);

REM ## CLIENTES08
INSERT INTO CLIENTES08 VALUES (101, 'DISTRIBUCIONES GOMEZ', 'MADRID', 7499, 0,0,3000);
INSERT INTO CLIENTES08 VALUES (102, 'LOGITRONICA S.L', 'BARCELONA', 7654,0,0,3000);
INSERT INTO CLIENTES08 VALUES (103, 'INDUSTRIAS LACTEAS S.A.', 'LAS ROZAS', 7844,0,0, 6000);
INSERT INTO CLIENTES08 VALUES (104, 'TALLERES ESTESO S.A.', 'SEVILLA', 7654, 0, 0, 3000);
INSERT INTO CLIENTES08 VALUES (105, 'EDICIONES SANZ', 'BARCELONA', 7499, 0,0,3000);
INSERT INTO CLIENTES08 VALUES (106, 'SIGNOLOGIC S.A.', 'MADRID', 7654,0,0,3000);
INSERT INTO CLIENTES08 VALUES (107, 'MARTIN Y ASOCIADOS S.L.', 'ARAVACA' , 7844,0,0, 6000);
INSERT INTO CLIENTES08 VALUES (108, 'MANUFACTURAS ALI S.A.', 'SEVILLA', 7654, 0, 0, 3000);

REM ## PRODUCTOS08
INSERT INTO PRODUCTOS08 VALUES(10,'MESA DESPACHO MOD. GAVIOTA', 550, 50);
INSERT INTO PRODUCTOS08 VALUES (20, 'SILLA DIRECTOR MOD. BUFALO', 670, 25);
INSERT INTO PRODUCTOS08 VALUES (30, 'ARMARIO NOGAL DOS PUERTAS', 460, 20);
INSERT INTO PRODUCTOS08 VALUES (40, 'MESA MODELO UNI�N',340, 15);
INSERT INTO PRODUCTOS08 VALUES (50, 'ARCHIVADOR CEREZO',1050, 20);
INSERT INTO PRODUCTOS08 VALUES (60, 'CAJA SEGURIDAD MOD B222', 280, 15);
INSERT INTO PRODUCTOS08 VALUES (70, 'DESTRUCTORA DE PAPEL A3',450, 25);
INSERT INTO PRODUCTOS08 VALUES (80, 'MODULO ORDENADOR MOD. ERGOS', 550, 25);

REM ## PEDIDOS08
INSERT INTO PEDIDOS08 VALUES(1000, 20, 103, 3, '06-OCT-2005');
INSERT INTO PEDIDOS08 VALUES(1001, 50, 106, 2, '06-OCT-2005');
INSERT INTO PEDIDOS08 VALUES(1002, 10, 101, 4, '07-OCT-2005');
INSERT INTO PEDIDOS08 VALUES(1003, 20, 105, 4, '16-OCT-2005');
INSERT INTO PEDIDOS08 VALUES(1004, 40, 106, 8, '20-OCT-2005');
INSERT INTO PEDIDOS08 VALUES(1005, 30, 105, 2, '20-OCT-2005');
INSERT INTO PEDIDOS08 VALUES(1006, 70, 103, 3, '03-NOV-2005');
INSERT INTO PEDIDOS08 VALUES(1007, 50, 101, 2, '06-NOV-2005');
INSERT INTO PEDIDOS08 VALUES(1008, 10, 106, 6, '16-NOV-2005');
INSERT INTO PEDIDOS08 VALUES(1009, 20, 105, 2, '26-NOV-2005');
INSERT INTO PEDIDOS08 VALUES(1010, 40, 102, 3, '08-DIC-2005');
INSERT INTO PEDIDOS08 VALUES(1011, 30, 106, 2, '15-DIC-2005');
INSERT INTO PEDIDOS08 VALUES(1012, 10, 105, 3, '06-DIC-2005');
INSERT INTO PEDIDOS08 VALUES(1013, 30, 106, 2, '06-DIC-2005');
INSERT INTO PEDIDOS08 VALUES(1014, 20, 101, 4, '07-ENE-2000');
INSERT INTO PEDIDOS08 VALUES(1015, 70, 105, 4, '16-ENE-2000');
INSERT INTO PEDIDOS08 VALUES(1016, 30, 106, 7, '18-ENE-2000');
INSERT INTO PEDIDOS08 VALUES(1017, 20, 105, 6, '20-ENE-2000');


COMMIT;
REM ****************** FIN ************

