# DUMMY DATA

INSERT INTO Restaurant (RestaurantID, Name, Location, PhoneNumber, OpeningHours) VALUES
	(1, 'Seaside Teppanyaki', '3525 Riverside Plaza Dr Ste 200 Riverside, CA 92506', '(248) 434-5508', '11:30 AM - 9:30 PM');

-- INSERT DIFFERENT MENUS
INSERT INTO Menu (MenuID, RestaurantID, MenuName, MenuDescription, StartTime, EndTime) VALUES
    (1, 1, 'Main', 'Menu of all the main entrees, appetizers, and non-alcoholic drinks', '11:30', '21:30'),
    (2, 1, 'Teppan', 'Menu of all the Teppan Items', '11:30', '21:30'),
    (3, 1, 'Sushi and Sahimi', 'All Suhsi entrees', '11:30', '21:30'),
    (4, 1, 'Happy Hour', 'Menu available for only a specific time period that offers customers better prices for selected items', '19:30', '20:30'),
    (5, 1, 'Kids', 'All Items come with a side of white or fried rice and miso soup. Must be under the age of 12','11:30', '21:30'),
    (6, 1, 'Dessert', 'Menu with only dessert items', '11:30', '21:30'),
    (7, 1, 'Beverages', 'Menu of non-alcoholic beverages', '11:30', '21:30'),
    (8, 1, 'Drink', 'Menu of alcoholic beverages', '11:30', '21:30');
    
-- Insert Menu Items for a sushi and teppanyaki place with MenuID reflecting different menu types

INSERT INTO MenuItem (MenuID, ItemName, Price, ItemDescription) VALUES 
(1, 'Cajun Chicken Salad', 13.00, 'Steamed soybeans with garlic, salt, or pepper'),
(1, 'Salmon Skin Salad', 16.00, 'Steamed soybeans with garlic, salt, or pepper'),
(1, 'Seared Albacore Salad', 16.00, 'Steamed soybeans with garlic, salt, or pepper'),
(1, 'Cucumber Salad', 7.00, 'Steamed soybeans with garlic, salt, or pepper'),

(1, 'Eggrolls', 4.50, 'Traditional Japanese soup with tofu, seaweed, and scallions'),
(1, 'Miso Soup', 4.50, 'Traditional Japanese soup with tofu, seaweed, and scallions'),
(1, 'Edamame', 8.00, 'Steamed soybeans with garlic, salt, or pepper'),

(1, 'Shrimp Tempura', 13.99, 'Lightly battered and fried shrimp with tempura sauce'),
(1, 'Vegetable Gyoza', 7.50, 'Pan-fried vegetable dumplings served with soy sauce'),
(1, 'Miso Soup', 4.50, 'Traditional Japanese soup with tofu, seaweed, and scallions'),

# TEPPAN ITEMS
(2, 'Chicken Teppanyaki', 15.99, 'Grilled chicken with mixed vegetables and special sauce'),
(2, 'Beef Teppanyaki', 17.99, 'Teppanyaki grilled beef with fried rice and vegetables'),

# SUSHI ITEMS
(3, 'Sunset Roll', 12.99, 'A delicious sushi roll with fresh salmon and avocado'),
(3, 'California Roll', 10.00, 'A classic sushi roll with crab, avocado, and cucumber'),
(3, 'Spicy Tuna Roll', 11.50, 'Sushi roll with spicy tuna, cucumber, and tobiko'),
(1, 'Salmon Sashimi', 14.00, 'Fresh slices of salmon served with soy sauce and wasabi'),
# HAPPY HOUR
(4, 'item1', 12.99, 'des1'),
(4, 'item2', 10.00, 'des2'),
(4, 'item3', 11.50, 'des3'),

# KIDS ITEMS
(5, 'Chicken Cutlet', 12.99, ''),
(5, 'Teriyaki Chicken', 10.00, ''),
(5, 'Beef Terriyaki', 11.50, ''),

# DESSERT ITEMS 
(6, 'Mochi Ice Cream', 5.00, 'Selection of chocolate, mango, strawberry, or green tea flavors'),
(6, 'Cheesecake', 6.50, ''),
(6, 'Tempura Ice Cream', 7.00, 'Green tea ice cream with tempura with red beans and drizzled with chocolate sauce.'),
(6, 'Red Bean Paste Bun', 4.00, 'Steamed bun filled with sweet red bean paste'),

# Beverage ITEMS
(7, 'Soft Drinks & Iced Teas', 4.00, 'Coke, Sprite, Diet Coke, Root Beer, Lemonade Orange Soda, Iced Tea, Iced Green Tea'),
(7, 'Strawberry Lemonade', 5.30, 'des2'),
(7, 'GingerAle', 4.00, 'des3'),

# Alcoholic Drink ITEMS
(7, 'Ginger Mojito', 12.99, 'des1'),
(7, 'Blue Lagoon', 10.50, 'des2'),
(7, 'Beer', 11.50, 'des3'),
(7, 'Sake Bomb', 11.50, 'des3'),
(7, 'Rodney Strong', 11.50, 'Chardonnay or Cabernet');


INSERT INTO InventoryItem (ItemName, NumUnits, QuantityPerUnit, Units) VALUES
-- Meat and Seafood
('Chicken Breast', 20, 4, 'lb'),
('Beef Sirloin', 20, 4, 'lb'),
('Shrimp', 20, 4, 'lb'),
('Salmon', 20, 4, 'lb'),
('Tuna', 20, 4, 'lb'),
('Crab', 20, 4, 'lb'),

-- Vegetables
('Cabbage', 20, 4, 'lb'),
('Carrots', 20, 4, 'lb'),
('Cucumber', 20, 4, 'lb'),
('Avocado', 20, 4, 'lb'),
('Mixed Greens', 20, 4, 'lb'),
('Radish Sprouts', 20, 4, 'lb'),

-- Seasonings and Sauces
('Soy Sauce', 50, 1, 'bottle'),
('Teriyaki Sauce', 30, 1, 'bottle'),
('Ponzu Sauce', 30, 1, 'bottle'),
('Miso Paste', 20, 1, 'bottle'),
('Tempura Batter Mix', 20, 4, 'lb'),

-- Other
('Sushi Rice', 50, 4, 'lb'),
('Nori Seaweed', 100, 1, 'pack'),
('Egg Roll Wrappers', 50, 1, 'pack'),
('Gyoza Wrappers', 50, 1, 'pack'),
('Tofu', 20, 4, 'lb'),
('Garlic', 30, 1, 'lb'),
('Ginger', 30, 1, 'lb'),

-- Desserts
('Mochi Ice Cream', 50, 1, 'pack'),
('Cheesecake Ingredients', 30, 1, 'pack'),
('Red Bean Paste', 20, 1, 'lb'),
('Buns', 40, 1, 'pack'),

-- Beverages
('Soft Drinks & Iced Teas', 100, 1, 'bottle'),
('Strawberries', 30, 1, 'lb'),
('Lemonade', 50, 1, 'bottle'),
('GingerAle', 50, 1,'bottle'),

-- Alcohol
('Rum', 20, 1, 'bottle'),
('Vodka', 20, 1, 'bottle'),
('Blue Curaçao', 20, 1,'bottle'),
('Beer', 100, 1, 'bottle'),
('Sake', 50, 1, 'bottle'),
('Chardonnay', 30, 1, 'bottle'),
('Cabernet', 30, 1, 'bottle');

INSERT INTO Ingredient (MenuItemID, InventoryItemID, Quantity, Units) VALUES 
-- Cajun Chicken Salad
(1, 1, 0.5, 'lb'),  -- Chicken Breast
(1, 2, 2, 'tsp'),  -- Cajun Seasoning
(1, 3, 2, 'cup'),  -- Mixed Greens
(1, 4, 0.5, 'cup'),  -- Cherry Tomatoes
(1, 5, 0.25, 'cup'),  -- Red Onions
(1, 6, 0.25, 'cup'),  -- Bell Peppers
(1, 7, 3, 'tbsp'),  -- Ranch Dressing

-- Salmon Skin Salad
(2, 8, 0.25, 'lb'),  -- Crispy Salmon Skin
(2, 3, 2, 'cup'),  -- Mixed Greens
(2, 9, 1, 'cup'),  -- Cucumber
(2, 10, 0.25, 'cup'),  -- Radish Sprouts
(2, 11, 3, 'tbsp'),  -- Ponzu Sauce

-- Seared Albacore Salad
(3, 12, 0.5, 'lb'),  -- Albacore Tuna
(3, 3, 2, 'cup'),  -- Mixed Greens
(3, 13, 1, 'cup'),  -- Avocado
(3, 14, 0.25, 'cup'),  -- Crispy Onions
(3, 15, 3, 'tbsp'),  -- Soy Ginger Dressing

-- Cucumber Salad
(4, 9, 1, 'cup'),  -- Cucumber
(4, 16, 0.25, 'cup'),  -- Rice Vinegar
(4, 17, 1, 'tbsp'),  -- Sugar
(4, 18, 0.5, 'tsp'),  -- Salt
(4, 19, 1, 'tbsp'),  -- Sesame Seeds

-- Eggrolls
(5, 20, 10, 'pcs'),  -- Egg Roll Wrappers
(5, 21, 0.5, 'lb'),  -- Ground Pork
(5, 22, 1, 'cup'),  -- Cabbage
(5, 4, 1, 'cup'),  -- Carrots
(5, 23, 3, 'tbsp'),  -- Soy Sauce
(5, 24, 1, 'tbsp'),  -- Garlic
(5, 25, 1, 'tbsp'),  -- Ginger

-- Miso Soup
(6, 26, 3, 'tbsp'),  -- Miso Paste
(6, 27, 0.25, 'lb'),  -- Tofu
(6, 28, 0.25, 'cup'),  -- Seaweed
(6, 29, 2, 'tbsp'),  -- Scallions

-- Edamame
(7, 30, 1, 'lb'),  -- Edamame
(7, 24, 1, 'tbsp'),  -- Garlic
(7, 18, 1, 'tsp'),  -- Salt
(7, 31, 0.5, 'tsp'),  -- Pepper

-- Shrimp Tempura
(8, 3, 0.5, 'lb'),  -- Shrimp
(8, 32, 1, 'cup'),  -- Tempura Batter Mix
(8, 33, 2, 'cup'),  -- Vegetable Oil
(8, 34, 0.25, 'cup'),  -- Tempura Sauce

-- Vegetable Gyoza
(9, 35, 10, 'pcs'),  -- Gyoza Wrappers
(9, 22, 1, 'cup'),  -- Cabbage
(9, 4, 1, 'cup'),  -- Carrots
(9, 36, 0.5, 'cup'),  -- Mushrooms
(9, 24, 1, 'tbsp'),  -- Garlic
(9, 23, 3, 'tbsp'),  -- Soy Sauce

-- Chicken Teppanyaki
(10, 1, 0.5, 'lb'),  -- Chicken Breast
(10, 37, 1, 'cup'),  -- Mixed Vegetables
(10, 23, 3, 'tbsp'),  -- Soy Sauce
(10, 24, 1, 'tbsp'),  -- Garlic
(10, 38, 3, 'tbsp'),  -- Teppanyaki Sauce

-- Beef Teppanyaki
(11, 2, 0.5, 'lb'),  -- Beef Sirloin
(11, 37, 1, 'cup'),  -- Mixed Vegetables
(11, 23, 3, 'tbsp'),  -- Soy Sauce
(11, 24, 1, 'tbsp'),  -- Garlic
(11, 38, 3, 'tbsp'),  -- Teppanyaki Sauce

-- Sunset Roll
(12, 3, 0.25, 'lb'),  -- Fresh Salmon
(12, 13, 1, 'cup'),  -- Avocado
(12, 39, 1, 'cup'),  -- Sushi Rice
(12, 40, 1, 'sheet'),  -- Nori Seaweed

-- California Roll
(13, 5, 0.25, 'lb'),  -- Crab
(13, 13, 1, 'cup'),  -- Avocado
(13, 9, 1, 'cup'),  -- Cucumber
(13, 39, 1, 'cup'),  -- Sushi Rice
(13, 40, 1, 'sheet'),  -- Nori Seaweed

-- Spicy Tuna Roll
(14, 4, 0.25, 'lb'),  -- Tuna
(14, 41, 2, 'tbsp'),  -- Spicy Mayo
(14, 9, 1, 'cup'),  -- Cucumber
(14, 39, 1, 'cup'),  -- Sushi Rice
(14, 40, 1, 'sheet'),  -- Nori Seaweed

-- Salmon Sashimi
(15, 3, 0.25, 'lb'),  -- Fresh Salmon

-- Chicken Cutlet (Kids)
(16, 1, 0.5, 'lb'),  -- Chicken Breast
(16, 42, 1, 'cup'),  -- Panko Breadcrumbs

-- Teriyaki Chicken (Kids)
(17, 1, 0.5, 'lb'),  -- Chicken Breast
(17, 23, 3, 'tbsp'),  -- Teriyaki Sauce

-- Beef Teriyaki (Kids)
(18, 2, 0.5, 'lb'),  -- Beef Sirloin
(18, 23, 3, 'tbsp'),  -- Teriyaki Sauce

-- Mochi Ice Cream
(19, 43, 1, 'pack'),  -- Mochi Ice Cream

-- Cheesecake
(20, 44, 1, 'pack'),  -- Cheesecake Ingredients

-- Tempura Ice Cream
(21, 32, 1, 'cup'),  -- Tempura Batter
(21, 45, 1, 'scoop'),  -- Green Tea Ice Cream
(21, 46, 1, 'tbsp'),  -- Red Bean Paste

-- Red Bean Paste Bun
(22, 46, 1, 'tbsp'),  -- Red Bean Paste
(22, 47, 1, 'bun'),  -- Steamed Bun

-- Soft Drinks & Iced Teas
(23, 48, 1, 'bottle'),  -- Soft Drinks & Iced Teas

-- Strawberry Lemonade
(24, 49, 1, 'cup'),  -- Lemonade
(24, 50, 1, 'cup'),  -- Strawberries

-- Ginger Ale
(25, 51, 1, 'bottle'),  -- Ginger Ale

-- Ginger Mojito
(26, 52, 1, 'bottle'),  -- Rum
(26, 24, 1, 'tbsp'),  -- Mint
(26, 16, 1, 'tsp'),  -- Lime Juice

-- Blue Lagoon
(27, 53, 1, 'bottle'),  -- Vodka
(27, 54, 1, 'bottle'),  -- Blue Curaçao

-- Beer
(28, 55, 1, 'bottle'),  -- Beer

-- Sake Bomb
(29, 56, 1, 'bottle');  -- Sake

INSERT INTO Suppliers (SupplierName, ContactName, PhoneNumber, EmailAddress, SupplierAddress) VALUES
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
INSERT INTO Customer (CustomerID, CustomerName, CustomerEmail, PhoneNumber, Address) VALUES
	(4, 'John Smith', 'johnsmith@gmail.com', '1234567890', '123 Mag Ave, Riverside, CA'),
	(6, 'Jane Doe', 'janedoe@gmail.com', '2345678901', '123 Mag Ave, Riverside, CA'),
	(8, 'Ronald Ellis', 'rellis@gmail.com', '4567890123', '456 Mag Ave, Riverside, CA');

-- Reservation dummy data
INSERT INTO Reservation (CustomerID, ReservationDate, NumberOfPeople, Status, SpecialRequests) VALUES
	(4, '2024-11-15 18:30:00', 3, 'Confirmed', 'N/A'),
    	(6, '2024-11-15 15:00:00', 8, 'Cancelled', 'wheelchair accessible'),
	(8, '2024-11-16 19:00:00', 2, 'Confirmed', 'birthday');

-- Waitlist dummy data
INSERT INTO Waitlist(ReservationID, Position, DateAdded) VALUES
    (1, 1, '2024-11-16 12:00:00'),
    (2, 2, '2024-11-16 12:30:00'),
    (3, 3, '2024-11-16 13:00:00');
