# airbnb-prague-sql-analysis
SQL data cleaning and analysis project focused on Airbnb listings in Prague.
## Project overview

This project analyzes Airbnb listings in Prague using SQL.  
The goal is to load the dataset, clean the data, check data quality and prepare the data for further exploratory analysis.

## Dataset

The project uses Airbnb data for Prague from Inside Airbnb.

Main tables:

- `listings` — information about Airbnb listings
- `calendar` — availability of listings by date
- `reviews` — reviews related to individual listings

## Tools used

- SQL
- MySQL
- DataGrip
- GitHub

## Project structure
```
airbnb-prague-sql-analysis/
├--- README.md
|----data/
├--- sql/
│   ├── 01_schema.sql
│   ├── 02_data_cleaning.sql
│   ├── 03_exploration.sql
│   ├── 04_analysis.sql
│   └── 05_advanced.sql
├---data/
└--- outputs/
```
## SQL files

### 01_schema.sql
Initial database checks:
- checking imported tables
- checking table structure
- checking row counts
- verifying relationships between tables

### 02_data_cleaning.sql
Data cleaning process:
- checking NULL values
- cleaning the `price` column
- creating `price_clean`
- converting selected columns to correct data types
- checking duplicates
- checking category consistency
- checking value ranges
- checking logical consistency between columns

### 03_exploration.sql
Exploratory data analysis:
- basic distributions
- listings by room type
- prices by neighbourhood
- review and availability patterns

### 04_analysis.sql
Main business analysis:
- revenue-related questions
- performance by neighbourhood and room type
- relationship between price, reviews and rating

### 05_advanced.sql
Advanced SQL analysis:
- CTEs
- window functions
- ranking
- trend analysis

## Current project status

- `01_schema.sql` — finished
- `02_data_cleaning.sql` — finished
- `03_exploration.sql` — finished
- `04_analysis.sql` — planned
- `05_advanced.sql` — planned
