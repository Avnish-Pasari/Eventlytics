
SET SEARCH_PATH TO ticketschema;
DROP TABLE IF EXISTS q4 CASCADE;

CREATE TABLE q4(
    username VARCHAR(60)
);

-- Do this for each of the views that define your intermediate steps.  
DROP VIEW IF EXISTS NameAndQuantity CASCADE;
DROP VIEW IF EXISTS NotHighest CASCADE;

-- Define views for your intermediate steps here:

-- finding the username and total quantity of tickets purchased with each username
CREATE VIEW NameAndQuantity AS
SELECT username, sum(quantity) as quantity
FROM Purchase
GROUP BY username;


-- finding the username of the users who did not purchase the highest number tickets
CREATE VIEW NotHighest AS
SELECT t1.username as username
FROM NameAndQuantity t1, NameAndQuantity t2
WHERE t1.quantity < t2.quantity;


-- Your query that answers the question goes below the "insert into" line:

-- finding the username of the users who purchased the highest number of tickets
INSERT INTO q4
(SELECT username FROM Purchase)
EXCEPT
(SELECT username FROM NotHighest);

SELECT * from q4;