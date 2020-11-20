## Austin TX Airbnb SQL Project

**Data Source**
http://insideairbnb.com/get-the-data.html

**Data** 

 1. **calendar_austin.csv**: This file contains the future available dates    and price of the listings
 2. **listings_austin.csv**: This file contains all information related to previous listing such as property info and reviews
 3. **hosts_austin.csv**: This file contains information about hosts who have listings in Austin TX

**Relational Database Schema**

 1. **calendar**: Table contains all information from calendar_austin.csv file
 2. **listings**: Table contains listings information from the austin_listings.csv file
 3. **hosts**: Table contains hosts information from the hosts_austin.csv file

**Schema Relationship**

 - Hosts and listings tables are linked together by host_id
 - Listings and calendar tables are linked together by listing_id




#### OPERATIONAL LAYER: 
Create an operational data layer in MySQL. Import a relational data set of your choosing into your local instance. Find a data which makes sense to be transformed in analytical data layer for further analytics. In ideal case, you can use the outcome of HW1.

#### ANALYTICS:
Create a short plan of what kind of analytics can be potentially executed on this data set. Plan how the analytical data layer, ETL, Data Mart would look like to support these analytics. (Remember ProductSales example during the class).

#### ANALYTICAL LAYER:
Design a denormalized data structure using the operational layer. Create table in MySQL for this structure.

#### ETL PIPLINE:
Create an ETL pipeline using Triggers, Stored procedures. Make sure to demonstrate every element of ETL (Extract, Transform, Load)

#### DATA MART:
Create Views as data marts.

*Optional: create Materialized Views with Events for some of the data marts.
