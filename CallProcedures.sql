
USE restaurant;

-- View Menu
SELECT * FROM Menu;

-- Menu Procedures
CALL DeleteMenu('Drink');
CALL AddMenu(1, 'Drink', 'Non-Alcholic Drinks', '11:30' , '21:30');
CALL UpdateMenuTimeWindow (1, time, time);

-- Menu Content Procedures
CALL AddItemToMenu(7, 35);
CALL RemoveItemFromMenu(7,35);

--  Menu Item Procedures
CALL AddMenuItem ('Calamari', 12.00, 'Fried Octopus');
CALL DeleteMenuItem()
CALL UpdateMenuItemPrice()

-- Menu Item Recipe/Ingredients Procedures
CALL AddIngredient();
CALL DeleteIngredient();
CALL UpdateIngredientQuantityUnit();

-- Inventory Item Procedures
CALL AddInventoryItem ();
CALL DeleteInventoryItem();
CALL UpdateInventoryItemQuantity();

-- Supplier Procedures
CALL AddSupplier();
CALL DeleteSupplier();
CALL UpdateSupplierInformation();



