/*
Program: load_climate_data.sql
Author: Anthony P
Date: 10/19/21
Description: Load Climate Data; run using "SOURCE ./filename.type"
            Run SECOND.
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

-- Load Dataset1 into climate_data table:
LOAD DATA LOCAL INFILE 'Dataset_1.csv' 
INTO TABLE climate_data 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
    (station_id, station_name, latitude, longitude, elevation, @cd_date, 
     @precip_days_total, @multi_precip_total, @multi_snow_total, @precip_total, 
     @snowfall, @snow_depth, @average_temp, @max_temp, @min_temp, @observation_temp, 
     @grnd_snow_water, @snowfall_water, @wt01, @wt03, @wt04, @wt05, @wt06, @wt11)
SET cd_date = STR_TO_DATE(@cd_date, '%Y-%m-%d'), 
    dataset = 1,
    multi_precip_total = CAST(@multi_precip_total AS DECIMAL(3,2)),
    precip_total = CAST(@precip_total AS DECIMAL(5,2)), 
    snowfall = CAST(@snowfall AS DECIMAL(4,1)),
    snow_depth = CAST(@snow_depth AS DECIMAL(5,1)),
    average_temp = CAST(@average_temp AS INTEGER),
    max_temp = CAST(@max_temp AS INTEGER),
    min_temp = CAST(@min_temp AS INTEGER),
    observation_temp = CAST(@observation_temp AS INTEGER),
    grnd_snow_water = CAST(@grnd_snow_water AS DECIMAL(3,1)),
    snowfall_water = CAST(@snowfall_water AS DECIMAL(3,1)),
    wt01 = IF(CAST(@wt01 AS INTEGER) = 1, 1, 0),
    wt03 = IF(CAST(@wt03 AS INTEGER) = 1, 1, 0),
    wt04 = IF(CAST(@wt04 AS INTEGER) = 1, 1, 0),
    wt05 = IF(CAST(@wt05 AS INTEGER) = 1, 1, 0),
    wt06 = IF(CAST(@wt06 AS INTEGER) = 1, 1, 0),
    wt11 = IF(CAST(@wt11 AS INTEGER) = 1, 1, 0);


-- Load Dataset2 into climate_data table:
LOAD DATA LOCAL INFILE 'Dataset_2.csv' 
INTO TABLE climate_data 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
    (station_id, station_name, latitude, longitude, elevation, @cd_date, 
     @precip_days_total, @multi_precip_total, @precip_total, 
     @snowfall, @snow_depth, @average_temp, @max_temp, @min_temp, 
     @grnd_snow_water, @snowfall_water)
SET cd_date = STR_TO_DATE(@cd_date, '%Y-%m-%d'), 
    dataset = 2,
    multi_precip_total = CAST(@multi_precip_total AS DECIMAL(3,2)),
    precip_total = CAST(@precip_total AS DECIMAL(5,2)), 
    snowfall = CAST(@snowfall AS DECIMAL(4,1)),
    snow_depth = CAST(@snow_depth AS DECIMAL(5,1)),
    average_temp = CAST(@average_temp AS INTEGER),
    max_temp = CAST(@max_temp AS INTEGER),
    min_temp = CAST(@min_temp AS INTEGER),
    grnd_snow_water = CAST(@grnd_snow_water AS DECIMAL(3,1)),
    snowfall_water = CAST(@snowfall_water AS DECIMAL(3,1));


-- Load Dataset3 into climate_data table:
LOAD DATA LOCAL INFILE 'Dataset_3.csv' 
INTO TABLE climate_data 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
    (station_id, station_name, latitude, longitude, elevation, @cd_date, @avg_wind_speed, @precip_days_total, 
    @sf_days_in_multiday, @fastest_mile, @multi_precip_total, @multi_snow_total, @peak_gust, @precip_total, 
    @sunshine_percent, @snowfall, @snow_depth, @average_temp, @max_temp, @min_temp, @observation_temp, 
    @sunshine_total, @wind_direction_2, @wind_direction_5, @gust_direction, @grnd_snow_water, @snowfall_water, 
    @wind_speed_2, @wind_speed_5, @gust_wind_speed, @wt01, @wt02, @wt03, @wt04, @wt05, @wt06, @wt07, @wt08, @wt09, 
    @wt10, @wt11, @wt13, @wt14, @wt15, @wt16, @wt17, @wt18, @wt19, @wt21, @wt22, @wv01, @wv03)
SET cd_date = STR_TO_DATE(@cd_date, '%Y-%m-%d'), 
    dataset = 3,
    avg_wind_speed = CAST(@avg_wind_speed AS DECIMAL(4,2)),
    precip_days_total = CAST(@precip_days_total AS INTEGER),
    multi_precip_total = CAST(@multi_precip_total AS DECIMAL(3,2)),
    multi_snow_total = CAST(@multi_snow_total AS INTEGER),
    peak_gust = CAST(@peak_gust AS TIME),
    precip_total = CAST(@precip_total AS DECIMAL(5,2)), 
    snowfall = CAST(@snowfall AS DECIMAL(4,1)),
    snow_depth = CAST(@snow_depth AS DECIMAL(5,1)),
    average_temp = CAST(@average_temp AS INTEGER),
    max_temp = CAST(@max_temp AS INTEGER),
    min_temp = CAST(@min_temp AS INTEGER),
    observation_temp = CAST(@observation_temp AS INTEGER),
    grnd_snow_water = CAST(@grnd_snow_water AS DECIMAL(3,1)),
    snowfall_water = CAST(@snowfall_water AS DECIMAL(3,1)),
    wt01 = IF(CAST(@wt01 AS INTEGER) = 1, 1, 0),
    wt02 = IF(CAST(@wt02 AS INTEGER) = 1, 1, 0),
    wt03 = IF(CAST(@wt03 AS INTEGER) = 1, 1, 0),
    wt04 = IF(CAST(@wt04 AS INTEGER) = 1, 1, 0),
    wt05 = IF(CAST(@wt05 AS INTEGER) = 1, 1, 0),
    wt06 = IF(CAST(@wt06 AS INTEGER) = 1, 1, 0),
    wt07 = IF(CAST(@wt07 AS INTEGER) = 1, 1, 0),
    wt08 = IF(CAST(@wt08 AS INTEGER) = 1, 1, 0),
    wt09 = IF(CAST(@wt09 AS INTEGER) = 1, 1, 0),
    wt10 = IF(CAST(@wt10 AS INTEGER) = 1, 1, 0),
    wt11 = IF(CAST(@wt11 AS INTEGER) = 1, 1, 0),
    wt13 = IF(CAST(@wt13 AS INTEGER) = 1, 1, 0),
    wt14 = IF(CAST(@wt14 AS INTEGER) = 1, 1, 0),
    wt15 = IF(CAST(@wt15 AS INTEGER) = 1, 1, 0),
    wt16 = IF(CAST(@wt16 AS INTEGER) = 1, 1, 0),
    wt17 = IF(CAST(@wt17 AS INTEGER) = 1, 1, 0),
    wt18 = IF(CAST(@wt18 AS INTEGER) = 1, 1, 0),
    wt19 = IF(CAST(@wt19 AS INTEGER) = 1, 1, 0),
    wt21 = IF(CAST(@wt21 AS INTEGER) = 1, 1, 0),
    wt22 = IF(CAST(@wt22 AS INTEGER) = 1, 1, 0);


-- Load weather types, (tab delimited text-file), into weather_types table:
LOAD DATA LOCAL INFILE 'WTDataset.txt'
INTO TABLE weather_types 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
      (wt_id, description);
