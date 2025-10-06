drop schema if exists ticketschema cascade;
create schema ticketschema;
set search_path to ticketschema;

-- Could not do: 
-- 1) Could not enforce the 'at least 10 seats per venue' constraint.
-- 2) Could not enforce a concert to be at exactly one venue.
-- Did not do:
-- 1) N/A
-- Extra Constraints:
-- 1) Taken name, city, address to be unique in table Venue. So, no venue can have same name, city and street address 
--    at the same time.
-- Assumptions:
-- 1) Concerts of the same name and same time can happen in different venues 
--    (because names of concerts are specified to be not unique) - 2 different concerts have the same name.

DROP TABLE IF EXISTS Owner CASCADE;
DROP TABLE IF EXISTS Venue CASCADE;
DROP TABLE IF EXISTS Seats CASCADE;
DROP TABLE IF EXISTS Concert CASCADE;
DROP TABLE IF EXISTS Price CASCADE;
DROP TABLE IF EXISTS Users CASCADE;
DROP TABLE IF EXISTS Purchase CASCADE;


-- In this table, we have made sure that the phonenumber
-- is unique. Thus, No two owners have the same phone number.
CREATE TABLE Owner (
  owner_id integer PRIMARY KEY,
  name varchar(60) NOT NULL,
  phonenumber varchar(60) NOT NULL unique
);


-- Concerts are booked in venues. 
-- In this table, we have a foreign key owner_id which 
-- prevents redundancy of owner data.
-- This allows some people/organizations own multiple venues 
-- but all venues have a single owner.
CREATE TABLE Venue (
  venue_id integer PRIMARY KEY,
  name varchar(60) NOT NULL,
  city varchar(60) NOT NULL,
  address varchar(60) NOT NULL,
  owner_id integer NOT NULL,
  unique (name, city, address),
  foreign key (owner_id) references Owner(owner_id)
);


-- Each seat has a unique identifier as seat_name.
-- Seats in a venue are organized into sections
-- Every seat belongs to exactly one section.
-- Each section has a name, that is unique to
-- that venue, but another venue might use the same section name.
-- Seat names do not repeat within the same section in a venue. But two different 
-- sections may have seats with the same name.
-- We achieve this by making seat_name, venue_id and section unique at the same time.
CREATE TABLE Seats (
  seat_id integer PRIMARY KEY,
  seat_name varchar(60) NOT NULL,
  venue_id integer NOT NULL,
  section varchar(60) NOT NULL,
  mobility boolean NOT NULL,
  unique (seat_name, venue_id, section),
  foreign key (venue_id) references Venue(venue_id)
);

-- Stores the concert information.
CREATE TABLE Concert (
  concert_id integer PRIMARY KEY,
  name varchar(60) NOT NULL,
  venue_id integer NOT NULL,
  date_and_time timestamp NOT NULL,
  unique (venue_id, date_and_time),
  foreign key (venue_id) references Venue(venue_id)
);

-- The price of a ticket depends the concert and the section in which the 
-- seat is located in the venue.
CREATE TABLE Price (
  ticket_id integer PRIMARY KEY,
  concert_id integer NOT NULL,
  section varchar(60) NOT NULL,
  price integer NOT NULL,
  foreign key (concert_id) references Concert(concert_id)
);


-- Each user has a unique username.
CREATE TABLE Users (
  username varchar(60) PRIMARY KEY,
  name varchar(60) NOT NULL
);


-- A user can purchase one or more tickets to any concert. 
-- When we record this, we also record the date and time of purchase as well as 
-- the quantity of tickets purchased.
CREATE TABLE Purchase (
  username varchar(60) NOT NULL,  
  ticket_id integer NOT NULL,
  date_and_time timestamp NOT NULL,
  quantity integer NOT NULL,
  primary key (username, ticket_id),
  foreign key (username) references Users(username),
  foreign key (ticket_id) references Price(ticket_id)
);



