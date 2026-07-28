/*
Project: Chinook Sales Data Exploration
Database: Chinook
Purpose: Explore sales data using foundational SQL
*/

 --SECTION 1: BASIC SALES DATA EXPLORATION

-- Question 1: Display the first 10 sales invoices.
SELECT *
FROM Invoice
LIMIT 10;

--Question 2: Present key transaction details for all sales invoices.
SELECT InvoiceID, CustomerID, InvoiceDate,BillingCountry,Total
FROM Invoice;

--Question 3: Identify sales invoices from the United Kingdom.
SELECT InvoiceId,InvoiceDate,BillingCity,BillingCountry,Total
FROM Invoice
WHERE BillingCountry = 'United Kingdom';

--Question 4:Find sales invoices with a total greater than 10.
SELECT InvoiceId,CustomerId,InvoiceDate,BillingCountry,Total
FROM Invoice
WHERE Total > 10;

--Question 5: Rank sales invoices from highest to lowest based on total amount.
SELECT InvoiceId,CustomerId,InvoiceDate,BillingCountry,Total
FROM Invoice
ORDER BY Total DESC;


--SECTION 2: FILTERING SALES DATA

--Question 6: Identify invoices issued from 2012 onwards.
SELECT InvoiceId,InvoiceDate,BillingCountry,Total
FROM Invoice
WHERE InvoiceDate >= '2012-01-01';

--Question 7: Display invoices from United Kingdom or Germany.
SELECT InvoiceId,InvoiceDate,BillingCountry,Total
FROM Invoice
WHERE BillingCountry IN ('United Kingdom', 'Germany');

--Question 8: Find invoices received outside the USA.
SELECT InvoiceId,BillingCountry,Total
FROM Invoice
WHERE NOT BillingCountry = 'USA';

-- Question 9: Identify high-value invoices from selected European markets.
SELECT InvoiceId,InvoiceDate,BillingCountry,Total
FROM Invoice
WHERE BillingCountry IN ('United Kingdom', 'Germany', 'France', 'Italy') AND Total > 50;

-- Question 10: Analyse qualifying non-USA invoices issued from 2012 onwards.
SELECT InvoiceId,InvoiceDate,BillingCountry,Total
FROM Invoice
WHERE NOT BillingCountry = 'USA' AND InvoiceDate >= '2012-01-01';

--SECTION 3: AGGREGATE SALES FUNCTIONS

-- Question 11: What is the total revenue, average invoice value, highest invoice and lowest invoice?
SELECT 
    ROUND(SUM(Total), 2) AS TotalRevenue,
    ROUND(AVG(Total), 2) AS AverageInvoice,
    MAX(Total) AS HighestInvoice,
    MIN(Total) AS LowestInvoice
FROM Invoice;

-- Question 12: Which billing countries generated the highest revenue?
SELECT BillingCountry, ROUND(SUM(Total), 2) AS TotalRevenue
FROM Invoice
GROUP BY BillingCountry
ORDER BY TotalRevenue DESC;

-- Question 13: Which billing countries generated the highest invoice count?
SELECT BillingCountry, COUNT(*) AS TotalInvoices
FROM Invoice
GROUP BY BillingCountry
ORDER BY TotalInvoices DESC;

-- Question 14: Which countries have an average invoice value greater than 5?
SELECT BillingCountry, ROUND(AVG(Total), 2) AS AverageInvoice
FROM Invoice
GROUP BY BillingCountry
HAVING AVG(Total) > 5
ORDER BY AverageInvoice DESC;

-- Question 15: How much revenue was generated each year?
SELECT strftime('%Y', InvoiceDate) AS Year, ROUND(SUM(Total), 2) AS TotalRevenue
FROM Invoice
GROUP BY Year
ORDER BY Year;

--SECTION 4: TABLE RELATIONSHIPS

--Question 16: Which customer has made the most invoices?
SELECT c.CustomerId,(c.FirstName||' '||c.LastName) AS CustomerName, COUNT(i.InvoiceId) AS TotalInvoices
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, CustomerName
ORDER BY TotalInvoices DESC
LIMIT 1;

--Question 17: Which invoices contain the highest number of purchased items?
SELECT
    i.InvoiceId,
    COUNT(il.InvoiceLineId) AS TotalItems
FROM Invoice i
JOIN InvoiceLine il
    ON i.InvoiceId = il.InvoiceId
GROUP BY i.InvoiceId
ORDER BY TotalItems DESC;
 
 --Question 18: Which albums contain the most tracks?
 SELECT
    a.Title AS Album,
    COUNT(t.TrackId) AS TotalTracks
FROM Album a
JOIN Track t
    ON a.AlbumId = t.AlbumId
GROUP BY a.AlbumId, a.Title
ORDER BY TotalTracks DESC;

--Question 19: Which artists have the most albums?
SELECT
    ar.Name AS Artist,
    COUNT(al.AlbumId) AS TotalAlbums
FROM Artist ar
JOIN Album al   
    ON ar.ArtistId = al.ArtistId
GROUP BY ar.ArtistId, ar.Name
ORDER BY TotalAlbums DESC;  

--Question 20: Which genres contain the highest number of tracks?
SELECT
    g.Name AS Genre,
    COUNT(t.TrackId) AS TotalTracks
FROM Genre g
JOIN Track t
    ON g.GenreId = t.GenreId
GROUP BY g.GenreId, g.Name
ORDER BY TotalTracks DESC;

-- SECTION 5: SALES PERFORMANCE ANALYSIS

-- Question 21: Which customers generated the highest total revenue?
SELECT 
    c.CustomerId,
    (c.FirstName || ' ' || c.LastName) AS CustomerName,
    ROUND(SUM(i.Total), 2) AS TotalRevenue
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, CustomerName
ORDER BY TotalRevenue DESC
LIMIT 10;   

--Question 22: Which countries generated the highest total revenue?
SELECT                
    i.BillingCountry,
    ROUND(SUM(i.Total), 2) AS TotalRevenue
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId       
GROUP BY i.BillingCountry
ORDER BY TotalRevenue DESC;

--Question 23: Which genres sold the highest number of tracks?
SELECT
    g.Name AS Genre,
    SUM(il.Quantity) AS TracksSold
FROM Genre g
JOIN Track t ON g.GenreId = t.GenreId                   
JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY g.GenreId, g.Name
ORDER BY TracksSold DESC;          

--Question 24: Which artists generated the highest sales revenue?
SELECT
    ar.Name AS Artist,
    ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS TotalRevenue
FROM Artist ar
JOIN Album al ON ar.ArtistId = al.ArtistId          
JOIN Track t ON al.AlbumId = t.AlbumId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY ar.ArtistId, ar.Name
ORDER BY TotalRevenue DESC
LIMIT 10;

--Question 25: Which year produced the highest revenue?
SELECT strftime('%Y', i.InvoiceDate) AS SalesYear, ROUND(SUM(i.Total), 2) AS TotalRevenue
FROM Invoice i
GROUP BY SalesYear
ORDER BY TotalRevenue DESC
LIMIT 1;
