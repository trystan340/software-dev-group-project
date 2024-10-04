-- CREATE SCHEMA flofusion;
-- DROP SCHEMA flofusion;

CREATE TABLE company (
    companyID INT,
    companyName VARCHAR(255),
    address VARCHAR(255),
    phoneNumber VARCHAR(15),
    storeHours VARCHAR(255),
    
    PRIMARY KEY (companyID)
);

CREATE TABLE employee (
    employeeID INT,
    email VARCHAR(255),
    employeeName VARCHAR(255),
    title VARCHAR(255),
    
    PRIMARY KEY (employeeID)
);

CREATE TABLE associate (
    employeeID INT,
    hourlyRate DECIMAL(10, 2),
    
    PRIMARY KEY (employeeID),
    CONSTRAINT associate_fk FOREIGN KEY (employeeID) REFERENCES employee (employeeID)
);

CREATE TABLE manager (
    employeeID INT,
    salary DECIMAL(10, 2),
    
    PRIMARY KEY (employeeID),
    CONSTRAINT manager_fk FOREIGN KEY (employeeID) REFERENCES employee (employeeID)
);

CREATE TABLE employee_account (
    employeeID INT,
    userName VARCHAR(255),
    e_password VARCHAR(255),
    
    PRIMARY KEY (employeeID),
    CONSTRAINT employee_account_fk FOREIGN KEY (employeeID) REFERENCES employee (employeeID)
);

CREATE TABLE employee_schedule (
    employeeID INT,
    daysOfWeekWithShift VARCHAR(255),
    notWorkingDays VARCHAR(255),
    shiftTimeRange VARCHAR(255),
    isOnVacation BOOLEAN,
    
    CONSTRAINT employee_schedule_fk FOREIGN KEY (employeeID) REFERENCES employee (employeeID)
);

CREATE TABLE calendar (
    employeeID INT,
    daysOfMonth VARCHAR(255),
    
    CONSTRAINT calendar_fk FOREIGN KEY (employeeID) REFERENCES employee_schedule (employeeID)
);

CREATE TABLE product (
    productID INT,
    productName VARCHAR(255),
    productPrice DECIMAL(10, 2),
    
    PRIMARY KEY(productID)
);

CREATE TABLE inventory (
    productID INT,
    numberOfItemInStock INT,
    
    CONSTRAINT inventory_fk FOREIGN KEY (productID) REFERENCES product (productID)
);

CREATE TABLE transaction (
    transactionID INT,
    employeeID INT,
    productID INT,
    companyID INT,
    itemList VARCHAR(1000),
    timeAndDate DATETIME,
    
    PRIMARY KEY (transactionID),
    CONSTRAINT transaction_fk1 FOREIGN KEY (employeeID) REFERENCES employee (employeeID),
    CONSTRAINT transaction_fk2 FOREIGN KEY (productID) REFERENCES inventory (productID),
    CONSTRAINT transaction_fk3 FOREIGN KEY (companyID) REFERENCES company (companyID)
);
