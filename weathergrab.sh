while true; do

APIkey=$(cat /scriptdir/weathercharts/data/wundergroundAPIkey.txt)
curl https://api.weather.com/v2/pws/observations/current?stationId=KPAASTON20\&format=json\&units=e\&apiKey=$APIkey > /scriptdir/weathercharts/data/data.json

holdpress=$(cat /scriptdir/weathercharts/data/data.json | jq '.observations[] | .imperial.pressure')
holdtemp=$(cat /scriptdir/weathercharts/data/data.json | jq '.observations[] | .imperial.temp')
holdhumid=$(cat /scriptdir/weathercharts/data/data.json | jq '.observations[] | .humidity')
holdwindspeed=$(cat /scriptdir/weathercharts/data/data.json | jq '.observations[] | .imperial.windSpeed')
holdwindgust=$(cat /scriptdir/weathercharts/data/data.json | jq '.observations[] | .imperial.windGust')

echo $(date +"%Y-%m-%d"), $(date +"%H:%M:%S"), $holdpress, inHg >> /scriptdir/weathercharts/data/outpress.raw
echo $(date +"%Y-%m-%d"), $(date +"%H:%M:%S"), $holdtemp, F >> /scriptdir/weathercharts/data/outtemp.raw
echo $(date +"%Y-%m-%d"), $(date +"%H:%M:%S"), $holdhumid, % >> /scriptdir/weathercharts/data/outhumid.raw
echo $(date +"%Y-%m-%d"), $(date +"%H:%M:%S"), $holdwindspeed, MPH >> /scriptdir/weathercharts/data/outspeed.raw
echo $(date +"%Y-%m-%d"), $(date +"%H:%M:%S"), $holdwindgust, MPH >> /scriptdir/weathercharts/data/outgust.raw


echo $holdtemp > /scriptdir/weathercharts/data/currStats.out
echo $holdpress  >> /scriptdir/weathercharts/data/currStats.out
echo $holdhumid  >> /scriptdir/weathercharts/data/currStats.out
echo $holdwindspeed  >> /scriptdir/weathercharts/data/currStats.out
echo $holdwindgust  >> /scriptdir/weathercharts/data/currStats.out

sleep 600
done

