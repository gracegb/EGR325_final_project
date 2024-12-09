USE restaurant;

-- View Menu
SELECT * FROM Menu;

-- Menu Procedures
CALL DeleteMenu(12);
CALL AddMenu('Drink', 'Alcholic Drinks', '11:30' , '21:30');
CALL UpdateMenuTimeWindow (4, '19:00', '20:00');

SELECT * FROM MenuContent;
-- Menu Content Procedures
CALL AddItemToMenu(1,1);
CALL RemoveItemFromMenu(1,1);

SELECT * FROM MenuItem;
--  Menu Item Procedures
CALL AddMenuItem ('Calamari', 12.00, 'Fried Octopus');
CALL DeleteMenuItem(37);
CALL UpdateMenuItemPrice(36, 12.50);

SELECT * FROM Ingredient;
-- Menu Item Recipe/Ingredients Procedures
CALL AddIngredient(1,1, 4, 'oz');
CALL DeleteIngredient(1,1);
CALL UpdateIngredientQuantityUnit(1,1, 0.25, 'lb');

SELECT * FROM InventoryItem;
-- Inventory Item Procedures
CALL AddInventoryItem ('Cherry Tomatos', 5, 12, 'lb', 2);
CALL DeleteInventoryItem(40);
CALL UpdateInventoryItemQuantity(40, 3);

SELECT * FROM Supplier;
-- Supplier Procedures
CALL AddSupplier('Good Grains Co.', 'John Doe', '555-1234', 'john.doe@goodgrains.com', '123 Grain St, Riverside, CA 92501');
CALL DeleteSupplier(11);
CALL UpdateSupplierContactInfo(10, 'John Doe', '555-1234', 'john.doe@dimsumimports.com');



