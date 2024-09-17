CREATE TABLE registro_Clientes ( 
ClienteID INT , 
fecha_registro DATETIME, 
PRIMARY KEY (clienteID,fecha_registro) 

); 
--  trigger 
DELIMITER // 
CREATE TRIGGER ClienteID_insert 
AFTER INSERT ON Clientes 
FOR EACH ROW 
BEGIN 
-- Acción  se inserta un cliente 
INSERT INTO registro_Clientes (ClienteID,fecha_registro) 
VALUES (NEW.ClienteID, NOW()); 

END// 

DELIMITER ; 

CREATE VIEW  vista_Empleados AS 
SELECT Nombre,apellido,fechaNacimiento FROM Empleados; 

SELECT * FROM vista_Empleados; 

SELECT * FROM Empleados; 

CREATE VIEW vista_Productos AS  
SELECT ProductoName FROM Productos; 


CREATE VIEW  vista_Categorias AS 
SELECT CategoriaName FROM Categorias; 
SHOW FULL TABLES IN  
mydb WHERE table_type = 'VIEW'; 

-- Vista clientes y pedidos  

CREATE VIEW  
vista_clientes_pedidos AS  
SELECT c.ClienteID , c.ClienteName AS 
ClienteName, p.PedidoID,Fecha_Pedido 
FROM Clientes c  
INNER JOIN Pedidos p ON  
c.ClienteID = p.ClienteID; 

-- Combinar pedidos y productos  

 SELECT vcp.ClienteID,vcp.ClienteName,vcp.PedidoID,vcp.Fecha_Pedido,vpd.ProductoName,vpd.Cantidad 
FROM vista_clientes_pedidos vcp 
INNER JOIN Detalle_Pedidos dp ON  
vcp.PedidoID = dp.PedidoID 
INNER JOIN vista_productos_detalles 
vpd ON dp.ProductoID = vpd.ProductoID ; 

 

 
-- PROCEDIMIENTO  inserta un nuevo cliente y pedido . 

DELIMITER // 

CREATE PROCEDURE 

Agregar_cliente_y_pedido( 

IN ClienteName VARCHAR (100), 
IN Fecha_Pedido DATE 

) 

BEGIN 
DECLARE nuevo_ClienteID INT ; 
  -- Insertar nuevo cliente  
INSERT INTO Clientes(nombre) 
   VALUES (ClienteName); 

-- obtener el ID del nuevo cliente  
   SET nuevo_ClienteID = LAST_INSERT_ID (); 
-- iNSERTAR NUEVO PEDIDO PARA EL CLIENTE RECIEN AGREGADO  

  INSERT INTO Pedidos(ClienteID, fecha)VALUES (nuevo_ClienteID,Fecha_Pedido); 
END // 

  DELIMITER ; 

 -- Devuelve el numero total de pedidos para un cliente  

 DELIMITER // 

CREATE PROCEDURE  
contar_pedidos_cliente( 
IN ClienteID INT , 
OUT total_pedidos INT 

) 
BEGIN 
-- Calcular total d epedidos para el cliente  
SELECT COUNT(*) 
  INTO total_pedidos 
  FROM Pedidos 
  WHERE ClienteID =ClienteID ; 
END // 
DELIMITER ; 

-- Procedimiento con parametro de salida  

-- declarar una variable para almacenar el resultado  

SET @total_pedidos=0 ; 

  -- llamar al procedimiento 

CALL contar_pedidos_cliente(1,@total_pedidos); 

  -- mostrar el resultado  

SELECT @total_pedidos; 

 triggers 

-- Actualizar pedido de cliente automaticamente  

 DELIMITER // 

CREATE TRIGGER  
actualizar_saldo_cliente 
AFTER INSERT ON Pedidos        
FOR EACH ROW 
BEGIN  
UPDATE Clientes  

SET saldo = saldo + total 
WHERE ClienteID = ClienteID; 
END // 
DELIMITER ; 

 

TRIGGER 
-- VERIFICAR DATOS ANTES DE ACTUALIZAR 
DELIMITER // 
CREATE TRIGGER 
verificar_total_pedido 
BEFORE UPDATE ON Pedidos 
FOR EACH ROW 
BEGIN 
IF total < 0 THEN 
SIGNAL SQLSTATE '45000' 
SET MESSAGE_TEXT ='El total del pedido no puede ser negativo.'; 
END IF; 
END // 
DELIMITER ; 

 -- TRIGGER
-- REGISTRAR CAMBIOS 

CREATE TABLE auditoria_pedidos ( 

auditoriaID INT PRIMARY KEY AUTO_INCREMENT, 

PedidoID INT , 

fecha TIMESTAMP DEFAULT 

CURRENT_TIMESTAMP, 

tipo_cambio ENUM('INSERT','UPDATE','DELETE'), 

datos_originales TEXT, 

datos_nuevos TEXT  

); 

 

-- TRIGGER de auditoria insercion  
DELIMITER // 
CREATE TRIGGER 
auditoria_pedidos_insertar 
AFTER INSERT ON Pedidos 
FOR EACH ROW 
BEGIN 
INSERT INTO  
auditoria_pedidos (PedidoID,tipo_cambio,datos_nuevos) 
VALUES (PedidoID,'INSERT',CONCAT('total:', 

total,'fecha;',fecha)); 

END // 
DELIMITER // 

-- CREACION DE FUNCION 

DELIMITER //
CREATE FUNCTION fn_ganancia_neta(ProductoID INT)  
RETURNS DECIMAL(15,2) 
DETERMINISTIC 
BEGIN 
   DECLARE diferenciaPrecio decimal (15,2); 
SELECT (precio_Productos_Categoria - Precio_Productos) INTO 
diferenciaPrecio 
FROM Productos WHERE ProductoID = ProductoID; 
RETURN diferenciaPrecio; 
END //
DELIMITER ; 

SELECT * FROM Productos 
WHERE  Precio < 20 OR CategoriaID = 6 