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

-- ADD A MENU ITEM 
CREATE PROCEDURE AddMenuItem (
    IN v_MenuID,
    IN p_ItemName VARCHAR(225) NOT NULL,
    IN p_Price DECIMAL(10,2) NOT NULL,
    IN p_ItemDescription TEXT
)
BEGIN
    INSERT INTO MenuItem (MenuID, ItemName, Price, ItemDescription) VALUES
    (v_MenuID, p_ItemName, p_Price, p_ItemDescription);
END;

--DELETE A MENU ITEM AND RECIPE WITH IT

DELIMITER //

CREATE PROCEDURE DeleteMenuItem (
    IN p_ItemName VARCHAR(225)
)
BEGIN
    DECLARE v_MenuItemID INT; -- Variable for MenuItemID

    START TRANSACTION;

    SELECT MenuItemID INTO v_MenuItemID --store input
        FROM MenuItem
        WHERE ItemName = p_ItemName;

    IF v_MenuItemID IS NOT NULL THEN -- CHECK if input exists in DB
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
    IN p_ItemName VARCHAR(225),
    IN p_NewPrice VARCHAR(10,2)
)
BEGIN
    Update MenuItem
    SET price = p_NewPrice
    WHERE ItemName = p_ItemName;
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
