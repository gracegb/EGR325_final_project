USE Restaurant;

DELIMITER $$

CREATE TRIGGER BeforeInsertReservation
BEFORE INSERT ON Reservation
FOR EACH ROW
BEGIN
    DECLARE v_BaseCapacity INT;
    DECLARE v_OverbookingCapacity INT;
    DECLARE v_TotalReservations INT;

    -- Retrieve the base capacity and overbooking capacity from the Restaurant table
    SELECT BaseCapacity, BaseCapacity + (BaseCapacity * OverbookingPercentage / 100)
    INTO v_BaseCapacity, v_OverbookingCapacity
    FROM Restaurant
    LIMIT 1;

    -- Count the total number of confirmed reservations for the same date and timeslot
    SELECT COUNT(*) INTO v_TotalReservations
    FROM Reservation
    WHERE ReservationDate = NEW.ReservationDate
      AND TimeSlotID = NEW.TimeSlotID
      AND ReservationStatus = 'Confirmed';

    -- Validate the capacity
    IF v_TotalReservations < v_BaseCapacity THEN
        -- Set the status to 'Confirmed' if within base capacity
        SET NEW.ReservationStatus = 'Confirmed';
    ELSEIF v_TotalReservations < v_OverbookingCapacity THEN
        -- Set the status to 'Waitlisted' if within overbooking capacity
        SET NEW.ReservationStatus = 'Waitlisted';
    ELSE
        -- Prevent the operation if overbooking capacity is exceeded
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reservation exceeds overbooking capacity.';
    END IF;
END$$

DELIMITER ;
