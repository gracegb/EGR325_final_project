------------------------
----|--PROCEDURES--|----
------------------------

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
