-- ----------------------
-- --|--PROCEDURES--|----
-- ----------------------
USE restaurant;

-- VIEW MENU
DELIMITER //
CREATE PROCEDURE ViewMenu (
    IN p_MenuName VARCHAR(225)
)
BEGIN
    DECLARE v_MenuID INT;
    
    SELECT MenuID INTO v_MenuID
        FROM Menu
        WHERE MenuName = p_MenuName;

    IF v_MenuID IS NOT NULL THEN
        SELECT * FROM MenuItem             
            WHERE MenuID = v_MenuID;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu does not exist';
    END IF;
END //

-- View the Recipe of a given MenuItem
CREATE PROCEDURE ViewRecipe (
    IN p_MenuItemName VARCHAR(255)
)
BEGIN
    DECLARE v_MenuItemID INT;

    SELECT MenuItemID INTO v_MenuItemID 
        FROM MenuItem
        WHERE MenuItemName = p_MenuItemName;
    
    IF v_MenuItemID IS NOT NULL THEN
        SELECT * FROM Ingredient
        WHERE MenuItemID = v_MenuItemID;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist';
    END IF;
END//

-- ----------------------USER STORY MODIFY & UPDATE THE MENU------------------------
-- ADD A Menu
CREATE PROCEDURE AddMenu (
    IN p_MenuName VARCHAR(225),
    IN p_MenuDescription TEXT,
    IN t_StartTime TIME,
    IN t_EndTime TIME
)
BEGIN
    INSERT INTO Menu (RestaurantID, MenuName, MenuDescription, StartTime, EndTime) VALUES
    (1, p_MenuName, p_MenuDescription, t_StartTime, t_EndTime);
END//

-- DELETE A MENU (with its menu content)
CREATE PROCEDURE DeleteMenu (
    IN p_MenuName VARCHAR(225)
)
BEGIN
    DECLARE v_MenuID INT;
    SELECT MenuID INTO v_MenuID FROM Menu
    WHERE MenuName = p_MenuName;

    START TRANSACTION;
        IF v_MenuID IS NOT NULL THEN
            DELETE FROM Menu
            WHERE MenuID = v_MenuID;
            DELETE FROM MenuContent
            WHERE MenuID = v_MenuID;
            
            COMMIT;
        ELSE
            -- Rollback if no Matches for MenuItem found
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist';
        END IF;
END //


-- DELETE a Menu Item from a Menu
CREATE PROCEDURE RemoveItemFromMenu (
    IN p_MenuName VARCHAR(225),
    IN p_MenuItemName VARCHAR(225)
) 
BEGIN
    DECLARE v_MenuID INT;
    DECLARE v_MenuItemID INT;
    
    SELECT MenuID, MenuItemID INTO v_MenuID, v_MenuItemID 
    FROM MenuContent
    WHERE MenuName = p_MenuName AND  MenuItemName = p_MenuItemName;

    START TRANSACTION;
        IF v_MenuID IS NOT NULL AND v_MenuItemID IS NOT NULL THEN
            DELETE FROM MenuContent
            WHERE MenuID = v_MenuID AND MenuItemID = v_MenuItemID;
        ELSE
            -- Rollback if no Matches for MenuItem found
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Item is not in Menu and therefore cannot be deleted';
        END IF;
END //

-- UPDATE Menu start time and end time 
CREATE PROCEDURE UpdateMenuTimeWindow (
    IN p_MenuName VARCHAR(225),
    IN t_StartTime TIME,
    IN t_EndTime TIME
)
BEGIN 
    DECLARE v_MenuID INT;
    SELECT MenuID INTO v_MenuID FROM Menu
    WHERE MenuName = p_MenuName;

    IF v_MenuID IS NOT NULL THEN
        UPDATE Menu
        SET StartTime = t_StartTime, EndTime = t_EndTime
        WHERE MenuID = v_MenuID;
    ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist';
    END IF;
END //

-- ----------------------USER STORY MODIFY & UPDATE MENU ITEM------------------------

-- ADD A MENU ITEM 
CREATE PROCEDURE AddMenuItem (
    IN p_MenuName VARCHAR(255),
    IN p_ItemName VARCHAR(255),
    IN p_Price DECIMAL(10,2),
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
END//

-- DELETE A MENU ITEM AND RECIPE WITH IT

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

-- Update the price of a specific menu item

CREATE PROCEDURE UpdateMenuItemPrice(
    IN p_MenuItemName VARCHAR(225),
    IN p_NewPrice DECIMAL(10, 2)
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
END //

-- ----------------------USER STORY MODIFY & UPDATE INGREDIENTS------------------------

-- Add Ingredient
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

    IF v_MenuItemID IS NOT NULL AND v_InventoryItemID IS NOT NULL THEN
        INSERT INTO Ingredient (MenuItemID, InventoryItemID, Quantity, Units) VALUES
        (v_MenuItemID, v_InventoryItemID, p_Quantity, p_Units);
		COMMIT;
    ELSEIF v_MenuItemID IS NOT NULL THEN
        -- Rollback if no Matches for MenuItem found
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ingredient is not an InventoryItem';
    
    ELSEIF v_InventoryItemID IS NOT NULL THEN
        -- Rollback if no Matches for MenuItem found
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist';
    
    ELSE
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist AND Ingredeint is not an Inventory Item';
    END IF;
END //

-- DELETE Ingredients 

CREATE PROCEDURE DeleteIngredient (
    IN p_MenuItemName VARCHAR(225),
    IN p_InventoryItemName VARCHAR(225)
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

    IF v_MenuItemID IS NOT NULL AND v_InventoryItemID IS NOT NULL THEN
        DELETE FROM Ingredient 
        WHERE MenuItem = v_MenuItemID AND InventoryItemID = v_InventoryItemID;
    
    ELSEIF v_MenuItemID IS NOT NULL THEN
        -- Rollback if no Matches for MenuItem found
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid Ingredient: Not in Inventory';
    
    ELSEIF v_InventoryItemID IS NOT NULL THEN
        -- Rollback if no Matches for MenuItem found
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist';
        
    ELSE
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist AND Ingredient is not an Inventory Item';
    END IF;
END //

-- UPDATE Quantities AND Units 
CREATE PROCEDURE UpdateIngredientQuantityUnit (
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
        SET Quantity = p_Quantity, Units = p_Units
        WHERE MenuItemID = v_MenuItemID AND InventoryItemID = v_InventoryItemID; 
    
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist AND Ingredient is not an Inventory Item';
    END IF;
END //

-- ----------------------USER STORY MODIFY & UPDATE Inventory------------------------

-- INSERT Inventory Item --
CREATE PROCEDURE AddInventoryItem (
    IN p_ItemName VARCHAR(255),
    IN p_NumUnits INT,
    IN p_QuantityPerUnit SMALLINT,
    IN p_Units VARCHAR(50),
    IN p_ThresholdNumUnits INT,
    IN p_SupplierName INT,
    IN p_UnitPrice DECIMAL(5,2)
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
        (SELECT InventoryItemID FROM InventoryItem WHERE ItemName = p_ItemName AND QuantityPerUnit = p_QuantityPerUnit AND Units = p_Units);

    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SupplierID is not a Valid ID';
    END IF;
END //

-- - DELETE Inventory Item ---
CREATE PROCEDURE DeleteInventoryItem (
    IN p_InventoryItemName VARCHAR(255),
    IN p_QuantityPerUnit SMALLINT,
    IN p_Units VARCHAR(50),
    IN p_SupplierName VARCHAR(255)
)
BEGIN
    DECLARE v_SupplierID INT;
    DECLARE v_InventoryItemID INT;

    START TRANSACTION;
        SELECT SupplierID INTO v_SupplierID FROM Supplier WHERE SupplierName = p_SupplierName;
        
        SELECT InventoryItemID INTO v_InventoryItemID 
            FROM InventoryItem WHERE SupplierID = v_SupplierID AND InventoryItemName = p_InventoryItemName 
            AND QuantityPerUnit = p_QuantityPerUnit AND Units = p_Units;
        
        IF v_SupplierID IS NOT NULL AND v_InventoryItemID IS NOT NULL THEN
            DELETE FROM InventoryItem 
            WHERE InventoryItemID = v_InventoryItemID;

            DELETE FROM Ingredient WHERE  InventoryItemID = v_InventoryItemID;
        ELSE
            Rollback;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Input does not match any records in InventoryItem';
		END IF;
END //

-- UPDATE Quantities of each InventoryItem

CREATE PROCEDURE UpdateInventoryItemQuantity (
    IN p_InventoryItemName VARCHAR(255),
    IN p_QuantityPerUnit SMALLINT,
    IN p_Units VARCHAR(50),
    IN p_NewNumUnits INT 
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
END //

-- ----------------------USER STORY MODIFY & UPDATE Supplier Info------------------------

-- INSERT SUPPLIER
CREATE PROCEDURE AddSupplier (
    IN p_SupplierName VARCHAR(255),
    IN p_ContactName VARCHAR(255),
    IN p_PhoneNumber VARCHAR(15),
    IN p_Email VARCHAR(255),
    IN p_SupplierAddress VARCHAR(255)
)
BEGIN

INSERT INTO Supplier (SupplierName, ContactName, PhoneNumber, Email, SupplierAddress) VALUES
(p_SupplierName, p_ContactName, p_PhoneNumber, p_Email, p_SupplierAddress);

END //

-- DELETE SUPPLIER
CREATE PROCEDURE DeleteSupplier (
    IN p_SupplierName VARCHAR(255)
)
BEGIN
    DECLARE v_SupplierID INT;
    
    START TRANSACTION;
        SELECT SupplierID INTO v_SupplierID FROM Supplier
        WHERE SupplierName = p_SupplierName;
        
        IF v_SupplierID IS NOT NULL THEN
            DELETE FROM Supplier 
            WHERE SupplierID = v_SupplierID;
            COMMIT;
        ELSE
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No matching Supplier records were found';
        END IF;
END //


-- UPDATE SUPPLIER - ContactName, PhoneNumber, Email, SupplierAddress 
CREATE PROCEDURE UpdateSupplierInformation (
    IN p_SupplierName VARCHAR(255),
    IN New_ContactName VARCHAR(255),
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
            AND Email = New_Email, SupplierAddress = New_SupplierAdress;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No matching Supplier records were found';
        END IF;
END //

DELIMITER ;

-- USER STORY Reservations!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! --
DELIMITER $$

CREATE PROCEDURE InsertReservation (
    IN p_CustomerID INT,
    IN p_TableID INT,
    IN p_TimeSlotID INT,
    IN p_ReservationDate DATETIME,
    IN p_PartySize INT,
    IN p_SpecialRequests TEXT
)
BEGIN
    DECLARE v_TotalReservations INT;
    DECLARE v_Capacity INT;
    DECLARE v_OverbookingCapacity INT;

    -- Get the base capacity and overbooking limit
    SELECT BaseCapacity, BaseCapacity + (BaseCapacity * OverbookingPercentage)
    INTO v_Capacity, v_OverbookingCapacity
    FROM Restaurant;

    -- Calculate the total number of reservations for the given timeslot and date
    SELECT COUNT(*)
    INTO v_TotalReservations
    FROM Reservation
    WHERE ReservationDate = p_ReservationDate
      AND TimeSlotID = p_TimeSlotID
      AND ReservationStatus = 'Confirmed';

    -- Insert reservation
    IF v_TotalReservations < v_Capacity THEN
        -- Confirmed reservation
        INSERT INTO Reservation (CustomerID, TableID, TimeSlotID, ReservationDate, PartySize, ReservationStatus, SpecialRequests)
        VALUES (p_CustomerID, p_TableID, p_TimeSlotID, p_ReservationDate, p_PartySize, 'Confirmed', p_SpecialRequests);
    ELSEIF v_TotalReservations < v_OverbookingCapacity THEN
        -- Overbook reservation
        INSERT INTO Reservation (CustomerID, TableID, TimeSlotID, ReservationDate, PartySize, ReservationStatus, SpecialRequests)
        VALUES (p_CustomerID, p_TableID, p_TimeSlotID, p_ReservationDate, p_PartySize, 'Waitlisted', p_SpecialRequests);

        -- Update waitlist position
        UPDATE Reservation
        SET WaitlistPosition = LAST_INSERT_ID()
        WHERE ReservationID = LAST_INSERT_ID();
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reservation exceeds overbooking capacity.';
    END IF;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS CancelReservation;

DELIMITER $$

CREATE PROCEDURE CancelReservation (
    IN p_ReservationID INT
)
BEGIN
    DECLARE v_TimeSlotID INT;
    DECLARE v_ReservationDate DATETIME;
    DECLARE v_NextReservationID INT;

    -- Get the timeslot and date of the canceled reservation
    SELECT TimeSlotID, ReservationDate
    INTO v_TimeSlotID, v_ReservationDate
    FROM Reservation
    WHERE ReservationID = p_ReservationID;

    -- Cancel the reservation
    DELETE FROM Reservation WHERE ReservationID = p_ReservationID;

    -- Find the next waitlisted customer's ReservationID
    SELECT ReservationID
    INTO v_NextReservationID
    FROM (
        SELECT ReservationID
        FROM Reservation
        WHERE ReservationStatus = 'Waitlisted'
          AND ReservationDate = v_ReservationDate
          AND TimeSlotID = v_TimeSlotID
        ORDER BY WaitlistPosition
        LIMIT 1
    ) AS SubQuery;

    -- Promote the next customer on the waitlist
    IF v_NextReservationID IS NOT NULL THEN
        UPDATE Reservation
        SET ReservationStatus = 'Confirmed',
            WaitlistPosition = NULL
        WHERE ReservationID = v_NextReservationID;
    END IF;

    -- Update the waitlist positions
    UPDATE Reservation
    SET WaitlistPosition = WaitlistPosition - 1
    WHERE ReservationStatus = 'Waitlisted'
      AND ReservationDate = v_ReservationDate
      AND TimeSlotID = v_TimeSlotID
      AND WaitlistPosition > 0;
END$$

DELIMITER ;




DROP PROCEDURE IF EXISTS PromoteFromWaitlist;

DELIMITER $$

CREATE PROCEDURE PromoteFromWaitlist (
    IN p_ReservationID INT
)
BEGIN
    DECLARE v_WaitlistPosition INT;

    -- Fetch the waitlist position of the reservation to be promoted
    SELECT WaitlistPosition
    INTO v_WaitlistPosition
    FROM Reservation
    WHERE ReservationID = p_ReservationID;

    -- Promote the reservation to 'Confirmed'
    UPDATE Reservation
    SET ReservationStatus = 'Confirmed',
        WaitlistPosition = NULL
    WHERE ReservationID = p_ReservationID;

    -- Use a temporary table to hold the IDs of reservations to update
    CREATE TEMPORARY TABLE TempWaitlistReservations (ReservationID INT);

    INSERT INTO TempWaitlistReservations (ReservationID)
    SELECT ReservationID
    FROM Reservation
    WHERE ReservationStatus = 'Waitlisted'
      AND WaitlistPosition > v_WaitlistPosition;

    -- Update the waitlist positions using the temporary table
    UPDATE Reservation
    SET WaitlistPosition = WaitlistPosition - 1
    WHERE ReservationID IN (SELECT ReservationID FROM TempWaitlistReservations);

    -- Drop the temporary table
    DROP TEMPORARY TABLE TempWaitlistReservations;
END$$

DELIMITER ;