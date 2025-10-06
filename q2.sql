
SET SEARCH_PATH TO ticketschema;
DROP TABLE IF EXISTS q2 CASCADE;

CREATE TABLE q2(
    owner_name VARCHAR(60),
    owner_phone varchar(60),
    venues_owned integer
);

-- DROP VIEW IF EXISTS intermediate_step CASCADE;

-- we have all the owners that have a venue in the venue table. We group by owner_id
-- to find the count of venues for each owner based on owner_id
DROP VIEW IF EXISTS owner_venue_count CASCADE;
CREATE VIEW owner_venue_count as
select owner_id, count(*) as venues_owned
from venue
group by owner_id;

-- select * from owner_venue_count;

-- now we need to find all the owners that do not own any venue
-- we do this by performing set subtraction of all owners with the owners that have venues (from venue table)
DROP VIEW IF EXISTS zero_owners CASCADE;
CREATE VIEW zero_owners as
(select owner_id from owner) except (select owner_id from owner_venue_count);

-- select * from zero_owners;

-- now we have owners with 0 venues so we add the column for 0 venues_owned
DROP VIEW IF EXISTS zero_column CASCADE;
CREATE VIEW zero_column as
select owner_id, 0 as venues_owned
from zero_owners;

-- select * from zero_column;

-- now we combine all owners with zero venues owned (from view zero_owners) and
-- all owners with one or more venues (from view owner_venue_count). To do this
-- we union both the views
DROP VIEW IF EXISTS all_owners CASCADE;
CREATE VIEW all_owners as
(select * from owner_venue_count) union (select * from zero_column);

-- we need to have owner name and phone number to allow for easy
-- identification of owner
DROP VIEW IF EXISTS owner_all_info CASCADE;
CREATE VIEW owner_all_info as
select name as owner_name, phonenumber as owner_phone, venues_owned
from owner, all_owners
where owner.owner_id = all_owners.owner_id;

-- select * from owner_all_info;

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q2
select * from owner_all_info;

select * from q2;