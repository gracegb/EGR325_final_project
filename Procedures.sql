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
