USE Restaurant;

-- Create new reservations
CALL InsertReservation(1, 1, 1, '2024-12-07 18:00:00', 4, 'Corner table');
CALL InsertReservation(2, 2, 2, '2024-12-07 20:00:00', 6, NULL);
CALL InsertReservation(3, 3, 1, '2024-12-08 18:00:00', 2, 'Romantic ambiance');

-- shows restaurant basecapacity and overbooked capacity
SELECT BaseCapacity, BaseCapacity + (BaseCapacity * OverbookingPercentage) AS OverbookingCapacity
FROM Restaurant;

-- shows we have 3 confirmed reservations for the selected date
SELECT COUNT(*) AS TotalReservations
FROM Reservation
WHERE ReservationDate = '2024-12-07 18:00:00'
  AND TimeSlotID = 1
  AND ReservationStatus = 'Confirmed';

-- 4 reservations total (1 on the waitlist)
SELECT COUNT(*) AS TotalReservationsIncludingWaitlist
FROM Reservation
WHERE ReservationDate = '2024-12-07 18:00:00'
  AND TimeSlotID = 1;
  
-- cancel reservations
CALL CancelReservation(3);
CALL CancelReservation(5);

-- manually promotes reservation 6
CALL PromoteFromWaitlist(6);


-- View all reservations
SELECT * FROM Reservation;

-- Check the waitlist positions -- no one is waitlisted any longer
SELECT ReservationID, ReservationStatus, WaitlistPosition
FROM Reservation
WHERE ReservationStatus = 'Waitlisted';

-- Check table availability
SELECT * FROM DiningTable;

-- Use function to see if reservation is available
SELECT IsReservationAvailable('2024-12-07 18:00:00', 1) AS IsAvailable;

-- Use view to see confirmed reservations
SELECT * FROM ConfirmedReservations;

-- View any errors or unpromoted reservations
SELECT * FROM Reservation WHERE ReservationStatus = 'Waitlisted' ORDER BY WaitlistPosition;
