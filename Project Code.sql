-- Exercise 1

-- 1.1	Write a query that lists all Customers in either Paris or London. Include Customer ID, Company Name and all address fields.
SELECT CustomerID, CompanyName,  Concat(Address, ', ', City) AS 'Adress Field' FROM Customers
    WHERE City = 'Paris' OR City = 'London' 

-- 1.2	List all products stored in bottles.
Select * FROM Products 
    WHERE QuantityPerUnit LIKE '%bottles%' 

-- 1.3	Repeat question above, but add in the Supplier Name and Country.
Select ProductName, CompanyName, Country FROM Products 
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
    WHERE QuantityPerUnit LIKE '%bottles%'
 
-- 1.4	Write an SQL Statement that shows how many products there are in each category. Include Category Name in result set and list the highest number first.
SELECT c.CategoryID, c.CategoryName AS "THE CATEGORY NAME", SUM(c.CategoryID) "THE NUMBER OF PRODUCTS IN THE CATEGORY" FROM Products p
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
        GROUP BY c.CategoryID, c.CategoryName ORDER BY sum(c.CategoryID) DESC

-- 1.5	List all UK employees using concatenation to join their title of courtesy, first name and last name together. Also include their city of residence.
SELECT CONCAT(Firstname,',',lastName) 


-- 1.6	List Sales Totals for all Sales Regions (via the Territories table using 4 joins) with a Sales Total greater than 1,000,000. Use rounding or FORMAT to present the numbers. 
SELECT r.RegionDescription, ROUND(SUM(od.UnitPrice*od.Quantity), -5) AS 'Sales' FROM Region r
INNER JOIN Territories t ON r.RegionID=t.RegionID
INNER JOIN EmployeeTerritories et ON t.TerritoryID = et.TerritoryID
INNER JOIN Orders o ON et.EmployeeID=o.EmployeeID
INNER JOIN [Order Details] od ON o.OrderID=od.OrderID GROUP BY r.RegionID, R.RegionDescription ORDER BY Sales DESC


-- 1.7	Count how many Orders have a Freight amount greater than 100.00 and either USA or UK as Ship Country.
SELECT COUNT(Freight) AS 'Freight Count' FROM Orders 
    WHERE Freight > 100.00
        AND (ShipCountry = 'USA' OR ShipCountry = 'UK')


-- 1.8	Write an SQL Statement to identify the Order Number of the Order with the highest amount of discount applied to that order.
SELECT TOP 1 OrderID, MAX(Discount) AS 'Amount Discount' FROM [Order Details] 
GROUP BY OrderID ORDER BY Discount DESC 

-- 2.1 Write the correct SQL statement to create the following table:
CREATE TABLE [Sparta Table](
    StudentID INT IDENTITY(1,1),
    Title varchar(12) NOT NULL,
    FirstName varchar(50) NOT NULL,
    LastName varchar(50) NOT NULL,
    University varchar(40) DEFAULT NULL,
    Course varchar(40) DEFAULT NULL,
    Grade INT DEFAULT NULL,
    PRIMARY KEY (StudentID) );

-- 2.2 Write SQL statements to add the details of the Spartans in your course to the table you have created.
 INSERT INTO [Sparta Table]
     (Title, FirstName, LastName, University, Course, Grade)
VALUES ('Mr.', 'Victor', 'Sibanda', 'Lincoln', 'Electrical Engineering', 74),
    ('Mr.', 'Zack', 'Davenport', 'UEA', 'Film and TV', 55),
    ('Mr.', 'Elliot', 'Harris', 'CCC', 'History', 58),
    ('Mr.', 'Adam', 'Mohsen', 'Sussex', 'Computer Science', 70),
    ('Mr.', 'Abdullah', 'Ayyaz', 'Westminster', 'Business Economics', 69),
    ('Mr.', 'Ash', 'Isbitt', 'Brunel', 'Visual Effect and Motion Graphics', 68),
    ('Mr.', 'James', 'Hovell', 'Portsmouth', 'Mathematics', 67),
    ('Mr.', 'Mahan', 'Yousfi', 'Portsmouth', 'Mathematics', 82),
    ('Mr.', 'Maksaud', 'Ahmed', '', '', ''),
    ('Miss', 'Sara', 'Abdrabu', 'Westminster', 'Computer Networks with Security', 67),
    ('Mr.', 'Camile', 'Malungu', 'Brunel', 'Computer Science', 57);

-- 3.1 List all Employees from the Employees table and who they report to. No Excel required. 
SELECT EmployeeID AS 'Employee ID',
TitleOfCourtesy + ' ' + FirstName + ' ' + LastName AS 'Name',
ReportsTo AS 'Reports To' FROM Employees;

-- 3.2 List all Suppliers with total sales over $10,000 in the Order Details table. Include the Company Name from the Suppliers Table and present as a bar chart as below:
SELECT s.SupplierID, s.CompanyName, FORMAT(SUM(od.UnitPrice*od.Quantity*(1-od.Discount)), 'N', 'en-uk') AS 'TotalSales' FROM [Order Details] od 
INNER JOIN Products p on od.ProductID=p.ProductID 
INNER JOIN Suppliers s ON p.SupplierID=s.SupplierID 
GROUP BY s.SupplierID, s.CompanyName HAVING (SUM(od.UnitPrice*od.Quantity*(1-od.Discount))) > 10000


-- 3.3 List the Top 10 Customers Year To Date for the latest year in the Orders file. Based on total value of orders shipped. No Excel required.
SELECT TOP 10 o.CustomerID, c.CompanyName,
       ROUND(SUM(od.UnitPrice*od.Quantity*(1-od.Discount)),0) AS 'Total Value'
  FROM ((Orders o
       INNER JOIN [Order Details] od 
       ON o.OrderID = od.OrderID)
       
       INNER JOIN Customers c 
       ON c.CustomerID=o.CustomerID)
 GROUP BY o.CustomerID, c.CompanyName, YEAR(ShippedDate)
 HAVING YEAR(ShippedDate) = (SELECT YEAR(MAX(ShippedDate)) FROM Orders)
 ORDER BY [Total Value] DESC


-- 3.4 Plot the Average Ship Time by month for all data in the Orders Table using a line chart as below.
SELECT CONCAT(MONTH(ShippedDate), ', ', YEAR(ShippedDate)) AS 'ShipMonth', AVG(DATEDIFF(day, ShippedDate, RequiredDate)) AS 'lengthOfJourney' 
FROM [Orders] GROUP BY ShippedDate HAVING DAY(ShippedDate) = AVG(DATEDIFF(day, ShippedDate, RequiredDate))

