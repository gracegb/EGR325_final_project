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
