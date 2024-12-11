USE Restaurant;

DELIMITER $$

CREATE FUNCTION IsReservationAvailable(
    p_ReservationDate DATETIME,
    p_TimeSlotID INT
) RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE v_BaseCapacity INT;
    DECLARE v_ConfirmedReservations INT;
    
    -- Retrieve the base capacity of the restaurant
    SELECT BaseCapacity INTO v_BaseCapacity
    FROM Restaurant;
    
    -- Count the number of confirmed reservations for the given date and timeslot
    SELECT COUNT(*) INTO v_ConfirmedReservations
    FROM Reservation
    WHERE ReservationDate = p_ReservationDate
      AND TimeSlotID = p_TimeSlotID
      AND ReservationStatus = 'Confirmed';
    
    -- Check if the confirmed reservations exceed the base capacity
    RETURN v_ConfirmedReservations < v_BaseCapacity;
END$$

DELIMITER ;