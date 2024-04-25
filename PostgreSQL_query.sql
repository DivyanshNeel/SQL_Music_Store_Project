                                -------- Question Set 1 - Easy --------

/* Q1: Who is the senior most employee based on job title? */
SELECT * FROM employee
ORDER BY hire_date DESC
LIMIT 1;


/* Q3: What are top 3 values of total invoice? */
SELECT billing_country, COUNT(total) 
FROM invoice
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money.
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */
SELECT billing_city, SUM(total) AS total_city_invoice
FROM invoice
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/
SELECT i.customer_id, c.first_name, c.last_name, SUM(i.total)
FROM customer AS c
JOIN invoice AS i ON c.customer_id = i.customer_id
GROUP BY 1,2,3
ORDER BY 4 DESC
LIMIT 1;


                              -------- Question Set 2 - Moderate ---------

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */
SELECT c.email, c.first_name, c.last_name, g.name 
FROM customer AS c
JOIN invoice AS i on i.customer_id = c.customer_id
JOIN invoice_line AS il on il.invoice_id = i.invoice_id
JOIN track AS t on t.track_id = il.track_id
JOIN genre AS g on g.genre_id = t.genre_id
WHERE g.name = 'Rock'
GROUP BY 1,2,3,4
ORDER BY 1 ASC;


/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */
SELECT a.name, COUNT(a.name)
FROM artist AS a
JOIN album AS al ON al.artist_id = a.artist_id
JOIN track AS t ON t.album_id = al.album_id
JOIN genre AS g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */
SELECT name, milliseconds
FROM track 
WHERE milliseconds > (select AVG(milliseconds) 
                      FROM track)
GROUP BY 1,2
ORDER BY 2 DESC;


                              -------- Question Set 3 - Advance --------

/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

/* Steps to Solve: First, find which artist has earned the most according to the InvoiceLines. Now use this artist to find 
which customer spent the most on this artist. For this query, you will need to use the Invoice, InvoiceLine, Track, Customer, 
Album, and Artist tables. Note, this one is tricky because the Total spent in the Invoice table might not be on a single product, 
so you need to use the InvoiceLine table to find out how many of each product was purchased, and then multiply this by the price
for each artist. */
WITH best_selling_artist AS
(
	SELECT a.artist_id, a.name, SUM(il.unit_price * il.quantity) 
FROM invoice_line AS il
JOIN track AS t on il.track_id = t.track_id
JOIN album AS al ON t.album_id = al.album_id
JOIN artist AS a ON al.artist_id = a.artist_id
GROUP BY 1,2
ORDER BY 3 DESC
)
	SELECT a.artist_id, c.first_name, c.last_name, bsa.name AS artist_name, SUM(il.unit_price * il.quantity) AS total_spent
FROM customer AS c
JOIN invoice AS i ON i.customer_id = c.customer_id
JOIN invoice_line AS il ON il.invoice_id = i.invoice_id
JOIN track AS t ON il.track_id = t.track_id
JOIN album AS al ON t.album_id = al.album_id
JOIN artist AS a ON al.artist_id = a.artist_id
JOIN best_selling_artist AS bsa ON bsa.artist_id = a.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 desc
limit 10;


/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */
WITH popular_genre AS 
(	
    SELECT g.genre_id, g.name, c.country, COUNT(il.quantity),
    ROW_NUMBER() OVER (PARTITION BY c.country ORDER BY COUNT(il.quantity) DESC) AS row_num
FROM customer as c
JOIN invoice AS i ON i.customer_id = c.customer_id
JOIN invoice_line AS il ON il.invoice_id = i.invoice_id
JOIN track AS t ON t.track_id = il.track_id
JOIN genre AS g ON t.genre_id = g.genre_id
	GROUP BY 1,2,3
	ORDER BY 4 DESC
)
    SELECT * FROM popular_genre
WHERE row_num <= 1;


/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */
WITH max_spent AS
(
    SELECT c.customer_id, c.first_name, c.last_name, i.billing_country, SUM(i.total),
ROW_NUMBER() OVER (PARTITION BY i.billing_country ORDER BY SUM(i.total) DESC) AS row_num
FROM customer AS c
JOIN invoice AS i ON i.customer_id = c.customer_id
GROUP BY 1,2,3,4
ORDER BY 4 ASC,5 DESC
)
    SELECT * FROM max_spent
WHERE row_num <= 1;