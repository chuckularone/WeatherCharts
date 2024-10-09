while true; do

APIkey=$(cat /scriptdir/data/wundergroundAPIkey.txt)
curl https://api.weather.com/v2/pws/observations/current?stationId=KPAASTON20\&format=json\&units=e\&apiKey=$APIkey > /scriptdir/data/data.json

holdpress=$(cat /scriptdir/data/data.json | jq '.observations[] | .imperial.pressure')
holdtemp=$(cat /scriptdir/data/data.json | jq '.observations[] | .imperial.temp')
holdhumid=$(cat /scriptdir/data/data.json | jq '.observations[] | .humidity')
holdwindspeed=$(cat /scriptdir/data/data.json | jq '.observations[] | .imperial.windSpeed')
holdwindgust=$(cat /scriptdir/data/data.json | jq '.observations[] | .imperial.windGust')

echo $(date +"%Y-%m-%d"), $(date +"%H:%M:%S"), $holdpress, inHg >> /scriptdir/data/outpress.raw
echo $(date +"%Y-%m-%d"), $(date +"%H:%M:%S"), $holdtemp, F >> /scriptdir/data/outtemp.raw
echo $(date +"%Y-%m-%d"), $(date +"%H:%M:%S"), $holdhumid, % >> /scriptdir/data/outhumid.raw
echo $(date +"%Y-%m-%d"), $(date +"%H:%M:%S"), $holdwindspeed, MPH >> /scriptdir/data/outspeed.raw
echo $(date +"%Y-%m-%d"), $(date +"%H:%M:%S"), $holdwindgust, MPH >> /scriptdir/data/outgust.raw


echo $holdtemp > /scriptdir/data/currStats.out
echo $holdpress  >> /scriptdir/data/currStats.out
echo $holdhumid  >> /scriptdir/data/currStats.out
echo $holdwindspeed  >> /scriptdir/data/currStats.out
echo $holdwindgust  >> /scriptdir/data/currStats.out

sleep 600
done
