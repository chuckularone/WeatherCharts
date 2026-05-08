The purpose of this suite of scripts is to publish hyperlocal weather elements from my home weather station to my blog:
```
        http:/theshanty.us/index.php/weather-stuff/
```

It publishes charts for the temperature, pressure and humidity daily starting at midnight

> [!Success]
> What does it do? (This may feel out of order, but it is the order things run in cron)
> #### killweathergrab.sh
>  - At midnight (if there is a running instance) this script kills the existing instance
>  - /usr/bin/rm -f \<the existing nohup file\>
> #### importWeather.pl
>  - Imports yesterday's raw weather data into the weather.sqlite database into individual tables:
>     - gusts
>     - humidity
>     - pressure
>     - temperature
>     - windspeed
> #### moveOldCharts.sh
>  - This script moves off the old graphical charts in the image directory of the web server and purges images over 30 days old
> #### weathergrab.sh
>  - Collects data from my Acu-Rite weather station by using the Weather Underground API 
>  - Adds those values to raw data files
>  - Processes the JSON into a list of raw values
>  - This script runs once a day and executes a loop every 600 seconds (10 minutes)
> #### weather.py
>  -  Using pandas and matplotlib creates graphs from the raw data files and places them in the image directory of the web server
>  - This script runs every 10 minutes everyday
> #### cleanUpDatabases.sh
>  - This script first goes through the databases loaded by importWeather.pl and puts all of the values into a single table; "date, time, temperature, humidity, pressure, windspeed, gusts"
>  - Next it pulls out unique values solving the "gaps and islands" problem and greatly reducing the size of the list, as all of these values change relatively slowly
> #### weatherToHtml.py
>  - Creates a single panel [display](http://blog.theshanty.us/weatherdata/weather_observation.html) of all of the current data collected by the KPAASTON20 weather station

### It uses:
- Unix Shell Scripting
- Curl
- The Weather Underground API
- JSON parsing to list
- Python
  - pandas
  - matplotlib
- And Wordpress

### To do:
- [ ] Develop a way to select and scan past charts
- [ ] Develop a way to combine data from a date range into a single chart.

---
## Changes:
#### 20251114 CJM
- Recovered scripts after accidental delete.
- Moved files from /scriptdir to /scriptdir/weatherstuff

#### 20260502 CJM
- Finally checking in changes to push daily data to a SQLite database

#### 20260507 CJM
- Cleaned up the look of the HTML output

#### 20260508 CJM
 - Added an amalgamated table to the database clean up tool


