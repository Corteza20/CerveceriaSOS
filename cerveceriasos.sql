DELIMITER //
CREATE FUNCTION
contar_pedidos_cliente(ClienteID INT)
RETURNS INT
DETERMINISTIC 
BEGIN 
DECLARE Num_Pedidos INT ;

SELECT COUNT(*)
INTO Num_Pedidos
FROM Pedidos
WHERE ClienteID = ClienteID;
return Num_Pedidos;
END //
DELIMITER ;
