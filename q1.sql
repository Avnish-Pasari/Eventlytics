
SET SEARCH_PATH TO ticketschema;
DROP TABLE IF EXISTS q1 CASCADE;

CREATE TABLE q1(
    concert_name VARCHAR(60),
    concert_datetime timestamp,
    venue varchar(60),
    total_value FLOAT,
    percentage_sold FLOAT
);

-- DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Each row gives price times quantity for tickets bought by each user in
-- each row of Purchase
-- So we have total money spent by a user along with the concert_id
-- so we find the expenditure by each user as we multiplied the
-- quantity of tickets bought
-- and the price of that ticket from the Price table
DROP VIEW IF EXISTS total CASCADE;
CREATE VIEW total as
select concert_id, price * quantity as product
from Price, Purchase
where Price.ticket_id = Purchase.ticket_id;

-- select * from total;

-- We sum all the values of tickets that users have bought (product) for each
-- concert_id.
-- So we have the total value of tickets sold for each concert.
DROP VIEW IF EXISTS sum_concert CASCADE;
CREATE VIEW sum_concert as
select concert_id, sum(product) as total
from total
group by concert_id;

-- select * from sum_concert;

-- In the above use we do not have the concerts that had no tickets sold
-- This will be a set subtraction of all concerts and the concerts
-- we have in view 'total' above
DROP VIEW IF EXISTS zeroes CASCADE;
CREATE VIEW zeroes as
(select concert_id from concert) except (select concert_id from total);

-- select * from zeroes;

-- We add new column to view 'zeroes' to show that value of tickets sold for
-- that concert is 0
DROP VIEW IF EXISTS zero_total CASCADE;
CREATE VIEW zero_total as
select concert_id, 0 as total
from zeroes;

-- select * from zero_total;

-- We union both the 'sum_concert' and 'zero_total' views to get total value of
-- tickets sold in all concerts.
DROP VIEW IF EXISTS unioned_total CASCADE;
CREATE VIEW unioned_total as
(select * from sum_concert) union (select * from zero_total);

-- select * from unioned_total;

-- now we need to find the percentage of the venue that was sold.
-- We do this by first finding the total number of seats in each venue.
DROP VIEW IF EXISTS all_seats CASCADE;
CREATE VIEW all_seats as
select venue_id, count(*) as seat_count
from Seats
group by venue_id;

-- select * from all_seats;

-- Now we need to find the total number of seats sold for each concert
-- We do this by joining price and purchase tables to get
-- sum of quantity (of tickets) bought for each concert.
-- the purchase table has quantity of tickets sold to each user.
-- We add this quantity
-- for each concert and get the total number of tickets sold.
DROP VIEW IF EXISTS sold CASCADE;
CREATE VIEW sold as
select concert_id, sum(quantity) as quantity_sold
from Price, Purchase
where Price.ticket_id = Purchase.ticket_id
group by concert_id;

-- select * from sold;

-- Since we now have the total quantity of tickets sold for each concert,
-- we need the venue_id for these concerts.
DROP VIEW IF EXISTS sold_venue CASCADE;
CREATE VIEW sold_venue as
select sold.concert_id, venue_id, quantity_sold
from sold, concert
where sold.concert_id = concert.concert_id;

-- select * from sold_venue;

-- The above table does not have concerts which had 0 tickets sold
-- we take the zeroes view which already has concerts with zero tickets sold
-- and put the percentage of tickets sold as 0
DROP VIEW IF EXISTS zero_percentage CASCADE;
CREATE VIEW zero_percentage as
select zeroes.concert_id, venue_id, 0 as percentage_sold
from zeroes, concert
where zeroes.concert_id = concert.concert_id;

-- select * from zero_percentage;

-- we divide the total seats sold for the given concert by the total seats in
-- each venue and multiply by 100 in order to
-- find the percentage of seats that are sold in the venue for each concert
DROP VIEW IF EXISTS percentage CASCADE;
CREATE VIEW percentage as
select concert_id, all_seats.venue_id,
((quantity_sold * 100)/ CAST(seat_count AS DECIMAL(7,2))) as percentage_sold
from sold_venue, all_seats
where sold_venue.venue_id = all_seats.venue_id;

-- select * from percentage;

-- Now we union all concerts with zero and non-zero percentages.
DROP VIEW IF EXISTS unioned_percentages CASCADE;
CREATE VIEW unioned_percentages as
(select * from zero_percentage) union (select * from percentage);

-- select * from unioned_percentages;

-- We create a table that have all info combined.
-- It has the concert name, concert time and venue name
-- (in order to identify specific concert) along with the
-- total value of tickets sold and
-- the percentage of the venue that is booked
DROP VIEW IF EXISTS all_info CASCADE;
CREATE VIEW all_info as
select concert.name as concert_name, concert.date_and_time as concert_datetime,
venue.name as venue, total as total_value, percentage_sold
from unioned_total, unioned_percentages, Concert, Venue
where unioned_total.concert_id = unioned_percentages.concert_id and
unioned_total.concert_id = Concert.concert_id
and venue.venue_id = unioned_percentages.venue_id;

-- select * from all_info;

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q1
select * from all_info;

SELECT * from q1;
