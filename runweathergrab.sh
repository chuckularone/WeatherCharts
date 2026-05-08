killpid=$(cat /scriptdir/weathercharts/data/weathergrab.pid)
dtg=$(date +"%Y%m%d.%H%M%S")
headerLine="date,time,value,unit"

# Kill old job if running
kill -9  $killpid

# Move off old outfiles
mv  /scriptdir/weathercharts/data/outtemp.raw /scriptdir/weathercharts/data/outtemp.$dtg.raw
mv  /scriptdir/weathercharts/data/outpress.raw /scriptdir/weathercharts/data/outpress.$dtg.raw
mv  /scriptdir/weathercharts/data/outhumid.raw /scriptdir/weathercharts/data/outhumid.$dtg.raw
mv  /scriptdir/weathercharts/data/outspeed.raw /scriptdir/weathercharts/data/outspeed.$dtg.raw
mv  /scriptdir/weathercharts/data/outgust.raw /scriptdir/weathercharts/data/outgust.$dtg.raw

# Create new outfiles
echo $headerLine > /scriptdir/weathercharts/data/outtemp.raw
echo $headerLine > /scriptdir/weathercharts/data/outhumid.raw
echo $headerLine > /scriptdir/weathercharts/data/outpress.raw
echo $headerLine > /scriptdir/weathercharts/data/outspeed.raw
echo $headerLine > /scriptdir/weathercharts/data/outgust.raw

# Run new script and capture PID
nohup /scriptdir/weathercharts/weathergrab.sh &
echo $! > /scriptdir/weathercharts/data/weathergrab.pid


