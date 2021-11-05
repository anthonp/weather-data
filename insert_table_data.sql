/*
Program: insert_table_data.sql
Author: Anthony P
Date: 10/19/21
Description: Insert table data for tables; run using "SOURCE ./filename.type"
            Run THIRD(LAST).
*/

/*
Dataset 1; One Year Jefferson County, Colorado; SLAVE:
"STATION","NAME","LATITUDE","LONGITUDE","ELEVATION","DATE","DAPR","MDPR","MDSF","PRCP","SNOW","SNWD","TAVG","TMAX","TMIN","TOBS","WESD","WESF",
"WT01","WT03","WT04","WT05","WT06","WT11"

Dataset 2; One Decade Many Stations Colorado; SLAVE:
"STATION","NAME","LATITUDE","LONGITUDE","ELEVATION","DATE","DAPR","MDPR","PRCP","SNOW","SNWD","TAVG","TMAX","TMIN","WESD","WESF"

Dataset 3; One Month Blizzard Jefferson County, Colorado; MASTER:
"STATION","NAME","LATITUDE","LONGITUDE","ELEVATION","DATE","AWND","DAPR","DASF","FMTM","MDPR","MDSF","PGTM","PRCP","PSUN","SNOW","SNWD","TAVG",
"TMAX","TMIN","TOBS","TSUN","WDF2","WDF5","WDFG","WESD","WESF","WSF2","WSF5","WSFG","WT01","WT02","WT03","WT04","WT05","WT06","WT07","WT08",
"WT09","WT10","WT11","WT13","WT14","WT15","WT16","WT17","WT18","WT19","WT21","WT22","WV01","WV03"
*/

-- Load weather stations from climate_data into weather_stations:

INSERT INTO weather_stations (
       station_id,
       station_name,
       latitude,
       longitude,
       elevation )
SELECT DISTINCT 
       station_id,
       station_name,
       latitude,
       longitude,
       elevation 
FROM   climate_data; 

-- Load air temperature data from cilmate_data into air_temperature:

INSERT INTO air_temperature (
       station_id,
       at_date,
       dataset,
       average_temp,
       max_temp,
       min_temp, 
       observation_temp )
SELECT DISTINCT 
       station_id,
       cd_date,
       dataset,
       average_temp,
       max_temp,
       min_temp,
       observation_temp 
FROM   climate_data; 

-- Load precipitation data from climate_data into precipitation:

INSERT INTO precipitation (
       station_id,
       p_date,
       dataset,
       precip_days_total,
       multi_precip_total,
       multi_snow_total,
       precip_total,
       snowfall,
       snow_depth, 
       grnd_snow_water, 
       snowfall_water )
SELECT
       station_id,
       cd_date,
       dataset,
       precip_days_total,
       multi_precip_total,
       multi_snow_total,
       precip_total,
       snowfall,
       snow_depth,
       grnd_snow_water,
       snowfall_water
FROM   climate_data
WHERE  precip_days_total IS NOT NULL
       OR multi_precip_total IS NOT NULL
       OR multi_snow_total IS NOT NULL
       OR precip_total IS NOT NULL
       OR snowfall IS NOT NULL
       OR snow_depth IS NOT NULL
       OR grnd_snow_water IS NOT NULL
       OR snowfall_water IS NOT NULL;

-- Load wind data from climate_data into wind:

INSERT INTO wind (
       station_id,
       wi_date,
       dataset,
       avg_wind_speed,
       peak_gust )
SELECT DISTINCT 
       station_id,
       cd_date,
       dataset,
       avg_wind_speed,
       peak_gust
FROM   climate_data; 

-- Load weather information from climate_data into weather

INSERT INTO weather (
       station_id,
       we_date,
       dataset,
       w_type )
SELECT
       station_id,
       cd_date,
       dataset,
       'WT01'
FROM   climate_data
WHERE  wt01
UNION ALL
SELECT
       station_id,
       cd_date,
       dataset,
       'WT02'
FROM   climate_data
WHERE  wt02
UNION ALL
SELECT
       station_id,
       cd_date,
       dataset,
       'WT03'
FROM   climate_data
WHERE  wt03
UNION ALL
SELECT
       station_id,
       cd_date,
       dataset,
       'WT04'
FROM   climate_data
WHERE  wt04
UNION ALL
SELECT
       station_id,
       cd_date,
       dataset,
       'WT05'
FROM   climate_data
WHERE  wt05
UNION ALL
SELECT
       station_id,
       cd_date,
       dataset,
       'WT06'
FROM   climate_data
WHERE  wt06
UNION ALL
SELECT
       station_id,
       cd_date,
       dataset,
       'WT07'
FROM   climate_data
WHERE  wt07
UNION ALL
SELECT
       station_id,
       cd_date,
       dataset,
       'WT08'
FROM   climate_data
WHERE  wt08
UNION ALL
SELECT
       station_id,
       cd_date,
       dataset,
       'WT09'
FROM   climate_data
WHERE  wt09
UNION ALL
SELECT
       station_id,
       cd_date,
       dataset,
       'WT10'
FROM   climate_data
WHERE  wt10
UNION ALL
SELECT
       station_id,
       cd_date,
       dataset,
       'WT11'
FROM   climate_data
WHERE  wt11
UNION ALL
SELECT
       station_id,
       cd_date,
       dataset,
       'WT13'
FROM   climate_data
WHERE  wt13
UNION ALL
SELECT
       station_id,
       cd_date,
       dataset,
       'WT14'
FROM   climate_data
WHERE  wt14
UNION ALL
SELECT
       station_id,
       cd_date,
       dataset,
       'WT15'
FROM   climate_data
WHERE  wt15
UNION ALL
SELECT
       station_id,
       cd_date,
       dataset,
       'WT16'
FROM   climate_data
WHERE  wt16
UNION ALL
SELECT
       station_id,
       cd_date,
       dataset,
       'WT17'
FROM   climate_data
WHERE  wt17
UNION ALL
SELECT
       station_id,
       cd_date,
       dataset,
       'WT18'
FROM   climate_data
WHERE  wt18
UNION ALL
SELECT
       station_id,
       cd_date,
       dataset,
       'WT19'
FROM   climate_data
WHERE  wt19
UNION ALL
SELECT
       station_id,
       cd_date,
       dataset,
       'WT21'
FROM   climate_data
WHERE  wt21
UNION ALL
SELECT
       station_id,
       cd_date,
       dataset,
       'WT22'
FROM   climate_data
WHERE  wt22;
