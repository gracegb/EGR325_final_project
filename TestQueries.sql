USE Restaurant;

CALL InsertReservation(1, 1, 1, '2024-12-07 18:00:00', 4, 'Corner table');
CALL InsertReservation(2, 2, 2, '2024-12-07 20:00:00', 6, NULL);
CALL InsertReservation(3, 3, 1, '2024-12-08 18:00:00', 2, 'Romantic ambiance');

SELECT BaseCapacity, BaseCapacity + (BaseCapacity * OverbookingPercentage) AS OverbookingCapacity
FROM Restaurant;

SELECT COUNT(*) AS TotalReservations
FROM Reservation
WHERE ReservationDate = '2024-12-07 18:00:00'
  AND TimeSlotID = 1
  AND ReservationStatus = 'Confirmed';


SELECT COUNT(*) AS TotalReservationsIncludingWaitlist
FROM Reservation
WHERE ReservationDate = '2024-12-07 18:00:00'
  AND TimeSlotID = 1;
  
CALL CancelReservation(3);
CALL CancelReservation(5);

CALL PromoteFromWaitlist(6);


-- View all reservations
SELECT * FROM Reservation;

-- Check the waitlist positions
SELECT ReservationID, ReservationStatus, WaitlistPosition
FROM Reservation
WHERE ReservationStatus = 'Waitlisted';

-- Check table availability
SELECT * FROM DiningTable;

-- View any errors or unpromoted reservations
SELECT * FROM Reservation WHERE ReservationStatus = 'Waitlisted' ORDER BY WaitlistPosition;
