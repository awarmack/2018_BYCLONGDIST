index
================

Load Data
---------

Data for this race comes from two sources: \* A CSV file log from Expedition \* A Flat text file containing raw NMEA sentances.

At somepoint the router would not allow any wifi connections for an unknown reason. (Yay!) So, I was able to hook the tablet directly to the NMEA multiplexer and read the serial data via the COM port and log it using the MultiPlexer log tool.

### Expedition Data

#### Load the raw expidition data

``` r
library(tidyverse)
```

    ## ── Attaching packages ────────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 3.0.0     ✔ purrr   0.2.5
    ## ✔ tibble  1.4.2     ✔ dplyr   0.7.6
    ## ✔ tidyr   0.8.1     ✔ stringr 1.3.1
    ## ✔ readr   1.1.1     ✔ forcats 0.3.0

    ## ── Conflicts ───────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
#Read the Raw Data
expdat <- read.csv("../raw_data/exp_log.csv", stringsAsFactors = FALSE)

#Change the Time
expdat$time <- as.POSIXct((expdat$Utc) * (60*60*24), origin = "1899-12-30", tz = "America/Detroit")

#Remove any All NA Columns
#Find columns where all is NA
allna <- which(apply(expdat, 2, function(x) all(is.na(x))))   

#remove those columns
expdat <- expdat %>% select(-allna)

#Select only needed columns
expdat <- expdat %>% select(time, Bsp, Awa, Aws, Twa, Tws, Twd, Lat, Lon, Hdg, Cog, Sog)

#change names to lowercase for easier handling
names(expdat) <- tolower(names(expdat))

#Remove any rows where we don't have all data
expdat <- na.omit(expdat)

summary(expdat)
```

    ##       time                          bsp             awa        
    ##  Min.   :2018-09-15 15:24:39   Min.   :0.000   Min.   :-179.5  
    ##  1st Qu.:2018-09-15 16:21:54   1st Qu.:2.610   1st Qu.: -33.0  
    ##  Median :2018-09-15 17:45:32   Median :3.120   Median : -18.5  
    ##  Mean   :2018-09-15 17:38:27   Mean   :3.042   Mean   :   0.5  
    ##  3rd Qu.:2018-09-15 18:46:43   3rd Qu.:3.750   3rd Qu.:  36.5  
    ##  Max.   :2018-09-15 19:47:46   Max.   :5.530   Max.   : 180.0  
    ##       aws              twa                 tws              twd        
    ##  Min.   : 1.100   Min.   :-179.7000   Min.   : 0.510   Min.   :  0.10  
    ##  1st Qu.: 6.100   1st Qu.: -52.2250   1st Qu.: 4.210   1st Qu.: 51.10  
    ##  Median : 7.200   Median : -29.9000   Median : 5.270   Median : 67.90  
    ##  Mean   : 7.666   Mean   :  -0.2935   Mean   : 5.639   Mean   : 71.51  
    ##  3rd Qu.: 9.300   3rd Qu.:  58.0000   3rd Qu.: 6.790   3rd Qu.: 85.30  
    ##  Max.   :80.500   Max.   : 180.0000   Max.   :76.900   Max.   :359.80  
    ##       lat             lon              hdg              cog       
    ##  Min.   :42.35   Min.   :-82.90   Min.   :  0.00   Min.   :  0.0  
    ##  1st Qu.:42.35   1st Qu.:-82.89   1st Qu.: 38.77   1st Qu.: 38.8  
    ##  Median :42.37   Median :-82.82   Median :104.00   Median :104.0  
    ##  Mean   :42.38   Mean   :-82.82   Mean   :106.97   Mean   :106.9  
    ##  3rd Qu.:42.40   3rd Qu.:-82.77   3rd Qu.:123.50   3rd Qu.:123.4  
    ##  Max.   :42.41   Max.   :-82.72   Max.   :360.00   Max.   :360.0  
    ##       sog      
    ##  Min.   :0.38  
    ##  1st Qu.:2.73  
    ##  Median :3.09  
    ##  Mean   :3.22  
    ##  3rd Qu.:3.97  
    ##  Max.   :5.31

#### Clean up the Expdition Data

``` r
#Remove huge outliers
expdat <- expdat[expdat$aws > 20, ]   #we definitely didn't encounter anything over 20 kts
```

### NMEA data

#### Load the raw NMEA data

``` r
nmea <- read_lines("../raw_data/nmea_log.txt")

head(nmea)
```

    ## [1] "$WIMTW,24.80,C*33"                                                      
    ## [2] "$GPRMC,003547,A,4226.5049,N,08241.2786,W,5.10,343.89,160918,7.76,W,A*20"
    ## [3] "$WIMWV,43.22,T,9.11,N,A*1B"                                             
    ## [4] "$WIMWV,28.00,R,13.30,N,A*28"                                            
    ## [5] "$GPRMB,A,0.039,L,,R28,4229.6810,N,08242.8940,W,3.398,339.4,,V,A*02"     
    ## [6] "$WIMWV,43.22,T,9.11,N,A*1B"

#### Process the NMEA data into tabular format

``` r
source("../src/parseNMEA.r")  #Load functions to parse NMEA data

print("TalkerID")
```

    ## [1] "TalkerID"

``` r
table(getTalkerID(nmea))
```

    ## 
    ##   GP   HC   HE   PG   VW   WI 
    ## 5092  349  349 1047  849 8731

``` r
print("Sentance Types")
```

    ## [1] "Sentance Types"

``` r
table(getSentanceType(nmea))
```

    ## 
    ##  APB  BOD  BWC  GGA  GLL  GSA  GSV  HDM  HDT  MDA  MTW  MWV  RMB  RMC  RME 
    ##  349  349  349  350  349  349 1250  349  349  699  699 7333  350  350  349 
    ##  RMM  RMZ  RTE  VHW  VLW  VTG  XTE 
    ##  349  349  349  698  151  349  349

``` r
table(getTalkerID(nmea), getSentanceType(nmea))
```

    ##     
    ##       APB  BOD  BWC  GGA  GLL  GSA  GSV  HDM  HDT  MDA  MTW  MWV  RMB  RMC
    ##   GP  349  349  349  350  349  349 1250    0    0    0    0    0  350  350
    ##   HC    0    0    0    0    0    0    0  349    0    0    0    0    0    0
    ##   HE    0    0    0    0    0    0    0    0  349    0    0    0    0    0
    ##   PG    0    0    0    0    0    0    0    0    0    0    0    0    0    0
    ##   VW    0    0    0    0    0    0    0    0    0    0    0    0    0    0
    ##   WI    0    0    0    0    0    0    0    0    0  699  699 7333    0    0
    ##     
    ##       RME  RMM  RMZ  RTE  VHW  VLW  VTG  XTE
    ##   GP    0    0    0  349    0    0  349  349
    ##   HC    0    0    0    0    0    0    0    0
    ##   HE    0    0    0    0    0    0    0    0
    ##   PG  349  349  349    0    0    0    0    0
    ##   VW    0    0    0    0  698  151    0    0
    ##   WI    0    0    0    0    0    0    0    0

Talker IDS: GP = Garmin GPS HC = Heading: compass, magnetic (Calculated by MiniPlex) HE = Heading: compass, true (Calculated by MiniPlex) PG = Garmin GPS VW = Raymarine Seatalk Boat speed WI = Raymarine Wind Data

Reference(<https://www.xj3.nl/download/99/NMEA.txt>) <br />

| ID  | Description                                  | Generated by         |
|-----|----------------------------------------------|----------------------|
| APB | Autopilot Sentence "B"                       | Garmin GPS           |
| BOD | Bearing - Waypoint to Waypoint (from Garmin) | Garmin GPS           |
| BWC | Bearing & Distance to Waypoint - Geat Circle | Garmin GPS           |
| GGA | Global Positioning System Fix Data           | Garmin               |
| GLL | Geographic Position - Latitude/Longitude     | Garmin               |
| GSA | GPS DOP and active satellites                | Garmin               |
| GSV | Satellites in view                           | Garmin               |
| HDM | Heading - Magnetic                           | MiniPlex(calculated) |
| HDT | Heading - True                               | MiniPlex (calculate) |
| MDA | ???                                          | RayMarine Wind       |
| MTW | Mean Temperature of Water                    |                      |
| MWV | Wind Speed and Angle                         |                      |
| RMB | Recommended Minimum Navigation Information   |                      |
| RMC | Recommended Minimum Navigation Information   |                      |
| RME | Garmin Estimated Error                       | Garmin GPS           |
| RMM |                                              | Garmin GPS           |
| RMZ |                                              | Garmin GPS           |
| RTE | Routes                                       | Garmin GPS           |
| VHW | Water speed and heading                      | RayMarine Boatspeed  |
| VLW | Distance Traveled through Water              | RayMarine Boatspeed  |
| VTG | Track made good and Ground speed             | RayMarine Boatspeed  |
| XTE | Cross Track Error                            | RayMarine Boatspeed  |
