------------------------
----|--PROCEDURES--|----
------------------------
--VIEW MENU

CREATE PROCEDURE ViewMenu (
    IN p_MenuName VARCHAR(225)
)
BEGIN
    DECLARE v_MenuID;
    
    SELECT MenuID INTO v_MenuID
        FROM Menu
        WHERE MenuName = p_MenuName;

    IF v_MenuID IS NOT NULL THEN
        SELECT * FROM MenuItem             
            WHERE MenuID = v_MenuID;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu does not exist';
    END IF;
END;

--View the Recipe of a given MenuItem
CREATE PROCEDURE ViewRecipe (
    IN p_MenuItemName
)
BEGIN
    DECLARE v_MenuItemID INT;

    MenuItemID INTO v_MenuItemID 
        FROM MenuItem
        WHERE MenuItemName = p_MenuItemName;
    
    IF v_MenuItemID IS NOT NULL THEN
        SELECT * FROM Ingredient
        WHERE MenuItemID = v_MenuItemID;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist';
    END IF;

END;

------------------------USER STORY MODIFY & UPDATE THE MENU------------------------
--ADD A Menu
CREATE PROCEDURE AddMenu (
    IN p_MenuName VARCHAR(225) NOT NULL,
    IN p_MenuDescription TEXT,
    IN t_StartTime TIME NOT NULL,
    IN t_EndTime TIME NOT NULL,
)
BEGIN
    INSERT INTO Menu (MenuName, MenuDescription, StartTime, EndTime) VALUES
    (p_MenuName, p_MenuDescription, t_StartTime, t_EndTime);
END;

--DELETE A MENU
CREATE PROCEDURE DeleteMenu (
    IN p_MenuName VARCHAR(225) NOT NULL,
)
BEGIN
    DECLARE v_MenuID INT;
    MenuID INTO v_MenuID FROM Menu
    WHERE MenuName = p_MenuName;

    DELIMITER //

    START TRANSACTION;
        IF v_MenuID IS NOT NULL THEN
            DELETE * FROM Menu, MenuContent
            WHERE MenuID = v_MenuID
        ELSE
            -- Rollback if no Matches for MenuItem found
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist';
        END IF;
    END //

DELIMITER ;

--DELETE a Menu Item from a Menu
CREATE PROCEDURE RemoveItemFromMenu (
    IN p_MenuName VARCHAR(225),
    IN p_MenuItemName VARCHAR(225)
) 
BEGIN
    DECLARE v_MenuID INT;
    MenuID INTO v_MenuID FROM MenuContent
    WHERE MenuName = p_MenuName;

    DECLARE v_MenuItemID From MenuItem
    MenuItemID INTO v_MenuItemID FROM MenuContent
    WHERE MenuItemName = p_MenuItemName;

    DELIMITER //

    START TRANSACTION;
        IF v_MenuID IS NOT NULL AND v_MenuItemID IS NOT NULL THEN
            DELETE * FROM MenuContent
            WHERE MenuID = v_MenuID AND MenuItemID = v_MenuItemID;
        ELSE
            -- Rollback if no Matches for MenuItem found
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Item is not in Menu and therefore cannot be deleted';
        END IF;
    END //
    DELIMITER;
END;

--UPDATE Menu start time and end time 
CREATE PROCEDURE UpdateMenuTimeWindow (
    IN p_MenuName VARCHAR(225),
    IN t_StartTime TIME,
    IN t_EndTime TIME
)
BEGIN 
    DECLARE v_MenuID INT;
    MenuID INTO v_MenuID FROM Menu
    WHERE MenuName = p_MenuName;

    IF v_MenuID IS NOT NULL THEN
        UPDATE Menu
        SET StartTime = t_StartTime
        AND SET EndTime = t_EndTime
        WHERE MenuID = v_MenuID;
    ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist';
    END IF;
END;

------------------------USER STORY MODIFY & UPDATE MENU ITEM------------------------

-- ADD A MENU ITEM 
CREATE PROCEDURE AddMenuItem (
    IN p_MenuName VARCHAR(255) NOT NULL,
    IN p_ItemName VARCHAR(255) NOT NULL,
    IN p_Price DECIMAL(10,2) NOT NULL,
    IN p_ItemDescription TEXT
)
BEGIN
    DECLARE v_MenuID INT;

    SELECT MenuID INTO v_MenuID
    WHERE MenuName = p_MenuName;

    IF v_MenuID IS NOT NULL THEN
        INSERT INTO MenuItem (MenuID, ItemName, Price, ItemDescription) VALUES
        (v_MenuID, p_ItemName, p_Price, p_ItemDescription);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu does not exist';
        END IF;
END;

--DELETE A MENU ITEM AND RECIPE WITH IT

DELIMITER //

CREATE PROCEDURE DeleteMenuItem (
    IN p_ItemName VARCHAR(225)
)
BEGIN
    DECLARE v_MenuItemID INT; 

    START TRANSACTION;

    SELECT MenuItemID INTO v_MenuItemID 
        FROM MenuItem
        WHERE ItemName = p_ItemName;

    IF v_MenuItemID IS NOT NULL THEN 
        -- Delete Ingredients related to the MenuItem
        DELETE FROM Ingredient 
        WHERE MenuItemID = v_MenuItemID;

        -- Delete the MenuItem
        DELETE FROM MenuItem 
        WHERE ItemName = p_ItemName;

        COMMIT;
    ELSE
    -- Rollback if no Matches for MenuItem found
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist';
    END IF;
END //

DELIMITER ;

-- Update the price of a specific menu item

CREATE PROCEDURE UpdateMenuItemPrice(
    IN p_MenuItemName VARCHAR(225),
    IN p_NewPrice VARCHAR(10,2)
)
BEGIN
    DECLARE v_MenuItemID INT;
    
    SELECT MenuItemID INTO v_MenuItemID
    WHERE MenuItemName = p_MenuItemName;

    IF v_MenuItemID iS NOT NULL THEN
        Update MenuItem SET price = p_NewPrice
        WHERE ItemName = p_ItemName;
    ELSE 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist';
    END IF;
END;

------------------------USER STORY MODIFY & UPDATE INGREDIENTS------------------------

-- Add Ingredient
DELIMITER //
CREATE PROCEDURE AddIngredient (
    IN p_MenuItemName VARCHAR(225),
    IN p_InventoryItemName VARCHAR(225),
    IN p_Quantity DECIMAL(10,2),
    IN p_Units VARCHAR(50)
)
BEGIN
    DECLARE v_MenuItemID INT; 
    DECLARE v_InventoryItemID INT;
    
    
    START TRANSACTION;
    SELECT MenuItemID INTO v_MenuItemID 
        FROM MenuItem
        WHERE MenuItemName = p_MenuItemName;

    SELECT InventoryItemID INTO v_InventoryItemID 
        FROM InventoryItem
        WHERE InventoryItemName = p_InventoryItemName;

    IF v_MenuItemID EXISTS AND v_InventoryItemID EXISTS THEN
        INSERT INTO Ingredient (MenuItemID, InventoryItemID, Quantity, Units) VALUES
        (v_MenuItemID, v_InventoryItemID, p_Quantity, p_Units);
    
    ELSE IF v_MenuItemID EXISTS
        -- Rollback if no Matches for MenuItem found
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ingredient is not an InventoryItem';
    
    ELSE IF v_InventoryItemID EXISTS
        -- Rollback if no Matches for MenuItem found
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist';
    
    ELSE
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist AND Ingredeint is not an Inventory Item';
    END IF;
END //

DELIMITER ;

-- DELETE Ingredients 
DELIMITER //
CREATE PROCEDURE DeleteIngredient (
    IN p_MenuItemName VARCHAR(225),
    IN p_InventoryItemName VARCHAR(225),
)
BEGIN
    DECLARE v_MenuItemID INT; 
    DECLARE v_InventoryItemID INT;
    
    START TRANSACTION;
    SELECT MenuItemID INTO v_MenuItemID 
        FROM MenuItem
        WHERE ItemName = p_ItemName;

    SELECT InventoryItemID INTO v_InventoryItemID 
        FROM InventoryItem
        WHERE ItemName = p_InventoryItemName;

    IF v_MenuItemID EXISTS AND v_InventoryItemID EXISTS THEN
        DELETE * From Ingredient 
        WHERE MenuItem = v_MenuItemID AND InventoryItemID = v_InventoryItemID;
    ELSE IF v_MenuItemID EXISTS
        -- Rollback if no Matches for MenuItem found
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid Ingredient: Not in Inventory';
    
    ELSE IF v_InventoryItemID EXISTS
        -- Rollback if no Matches for MenuItem found
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist';
    ELSE
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist AND Ingredient is not an Inventory Item';
    END IF;
    END //
END;

-- UPDATE Quantities AND Units 

CREATE PROCEDURE AlterIngredientQuantityUnit (
    IN p_MenuItemName VARCHAR(225),
    IN p_InventoryItemName VARCHAR(225),
    IN p_Quantity DECIMAL(10,2),
    IN p_Units VARCHAR(50)
)
BEGIN
    DECLARE v_MenuItemID INT; 
    DECLARE v_InventoryItemID INT;
    
    SELECT MenuItemID, InventoryItemID 
        INTO v_MenuItemID, v_InventoryItemID 
        FROM Ingredient
        WHERE MenuItemName = p_MenuItemName 
        AND InventoryItemName = v_InventoryItemName ;

    IF v_MenuItemID IS NOT NULL AND v_InventoryItemID IS NOT NULL THEN
        UPDATE Ingredient
        SET Quantity = p_Quantity AND Units = p_Units
        WHERE MenuItemID = v_MenuItemID AND InventoryItemID = v_InventoryItemID; 
    
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist AND Ingredient is not an Inventory Item';
    END IF;
END;

------------------------USER STORY MODIFY & UPDATE Inventory------------------------

--- INSERT Inventory Item ---
CREATE PROCEDURE AddInventoryItem (
    IN p_ItemName VARCHAR(255) NOT NULL,
    IN p_NumUnits INT,
    IN p_QuantityPerUnit SMALLINT,
    IN p_Units VARCHAR(50),
    IN p_ThresholdNumUnits INT,
    IN p_SupplierName INT NOT NULL,
    IN p_UnitPrice DECIMAL(5,2) NOT NULL
)
BEGIN
    DECLARE v_SupplierID INT;
    
    SELECT SupplierID INTO v_SupplierID 
        FROM Supplier
        WHERE p_SupplierName = p_SupplierName;
    
    IF v_SupplierID IS NOT NULL THEN
        INSERT INTO InventoryItem 
        (ItemName, NumUnits, QuantityPerUnit, Units, ThresholdNumUnits, SupplierID) VALUES
        (p_ItemName, p_NumUnits, p_QuantityPerUnit, p_Units, p_ThresholdNumUnits, v_SupplierID);

        UPDATE SupplierInventoryItemCatalog
        SET UnitPrice = p_UnitPrice 
        WHERE SupplierID = v_SupplierID AND InventoryItemID = 
        (SELECT InventoryItemID FROM InventoryItem WHERE ItemName = p_ItemName AND QuantityPerUnit = p_QuantityPerUnit AND Units = p_Units)

    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SupplierID is not a Valid ID';
    END IF;
END;

--- DELETE Inventory Item ---
DELIMITER //
CREATE PROCEDURE DeleteInventoryItem (
    IN p_InventoryItemName VARCHAR(255) NOT NULL,
    IN p_QuantityPerUnit SMALLINT NOT NULL,
    IN p_Units VARCHAR(50),
    IN p_SupplierName VARCHAR(255)
)
BEGIN
    DECLARE v_SupplierID INT;
    DECLARE v_InventoryItemID INT;

    BEGIN TRANSACTION
        SELECT SupplierID INTO v_SupplierID FROM Supplier WHERE SupplierName = p_SupplierName
        
        SELECT InventoryItemID INTO v_InventoryItemID 
            FROM InventoryItem WHERE SupplierID = v_SupplierID AND InventoryItemName = p_InventoryItemName 
            AND QuantityPerUnit = p_QuantityPerUnit AND Units = p_Units;
        
        IF v_SupplierID IS NOT NULL AND v_InventoryItemID IS NOT NULL
            DELETE * FROM InventoryItem 
            WHERE InventoryItemID = v_InventoryItemID;

            DELETE * FROM Ingredient WHERE  InventoryItemID = v_InventoryItemID;
        ELSE
            Rollback;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Input does not match any records in InventoryItem';
    END IF;
    END //
END;
DELIMITER ;

-- UPDATE Quantities of each InventoryItem

CREATE PROCEDURE UpdateInventoryItemQuantity (
    IN p_InventoryItemName VARCHAR(255) NOT NULL,
    IN p_QuantityPerUnit SMALLINT,
    IN p_Units VARCHAR(50),
    IN p_NewNumUnits INT --NEW Value
)
BEGIN
    DECLARE v_InventoryItemID INT;

    SELECT InventoryItemID INTO v_InventoryItemID FROM InventoryItem
    WHERE InentoryItemName = p_InventoryItemName AND QuantityPerUnit = p_QuantityPerUnit
    AND Units = p_Units;

    IF v_InventoryItemID IS NOT NULL THEN
        UPDATE InventoryItem
        SET NumUnits = p_NewNumUnits;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No matching InventoryItem records were found';
    END IF;
END;

------------------------USER STORY MODIFY & UPDATE Supplier Info------------------------

--INSERT SUPPLIER
CREATE PROCEDURE AddSupplier (
    IN p_SupplierName VARCHAR(255) NOT NULL,
    IN p_ContactName VARCHAR(255) NOT NULL,
    IN p_PhoneNumber VARCHAR(15) NOT NULL,
    IN p_Email VARCHAR(255) NOT NULL,
    IN p_SupplierAddress VARCHAR(255) NOT NULL
)
BEGIN

INSERT INTO Supplier (SupplierName, ContactName, PhoneNumber, Email, SupplierAddress) VALUES
(p_SupplierName, p_ContactName, p_PhoneNumber, p_Email, p_SupplierAddress);

END;

--DELETE SUPPLIER
DELIMITER //
CREATE PROCEDURE DeleteSupplier (
    IN p_SupplierName VARCHAR(255) NOT NULL,
)
BEGIN
    DECLARE v_SupplierID INT;
    
    START TRANSACTION
        SELECT SupplierID INTO v_SupplierID FROM Supplier
        WHERE SupplierName = p_SupplierName;
        
        IF v_SupplierID IS NOT NULL THEN
            DELETE * FROM Supplier 
            WHERE SupplierID = v_SupplierID
        ELSE
            Rollback
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No matching Supplier records were found';
        END IF;
    END //
END;


-- UPDATE SUPPLIER - ContactName, PhoneNumber, Email, SupplierAddress 
CREATE PROCEDURE UpdateSupplierInformation (
    IN p_SupplierName VARCHAR(255) NOT NULL,
    IN New_ContactName VARCHAR(255) NOT NULL,
    IN New_PhoneNumber VARCHAR(15),
    IN New_Email VARCHAR(255),
    IN New_SupplierAdress VARCHAR(255)
)
BEGIN
    DECLARE v_SupplierID INT;
    
        SELECT SupplierID INTO v_SupplierID FROM Supplier
        WHERE SupplierName = p_SupplierName;
        
        IF v_SupplierID IS NOT NULL THEN
            UPDATE Supplier
            SET ContactName = New_ContactName AND PhoneNumber = New_PhoneNumber
            AND Email = New_Email, AND SupplierAddress = New_SupplierAdress;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No matching Supplier records were found';
        END IF;
END;


--checking if reservation is overbooked

DELIMITER $$

CREATE PROCEDURE InsertReservationWithOverbooking(
    IN p_CustomerID INT,
    IN p_ReservationDate DATETIME,
    IN p_NumberOfPeople INT,
    IN p_SpecialRequests TEXT
)
BEGIN
    DECLARE base_capacity INT;
    DECLARE overbooking_percentage DECIMAL(5, 2);
    DECLARE overbooking_limit INT;
    DECLARE current_reservations INT;

    SELECT BaseCapacity, OverbookingPercentage INTO base_capacity, overbooking_percentage
    FROM RestaurantConfig
    WHERE ConfigID = 1;  

    SET overbooking_limit = base_capacity * (1 + (overbooking_percentage / 100));

    SELECT COUNT(*) INTO current_reservations
    FROM Reservation
    WHERE DATE(ReservationDate) = DATE(p_ReservationDate);

    IF current_reservations < overbooking_limit THEN
        INSERT INTO Reservation (CustomerID, ReservationDate, NumberOfPeople, Status, SpecialRequests)
        VALUES (p_CustomerID, p_ReservationDate, p_NumberOfPeople, 'Confirmed', p_SpecialRequests);
    ELSE
        INSERT INTO Reservation (CustomerID, ReservationDate, NumberOfPeople, Status, SpecialRequests)
        VALUES (p_CustomerID, p_ReservationDate, p_NumberOfPeople, 'Waitlisted', p_SpecialRequests);
    END IF;
END $$

DELIMITER ;
