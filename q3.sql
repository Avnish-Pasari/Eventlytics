
SET SEARCH_PATH TO ticketschema;
DROP TABLE IF EXISTS q3 CASCADE;

CREATE TABLE q3(
    venue_name VARCHAR(60),
    percentage FLOAT
);

-- Do this for each of the views that define your intermediate steps.  
DROP VIEW IF EXISTS MobilityTrue CASCADE;
DROP VIEW IF EXISTS MobilityAll CASCADE;
DROP VIEW IF EXISTS Percentage CASCADE;
DROP VIEW IF EXISTS NameAndPercentage CASCADE;

-- Define views for your intermediate steps here:

-- Finding the number of accessible seats for each of the venues
CREATE VIEW MobilityTrue AS
SELECT venue_id, SUM(CASE WHEN mobility THEN 1 ELSE 0 END) as mobility_t
FROM Seats
GROUP BY venue_id;

-- Finding all the seats for each of the venues
CREATE VIEW MobilityAll AS
SELECT venue_id, count(*) as mobility_full
FROM Seats
GROUP BY venue_id;

-- Calculating the percentage of accessible seats i.e. accessible / all seats * 100
CREATE VIEW Percentage AS
SELECT MobilityAll.venue_id as venue_id, CAST(mobility_t AS DECIMAL(7,2)) / mobility_full * 100 as pct
FROM MobilityTrue, MobilityAll
WHERE MobilityTrue.venue_id = MobilityAll.venue_id;

-- Finding the name of the venues using the venue_id
CREATE VIEW NameAndPercentage AS
SELECT name, pct
FROM Venue, Percentage
WHERE Venue.venue_id = Percentage.venue_id;


-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q3
(SELECT * FROM NameAndPercentage);

SELECT * from q3;