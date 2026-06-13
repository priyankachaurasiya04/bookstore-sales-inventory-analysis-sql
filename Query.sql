
 -- CREATE TABLE Books
DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
	Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(50),
	Genre VARCHAR(50),
	Published_Year INT,
	Price NUMERIC(10,2),
	Stock INT
)

-- CREATE TABLE customers
DROP TABLE IF EXISTS customers;
CREATE TABLE customers(
	Customer_ID SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(50),
	Phone VARCHAR(15),
	City VARCHAR(50),
	Country VARCHAR(50)
	)

-- CREATE TABLE Orders
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
	Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10,2)
	)


SELECT * FROM Books;
SELECT * FROM customers;
SELECT * FROM Orders;


-- Import Data Into Book Table

COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'D:\Data Analytics\Projects\SQL Project'
CSV HEADER;

COPY customers(Customer_ID, Name, Email, Phone, City, Country)
FROM 'D:\Data Analytics\Projects\SQL Project'
CSV HEADER;

COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'D:\Data Analytics\Projects\SQL Project'
CSV HEADER;


-- 1) Retrieve all books in the "Fiction" genre
SELECT * FROM Books
WHERE Genre = 'Fiction';

-- 2) Find books published after the year 1950
SELECT * FROM Books
WHERE Published_Year > 1950;

-- 3) List all customers from the Canada
SELECT * FROM customers 
WHERE Country = 'Canada';

-- 4) Show orders placed in November 2023
SELECT * FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available
SELECT SUM(Stock) AS total_Stock
FROM Books;

-- 6) Find the details of the most expensive book
SELECT Title , Price
FROM Books
ORDER BY Price DESC
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book
SELECT * FROM Orders
WHERE Quantity > 1

-- 8) Retrieve all orders where the total amount exceeds $20
SELECT * FROM Orders
WHERE Total_Amount > 20

-- 9) List all genres available in the Books table
SELECT Genre FROM Books
GROUP BY Genre;

-- OR
SELECT DISTINCT Genre FROM Books

-- 10) Find the book with the lowest stock
SELECT *
FROM Books
ORDER BY Stock ASC
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders
SELECT SUM(Total_Amount) AS total_revenue
FROM Orders

-- Advance Question

-- 1) Retrieve the total number of books sold for each genre
SELECT b.Genre, SUM(o.Quantity)
FROM Books b
JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Genre

-- 2) Find the average price of books in the "Fantasy" genre

SELECT  AVG(Price) AS avg_price
FROM Books
WHERE Genre = 'Fantasy'


-- 3) List customers who have placed at least 2 orders
SELECT o.Customer_ID,c.name, COUNT(o.Order_ID) AS order_placed
FROM customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY o.Customer_ID , c.name
HAVING COUNT(o.Order_ID) >= 2


-- 4) Find the most frequently ordered book
SELECT Book_ID , COUNT(Order_ID) AS Ordered
FROM Orders
GROUP BY Book_ID
ORDER BY Ordered DESC
LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre 
SELECT Title, Price
FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3

-- 6) Retrieve the total quantity of books sold by each author
SELECT b.Author, SUM(o.Quantity) AS Total_Sold
FROM Books b
JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Author

-- 7) List the cities where customers who spent over $30 are located
SELECT  DISTINCT c.City, o.Total_Amount AS total_Spent
FROM customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
WHERE o.Total_Amount > 30


-- 8) Find the customer who spent the most on orders
SELECT c.Customer_ID, c.name, SUM(o.Total_Amount) total_Spent
FROM customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.name , c.Customer_ID
ORDER BY total_Spent DESC
LIMIT 1

-- 9) Calculate the stock remaining after fulfilling all orders
SELECT b.Book_ID , b.Title, b.Stock,COALESCE(SUM(Quantity),0) AS Total_Qty,
b.Stock - COALESCE(SUM(Quantity),0) AS Remaining_Qty
FROM Books b
LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID
