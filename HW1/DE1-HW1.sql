-- Creating the database 'world'
CREATE SCHEMA world;

-- Setting 'world' as default
USE world;

-- Creating table 'city' in 'world' schema
CREATE TABLE city (
id int NOT NULL, PRIMARY KEY (id),
cityname char(50) NOT NULL DEFAULT '',
countrycode char(3) NOT NULL DEFAULT '',
district char(50) NOT NULL DEFAULT '',
population int NOT NULL DEFAULT '0');

-- Importing data into the table 'city'  
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\city.csv'
INTO TABLE city
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(iD, cityname, countrycode, district, population);

-- Creating table 'country' in 'world' schema
CREATE TABLE country (
country_code char(3) NOT NULL, PRIMARY KEY (country_code),
country_name char(50) NOT NULL,
continent char(50) NOT NULL,
surface_area int NOT NULL DEFAULT '0',
population int NOT NULL DEFAULT '0',
gnp decimal(10,2) NOT NULL,
government_form char(50) NOT NULL,
code2 char(3) NOT NULL);

-- Importing data into the table 'country'  
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\country.csv'
INTO TABLE country
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\\' -- tip from stackoverflow
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(country_code, country_name, continent, surface_area, population, gnp, government_form, code2);

-- Creating table 'countrylanguage' in 'world' schema
CREATE TABLE countrylanguage (
country_code char(3) NOT NULL, PRIMARY KEY (country_code,language),
language char(30) NOT NULL,
isOfficial enum('T','F') NOT NULL,
percentage decimal(4,1) NOT NULL);
  
-- Importing data into the table 'countrylanguage'  
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\countrylanguage.csv'
INTO TABLE countrylanguage
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(country_code, language, isOfficial, percentage);
  
  



