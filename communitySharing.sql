-- Create the User Table
CREATE TABLE User (
    UserID INT PRIMARY KEY,
    Password VARCHAR(255) NOT NULL
);

-- Create the UserDetails Table
CREATE TABLE UserDetails (
    DetailID INT PRIMARY KEY,
    UserID INT,
    Username VARCHAR(255) NOT NULL UNIQUE,
    Email VARCHAR(255) NOT NULL UNIQUE,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

-- Create the ContactInfo Table
CREATE TABLE ContactInfo (
    ContactInfoID INT PRIMARY KEY,
    UserID INT,
    PhoneNumber VARCHAR(255),
    Address VARCHAR(255),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

-- Create the Resource Table
CREATE TABLE Resource (
    ResourceID INT PRIMARY KEY,
    ResourceName VARCHAR(255) NOT NULL,
    Description TEXT,
    ConditionID INT,
    OwnerID INT,
    CategoryID INT,
    LocationID INT,
    FOREIGN KEY (ConditionID) REFERENCES Condition(ConditionID),
    FOREIGN KEY (OwnerID) REFERENCES User(UserID),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
    FOREIGN KEY (LocationID) REFERENCES Location(LocationID)
);

-- Create the Condition Table
CREATE TABLE Condition (
    ConditionID INT PRIMARY KEY,
    ConditionName VARCHAR(255) NOT NULL UNIQUE
);

-- Create the LendingHistory Table
CREATE TABLE LendingHistory (
    LendingID INT PRIMARY KEY,
    ResourceID INT,
    BorrowerID INT,
    LendDate DATE NOT NULL,
    ReturnDate DATE,
    FOREIGN KEY (ResourceID) REFERENCES Resource(ResourceID),
    FOREIGN KEY (BorrowerID) REFERENCES User(UserID)
);

-- Create the Availability Table
CREATE TABLE Availability (
    ResourceID INT PRIMARY KEY,
    Available BOOLEAN NOT NULL,
    BorrowUntil DATE,
    FOREIGN KEY (ResourceID) REFERENCES Resource(ResourceID)
);

-- Create the Category Table
CREATE TABLE Category (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(255) NOT NULL UNIQUE
);

-- Create the Location Table
CREATE TABLE Location (
    LocationID INT PRIMARY KEY,
    LocationName VARCHAR(255) NOT NULL,
    Address VARCHAR(255)
);

-- Create the Notification Table
CREATE TABLE Notification (
    NotificationID INT PRIMARY KEY,
    UserID INT,
    ResourceID INT,
    MessageID INT,
    NotificationDate DATE NOT NULL,
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (ResourceID) REFERENCES Resource(ResourceID),
    FOREIGN KEY (MessageID) REFERENCES Message(MessageID)
);

-- Create the Message Table
CREATE TABLE Message (
    MessageID INT PRIMARY KEY,
    MessageContent TEXT NOT NULL UNIQUE
);

-- Create the Review Table
CREATE TABLE Review (
    ReviewID INT PRIMARY KEY,
    ResourceID INT,
    UserID INT,
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    Comment TEXT,
    ReviewDate DATE NOT NULL,
    FOREIGN KEY (ResourceID) REFERENCES Resource(ResourceID),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

-- Insert values into User Table
INSERT INTO User (UserID, Password) VALUES
(1, 'password123'),
(2, 'securepass456'),
(3, 'mypassword789');

-- Insert values into UserDetails Table
INSERT INTO UserDetails (DetailID, UserID, Username, Email) VALUES
(1, 1, 'john_doe', 'john@example.com'),
(2, 2, 'jane_smith', 'jane@example.com'),
(3, 3, 'alex_brown', 'alex@example.com');

-- Insert values into ContactInfo Table
INSERT INTO ContactInfo (ContactInfoID, UserID, PhoneNumber, Address) VALUES
(1, 1, '123-456-7890', '123 Elm Street'),
(2, 2, '987-654-3210', '456 Oak Avenue'),
(3, 3, '555-555-5555', '789 Pine Road');

-- Insert values into Resource Table
INSERT INTO Resource (ResourceID, ResourceName, Description, ConditionID, OwnerID, CategoryID, LocationID) VALUES
(1, 'Laptop', 'Dell Inspiron 15', 1, 1, 1, 1),
(2, 'Hammer', 'Heavy-duty steel hammer', 2, 2, 2, 2),
(3, 'Python Programming Book', 'Beginner to Advanced Guide', 1, 3, 3, 3);

-- Insert values into Condition Table
INSERT INTO Condition (ConditionID, ConditionName) VALUES
(1, 'New'),
(2, 'Good'),
(3, 'Used');

-- Insert values into LendingHistory Table
INSERT INTO LendingHistory (LendingID, ResourceID, BorrowerID, LendDate, ReturnDate) VALUES
(1, 1, 2, '2025-04-01', '2025-04-10'),
(2, 2, 3, '2025-04-05', NULL),
(3, 3, 1, '2025-04-07', '2025-04-15');

-- Insert values into Availability Table
INSERT INTO Availability (ResourceID, Available, BorrowUntil) VALUES
(1, 0, '2025-04-10'),
(2, 0, '2025-04-20'),
(3, 1, NULL);

-- Insert values into Category Table
INSERT INTO Category (CategoryID, CategoryName) VALUES
(1, 'Electronics'),
(2, 'Tools'),
(3, 'Books');

-- Insert values into Location Table
INSERT INTO Location (LocationID, LocationName, Address) VALUES
(1, 'Storage Room A', 'Building 1, Floor 2'),
(2, 'Workshop', 'Building 2, Floor 1'),
(3, 'Library', 'Building 3, Ground Floor');

-- Insert values into Notification Table
INSERT INTO Notification (NotificationID, UserID, ResourceID, MessageID, NotificationDate) VALUES
(1, 1, 2, 1, '2025-04-08'),
(2, 2, 3, 2, '2025-04-09'),
(3, 3, 1, 3, '2025-04-10');

-- Insert values into Message Table
INSERT INTO Message (MessageID, MessageContent) VALUES
(1, 'Your borrowed resource is due soon.'),
(2, 'Please return the borrowed resource.'),
(3, 'The resource you requested is now available.');

-- Insert values into Review Table
INSERT INTO Review (ReviewID, ResourceID, UserID, Rating, Comment, ReviewDate) VALUES
(1, 1, 2, 5, 'Excellent condition, highly recommended!', '2025-04-11'),
(2, 2, 3, 4, 'Good tool, but the handle is slightly worn.', '2025-04-12'),
(3, 3, 1, 3, 'Helpful book, but some pages are damaged.', '2025-04-13');

-- START TRANSACTION
START TRANSACTION;

-- 1. List all users
-- Query rewritten to include UserDetails for complete user information
SELECT u.UserID, ud.Username, ud.Email, u.Password
FROM User u
JOIN UserDetails ud ON u.UserID = ud.UserID;

-- 2. Show all resources with their availability
SELECT r.ResourceName, a.Available, a.BorrowUntil
FROM Resource r
JOIN Availability a ON r.ResourceID = a.ResourceID;

-- 3. List all resources along with category and location
SELECT r.ResourceName, c.CategoryName, l.LocationName
FROM Resource r
JOIN Category c ON r.CategoryID = c.CategoryID
JOIN Location l ON r.LocationID = l.LocationID;

-- 4. Show resources and their condition
SELECT r.ResourceName, rc.ConditionName
FROM Resource r
JOIN Condition rc ON r.ConditionID = rc.ConditionID;

-- 5. Get all users who have written reviews
SELECT DISTINCT ud.Username
FROM UserDetails ud
JOIN Review rv ON ud.UserID = rv.UserID;

-- 6. Show average rating for each resource
SELECT r.ResourceName, AVG(rv.Rating) AS AvgRating
FROM Review rv
JOIN Resource r ON rv.ResourceID = r.ResourceID
GROUP BY r.ResourceName;

-- 7. Get top 5 highest-rated resources
SELECT r.ResourceName, AVG(rv.Rating) AS AvgRating
FROM Review rv
JOIN Resource r ON rv.ResourceID = r.ResourceID
GROUP BY r.ResourceName
ORDER BY AvgRating DESC
LIMIT 5;

-- 8. Count how many resources are available
SELECT COUNT(*) AS AvailableCount
FROM Availability
WHERE Available = 1;

-- 9. Show all users and how many resources they own
SELECT ud.Username, COUNT(r.ResourceID) AS TotalResources
FROM UserDetails ud
LEFT JOIN Resource r ON ud.UserID = r.OwnerID
GROUP BY ud.Username;

-- 10. Show borrowing history of a resource
SELECT lh.LendDate, lh.ReturnDate, ud.Username
FROM LendingHistory lh
JOIN UserDetails ud ON lh.BorrowerID = ud.UserID
WHERE lh.ResourceID = 5;

-- 11. List all notifications with user and message
SELECT n.NotificationID, ud.Username, m.MessageContent, n.NotificationDate
FROM Notification n
JOIN UserDetails ud ON n.UserID = ud.UserID
JOIN Message m ON n.MessageID = m.MessageID;

-- 12. Find resources not currently available
SELECT r.ResourceName
FROM Resource r
JOIN Availability a ON r.ResourceID = a.ResourceID
WHERE a.Available = 0;

-- 13. List all categories with the number of resources
SELECT c.CategoryName, COUNT(r.ResourceID) AS Total
FROM Category c
LEFT JOIN Resource r ON c.CategoryID = r.CategoryID
GROUP BY c.CategoryName;

-- 14. Show all resources that are due to be returned after today
SELECT r.ResourceName, a.BorrowUntil
FROM Resource r
JOIN Availability a ON r.ResourceID = a.ResourceID
WHERE a.BorrowUntil > CURDATE();

-- 15. Find users with more than 1 review
SELECT ud.Username, COUNT(rv.ReviewID) AS ReviewCount
FROM UserDetails ud
JOIN Review rv ON ud.UserID = rv.UserID
GROUP BY ud.Username
HAVING COUNT(rv.ReviewID) > 1;

-- 16. List all reviews with usernames and resource names
SELECT ud.Username, r.ResourceName, rv.Rating, rv.Comment
FROM Review rv
JOIN UserDetails ud ON rv.UserID = ud.UserID
JOIN Resource r ON rv.ResourceID = r.ResourceID;

-- 17. Show resources in 'Books' category
SELECT r.ResourceName
FROM Resource r
JOIN Category c ON r.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Books';

-- 18. Show users who haven’t posted any review
SELECT ud.Username
FROM UserDetails ud
LEFT JOIN Review rv ON ud.UserID = rv.UserID
WHERE rv.ReviewID IS NULL;

-- 19. Show last 5 notifications
SELECT * FROM Notification ORDER BY NotificationDate DESC LIMIT 5;

-- 20. Show resource usage frequency (how many times borrowed)
SELECT r.ResourceName, COUNT(lh.LendingID) AS TimesLent
FROM Resource r
LEFT JOIN LendingHistory lh ON r.ResourceID = lh.ResourceID
GROUP BY r.ResourceName;

-- 21. Update a user's email
UPDATE UserDetails
SET Email = 'newemail@example.com'
WHERE UserID = 1;

-- 22. Mark a resource as available
UPDATE Availability
SET Available = 1, BorrowUntil = NULL
WHERE ResourceID = 4;

-- 23. Delete a review with a bad rating
DELETE FROM Review WHERE Rating = 1;

-- 24. Find all resources owned by user 'user3'
SELECT r.ResourceName
FROM Resource r
JOIN UserDetails ud ON r.OwnerID = ud.UserID
WHERE ud.Username = 'user3';

-- 25. Show all usernames and their contact numbers
SELECT ud.Username, ci.PhoneNumber
FROM UserDetails ud
JOIN ContactInfo ci ON ud.UserID = ci.UserID;

-- 26. List all usernames who have borrowed a resource
SELECT DISTINCT ud.Username
FROM UserDetails ud
JOIN LendingHistory lh ON ud.UserID = lh.BorrowerID;

-- 27. Count total number of reviews per rating
SELECT Rating, COUNT(*) AS Total
FROM Review
GROUP BY Rating;

-- 28. Show users who received notifications in the past 30 days
SELECT DISTINCT ud.Username
FROM Notification n
JOIN UserDetails ud ON n.UserID = ud.UserID
WHERE n.NotificationDate >= CURDATE() - INTERVAL 30 DAY;

-- 29. Resources in 'Poor' condition
SELECT r.ResourceName
FROM Resource r
JOIN Condition rc ON r.ConditionID = rc.ConditionID
WHERE rc.ConditionName = 'Poor';

-- 30. Create a view with full resource summary
CREATE OR REPLACE VIEW ResourceSummary AS
SELECT r.ResourceName, ud.Username AS Owner, c.CategoryName, l.LocationName, rc.ConditionName, a.Available
FROM Resource r
JOIN UserDetails ud ON r.OwnerID = ud.UserID
JOIN Category c ON r.CategoryID = c.CategoryID
JOIN Location l ON r.LocationID = l.LocationID
JOIN Condition rc ON r.ConditionID = rc.ConditionID
JOIN Availability a ON r.ResourceID = a.ResourceID;

-- 31. Query the ResourceSummary view
SELECT * FROM ResourceSummary;

-- 32. Get the highest-rated resource
SELECT r.ResourceName
FROM Review rv
JOIN Resource r ON rv.ResourceID = r.ResourceID
GROUP BY r.ResourceName
ORDER BY AVG(rv.Rating) DESC
LIMIT 1;

-- 33. Get all resources borrowed but not returned yet
SELECT r.ResourceName, lh.BorrowerID
FROM LendingHistory lh
JOIN Resource r ON lh.ResourceID = r.ResourceID
WHERE lh.ReturnDate IS NULL;

-- 34. Change the name of a resource
UPDATE Resource
SET ResourceName = 'High-Powered Drill'
WHERE ResourceID = 1;

-- 35. Delete a user and their contact info
DELETE FROM ContactInfo WHERE UserID = 25;
DELETE FROM User WHERE UserID = 25;

-- 36. Count of messages used in notifications
SELECT m.MessageContent, COUNT(n.NotificationID) AS TimesUsed
FROM Message m
JOIN Notification n ON m.MessageID = n.MessageID
GROUP BY m.MessageContent;

-- 37. Show reviews containing the word 'helpful'
SELECT * FROM Review WHERE Comment LIKE '%helpful%';

-- 38. Find resources never borrowed
SELECT r.ResourceName
FROM Resource r
LEFT JOIN LendingHistory lh ON r.ResourceID = lh.ResourceID
WHERE lh.LendingID IS NULL;

-- 39. Show the most recently added review
SELECT * FROM Review ORDER BY ReviewDate DESC LIMIT 1;

-- 40. Get count of users per email domain
SELECT SUBSTRING_INDEX(Email, '@', -1) AS Domain, COUNT(*) AS UserCount
FROM UserDetails
GROUP BY Domain;

-- COMMIT TRANSACTION
COMMIT;