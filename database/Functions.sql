DELIMITER $$

-- Function for company
CREATE FUNCTION isOpen() RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE currentTime TIME;
    SET currentTime = CURRENT_TIME();
    -- Assuming storeHours is in the format 'HH:MM-HH:MM'
    IF currentTime BETWEEN SUBSTRING_INDEX(storeHours, '-', 1) AND SUBSTRING_INDEX(storeHours, '-', -1) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END$$

-- Function for employee_schedule
CREATE FUNCTION calculateHoursWorked(employeeID INT) RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE hoursWorked INT;
    
    SELECT SUM(TIMESTAMPDIFF(HOUR, SUBSTRING_INDEX(shiftTimeRange, '-', 1), SUBSTRING_INDEX(shiftTimeRange, '-', -1))) INTO hoursWorked FROM employee_schedule WHERE employeeID = employeeID;
    
    RETURN hoursWorked;
END$$

-- Functions for employee
CREATE FUNCTION clockIn(employeeID INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    -- Logic to record clock-in time
    INSERT INTO employee_schedule (employeeID, shiftTimeRange) VALUES (employeeID, CONCAT(CURRENT_DATE(), ' ', CURRENT_TIME()));
    RETURN TRUE;
END$$

CREATE FUNCTION clockOut(employeeID INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    -- Logic to record clock-out time
    UPDATE employee_schedule SET shiftTimeRange = CONCAT(shiftTimeRange, '-', CURRENT_TIME()) WHERE employeeID = employeeID;
    RETURN TRUE;
END$$

-- Functions for associate
CREATE FUNCTION requestVacation(employeeID INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    -- Logic to request vacation
    UPDATE employee_schedule SET isOnVacation = TRUE WHERE employeeID = employeeID;
    RETURN TRUE;
END$$

CREATE FUNCTION requestShift(employeeID INT, newShift VARCHAR(255)) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    -- Logic to request a new shift
    UPDATE employee_schedule SET daysOfWeekWithShift = newShift WHERE employeeID = employeeID;
    RETURN TRUE;
END$$

CREATE FUNCTION calculateWeeklyPaycheckAssociate(employeeID INT) RETURNS DECIMAL(10, 2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE hourlyRate DECIMAL(10, 2);
    DECLARE hoursWorked INT;
    DECLARE paycheck DECIMAL(10, 2);
    
    SELECT hourlyRate INTO hourlyRate FROM associate WHERE employeeID = employeeID;
    SELECT SUM(TIMESTAMPDIFF(HOUR, SUBSTRING_INDEX(shiftTimeRange, '-', 1), SUBSTRING_INDEX(shiftTimeRange, '-', -1))) INTO hoursWorked FROM employee_schedule WHERE employeeID = employeeID;
    
    SET paycheck = hourlyRate * hoursWorked;
    RETURN paycheck;
END$$

-- Functions for manager
CREATE FUNCTION assignShift(employeeID INT, newShift VARCHAR(255)) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    -- Logic to assign a new shift
    UPDATE employee_schedule SET daysOfWeekWithShift = newShift WHERE employeeID = employeeID;
    RETURN TRUE;
END$$

CREATE FUNCTION approveVacation(employeeID INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    -- Logic to approve vacation
    UPDATE employee_schedule SET isOnVacation = TRUE WHERE employeeID = employeeID;
    RETURN TRUE;
END$$

CREATE FUNCTION calculateWeeklyPaycheckManager(employeeID INT) RETURNS DECIMAL(10, 2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE salary DECIMAL(10, 2);
    DECLARE paycheck DECIMAL(10, 2);
    
    SELECT salary INTO salary FROM manager WHERE employeeID = employeeID;
    
    SET paycheck = salary / 52; -- Assuming weekly paycheck
    RETURN paycheck;
END$$

-- Function for employee_account
CREATE FUNCTION logIn(userName VARCHAR(255), password VARCHAR(255)) RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE userCount INT;
    
    SELECT COUNT(*) INTO userCount FROM employee_account WHERE userName = userName AND password = password;
    
    IF userCount > 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END$$

-- Functions for inventory
CREATE FUNCTION addItem(productID INT, quantity INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    -- Logic to add item to inventory
    UPDATE inventory SET numberOfItemInStock = numberOfItemInStock + quantity WHERE productID = productID;
    RETURN TRUE;
END$$

CREATE FUNCTION removeItem(productID INT, quantity INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    -- Logic to remove item from inventory
    UPDATE inventory SET numberOfItemInStock = numberOfItemInStock - quantity WHERE productID = productID;
    RETURN TRUE;
END$$

CREATE FUNCTION updateItemStock(productID INT, newStock INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    -- Logic to update item stock
    UPDATE inventory SET numberOfItemInStock = newStock WHERE productID = productID;
    RETURN TRUE;
END$$

CREATE FUNCTION updateIsInStock(productID INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE stock INT;
    
    SELECT numberOfItemInStock INTO stock FROM inventory WHERE productID = productID;
    
    IF stock > 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END$$

CREATE FUNCTION updateItemPrice(productID INT, newPrice DECIMAL(10, 2)) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    -- Logic to update item price
    UPDATE product SET productPrice = newPrice WHERE productID = productID;
    RETURN TRUE;
END$$

-- Functions for transaction
CREATE FUNCTION calculateSubTotal(transactionID INT) RETURNS DECIMAL(10, 2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE subTotal DECIMAL(10, 2);
    
    SELECT SUM(productPrice) INTO subTotal FROM product WHERE productID IN (SELECT productID FROM transaction WHERE transactionID = transactionID);
    
    RETURN subTotal;
END$$

CREATE FUNCTION calculateTotal(transactionID INT, discount DECIMAL(10, 2)) RETURNS DECIMAL(10, 2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE subTotal DECIMAL(10, 2);
    DECLARE total DECIMAL(10, 2);
    
    SET subTotal = calculateSubTotal(transactionID);
    
    SET total = subTotal - (subTotal * discount / 100);
    RETURN total;
END$$

CREATE FUNCTION applyDiscount(transactionID INT, discount DECIMAL(10, 2)) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    -- Logic to apply discount
    UPDATE transaction SET itemList = CONCAT(itemList, ', Discount: ', discount) WHERE transactionID = transactionID;
    RETURN TRUE;
END$$

CREATE FUNCTION voidItem(transactionID INT, productID INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    -- Logic to void an item from the transaction
    UPDATE transaction SET itemList = REPLACE(itemList, CONCAT(productID, ','), '') WHERE transactionID = transactionID;
    RETURN TRUE;
END$$

DELIMITER ;
