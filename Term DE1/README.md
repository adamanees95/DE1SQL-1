## Austin TX Airbnb SQL Project

**Data Source**
http://insideairbnb.com/get-the-data.html

### Data ###

 1. **calendar_austin.csv**: This file contains the future available dates    and price of the listings
 2. **listings_austin.csv**: This file contains all information related to previous listing such as property info and reviews
 3. **hosts_austin.csv**: This file contains information about hosts who have listings in Austin TX

### Relational Database Schema ###

 1. **calendar**: Table contains all information from calendar_austin.csv file
 2. **listings**: Table contains listings information from the austin_listings.csv file
 3. **hosts**: Table contains hosts information from the hosts_austin.csv file

### Schema Relationship ###

 - Hosts and listings tables are linked together by host_id
 - Listings and calendar tables are linked together by listing_id


### OPERATIONAL LAYER ###
Create an operational data layer in MySQL. Import a relational data set of your choosing into your local instance. Find a data which makes sense to be transformed in analytical data layer for further analytics.\
 
**Create our first database / schema**
~~~~
DROP SCHEMA IF EXISTS airbnb;
CREATE SCHEMA airbnb;

-- Set airbnb schema as default
USE airbnb;
~~~~

 We will now create 3 tables inside the schema and import data in those tables:
 
1. Hosts
~~~~
DROP TABLE IF EXISTS hosts;
CREATE TABLE hosts (
    host_id INT NOT NULL,
    PRIMARY KEY(host_id),
    host_name VARCHAR(100),
    host_since DATE,
    host_is_superhost CHAR(5),
    host_listings_count INT
);

-- Import host.csv data into hosts table
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\hosts_austin.csv' 
INTO TABLE hosts
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
(host_id, host_name, @host_since, host_is_superhost, @host_listings_count)
SET
host_since = nullif(@host_since, ''),
host_listings_count = nullif(@host_listings_count,'');
~~~~

2. Listings
~~~~
DROP TABLE IF EXISTS listings;
CREATE TABLE listings (
    listing_id INT NOT NULL,
    PRIMARY KEY (listing_id),
    host_id INT NOT NULL,
    listing_name VARCHAR(255),
    listing_description VARCHAR(10500),
    property_type VARCHAR(50),
    room_type VARCHAR(50),
    accommodates VARCHAR(50),
    bathrooms VARCHAR(25),
    bedrooms INT,
    beds INT,
    price INT,
    minimum_nights INT,
    maximum_nights INT,
    number_of_reviews INT,
    review_scores_rating INT,
    review_scores_accuracy INT,
    review_scores_cleanliness INT,
    review_scores_checkin INT,
    review_scores_communication INT,
    review_scores_location INT,
    review_scores_value INT,
    FOREIGN KEY(host_id) REFERENCES airbnb.host(host_id));
    
    
-- Import listing_austin.csv data into listings table
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\listings_austin.csv' 
INTO TABLE listings
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
(listing_id,host_id,listing_name,listing_description,property_type,room_type,accommodates,bathrooms,@bedrooms,@beds,@price,@minimum_nights,@maximum_nights,number_of_reviews,@review_scores_rating,@review_scores_accuracy,@review_scores_cleanliness,@review_scores_checkin,@review_scores_communication,@review_scores_location,@review_scores_value)
SET
bedrooms = nullif(@bedrooms, ''),
beds = nullif(@beds, ''),
price = nullif(@price, ''),
minimum_nights = nullif(@minimum_nights, ''),
maximum_nights = nullif(@maximum_nights, ''),
review_scores_rating = nullif(@review_scores_rating , ''),
review_scores_accuracy = nullif(@review_Scores_accuracy, ''),
review_scores_cleanliness = nullif(@review_scores_cleanliness,''),
review_scores_checkin = nullif(@review_scores_checkin, ''),
review_scores_communication = nullif(@review_scores_communication,''),
review_scores_location = nullif(@review_scores_location,''),
review_scores_value = nullif(@review_scores_value,'');
~~~~

3. Calendar
~~~~
DROP TABLE IF EXISTS calendar;
CREATE TABLE calendar (
    listing_id INT NOT NULL,
    available_date DATE,
    available VARCHAR(5),
    price INT,
    minimum_nights INT,
    maximum_nights INT,
    FOREIGN KEY (listing_id) REFERENCES listings(listing_id)
);

-- Import availability.csv data into calendar table
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\calendar_austin.csv' 
INTO TABLE calendar
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
(listing_id, available_date, available, @price, @minimum_nights, @maximum_nights)
SET
price = nullif(@price, ''),
minimum_nights = nullif(@minimum_nights, ''),
maximum_nights = nullif(@maximum_nights, '');
~~~~


-- Create new host_rating table with overall host rating
DROP TABLE IF EXISTS host_ratings;
CREATE TABLE host_ratings
SELECT host_id,
host_name,
host_since,
host_is_superhost,
number_of_reviews,
host_listings_count,
avg(review_scores_rating) AS host_rating
FROM listings
INNER JOIN hosts
USING(host_id)
GROUP BY host_id;

-- Create table 'reviews' in airbnb schema (Table updated)
DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
    review_id INTEGER NOT NULL,
    PRIMARY KEY (review_id),
    listing_id INT,
    reviewer_id INT,
    reviewer_name VARCHAR(100),
    review_date DATE ,
    comments VARCHAR(10500),
	FOREIGN KEY(listing_id) REFERENCES listings(listing_id)
);

-- Import reviews.csv data into reviews table
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\reviews_austin.csv' 
INTO TABLE reviews
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
(review_id, listing_id,reviewer_id,reviewer_name,review_date,comments);


DROP TABLE IF EXISTS calendar;
CREATE TABLE calendar (
    listing_id INT NOT NULL,
    available_date DATE,
    available VARCHAR(5),
    price INT,
    minimum_nights INT,
    maximum_nights INT,
    FOREIGN KEY (listing_id) REFERENCES listings(listing_id)
);

-- Import availability.csv data into availability table
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\calendar_austin.csv' 
INTO TABLE calendar
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
(listing_id, available_date, available, @price, @minimum_nights, @maximum_nights)
SET
price = nullif(@price, ''),
minimum_nights = nullif(@minimum_nights, ''),
maximum_nights = nullif(@maximum_nights, '');
~~~~
