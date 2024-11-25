USE Restaurant;
-- Verify that dining tables were successfully inserted
SELECT * FROM DiningTable;
-- Verify that all timeslots were successfully inserted
SELECT * FROM Timeslot;
-- Verify that all tables are mapped to timeslots with availability
SELECT * FROM TableAvailability;
-- Verify that the customers were successfully inserted
SELECT * FROM Customer;
-- Verify that reservations were successfully inserted
SELECT * FROM Reservation;

-- Verify the waitlist for the timeslot '18:30:00 - 19:00:00'
SELECT r.ReservationID, c.CustomerName, r.PartySize, r.WaitlistPosition
FROM Reservation r
JOIN Customer c ON r.CustomerID = c.CustomerID
WHERE r.Status = 'Waitlisted' AND r.TimeSlotID = (SELECT TimeSlotID FROM Timeslot WHERE StartTime = '18:30:00' AND EndTime = '19:00:00')
ORDER BY r.WaitlistPosition ASC;

-- Try inserting a reservation with overbooking
CALL InsertReservationWithOverbooking(1, '2024-11-25 18:30:00', 4, 'Birthday Celebration');

-- Cancel reservation with ID = 1 and promote the waitlisted reservation
CALL CancelReservation(1);

-- Verify the updated reservations after canceling reservation 1 and promoting the waitlist
SELECT r.ReservationID, c.CustomerName, r.Status, r.TableID, r.WaitlistPosition
FROM Reservation r
JOIN Customer c ON r.CustomerID = c.CustomerID
WHERE r.TimeSlotID = (SELECT TimeSlotID FROM Timeslot WHERE StartTime = '18:30:00' AND EndTime = '19:00:00')
ORDER BY r.WaitlistPosition ASC;
