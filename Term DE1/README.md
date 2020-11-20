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

### ANALYTICAL LAYER ###
Design a denormalized data structure using the operational layer.\

#### Stored Procedure ####
~~~~
DROP PROCEDURE IF EXISTS Get_Available_listings;

DELIMITER $$

CREATE PROCEDURE Get_Available_listings()
BEGIN

	DROP TABLE IF EXISTS available_listings;

	CREATE TABLE available_listings AS
	SELECT 
	   listings.listing_id,
	   listings.listing_name,
	   calendar.available_date,
       listings.property_type,
       listings.room_type,
       listings.accommodates,
       listings.beds,
       calendar.minimum_nights,
       calendar.maximum_nights,
       calendar.price,
	   hosts.host_id,
       hosts.host_name
	FROM
		listings
	INNER JOIN
		calendar USING (listing_id)
	INNER JOIN
		hosts USING (host_id)
	ORDER BY available_date;

END $$
DELIMITER ;

Call Get_Available_listings();

-- View Data Warehouse
SELECT * FROM available_listings;
~~~~
~~~~
DELIMITER $$

CREATE TRIGGER update_host_rating
AFTER INSERT
ON listings FOR EACH ROW
BEGIN
TRUNCATE TABLE host_ratings;

	INSERT INTO host_ratings
	SELECT host_id,
	host_name = old.host_name,
	host_since,
	host_is_superhost,
	number_of_reviews,
	host_listings_count,
	avg(review_scores_rating) AS host_rating
	FROM listings
	INNER JOIN hosts
	USING(host_id)
	GROUP BY host_id;
END$$

DELIMITER ;
~~~~

##### Testing ####
TEST TRIGGER BY INSERTING A NEW ROW INTO HOST AND LISTING TABLES
~~~~
INSERT INTO hosts(host_id,host_name, host_since, host_is_superhost, host_listings_count)
VALUES
	(99,'Fasih','2020/11/20','t',5);

INSERT INTO listings(listing_id,host_id,listing_name,listing_description,property_type,room_type,accommodates,bathrooms,bedrooms,beds,price,minimum_nights,maximum_nights,number_of_reviews,review_scores_rating,review_scores_accuracy,review_scores_cleanliness,review_scores_checkin,review_scores_communication, review_scores_location, review_scores_value)
VALUES
 (99,99,'Zen-East','Its great!','Entire house','Entire home/apt',4,'2 baths',2,2,179,7,180,24,93,0,1,1,1,1,1); 
 ~~~~
 
 Trigger ran successfully
 ~~~~
  -- TRIGGER WAS SUCCESSFUL. NEW HOST WAS SUCCESSFULLY ADDED IN HOST_RATINGS TABLE
 SELECT * FROM host_ratings
 WHERE host_id = 99;
 ~~~~
 
### VIEW ###

~~~~
 -- Create VIEW for summary statistics of property type in relation to price
DROP VIEW IF EXISTS property_type_stats; 

CREATE VIEW `property_type_stats` AS
SELECT property_type AS 'Property Type',
		COUNT(property_type) AS 'No of Listings',
	   ROUND(Min(price)) AS 'Min Price (Total)',
       ROUND(Max(price)) AS 'Max Price (Total)',
       ROUND(AVG(price)) AS 'Avg Price (Total)',
       ROUND( MIN(price/accommodates)) AS 'Min Price (Person)',
       ROUND(MAX(price/accommodates)) AS 'Max Price (Person)',
       ROUND(AVG(price/accommodates)) AS 'Avg Price (Person)'
FROM available_listings
GROUP BY property_type
ORDER BY property_type;
~~~~

### Materialized View with Event
Hosts with host rating score less than 50

~~~~
DROP VIEW IF EXISTS host_rating_warning;

CREATE TABLE messages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    message VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL
);

SET GLOBAL event_scheduler = ON;

DELIMITER $$

CREATE EVENT host_rating_warning_refresh
ON SCHEDULE EVERY 1 MINUTE
STARTS CURRENT_TIMESTAMP
ENDS CURRENT_TIMESTAMP + INTERVAL 5 minute
DO
	BEGIN
		DROP VIEW IF EXISTS host_rating_warning;
        
		CREATE VIEW host_rating_warning AS
		SELECT *
		FROM host_ratings
		WHERE host_rating < 70 AND number_of_reviews > 0
		ORDER BY host_rating DESC;

		INSERT INTO messages(message,created_at)
		VALUES('Event was generated. Host_rating_warning view was updated.',NOW());
	
	END$$
DELIMITER ;

SELECT * FROM host_rating_warning;
~~~~
 
