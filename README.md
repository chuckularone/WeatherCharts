# Purpose

The purpose of this suite of scripts is to publish hyperlocal weather elements from my home weather station to my blog:
```
	http:/theshanty.us/index.php/weather-stuff/
```

It publishes charts for the temperature, pressure and humidity daily starting at midnight

### It uses: 
- Unix Shell Scripting
- Curl
- The Weather Underground API
- JSON parsing to CSV
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
