--Restaurant Data
INSERT INTO Restaurant (RestaurantID, Name, Location, PhoneNumber, OpeningHours) VALUES
	(1, 'Seaside Teppanyaki', '3525 Riverside Plaza Dr Ste 200 Riverside, CA 92506', '(248) 434-5508', '11:30 AM - 9:30 PM');

INSERT INTO Menu (MenuID, RestaurantID, Name, Description, StartTime, EndTime) VALUES
	(1, 1, 'Main', 'Menu of all the main entrees, appetizers, and non-alcoholic drinks', 11:30, 21:30)
	(2, 1, 'Dessert', 'Menu with only dessert items', 11:30, 21:30)
	(3, 1, 'Drink', 'Menu of alcoholic beverages', 11:30, 21:30)
	(4, 1, 'Happy Hour', 'Menu available for only a specific time period that offers customers better prices', 11:30, 21:30)
	(5, 1, 'Kids', 'Menu Items for kids under the age of 12 with smaller portions and cheaper prices', 11:30, 21:30);
	
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
