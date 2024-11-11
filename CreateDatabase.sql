CREATE DATABASE Restaurant;
USE Restaurant;
CREATE TABLE Customer (
	CustomerID INT NOT NULL auto_increment,
    CustomerName varchar(100) NOT NULL,
    CustomerEmail varchar(150) NOT NULL UNIQUE,
    PhoneNumber varchar(15) NOT NULL UNIQUE,
    Address varchar(225),
    PRIMARY KEY (CustomerID)
);
CREATE TABLE Reservation (
    ReservationID INT NOT NULL AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    ReservationDate DATETIME NOT NULL,
    NumberOfPeople INT NOT NULL,
    Status ENUM('Pending', 'Confirmed', 'Cancelled') DEFAULT 'Pending',
    SpecialRequests TEXT,
    PRIMARY KEY (ReservationID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE CASCADE
);
