2018 BYC Long Distance Race
================

Source Data
-----------

The data from the race is collected from three on-board instruments: - Raymarine Wind Guage - Raymarine Boat Speed - Garmin GPS Plotter

These devices transmit NMEA sentances which is multiplexed and then broadcast over wifi using a [MiniPlex-3](http://www.shipmodul.com/en/miniplex-3.html).

The data is then read into [Expedition](http://www.expeditionmarine.com/about.htm) sailing software and logged as a csv file.

Load Data
---------

    ## ── Attaching packages ────────────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 3.0.0     ✔ purrr   0.2.5
    ## ✔ tibble  1.4.2     ✔ dplyr   0.7.6
    ## ✔ tidyr   0.8.1     ✔ stringr 1.3.1
    ## ✔ readr   1.1.1     ✔ forcats 0.3.0

    ## ── Conflicts ───────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

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

Path Sailed
-----------

Wind Direction & Speed
----------------------

![](readme_files/figure-markdown_github/unnamed-chunk-3-1.png)![](readme_files/figure-markdown_github/unnamed-chunk-3-2.png)

Calculate Polar Boatspeed
-------------------------

    ## 
    ## Attaching package: 'zoo'

    ## The following objects are masked from 'package:base':
    ## 
    ##     as.Date, as.Date.numeric

    ## Warning: Removed 29 rows containing missing values (geom_path).

![](readme_files/figure-markdown_github/unnamed-chunk-4-1.png)

    ## Warning: Removed 1261 rows containing non-finite values (stat_bin).

    ## Warning: Removed 1 rows containing missing values (geom_bar).

![](readme_files/figure-markdown_github/unnamed-chunk-5-1.png)

    ## Warning: Removed 1261 rows containing non-finite values (stat_bin).

    ## Warning: Removed 7 rows containing missing values (geom_bar).

![](readme_files/figure-markdown_github/unnamed-chunk-6-1.png)

    ## Warning: Removed 1261 rows containing non-finite values (stat_bin).

    ## Warning: Removed 10 rows containing missing values (geom_bar).

![](readme_files/figure-markdown_github/unnamed-chunk-7-1.png)

Optimal VMC
===========

Save Data
=========
