-- Update the price of a specific menu item
DELIMITER //

CREATE PROCEDURE UpdateMenuItemPrice(
    IN p_ItemName VARCHAR(225),
    IN p_NewPrice DECIMAL(10, 2) -- Corrected the data type syntax
)
BEGIN
    UPDATE MenuItem
    SET price = p_NewPrice
    WHERE ItemName = p_ItemName;
END //

DELIMITER ;

-- DELETE A MENU ITEM AND RECIPE WITH IT
DELIMITER //

CREATE PROCEDURE DeleteMenuItem(
    IN p_ItemName VARCHAR(225)
)
BEGIN
    DECLARE v_MenuItemID INT; -- Variable for MenuItemID

    START TRANSACTION;

    -- Retrieve MenuItemID for the given item name
    SELECT MenuItemID INTO v_MenuItemID
    FROM MenuItem
    WHERE ItemName = p_ItemName;

    IF v_MenuItemID IS NOT NULL THEN -- Check if the input exists in the DB
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

-- View Menu and its items
DELIMITER //

CREATE PROCEDURE ViewMenu(
    IN p_MenuName VARCHAR(225)
)
BEGIN
    DECLARE v_MenuID INT;

    -- Retrieve MenuID for the given menu name
    SELECT MenuID INTO v_MenuID
    FROM Menu
    WHERE MenuName = p_MenuName;

    IF v_MenuID IS NOT NULL THEN
        -- Select all items related to the MenuID
        SELECT * FROM MenuItem
        WHERE MenuID = v_MenuID;
    ELSE
        -- Handle case where the menu does not exist
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Menu does not exist';
    END IF;
END //

DELIMITER ;
