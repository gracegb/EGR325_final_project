USE Restaurant;

CALL InsertReservation(1, 2, 3, '2024-12-25 19:00:00', 4, 'Window seat preferred');

CALL CancelReservation(3);

SELECT * FROM Reservation;

CALL PromoteFromWaitlist(1);





-- -- Set the base capacity and overbooking percentage for testing
-- UPDATE Restaurant SET BaseCapacity = 5, OverbookingPercentage = 0.2 WHERE RestaurantID = 1;

-- -- Insert reservations up to the base capacity
-- CALL InsertReservationWithOverbooking('Alice A', 'alice.a@example.com', '555-123-4561', '2024-12-01 18:00:00', 2, 'Anniversary dinner');
-- CALL InsertReservationWithOverbooking('Bob B', 'bob.b@example.com', '555-123-4562', '2024-12-01 18:00:00', 2, 'Business meeting');
-- CALL InsertReservationWithOverbooking('Carol C', 'carol.c@example.com', '555-123-4563', '2024-12-01 18:00:00', 1, 'None');
-- CALL InsertReservationWithOverbooking('David D', 'david.d@example.com', '555-123-4564', '2024-12-01 18:00:00', 1, 'None');
-- CALL InsertReservationWithOverbooking('Eve E', 'eve.e@example.com', '555-123-4565', '2024-12-01 18:00:00', 2, 'None'); -- Should trigger waitlist

-- -- Check the reservations and waitlist
-- SELECT CustomerID, Status, WaitlistPosition FROM Reservation WHERE DATE(ReservationDate) = '2024-12-01';


-- -- Cancel a reservation and verify waitlist updates
-- UPDATE Reservation SET Status = 'Canceled' WHERE CustomerID = 2 AND DATE(ReservationDate) = '2024-12-01';

-- -- Check waitlist positions after cancellation
-- SELECT CustomerID, Status, WaitlistPosition FROM Reservation WHERE DATE(ReservationDate) = '2024-12-01';




-- -- Attempt to overbook beyond the allowed percentage
-- CALL InsertReservationWithOverbooking('Frank F', 'frank.f@example.com', '555-123-4566', '2024-12-01 18:00:00', 2, 'None');
-- CALL InsertReservationWithOverbooking('Grace G', 'grace.g@example.com', '555-123-4567', '2024-12-01 18:00:00', 2, 'None');

-- -- Verify no additional reservations were added beyond capacity and overbooking limit
-- SELECT CustomerID, Status, WaitlistPosition FROM Reservation WHERE DATE(ReservationDate) = '2024-12-01';


-- -- Insert a large party that cannot fit within the remaining overbooking capacity
-- CALL InsertReservationWithOverbooking('Hannah H', 'hannah.h@example.com', '555-123-4568', '2024-12-01 18:00:00', 6, 'Family gathering');

-- -- Verify that the reservation was not confirmed and placed on the waitlist
-- SELECT CustomerID, Status, WaitlistPosition FROM Reservation WHERE DATE(ReservationDate) = '2024-12-01';


-- -- Mark all tables as available and test if waitlist customers are promoted
-- UPDATE TableAvailability SET IsAvailable = TRUE WHERE Date = '2024-12-01';

-- -- Check if waitlist reservations are promoted
-- SELECT CustomerID, Status, WaitlistPosition FROM Reservation WHERE DATE(ReservationDate) = '2024-12-01';




