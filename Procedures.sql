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
    IN p_MenuID INT
)
BEGIN
    START TRANSACTION;
        SELECT MenuID INTO p_MenuID 
        WHERE MenuID = p_MenuID;

        IF p_MenuID IS NOT NULL THEN
            DELETE FROM Menu
            WHERE MenuID = p_MenuID;
            DELETE FROM MenuContent
            WHERE MenuID = p_MenuID;
            COMMIT;
        ELSE
            -- Rollback if no Matches for MenuItem found
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist';
        END IF;
END //


-- DELETE a Menu Item from a Menu
CREATE PROCEDURE RemoveItemFromMenu (
    IN p_MenuID INT,
    IN p_MenuItemID INT
) 
BEGIN

    START TRANSACTION;

        SELECT MenuID INTO p_MenuID FROM MenuContent
        WHERE MenuID = p_MenuID;

        IF p_MenuID IS NOT NULL AND p_MenuItemID IS NOT NULL THEN
            DELETE FROM MenuContent
            WHERE MenuID = p_MenuID AND MenuItemID = p_MenuItemID;
        ELSE
            -- Rollback if no Matches for MenuItem found
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Item is not in Menu and therefore cannot be deleted';
        END IF;
END //

CREATE PROCEDURE AddItemToMenu (
    IN p_MenuID INT,
    IN p_MenuItemID INT
)
BEGIN
    SELECT MenuID INTO p_MenuID
    WHERE MenuID = p_MenuID;

    SELECT MenuItemID INTO p_MenuItemID FROM MenuItem
    WHERE MenuItemID = p_MenuItemID;

    IF p_MenuID IS NOT NULL AND p_MenuItemID IS NOT NULL THEN
            INSERT INTO MenuContent (MenuID, MenuItemID) 
            VALUES (p_MenuID, p_MenuItemID);
        ELSE
            -- Rollback if no Matches for MenuItem found
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Item or Menu does not exist';
        END IF;
END //


-- UPDATE Menu start time and end time 
CREATE PROCEDURE UpdateMenuTimeWindow (
    IN p_MenuID INT,
    IN t_StartTime TIME,
    IN t_EndTime TIME
)
BEGIN 
    IF p_MenuID IS NOT NULL THEN
        UPDATE Menu
        SET StartTime = t_StartTime, EndTime = t_EndTime
        WHERE MenuID = p_MenuID;
    ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist';
    END IF;
END //

-- ----------------------USER STORY MODIFY & UPDATE MENU ITEM------------------------

-- ADD A MENU ITEM 
CREATE PROCEDURE AddMenuItem (
    IN p_MenuItemName VARCHAR(255),
    IN p_Price DECIMAL(10,2),
    IN p_ItemDescription TEXT
)
BEGIN
        INSERT INTO MenuItem (MenuItemName, Price, ItemDescription) VALUES
        (p_MenuItemName, p_Price, p_ItemDescription);
    
END//

-- DELETE A MENU ITEM AND RECIPE WITH IT

CREATE PROCEDURE DeleteMenuItem (
    IN p_MenuItemID INT
)
BEGIN

    SELECT MenuItemID INTO v_MenuItemID 
        FROM MenuItem
        WHERE MenuItemID = p_MenuItemID;

    IF v_MenuItemID IS NOT NULL THEN 
        -- Delete Ingredients related to the MenuItem
        DELETE FROM Ingredient 
        WHERE MenuItemID = v_MenuItemID;

        -- Delete the MenuItem
        DELETE FROM MenuItem 
        WHERE MenuItemID = v_MenuItemID;

        COMMIT;
    ELSE
        -- Rollback if no Matches for MenuItem found
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist';
    END IF;
END //

-- Update the price of a specific menu item

CREATE PROCEDURE UpdateMenuItemPrice(
    IN p_MenuItemID VARCHAR(225),
    IN p_NewPrice DECIMAL(10, 2)
)
BEGIN
    SELECT MenuItemID INTO p_MenuItemID
    WHERE MenuItemName = p_MenuItemID;

    IF p_MenuItemID iS NOT NULL THEN
        Update MenuItem SET price = p_NewPrice
        WHERE ItemName = p_ItemName;
    ELSE 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist';
    END IF;
END //

-- ----------------------USER STORY MODIFY & UPDATE INGREDIENTS------------------------

-- Add Ingredient
CREATE PROCEDURE AddIngredient (
    IN p_MenuItemID INT,
    IN p_InventoryItemID INT,
    IN p_Quantity DECIMAL(10,2),
    IN p_Units VARCHAR(50)
)
BEGIN
    START TRANSACTION;
    SELECT MenuItemID INTO p_MenuItemID FROM MenuItem
        WHERE MenuItemID = p_MenuItemID;

    SELECT InventoryItemID INTO p_InventoryItemID FROM InventoryItem
        WHERE InventoryItemID = p_InventoryItemID;

    IF p_MenuItemID IS NOT NULL AND p_InventoryItemID IS NOT NULL THEN
        INSERT INTO Ingredient (MenuItemID, InventoryItemID, Quantity, Units) VALUES
        (p_MenuItemID, p_InventoryItemID, p_Quantity, p_Units);
		COMMIT;
    ELSEIF v_MenuItemID IS NOT NULL THEN
        -- Rollback if no Matches for MenuItem found
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'InventoryItem does not exist';
    
    ELSEIF v_InventoryItemID IS NOT NULL THEN
        -- Rollback if no Matches for MenuItem found
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist';
    
    ELSE
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu item does not exist AND Inventory Item does not exist';
    END IF;
END //

-- DELETE Ingredients 

CREATE PROCEDURE DeleteIngredient (
    IN p_MenuItemID INT,
    IN p_InventoryItemID INT
)
BEGIN
    START TRANSACTION;
    SELECT MenuItemID, InventoryItemID 
        INTO p_MenuItemID, p_InventoryItemID 
        FROM Ingredient
        WHERE MenuItemID = p_MenuItemID 
        AND InventoryItemID = p_InventoryItemName;
        
    IF p_MenuItemID IS NOT NULL AND p_InventoryItemID IS NOT NULL THEN
        DELETE FROM Ingredient 
        WHERE MenuItem = p_MenuItemID AND InventoryItemID = p_InventoryItemID;
    ELSE
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No ingredient found for specified menu item.';
    END IF;
END //

-- UPDATE Quantities AND Units 
CREATE PROCEDURE UpdateIngredientQuantityUnit (
    IN p_MenuItemID INT,
    IN p_InventoryItemID INT,
    IN p_Quantity DECIMAL(10,2),
    IN p_Units VARCHAR(50)
)
BEGIN
    DECLARE p_MenuItemID INT; 
    DECLARE p_InventoryItemID INT;
    
    SELECT MenuItemID, InventoryItemID 
        INTO p_MenuItemID, p_InventoryItemID 
        FROM Ingredient
        WHERE MenuItemName = p_MenuItemID 
        AND InventoryItemID = p_InventoryItemID ;

    IF p_MenuItemID IS NOT NULL AND p_InventoryItemID IS NOT NULL THEN
        UPDATE Ingredient
        SET Quantity = p_Quantity, Units = p_Units
        WHERE MenuItemID = p_MenuItemID AND InventoryItemID = p_InventoryItemID; 
    
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ingredient does not exist';
    END IF;
END //

-- ----------------------USER STORY MODIFY & UPDATE Inventory------------------------

-- INSERT Inventory Item --
CREATE PROCEDURE AddInventoryItem (
    IN p_InventoryItemName VARCHAR(255),
    IN p_TotalUnits INT,
    IN p_AmountPerUnit SMALLINT,
    IN p_UnitType VARCHAR(50),
    IN p_Threshold INT
)
BEGIN
    
    INSERT INTO InventoryItem 
    (InventoryItemName, TotalUnits, AmountPerUnit, UnitType, Threshold) VALUES
    (p_ItemName, p_TotalUnits, p_AmountPerUnit, p_UnitType, p_Threshold);

    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SupplierID is not a Valid ID';
    END IF;
END //

-- - DELETE Inventory Item ---
CREATE PROCEDURE DeleteInventoryItem (
    IN p_InventoryItemID INT
)
BEGIN
        START TRANSACTION;
        SELECT InventoryItemID INTO p_InventoryItemID 
            FROM InventoryItem 
            WHERE  InventoryItemID = p_InventoryItemID;
        
        IF p_InventoryItemID IS NOT NULL THEN
            DELETE FROM InventoryItem 
            WHERE InventoryItemID = p_InventoryItemID;

            DELETE FROM Ingredient WHERE  InventoryItemID = p_InventoryItemID; -- Delete Ingredients associated with Inventory Item
        ELSE
            Rollback;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Input does not match any records in InventoryItem';
		END IF;
END //

-- UPDATE Quantities of each InventoryItem

CREATE PROCEDURE UpdateInventoryItemQuantity (
    IN p_InventoryItemID INT,
    IN p_NewTotalUnits INT 
)
BEGIN
    DECLARE p_InventoryItemID INT;

    SELECT InventoryItemID INTO p_InventoryItemID FROM InventoryItem
    WHERE InentoryItemID = p_InventoryItemID;

    IF p_InventoryItemID IS NOT NULL THEN
        UPDATE InventoryItem
        SET TotalUnits = p_NewTotalUnits;
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
    IN p_SupplierID INT
)
BEGIN
    START TRANSACTION;
        SELECT SupplierID INTO p_SupplierID FROM Supplier
        WHERE SupplierID = p_SupplierID;
        
        IF p_SupplierID IS NOT NULL THEN
            DELETE FROM Supplier 
            WHERE SupplierID = p_SupplierID;
            COMMIT;
        ELSE
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No matching Supplier records were found';
        END IF;
END //


-- UPDATE SUPPLIER - ContactName, PhoneNumber, Email, SupplierAddress 
CREATE PROCEDURE UpdateSupplierContactInfo (
    IN p_SupplierID INT,
    IN New_ContactName VARCHAR(255),
    IN New_PhoneNumber VARCHAR(15),
    IN New_Email VARCHAR(255),
)
BEGIN
    SELECT SupplierID INTO p_SupplierID FROM Supplier
    WHERE SupplierID = p_SupplierID;
        
        IF p_SupplierID IS NOT NULL THEN
            UPDATE Supplier
            SET ContactName = New_ContactName, PhoneNumber = New_PhoneNumber, 
            Email = New_Email;
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
