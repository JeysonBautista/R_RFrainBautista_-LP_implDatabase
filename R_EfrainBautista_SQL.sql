/*Crear una nueva base de datos con el nombre db Market2023 con los siguientes archivos*/
USE master; -- Cambia al contexto de la base de datos principal

-- Comprueba si la base de datos ya existe y elimínala si es necesario
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Market2023')
BEGIN
    ALTER DATABASE Market2023 SET OFFLINE WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Market2023;
END

-- Crear la base de datos
CREATE DATABASE [Market2023]
ON PRIMARY
(
    NAME = N'Market2023',
    FILENAME = N'C:\VENTAS\Market2023.mdf',
    SIZE = 15MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 5MB
)
LOG ON
(
    NAME = N'Market2023_Data',
    FILENAME = N'C:\VENTAS\Market2023.ndf',
    SIZE = 30MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 25%
)
LOG ON
(
    NAME = N'Market2023_Log',
    FILENAME = N'C:\VENTAS\Market2023.ldf',
    SIZE = 60MB,
    MAXSIZE = 150MB,
    FILEGROWTH = 20%
);

/*Crear los siguientes Esquemas*/

-- Crear el esquema PERSONA con descripción
CREATE SCHEMA PERSONA;
EXEC sp_addextendedproperty 'MS_Description', 'Esquema persona', 'SCHEMA', 'PERSONA';

-- Crear el esquema PRODUCTO con descripción
CREATE SCHEMA PRODUCTO;
EXEC sp_addextendedproperty 'MS_Description', 'Esquema producto', 'SCHEMA', 'PRODUCTO';

-- Crear el esquema VENTAS con descripción
CREATE SCHEMA VENTAS;
EXEC sp_addextendedproperty 'MS_Description', 'Esquema ventas', 'SCHEMA', 'VENTAS';


-- Crear la tabla PERSONA 
CREATE TABLE PERSONA (
    IDPER INT IDENTITY(200,1) PRIMARY KEY,
    DNIPER CHAR(8),
    NOMPER VARCHAR(100) NOT NULL,
    APEPER VARCHAR(100) NOT NULL,
    EMAPER VARCHAR(110),
    CELPER CHAR(9),
    ESTADO CHAR(1) DEFAULT 'A',
    FECNACPER DATE,
    TIPOPERSONA CHAR(1) CHECK (TIPOPERSONA IN ('V', 'C'))
);

-- Insertar registros 
INSERT INTO PERSONA (DNIPER, NOMPER, APEPER, EMAPER, CELPER, FECNACPER, TIPOPERSONA)
VALUES
    ('7788995', 'Alberto', 'Solano Pariona', 'juan@example.com', '123456789', '1990-05-15', 'V'),
    ('45781233', 'María', 'López', 'maria@example.com', '987654321', '1985-09-20', 'C'),
    ('15487922', 'Pedro', 'Ramírez', NULL, NULL, '1995-03-10', 'C');



-- Crear la tabla CATEGORIA 
CREATE TABLE CATEGORIA (
    IDCAT INT IDENTITY(10,10) PRIMARY KEY,
    NOMCAT VARCHAR(255) NOT NULL
);

-- Insertar registros de ejemplo
INSERT INTO CATEGORIA (NOMCAT)
VALUES
    ('Abarrotes'),
    ('Carnes y pollos'),
    ('higiene y Limpieza');

-- Crear la tabla PRODUCTO con ID personalizado
CREATE TABLE PRODUCTO (
    CODPRO VARCHAR(10) PRIMARY KEY,
    NOMPRO VARCHAR(255) NOT NULL,
	PREPRO DECIMAL(10,2),
	STOCKPRO INT,
	IDCATPRO INT,
    ESTPRO CHAR(1) DEFAULT 'A'
);

-- Insertar registros de ejemplo con ID personalizado
INSERT INTO PRODUCTO (CODPRO, NOMPRO, PREPRO, STOCKPRO,IDCATPRO,ESTPRO)
VALUES
    ('P01', 'Arroz', 'Televisor LED de 55 pulgadas', 699.99),
    ('P02', 'Azucar', 'Camiseta de algodón en varios colores', 19.99),
    ('P03', 'Pollo fresco', 'Sofá de cuero de 3 plazas', 899.99),
	('P04', 'Lomo fino', 'Sofá de cuero de 3 plazas', 899.99),
	('P05', 'detergente opal', 'Sofá de cuero de 3 plazas', 899.99),
	('P06', 'Suavisante Ariel', 'Sofá de cuero de 3 plazas', 899.99);



-- Establecer la relación entre las tablas
ALTER TABLE PRODUCTO
ADD CONSTRAINT FK_PRODUCTO_CATEGORIA
FOREIGN KEY (IDCAT)
REFERENCES CATEGORIA(IDCAT);


-- Crear la tabla VENTA
CREATE TABLE VENTA (
    IDVEN INT IDENTITY(1,1) PRIMARY KEY,
    FECVEN DATETIME DEFAULT GETDATE(),
	IDVEND INT,
	IDCLI INT,
	TIPPAGVEN  CHAR(1) CHECK (TIPPAGVEN IN ('E', 'T')),
    ESTVEN CHAR(1) DEFAULT 'A'
);

-- Insertar registros de ejemplo
-- No es necesario especificar ID ni FECHAVENTA, ya que se generarán automáticamente
INSERT INTO VENTA (IDVEND,IDCLI,TIPPAGVEN,ESTVEN)
VALUES
    ('200','202','E','A'),
    ('201','204','T','A'),
    ('202','205','T','A'),
	('203','206','E','A');


	ALTER TABLE VENTA
ADD CONSTRAINT FK_VENTA_PERSONA
FOREIGN KEY (IDPER)
REFERENCES PERSONA(IDPER);

-- Crear la tabla VENTA_DETALLE 
CREATE TABLE VENTA_DETALLE (
    IDVENDEN INT IDENTITY(300, 1) PRIMARY KEY,
    IDVEN INT,
    CODPRO INT, 
    CANVENDET DECIMAL(10, 2) 
);

-- No es necesario especificar ID, ya que se generará automáticamente
INSERT INTO VENTA_DETALLE (IDVEN, CODPRO, CANVENDET)
VALUES
    (300, P01, 2),
    (301, P04, 4); 


ALTER TABLE VENTA_DETALLE
ADD CONSTRAINT FK_VENTA_DETALLE_VENTA
FOREIGN KEY (IDVEN)
REFERENCES VENTA(IDVEN);

ALTER TABLE VENTA_DETALLE
ADD CONSTRAINT FK_VENTA_DETALLE_PRODUCTO
FOREIGN KEY (CODPRO)
REFERENCES PRODUCTO(CODPRO);






