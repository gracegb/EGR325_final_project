USE Restaurant;

INSERT INTO Reservation (CustomerID, TableID, TimeSlotID, ReservationDate, PartySize, Status, SpecialRequests)
VALUES 
    (1, 1, 1, '2024-11-26', 4, 'Confirmed', 'Window seat'),
    (2, 2, 1, '2024-11-26', 6, 'Confirmed', 'Birthday celebration');

CALL InsertReservationWithOverbooking(
    'Grace b', 
    'grace.b@example.com', 
    '123-456-7890', 
    '2024-11-26 12:00:00', 
    4, 
    'Allergy note'
);

SELECT ReservationID, Status, WaitlistPosition
FROM Reservation
WHERE DATE(ReservationDate) = '2024-11-26';

UPDATE Restaurant SET BaseCapacity = 10, OverbookingPercentage = 20 WHERE RestaurantID = 1;

CALL InsertReservationWithOverbooking(4, '2024-11-26 18:00:00', 4, 'None');
CALL InsertReservationWithOverbooking(5, '2024-11-26 18:00:00', 4, 'None');
CALL InsertReservationWithOverbooking(6, '2024-11-26 18:00:00', 4, 'None');

SELECT ReservationID, Status
FROM Reservation
WHERE DATE(ReservationDate) = '2024-11-26';


UPDATE TableAvailability SET IsAvailable = FALSE WHERE TableID = 1 AND TimeSlotID = 1;

CALL CancelReservation(1); -- Assuming ReservationID 1 is the reservation to cancel.

SELECT TableID, IsAvailable FROM TableAvailability WHERE TableID = 1 AND TimeSlotID = 1;
SELECT ReservationID, Status, TableID, WaitlistPosition FROM Reservation WHERE Status IN ('Confirmed', 'Waitlisted');


-- -- Verify that dining tables were successfully inserted
-- SELECT * FROM DiningTable;
-- -- Verify that all timeslots were successfully inserted
-- SELECT * FROM Timeslot;
-- -- Verify that all tables are mapped to timeslots with availability
-- SELECT * FROM TableAvailability;
-- -- Verify that the customers were successfully inserted
-- SELECT * FROM Customer;
-- -- Verify that reservations were successfully inserted
-- SELECT * FROM Reservation;

-- -- Verify the waitlist for the timeslot '18:30:00 - 19:00:00'
-- SELECT r.ReservationID, c.CustomerName, r.PartySize, r.WaitlistPosition
-- FROM Reservation r
-- JOIN Customer c ON r.CustomerID = c.CustomerID
-- WHERE r.Status = 'Waitlisted' AND r.TimeSlotID = (SELECT TimeSlotID FROM Timeslot WHERE StartTime = '18:00:00' AND EndTime = '18:30:00')
-- ORDER BY r.WaitlistPosition ASC;

-- -- Try inserting a reservation with overbooking
-- CALL InsertReservationWithOverbooking(1, '2024-11-25 18:30:00', 4, 'Birthday Celebration');

-- -- Cancel reservation with ID = 1 and promote the waitlisted reservation
-- CALL CancelReservation(1);

-- -- Verify the updated reservations after canceling reservation 1 and promoting the waitlist
-- SELECT r.ReservationID, c.CustomerName, r.Status, r.TableID, r.WaitlistPosition
-- FROM Reservation r
-- JOIN Customer c ON r.CustomerID = c.CustomerID
-- WHERE r.TimeSlotID = (SELECT TimeSlotID FROM Timeslot WHERE StartTime = '18:30:00' AND EndTime = '19:00:00')
-- ORDER BY r.WaitlistPosition ASC;

-- SELECT * FROM Timeslot;
-- SELECT * FROM DiningTable;
-- SELECT * FROM Customer;
-- SELECT * FROM Reservation;

-- SELECT TimeSlotID
-- FROM Timeslot
-- WHERE StartTime = '18:30:00' AND EndTime = '19:00:00';