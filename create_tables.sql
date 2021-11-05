/*
Program: create_tables.sql
Author: Anthony P
Date: 10/18/21
Description: Create Table Script, run using "SOURCE ./filename.type"
              All existing climate data will be removed!
              Creates NEW tables!
              NOTE: "Record" in this file is for documentation purposes; tables are referred to as "records" by developer.
              Run FIRST.
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

/*
Delete table if it exists:
*/

DROP TABLE IF EXISTS weather;
DROP TABLE IF EXISTS wind;
DROP TABLE IF EXISTS air_temperature;
DROP TABLE IF EXISTS precipitation;
DROP TABLE IF EXISTS weather_types;
DROP TABLE IF EXISTS weather_stations;
DROP TABLE IF EXISTS climate_data;

/*
GENERAL TABLE OVERVIEW FOR ALL DATA IN climate_data & 6 other tables (Dataset 3 is the master record; Datasets 1 and 2 are slave records):

station_id           STATION       STRING, 11 characters              Station ID, expressed as a string of letters and digits.
station_name         NAME          STRING, MAX 30-50 chars            Name of station, expressed in separated words. 10-20ish characters long.
latitude             LATITUDE      DECIMAL, ##.######## MAX OF 11     Latitude, expressed as floating-point number; details location.
longitude            LONGITUDE     DECIMAL, ##.######## MAX OF 11     Longitude, expressed as floating-point number; details location.
elevation            ELEVATION     DECIMAL, ####.#                    Elevation, expressed as floating-point number; details height.
cd_date              DATE          YYYY-MM-DD                         Date, expressed as string with separation characters.
avg_wind_speed       AWND          DECIMAL, ##.##                     Average daily wind speed in mph.
precip_days_total    DAPR          INTEGER, #, EMPTY SET 1            Day count in multiday precipitation total, expressed as whole numbers.
sf_days_in_multiday  DASF          EMPTY IN SET 2,3, DO NOT CAST      Number of days in multiday snowfall. Empty or redundant, will not use.
fastest_mile         FMTM          INTEGER, ####, DO NOT CAST         Fastest 1-minute wind. Useless, will not use.
multi_precip_total   MDPR          DECIMAL, #.##                      Multiday precipitation total in inches.
multi_snow_total     MDSF          EMPTY IN SET 3, DO NOT CAST        Multiday snowfall total in inches.
peak_gust            PGTM          INTEGER ####                       Peak gust time, hours and minutes, HHMM.
precip_total         PRCP          DECIMAL, ##.##                     Total precipitation expressed in floating-point value. Details total rainfall.
sunshine_percent     PSUN          EMPTY IN SET 3, DO NOT CAST        Percent of daily possible sunshine. Useless, will not use.
snowfall             SNOW          DECIMAL, ##.#                      Amount of snow falling represented in inches as floating-point value.
snow_depth           SNWD          DECIMAL, ##.#                      Depth of snow expressed in floating-point value representing inches on ground.
average_temp         TAVG          INTEGER ###                        The average temperature expressed as 2-digit + floating-point value.
max_temp             TMAX          INTEGER ###                        The maximum temperature expressed as 2/3-digit + floating-point value.
min_temp             TMIN          INTEGER ###                        Minimum temperature expressed as 1/2-digit + floating-point value.
observation_temp     TOBS          INTEGER ###                        The temperature taken at time of watch; floating-point value.
sunshine_total       TSUN          EMPTY IN SET 3, DO NOT CAST        Daily total sunshine in minutes. Empty column. Will not use.
wind_direction_2     WDF2          INTEGER                            Direction of fastest 2-minute wind in degrees. Useless, will not use.
wind_direction_5     WDF5          INTEGER                            Direction of fastest 5-second wind in degrees. Useless, will not use.
gust_direction       WDFG          EMPTY IN SET 3, DO NOT CAST        Direction of peak wind gust in degrees. Useless, will not use.
grnd_snow_water      WESD          DECIMAL, ##.#                      Water-equivalent of snow on ground, represented in floating-point value as inches.
snowfall_water       WESF          DECIMAL, #.#                       Water-equivalent of snowfall, represented in floating-point value as inches.
wind_speed_2         WSF2          DECIMAL, ##.#                      Fastest 2-minute wind speed in mph, useless, will not use.
wind_speed_5         WSF5          DECIMAL, ##.#                      Fastest 5-second wind speed in mph, useless, will not use.
gust_wind_speed      WSFG          EMPTY IN SET 3, DO NOT CAST        Peak gust wind speed in mph, empty column, will not use.
type                 WT01          INTEGER #                          Weather type, fog.
type                 WT02          INTEGER #                          Weather type, heavy fog.
type                 WT03          INTEGER #                          Weather type, thunder.
type                 WT04          INTEGER #                          Weather type, ice pellets.
type                 WT05          INTEGER #                          Weather type, hail.
type                 WT06          INTEGER #                          Weather type, glaze/rime.
type                 WT07          INTEGER #                          Weather type, dust/ash.
type                 WT08          INTEGER #                          Weather type, smoke/haze.
type                 WT09          INTEGER #                          Weather type, blowing/drifting snow.
type                 WT10          INTEGER #                          Weather type, tornado.
type                 WT11          INTEGER #                          Weather type, high wind.
type                 WT13          INTEGER #                          Weather type, mist.
type                 WT14          INTEGER #                          Weather type, drizzle.
type                 WT15          INTEGER #                          Weather type, freezing drizzle.
type                 WT16          INTEGER #                          Weather type, rain.
type                 WT17          INTEGER #                          Weather type, freezing rain.
type                 WT18          INTEGER #                          Weather type, snow.
type                 WT19          INTEGER #                          Weather type, unknown water.
type                 WT21          INTEGER #                          Weather type, ground fog.
type                 WT22          INTEGER #                          Weather type, ice fog.
vicinity_type_1      WV01          INTEGER #, DO NOT CAST AT ALL     Weather in relative vicinity, 1 being fog. Irrelevant information, will not use.
vicinity_type_3      WV03          INTEGER #, DO NOT CAST AT ALL     Weather in relative vicinity, 3 being thunder. Irrelevant information, will not use.
*/

/*
Create Table Diagram (what will be included in master record table climate_data):
Create Table:        climate_data
Columns:             cd_id                                                                 Incrementing auto-id.
                     station_id           STATION       STRING, 11 characters              Station ID, expressed as a string of letters and digits.
                     station_name         NAME          STRING, MAX 30-50 chars            Name of station, expressed in separated words. 10-20ish characters long.
                     latitude             LATITUDE      DECIMAL, ##.######## MAX OF 11     Latitude, expressed as floating-point number; details location.
                     longitude            LONGITUDE     DECIMAL, ##.######## MAX OF 11     Longitude, expressed as floating-point number; details location.
                     elevation            ELEVATION     DECIMAL, ####.#                    Elevation, expressed as floating-point number; details height.
                     cd_date              DATE          YYYY-MM-DD                         Date, expressed as string with separation characters.
                     dataset                                                               Dataset, details which set of data conclusions originate from; integer. 1,2,3
                     avg_wind_speed       AWND          DECIMAL, ##.##                     Average daily wind speed in mph.
                     precip_days_total    DAPR          INTEGER, #, EMPTY SET 1            Day count in multiday precipitation total, expressed as whole numbers.
                     multi_precip_total   MDPR          DECIMAL, #.##                      Multiday precipitation total in inches.
                     multi_snow_total     MDSF          EMPTY IN SET 3, DO NOT CAST        Multiday snowfall total in inches.
                     peak_gust            PGTM          INTEGER ####                       Peak gust time, hours and minutes, HHMM.
                     precip_total         PRCP          DECIMAL, ##.##                     Total precipitation expressed in floating-point value. Details total rainfall.
                     snowfall             SNOW          DECIMAL, ##.#                      Amount of snow falling represented in inches as floating-point value.
                     snow_depth           SNWD          DECIMAL, ##.#                      Depth of snow expressed in floating-point value representing inches on ground.
                     average_temp         TAVG          INTEGER ###                        The average temperature expressed as 2-digit + floating-point value.
                     max_temp             TMAX          INTEGER ###                        The maximum temperature expressed as 2/3-digit + floating-point value.
                     min_temp             TMIN          INTEGER ###                        Minimum temperature expressed as 1/2-digit + floating-point value.
                     observation_temp     TOBS          INTEGER ###                        The temperature taken at time of watch; floating-point value.
                     grnd_snow_water      WESD          DECIMAL, ##.#                      Water-equivalent of snow on ground, represented in floating-point value as inches.
                     snowfall_water       WESF          DECIMAL, #.#                       Water-equivalent of snowfall, represented in floating-point value as inches.
                     type        WT** (01-22), excluding some sequential IDs with prefix WT followed by two digits
*/
/*
Table 1: climate_data creation; GRANDFATHER record; all other 6 tables inherit from this record.
This table is the flat sql data in one table; houses all existing datafields that will be used to construct other tables.
*/

CREATE TABLE climate_data (
       cd_id              INTEGER auto_increment PRIMARY KEY, 
       station_id         VARCHAR(17) NOT NULL, 
       station_name       VARCHAR(50) NOT NULL, 
       latitude           DECIMAL(9,5) NOT NULL, 
       longitude          DECIMAL(10,5) NOT NULL, 
       elevation          DECIMAL(6,1) NOT NULL,
       cd_date            DATE NOT NULL,
       dataset            INTEGER NOT NULL,
       avg_wind_speed     DECIMAL(4,2),
       precip_days_total  INTEGER,
       multi_precip_total DECIMAL(3,2),
       multi_snow_total   INTEGER,
       peak_gust          TIME,
       precip_total       DECIMAL(5,2),
       snowfall           DECIMAL(4,1),
       snow_depth         DECIMAL(5,1),
       average_temp       INTEGER,
       max_temp           INTEGER,
       min_temp           INTEGER,
       observation_temp   INTEGER,
       grnd_snow_water    DECIMAL(3,1),
       snowfall_water     DECIMAL(3,1),
       wt01               BOOLEAN,
       wt02               BOOLEAN,
       wt03               BOOLEAN,
       wt04               BOOLEAN,
       wt05               BOOLEAN,
       wt06               BOOLEAN,
       wt07               BOOLEAN,
       wt08               BOOLEAN,
       wt09               BOOLEAN,
       wt10               BOOLEAN,
       wt11               BOOLEAN,
       wt13               BOOLEAN,
       wt14               BOOLEAN,
       wt15               BOOLEAN,
       wt16               BOOLEAN,
       wt17               BOOLEAN,
       wt18               BOOLEAN,
       wt19               BOOLEAN,
       wt21               BOOLEAN,
       wt22               BOOLEAN 
); 

/*
Create Table Diagram (what will be included in slave record table weather_stations):
Create Table:   weather_stations
Columns:        station_id  Station ID, expressed as a string of letters and digits. STATION
                station_name    Name of station, expressed in separated words. 10-20 characters long. NAME
                latitude    Latitude, expressed as floating-point number; details location. LATITUDE
                longitude   Longitude, expressed as floating-point number; details location. LONGITUDE
                elevation   Elevation, expressed as floating-point number; details height. ELEVATION
*/
/*
Table 2: weather_stations creation; GRANDCHILD record; inherits data from GRANDFATHER record.
This table is an off-shoot of climate_data, and will be used to link other tables together; no foreign-key.
*/

CREATE TABLE weather_stations (
       station_id    VARCHAR(17) PRIMARY KEY,
       station_name  VARCHAR(50) NOT NULL,
       latitude      DECIMAL(9,5) NOT NULL, 
       longitude     DECIMAL(10,5) NOT NULL,
       elevation     DECIMAL(6,1) NOT NULL
);

/*
Create Table Diagram (what will be included in slave record table weather_types):
Create Table:   weather_types
Colummns:       wt_id               
                description
*/
/*
Table 3: weather_types creation; GRANDCHILD record; inherits data from GRANDFATHER record.
This table serves to identify my weather conditions by type ID and description.
*/

CREATE TABLE weather_types (
       wt_id                VARCHAR(4) PRIMARY KEY,
       description          VARCHAR(50) NOT NULL
);

/*
Create Table Diagram (what will be included in slave record table precipitation):
Create Table: precipitation 
Columns:      p_id               INTEGER auto_increment PRIMARY KEY,  Incrementing precip ID.
              station_id         VARCHAR(17) NOT NULL,                Station ID, expressed as a string of letters and digits. STATION
              p_date             DATE NOT NULL,                       Date, expressed as string with separation characters. DATE
              dataset            INTEGER NOT NULL,                    Dataset, details which set of data conclusions originate from; integer. 1,2,3
              multi_precip_total DECIMAL(3,2),                        Multiday precipitation total in inches. MDPR
              multi_snow_total   INTEGER,                             Multiday snowfall total in inches. MDSF
              precip_days_total  INTEGER,                             Day count in multiday precipitation total, expressed as whole numbers. DAPR
              precip_total       DECIMAL(5,2),                        Total precipitation expressed in floating-point value. Details total rainfall. PRCP
              snowfall           DECIMAL(4,1),                        Amount of snow falling represented in inches as floating-point value. SNOW
              snow_depth         DECIMAL(5,1),                        Depth of snow expressed in floating-point value representing inches. SNWD
              grnd_snow_water    DECIMAL(3,1),                        Water-equivalent of snow on ground, represented in floating-point value as inches. WESD
              snowfall_water     DECIMAL(3,1),                        Water-equivalent of snowfall, represented in floating-point value as inches. WESF
              FOREIGN KEY (station_id) REFERENCES weather_stations(station_id)      Foreign Key Reference.
*/       
/*
Table 4: precipitation creation; GRANDCHILD record; inherits data from GRANDFATHER record.
This table is an off-shoot of climate_data, and will be used to hold precipitation data; station_id foreign-key.
*/

CREATE TABLE precipitation (
       p_id               INTEGER auto_increment PRIMARY KEY,
       station_id         VARCHAR(17) NOT NULL,
       p_date             DATE NOT NULL,
       dataset            INTEGER NOT NULL,
       precip_days_total  INTEGER,
       multi_precip_total DECIMAL(3,2),
       multi_snow_total   INTEGER,
       precip_total       DECIMAL(5,2),
       snowfall           DECIMAL(4,1),
       snow_depth         DECIMAL(5,1),
       grnd_snow_water    DECIMAL(3,1),
       snowfall_water     DECIMAL(3,1),
       FOREIGN KEY (station_id) REFERENCES weather_stations(station_id) ON DELETE CASCADE ON UPDATE CASCADE
);

/*
Create Table Diagram (what will be included in slave record table air_temperature):
Create Table:   air_temperature 
                at_id               INTEGER auto_increment PRIMARY KEY,
                station_id          VARCHAR(17) NOT NULL,                    Station ID, expressed as a string of letters and digits. STATION
                at_date             DATE NOT NULL,                           Date, expressed as string with separation characters. DATE
                dataset             INTEGER NOT NULL,                        Dataset, details which set of data conclusions originate from; integer. 1,2,3
                average_temp        INTEGER,                                 The average temperature expressed as 2-digit + floating-point value. TAVG
                max_temp            INTEGER,                                 The maximum temperature expressed as 2/3-digit + floating-point value. TMAX
                min_temp            INTEGER,                                 Minimum temperature expressed as 1/2-digit + floating-point value. TMIN
                observation_temp    INTEGER,                                 The temperature taken at time of watch; floating-point value. TOBS
                FOREIGN KEY (station_id) REFERENCES weather_stations(station_id)    Foreign key reference.
*/
/*
Table 5: air_temperature creation; GRANDCHILD record; inherits data from GRANDFATHER record.
This table will be used to describe all the temperatures/air temperatures present in my datasets.
*/

CREATE TABLE air_temperature (
       at_id               INTEGER auto_increment PRIMARY KEY,
       station_id          VARCHAR(17) NOT NULL,
       at_date             DATE NOT NULL,
       dataset             INTEGER NOT NULL,
       average_temp        INTEGER,
       max_temp            INTEGER,
       min_temp            INTEGER,
       observation_temp    INTEGER,
       FOREIGN KEY (station_id) REFERENCES weather_stations(station_id) ON DELETE CASCADE ON UPDATE CASCADE
);

/*
Create Table Diagram (what will be included in slave record table wind):
Create Table:  wind 
Columns:       wi_id               INTEGER auto_increment PRIMARY KEY,
               station_id          VARCHAR(17) NOT NULL,
               wi_date             DATE NOT NULL,                            Date, expressed as string with separation characters. DATE
               dataset             INTEGER NOT NULL,                         Dataset, details which set of data conclusions originate from; integer. 1,2,3
               avg_wind_speed      DECIMAL(4,2),                             Average daily wind speed in mph.
               peak_gust           TIME,                                     Peak gust time, hours and minutes, HHMM.
               FOREIGN KEY (station_id) REFERENCES weather_stations(station_id)     Foreign key reference.
*/
/*
Table 6: wind creation; GRANDCHILD record; inherits data from GRANDFATHER record.
This table serves to organize all wind-related data. I will use this table to represent wind values where anomalies occur.
*/

CREATE TABLE wind (
       wi_id               INTEGER auto_increment PRIMARY KEY,
       station_id          VARCHAR(17) NOT NULL,
       wi_date             DATE NOT NULL,
       dataset             INTEGER NOT NULL,
       avg_wind_speed      DECIMAL(4,2),
       peak_gust           TIME,
       FOREIGN KEY (station_id) REFERENCES weather_stations(station_id) ON DELETE CASCADE ON UPDATE CASCADE
);

/*
Create Table Diagram (what will be included in slave record table weather):
Create Table:   weather
Colummns:       we_id               INTEGER auto_increment PRIMARY KEY,
                station_id  Station ID, expressed as a string of letters and digits. STATION
                we_date        Date, expressed as string with separation characters. DATE
                dataset     Dataset, details which set of data conclusions originate from; integer. 1,2,3
                w_type        WT** (01-22), excluding some sequential IDs with prefix WT followed by two digits
                FOREIGN KEY (w_type) REFERENCES weather_types(wt_id)  Foreign Key Reference.
*/
/*
Table 7: weather creation; GRANDCHILD record; inherits data from GRANDFATHER record.
This table is going to be used for declarations of weather per weather station and date. This table simply 
aggregates all weather events and stations into one table.
*/

CREATE TABLE weather (
       we_id               INTEGER auto_increment PRIMARY KEY,
       station_id          VARCHAR(17) NOT NULL,
       we_date             DATE NOT NULL,
       dataset             INTEGER NOT NULL,
       w_type              VARCHAR(4),
       FOREIGN KEY (station_id) REFERENCES weather_stations(station_id) ON DELETE CASCADE ON UPDATE CASCADE,
       FOREIGN KEY (w_type) REFERENCES weather_types(wt_id) ON DELETE CASCADE ON UPDATE CASCADE
);
