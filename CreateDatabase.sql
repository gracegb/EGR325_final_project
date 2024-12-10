DROP DATABASE restaurant;
CREATE DATABASE IF NOT EXISTS restaurant;
USE restaurant;

-- Restaurant Information
CREATE TABLE Restaurant (
    RestaurantID INT PRIMARY KEY DEFAULT 1,
    RestaurantName VARCHAR(255) NOT NULL UNIQUE,
    Location VARCHAR(255),
    PhoneNumber VARCHAR(15),
    OpeningHours VARCHAR(100),
    BaseCapacity INT NOT NULL DEFAULT 100,
    OverbookingPercentage DECIMAL(5, 2) NOT NULL DEFAULT 0.2
);

-- Dining Tables
CREATE TABLE DiningTable (
    TableID INT AUTO_INCREMENT PRIMARY KEY,
    Seats INT NOT NULL,
    TableType VARCHAR(50),
    IsAvailable BOOLEAN DEFAULT TRUE -- Optional, for tracking overall status
);

-- Time Slots
CREATE TABLE Timeslot (
    TimeSlotID INT AUTO_INCREMENT PRIMARY KEY,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL
);

-- Table Availability (Joining Table)
CREATE TABLE TableAvailability (
    AvailabilityID INT AUTO_INCREMENT PRIMARY KEY,
    TableID INT NOT NULL,
    TimeSlotID INT NOT NULL,
    IsAvailable BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (TableID) REFERENCES DiningTable(TableID),
    FOREIGN KEY (TimeSlotID) REFERENCES Timeslot(TimeSlotID)
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

-- Reservations (Updated to move WaitlistPosition to this table)
CREATE TABLE Reservation (
    ReservationID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    TableID INT NOT NULL,
    TimeSlotID INT NOT NULL,
    ReservationDate DATETIME NOT NULL,
    PartySize INT NOT NULL,
    WaitlistPosition INT DEFAULT NULL,   -- Moved WaitlistPosition to Reservation table
    ReservationStatus ENUM('Confirmed', 'Waitlisted') DEFAULT 'Confirmed',
    SpecialRequests TEXT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (TableID) REFERENCES DiningTable(TableID),
    FOREIGN KEY (TimeSlotID) REFERENCES Timeslot(TimeSlotID)
);

-- Menu
CREATE TABLE Menu (
    MenuID INT AUTO_INCREMENT PRIMARY KEY,
    RestaurantID INT DEFAULT 1,
    MenuName VARCHAR(255) NOT NULL UNIQUE,    -- e.g., 'Happy Hour', 'Dessert'
    MenuDescription TEXT,
    StartTime TIME NOT NULL,       -- Start time for menu availability
    EndTime TIME NOT NULL,         -- End time for menu availability
    IsActive BOOLEAN DEFAULT FALSE, -- Automatically updated
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID)
);

-- Menu Item
CREATE TABLE MenuItem (
    MenuItemID INT AUTO_INCREMENT PRIMARY KEY,
    MenuItemName VARCHAR(255) NOT NULL,    -- e.g., 'Chocolate Lava Cake'
    Price DECIMAL(10, 2) NOT NULL,
    ItemDescription TEXT
);

-- Menu Content
CREATE TABLE MenuContent (
    MenuID INT NOT NULL,
    MenuItemID INT NOT NULL,
    FOREIGN KEY (MenuID) REFERENCES Menu(MenuID),
    FOREIGN KEY (MenuItemID) REFERENCES MenuItem(MenuItemID)
);

-- Supplier
CREATE TABLE Supplier (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierName VARCHAR(255) NOT NULL,    -- e.g., 'Fresh Farm Supplies'
    ContactName VARCHAR(255),
    PhoneNumber VARCHAR(15),
    Email VARCHAR(255),
    SupplierAddress VARCHAR(255)
);

-- Inventory
CREATE TABLE InventoryItem ( -- Assumptions: Only ONE INVENTORY
    InventoryItemID INT AUTO_INCREMENT PRIMARY KEY,
    InventoryItemName VARCHAR(255) NOT NULL,    -- e.g., 'Flour', 'Sugar'
    TotalUnits INT,
    AmountPerUnit SMALLINT,
    UnitType VARCHAR(50), -- 'liters' 'Cups' 'Gallons,' 'lb', 'kg', ' 'oz'
    Threshold INT
);

-- Ingredient
CREATE TABLE Ingredient (
    MenuItemID INT NOT NULL,
    InventoryItemID INT NOT NULL,
    Quantity DECIMAL(10, 2) NOT NULL, -- Quantity needed for the menu item
    UnitType VARCHAR(50),
    FOREIGN KEY (MenuItemID) REFERENCES MenuItem(MenuItemID),
    FOREIGN KEY (InventoryItemID) REFERENCES InventoryItem(InventoryItemID)
);

-- SupplierIngredient join table
CREATE TABLE SupplierCatalog (
    SupplierID INT NOT NULL,
    InventoryItemID INT NOT NULL,
    UnitPrice DECIMAL(5,2) NOT NULL
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID),
    FOREIGN KEY (InventoryItemID) REFERENCES InventoryItem(InventoryItemID)
);
