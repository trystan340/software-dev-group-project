-- Insert into company table
INSERT INTO company (companyID, companyName, address, phoneNumber, storeHours)
VALUES (1, 'FloFusion Inc.', '123 Main St, Tyler, TX', '123-456-7890', '9 AM - 5 PM');

-- Insert into employee table
INSERT INTO employee (employeeID, email, employeeName, title)
VALUES (1, 'john.doe@flofusion.com', 'John Doe', 'Manager'),
       (2, 'jane.smith@flofusion.com', 'Jane Smith', 'Associate');

-- Insert into associate table
INSERT INTO associate (employeeID, hourlyRate)
VALUES (2, 20.00);

-- Insert into manager table
INSERT INTO manager (employeeID, salary)
VALUES (1, 60000.00);

-- Insert into employee_account table
INSERT INTO employee_account (employeeID, userName, e_password)
VALUES (1, 'johndoe', 'password123'),
       (2, 'janesmith', 'password456');

-- Insert into employee_schedule table
INSERT INTO employee_schedule (employeeID, daysOfWeekWithShift, notWorkingDays, shiftTimeRange, isOnVacation)
VALUES (1, 'Mon-Fri', 'Sat, Sun', '9 AM - 5 PM', FALSE),
       (2, 'Mon-Fri', 'Sat, Sun', '9 AM - 5 PM', FALSE);

-- Insert into calendar table
INSERT INTO calendar (employeeID, daysOfMonth)
VALUES (1, '1-31'),
       (2, '1-31');

-- Insert into product table
INSERT INTO product (productID, productName, productPrice)
VALUES (1, 'Product A', 10.00),
       (2, 'Product B', 20.00);

-- Insert into inventory table
INSERT INTO inventory (productID, numberOfItemInStock)
VALUES (1, 100),
       (2, 50);

-- Insert into transaction table
INSERT INTO transaction (transactionID, employeeID, productID, companyID, itemList, timeAndDate)
VALUES (1, 1, 1, 1, 'Product A', '2024-10-03 10:00:00'),
       (2, 2, 2, 1, 'Product B', '2024-10-03 11:00:00');
