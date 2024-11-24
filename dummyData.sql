USE restaurant;
-- INSERT DIFFERENT MENUS
INSERT INTO Menu (RestaurantID, MenuName, MenuDescription, StartTime, EndTime) VALUES
    (1, 'Main', 'Menu of all the main entrees, appetizers, and non-alcoholic drinks', '11:30', '21:30'),
    (1, 'Teppan', 'Menu of all the Teppan Items', '11:30', '21:30'),
    (1, 'Sushi and Sahimi', 'All Suhsi entrees', '11:30', '21:30'),
    (1, 'Happy Hour', 'Menu available for only a specific time period that offers customers better prices for selected items', '19:30', '20:30'),
    (1, 'Kids', 'All Items come with a side of white or fried rice and miso soup. Must be under the age of 12','11:30', '21:30'),
    (1, 'Dessert', 'Menu with only dessert items', '11:30', '21:30'),
    (1, 'Beverages', 'Menu of non-alcoholic beverages', '11:30', '21:30'),
    (1, 'Drink', 'Menu of alcoholic beverages', '11:30', '21:30');

INSERT INTO MenuItem (MenuItemName, Price, ItemDescription) VALUES 
('Cajun Chicken Salad', 13.00, 'Steamed soybeans with garlic, salt, or pepper'),
('Salmon Skin Salad', 16.00, 'Steamed soybeans with garlic, salt, or pepper'),
('Seared Albacore Salad', 16.00, 'Steamed soybeans with garlic, salt, or pepper'),
('Cucumber Salad', 7.00, 'Steamed soybeans with garlic, salt, or pepper'),
('Eggrolls', 4.50, 'Traditional Japanese soup with tofu, seaweed, and scallions'),
('Miso Soup', 4.50, 'Traditional Japanese soup with tofu, seaweed, and scallions'),
('Edamame', 8.00, 'Steamed soybeans with garlic, salt, or pepper'),
('Shrimp Tempura', 13.99, 'Lightly battered and fried shrimp with tempura sauce'),
('Vegetable Gyoza', 7.50, 'Pan-fried vegetable dumplings served with soy sauce'),
('Miso Soup', 4.50, 'Traditional Japanese soup with tofu, seaweed, and scallions'),
('Chicken Teppanyaki', 15.99, 'Grilled chicken with mixed vegetables and special sauce'),
('Beef Teppanyaki', 17.99, 'Teppanyaki grilled beef with fried rice and vegetables'),
('Sunset Roll', 12.99, 'A delicious sushi roll with fresh salmon and avocado'),
('California Roll', 10.00, 'A classic sushi roll with crab, avocado, and cucumber'),
('Spicy Tuna Roll', 11.50, 'Sushi roll with spicy tuna, cucumber, and tobiko'),
('Salmon Sashimi', 14.00, 'Fresh slices of salmon served with soy sauce and wasabi'),
('Miso Glazed Black Cod', 9.99, 'Grilled black cod with a sweet miso glaze served with pickled vegetables'),
('Teriyaki Chicken Skewers', 7.50, 'Grilled chicken skewers in a savory teriyaki sauce'),
('Vegetable Tempura', 6.00, 'Crispy battered seasonal vegetables served with dipping sauce'),
('Shrimp Dumplings', 8.50, 'Steamed shrimp dumplings served with soy sauce and sesame oil'),
('Beef Teppan', 10.50, 'Tender beef marinated in soy sauce and garlic, grilled to perfection'),
('Chicken Cutlet', 12.99, ''),
('Teriyaki Chicken', 10.00, ''),
('Beef Teriyaki', 11.50, ''),
('Mochi Ice Cream', 5.00, 'Selection of chocolate, mango, strawberry, or green tea flavors'),
('Cheesecake', 6.50, ''),
('Tempura Ice Cream', 7.00, 'Green tea ice cream with tempura with red beans and drizzled with chocolate sauce.'),
('Red Bean Paste Bun', 4.00, 'Steamed bun filled with sweet red bean paste'),
('Soft Drinks & Iced Teas', 4.00, 'Coke, Sprite, Diet Coke, Root Beer, Lemonade Orange Soda, Iced Tea, Iced Green Tea'),
('Strawberry Lemonade', 5.30, 'Fresh strawberry lemonade served chilled'),
('Ginger Ale', 4.00, 'Refreshing ginger-flavored soft drink'),
('Ginger Mojito', 12.99, 'Refreshing mojito with ginger infusion'),
('Blue Lagoon', 10.50, 'Bright blue cocktail with vodka and blue curaçao'),
('Beer', 11.50, 'Choice of local or imported beer'),
('Sake Bomb', 11.50, 'Sake served with a light beer'),
('Rodney Strong', 11.50, 'Chardonnay or Cabernet');

INSERT INTO Supplier (SupplierName, ContactName, PhoneNumber, Email, SupplierAddress) VALUES
('Fresh Farms Produce', 'John Doe', '(555) 123-4567', 'johndoe@freshfarms.com', '456 Greenway Lane, Riverside, CA 92506'),
('Seafood Fresh', 'Sarah Smith', '(555) 987-6543', 'sarah@seafoodfresh.com', '789 Ocean Drive, Riverside, CA 92506'),
('Quality Meats Co.', 'Mike Johnson', '(555) 543-2109', 'mike@qualitymeats.com', '321 Butcher St, Riverside, CA 92506'),
('Sushi Essentials', 'Emily Tan', '(555) 333-4444', 'emily@sushiestentials.com', '234 Sushi Ln, Riverside, CA 92506'),
('Organic Dairy Farms', 'Lisa Marie', '(555) 888-7777', 'lisa@organicdairy.com', '123 Dairy Rd, Riverside, CA 92506'),
('Gourmet Spice Co.', 'Samuel Lee', '(555) 222-8888', 'sam@spiceco.com', '678 Spice St, Riverside, CA 92506'),
('Sea Harvest Suppliers', 'Jennifer Brown', '(555) 444-9999', 'jenny@seaharvest.com', '234 Ocean Ave, Riverside, CA 92506'),
('Vegetable Growers Inc.', 'Robert Green', '(555) 666-4444', 'robert@veginc.com', '890 Green Way, Riverside, CA 92506'),
('Italian Herb Co.', 'Catherine White', '(555) 112-2334', 'catherine@herbco.com', '345 Herb St, Riverside, CA 92506'),
('Dim Sum Imports', 'Henry Wang', '(555) 777-0001', 'henry@dimsumimports.com', '567 Dumpling Ave, Riverside, CA 92506');

INSERT INTO InventoryItem (InventoryItemName, NumUnits, QuantityPerUnit, Units, ThresholdNumUnits, SupplierID) VALUES

-- Meat and Seafood (assumed SupplierID for Quality Meats)
('Chicken Breast', 20, 4, 'lb', 10, 3),
('Beef Sirloin', 20, 4, 'lb', 15, 3),
('Shrimp', 20, 4, 'lb', 5, 2),
('Salmon', 20, 4, 'lb', 12, 2),
('Tuna', 20, 4, 'lb', 8, 2),
('Crab', 20, 4, 'lb', 6, 2),

-- Vegetables (assumed SupplierID for Fresh Farms Produce)
('Cabbage', 20, 4, 'lb', 10, 1),
('Carrots', 20, 4, 'lb', 20, 1),
('Cucumber', 20, 4, 'lb', 25, 1),
('Avocado', 20, 4, 'lb', 18, 1),
('Mixed Greens', 20, 4, 'lb', 15, 1),
('Radish Sprouts', 20, 4, 'lb', 12, 1),

-- Seasonings and Sauces (assumed SupplierID for Gourmet Spice Co.)
('Soy Sauce', 50, 1, 'bottle', 30, 6),
('Teriyaki Sauce', 30, 1, 'bottle', 25, 6),
('Ponzu Sauce', 30, 1, 'bottle', 20, 6),
('Miso Paste', 20, 1, 'bottle', 15, 6),
('Tempura Batter Mix', 20, 4, 'lb', 10, 6),

-- Other (assumed SupplierID for Sushi Essentials)
('Sushi Rice', 50, 4, 'lb', 40, 4),
('Nori Seaweed', 100, 1, 'pack', 50, 4),
('Egg Roll Wrappers', 50, 1, 'pack', 4, 4),
('Gyoza Wrappers', 50, 1, 'pack', 4, 4),
('Tofu', 20, 4, 'lb', 30, 4),
('Garlic', 30, 1, 'lb', 25, 4),
('Ginger', 30, 1, 'lb', 25, 4),

-- Desserts (assumed SupplierID for Organic Dairy Farms)
('Mochi Ice Cream', 50, 1, 'pack', 15, 5),
('Cheesecake Ingredients', 30, 1, 'pack', 10, 5),
('Red Bean Paste', 20, 1, 'lb', 8, 4),
('Buns', 40, 1, 'pack', 20, 4),

-- Beverages (assumed SupplierID for Sea Harvest Suppliers)
('Soft Drinks & Iced Teas', 100, 1, 'bottle', 50, 7),
('Strawberries', 30, 1, 'lb', 20, 1),
('Lemonade', 50, 1, 'bottle', 30, 7),
('GingerAle', 50, 1,'bottle', 25, 7),

-- Alcohol (assumed SupplierID for Sea Harvest Suppliers)
('Rum', 20, 1, 'bottle', 10, 7),
('Vodka', 20, 1, 'bottle', 10, 7),
('Blue Curaçao', 20, 1,'bottle', 10, 7),
('Beer', 100, 1, 'bottle', 50, 7),
('Sake', 50, 1, 'bottle', 15, 7),
('Chardonnay', 30, 1, 'bottle', 20, 7),
('Cabernet', 30, 1, 'bottle', 20, 7);

INSERT INTO SupplierIngredientCatalog (SupplierID, InventoryItemID, UnitPrice) VALUES

-- Fresh Farms Produce (SupplierID = 1)
(1, 1, 5.00),   -- Chicken Breast
(1, 5, 0.75),   -- Red Onions
(1, 9, 2.00),   -- Cucumber
(1, 13, 2.00),  -- Avocado
(1, 22, 0.75),  -- Cabbage
(1, 1, 5.00),   -- Chicken Breast (Kids)
(1, 1, 5.00),   -- Chicken Breast for Teriyaki Chicken (Kids)

-- Seafood Fresh (SupplierID = 2)
(2, 3, 10.00),  -- Shrimp
(2, 4, 6.00),   -- Tuna
(2, 5, 12.00),  -- Crab
(2, 3, 10.00),  -- Fresh Salmon
(2, 2, 7.00),   -- Beef Sirloin (Kids)

-- Quality Meats Co. (SupplierID = 3)
(3, 21, 5.00),  -- Ground Pork
(3, 23, 0.50),  -- Soy Sauce
(3, 1, 5.00),   -- Chicken Breast
(3, 2, 7.00),   -- Beef Sirloin
(3, 4, 1.50),   -- Carrots 
(3, 24, 0.30),  -- Garlic
(3, 25, 0.30),  -- Ginger

-- Organic Dairy Farms (SupplierID = 4)
(4, 10, 2.50),  -- Cheese
(4, 16, 0.75),  -- Rice Vinegar
(4, 17, 0.50),  -- Sugar
(4, 18, 0.15),  -- Salt
(4, 19, 1.00),  -- Sesame Seeds
(4, 32, 1.50),  -- Tempura Batter

-- Sushi Essentials (SupplierID = 5)
(5, 3, 3.00),   -- Mixed Greens
(5, 41, 0.50),  -- Spicy Mayo
(5, 44, 10.00), -- Cheesecake Ingredients
(5, 46, 1.00),  -- Red Bean Paste
(5, 40, 0.30),  -- Nori Seaweed
(5, 39, 1.00),  -- Sushi Rice

-- Gourmet Spice Co. (SupplierID = 6)
(6, 26, 0.75),  -- Miso Paste
(6, 15, 1.50),  -- Soy Ginger Dressing
(6, 32, 1.50),  -- Tempura Batter
(6, 29, 0.30),  -- Scallions

-- Sea Harvest (SupplierID = 7)
(7, 8, 4.00),   -- Crispy Salmon Skin
(7, 11, 1.25),  -- Ponzu Sauce
(7, 12, 8.00),  -- Albacore Tuna

-- Vegetable Growers Inc. (SupplierID = 8)
(8, 4, 1.50),   -- Carrots
(8, 36, 1.50),  -- Mushrooms
(8, 35, 0.20),  -- Gyoza Wrappers
(8, 22, 0.75);  -- Cabbage

-- Customer dummy data
INSERT INTO Customer (CustomerName, CustomerEmail, PhoneNumber, Address) VALUES
	('John Smith', 'johnsmith@gmail.com', '1234567890', '123 Mag Ave, Riverside, CA'),
	('Jane Doe', 'janedoe@gmail.com', '2345678901', '123 Mag Ave, Riverside, CA'),
	('Ronald Ellis', 'rellis@gmail.com', '4567890123', '456 Mag Ave, Riverside, CA');

-- Reservation dummy data
INSERT INTO Reservation (CustomerID, ReservationDate, PartySize, Status, SpecialRequests) VALUES
	(1,'2024-11-15 18:30:00', 3, 'Confirmed', 'N/A'),
    	(2,'2024-11-15 15:00:00', 8, 'Cancelled', 'wheelchair accessible'),
	(3,'2024-11-16 19:00:00', 2, 'Confirmed', 'birthday');

-- Waitlist dummy data
INSERT INTO Waitlist(ReservationID, Position, DateAdded) VALUES
    (1, 1, '2024-11-16 12:00:00'),
    (2, 2, '2024-11-16 12:30:00'),
    (3, 3, '2024-11-16 13:00:00');
