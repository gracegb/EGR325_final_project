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

INSERT INTO Customer (CustomerName, CustomerEmail, PhoneNumber, Address) VALUES
	('John Smith', 'johnsmith@gmail.com', '1234567890', '123 Mag Ave, Riverside, CA'),
	('Jane Doe', 'janedoe@gmail.com', '2345678901', '123 Mag Ave, Riverside, CA'),
	('Ronald Ellis', 'rellis@gmail.com', '4567890123', '456 Mag Ave, Riverside, CA');
    
INSERT INTO Reservation (CustomerID, ReservationDate, NumberOfPeople, NumberOfPeople, Status, SpecialRequests) VALUES
	(1, '2024-11-15 18:30:00', 3, 'Confirmed', 'N/A'),
    (2, '2024-11-15 15:00:00', 8, 'Cancelled', 'wheelchair accessible'),
	(3, '2024-11-16 19:00:00', 2, 'Confirmed', 'birthday');

    