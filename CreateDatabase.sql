CREATE DATABASE IF NOT EXISTS Restaurant;
USE Restaurant;

-- Make a clean slate for testing/working with the data :)
DROP TABLE IF EXISTS Waitlist;
DROP TABLE IF EXISTS Reservation;
DROP TABLE IF EXISTS Customer;

-- Restaurant Information
CREATE TABLE Restaurant (
    RestaurantID INT PRIMARY KEY DEFAULT 1,
    Name VARCHAR(255) NOT NULL,
    Location VARCHAR(255),
    PhoneNumber VARCHAR(15),
    OpeningHours VARCHAR(100),
    BaseCapacity INT NOT NULL,
    OverbookingPercentage DECIMAL(5, 2) NOT NULL
);

CREATE TABLE Menu (
    MenuID INT AUTO_INCREMENT PRIMARY KEY,
    RestaurantID INT DEFAULT 1,
    Name VARCHAR(255) NOT NULL,    -- e.g., 'Happy Hour', 'Dessert'
    Description TEXT,
    StartTime TIME NOT NULL,       -- Start time for menu availability
    EndTime TIME NOT NULL,         -- End time for menu availability
    IsActive BOOLEAN DEFAULT FALSE, -- Automatically updated
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID)
);

CREATE TABLE MenuItem (
    MenuItemID INT AUTO_INCREMENT PRIMARY KEY,
    MenuID INT NOT NULL,
    Name VARCHAR(255) NOT NULL,    -- e.g., 'Chocolate Lava Cake'
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (MenuID) REFERENCES Menu(MenuID)
);

CREATE TABLE Ingredient (
    IngredientID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,    -- e.g., 'Flour', 'Sugar'
    Unit VARCHAR(50),              -- e.g., 'kg', 'liters'
    SupplierID INT NOT NULL,
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);

CREATE TABLE Inventory (
    InventoryID INT AUTO_INCREMENT PRIMARY KEY,
    IngredientID INT NOT NULL,
    Quantity DECIMAL(10, 2) NOT NULL,
    LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (IngredientID) REFERENCES Ingredient(IngredientID)
);

CREATE TABLE Supplier (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,    -- e.g., 'Fresh Farm Supplies'
    ContactName VARCHAR(255),
    PhoneNumber VARCHAR(15),
    Email VARCHAR(255),
    Address VARCHAR(255)
);

CREATE TABLE SupplierIngredientCatalog (
	SupplierID INT NOT NULL,
	IngredientID INT NOT NULL,
	UnitPrice DECIMAL(5,2) NOT NULL
);

CREATE TABLE MenuItemIngredient (
    MenuItemIngredientID INT AUTO_INCREMENT PRIMARY KEY,
    MenuItemID INT NOT NULL,
    IngredientID INT NOT NULL,
    QuantityRequired DECIMAL(10, 2) NOT NULL, -- Quantity needed for the menu item
    FOREIGN KEY (MenuItemID) REFERENCES MenuItem(MenuItemID),
    FOREIGN KEY (IngredientID) REFERENCES Ingredient(IngredientID)
);

-- Customers
CREATE TABLE Customer (
	CustomerID INT NOT NULL AUTO_INCREMENT,
    CustomerName VARCHAR(100) NOT NULL,
    CustomerEmail VARCHAR(150) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(15) NOT NULL UNIQUE,
    Address VARCHAR(225),
    PRIMARY KEY (CustomerID)
);

-- Reservations
CREATE TABLE Reservation (
    ReservationID INT NOT NULL AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    ReservationDate DATETIME NOT NULL,
    PartySize INT NOT NULL,
    Status ENUM('Pending', 'Confirmed', 'Cancelled', 'Waitlisted') DEFAULT 'Pending',
    SpecialRequests TEXT,
    PRIMARY KEY (ReservationID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE CASCADE
);

CREATE TABLE RestaurantTableReservation ( --Creates a list of reservations at a given table (Teppan tables can have multiple parties/reservations)
	ReservationID
	TableID
)

CREATE TABLE RestaurantTable (
	TableID int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	Type VARCHAR(50),
	Seats SMALLINT(10)	
);

-- Create the Waitlist table
CREATE TABLE Waitlist (
    WaitlistID INT NOT NULL AUTO_INCREMENT,
    ReservationID INT NOT NULL,
    Position INT NOT NULL,
    DateAdded DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (WaitlistID),
    FOREIGN KEY (ReservationID) REFERENCES Reservation(ReservationID) ON DELETE CASCADE
);

--STORED PROCEDURES

-- set pos in waitlist automatically
DELIMITER $$
-- clear if exists already
DROP PROCEDURE IF EXISTS SetWaitlistPosition$$
CREATE TRIGGER SetWaitlistPosition
BEFORE INSERT ON Waitlist
FOR EACH ROW
BEGIN
    SET NEW.Position = (SELECT IFNULL(MAX(Position), 0) + 1 FROM Waitlist);
END$$
DELIMITER ;

-- move res to the waitlist
DELIMITER $$
-- clear if exists already
DROP PROCEDURE IF EXISTS MoveToWaitlist$$
CREATE PROCEDURE MoveToWaitlist(IN reservationId INT)
BEGIN
    UPDATE Reservation
    SET Status = 'Waitlisted'
    WHERE ReservationID = reservationId;

    INSERT INTO Waitlist (ReservationID)
    VALUES (reservationId);
END$$
DELIMITER ;

--checks if reservation list is overbooked
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
--get base capacity from restaurant info table
    SELECT BaseCapacity, OverbookingPercentage INTO base_capacity, overbooking_percentage
    FROM Restaurant
    WHERE RestaurantID = 1;  
--calc overbooking limit
    SET overbooking_limit = base_capacity * (1 + (overbooking_percentage / 100));
--get current people (MODIFY)
    SELECT COUNT(*) INTO current_reservations
    FROM Reservation
    WHERE DATE(ReservationDate) = DATE(p_ReservationDate);
--check if next reservation is within limit
    IF current_reservations < overbooking_limit THEN
        INSERT INTO Reservation (CustomerID, ReservationDate, NumberOfPeople, Status, SpecialRequests)
        VALUES (p_CustomerID, p_ReservationDate, p_NumberOfPeople, 'Confirmed', p_SpecialRequests);
    ELSE
        INSERT INTO Reservation (CustomerID, ReservationDate, NumberOfPeople, Status, SpecialRequests)
        VALUES (p_CustomerID, p_ReservationDate, p_NumberOfPeople, 'Waitlisted', p_SpecialRequests);
    END IF;
END $$
DELIMITER ;
