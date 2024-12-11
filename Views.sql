USE Restaurant;

-- View to summarize confirmed reservations for each date and timeslot
CREATE VIEW ConfirmedReservations AS
SELECT 
    ReservationDate, 
    TimeSlotID, 
    COUNT(*) AS ConfirmedCount
FROM Reservation
WHERE ReservationStatus = 'Confirmed'
GROUP BY ReservationDate, TimeSlotID;

