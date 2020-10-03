USE birdstrikes;

-- Exercise1: What state figures in the 145th line of our database?
SELECT * FROM birdstrikes LIMIT 145;
-- Answer: Tennessee

-- Exercise2: What is flight_date of the latest birstrike in this database?
SELECT * FROM birdstrikes ORDER BY flight_date DESC;
-- Answer: 2000-04-18

-- Exercise3: What was the cost of the 50th most expensive damage?
SELECT DISTINCT cost FROM birdstrikes ORDER BY cost DESC LIMIT 50;
-- Answer: 5345

-- Exercise4: What state figures in the 2nd record, if you filter out all records which have no state and no bird_size specified?
SELECT * FROM birdstrikes WHERE state IS NOT NULL AND bird_size IS NOT NULL;
-- Answer: ''

-- Exercise5: How many days elapsed between the current date and the flights happening in week 52, for incidents from Colorado?
SELECT WEEKOFYEAR(flight_date), flight_date FROM birdstrikes WHERE state = 'Colorado'; -- Answer: 2000-01-01
SELECT NOW() AS 'current_date';
SELECT DATEDIFF('2020-10-02','2000-01-01');
-- Answer: 7580








