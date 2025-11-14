killpid=$(cat /scriptdir/weathercharts/data/weathergrab.pid)
dtg=$(date +"%Y%m%d.%H%M%S")
headerLine="date,time,value,unit"

# Kill old job if running
kill -9  $killpid

# Move off old outfiles
mv  /scriptdir/weathercharts/data/outtemp.raw /scriptdir/weathercharts/data/outtemp.$dtg.raw
mv  /scriptdir/weathercharts/data/outpress.raw /scriptdir/weathercharts/data/outpress.$dtg.raw
mv  /scriptdir/weathercharts/data/weathercharts/outhumid.raw /scriptdir/weathercharts/data/outhumid.$dtg.raw

# Create new outfiles
echo $headerLine > /scriptdir/weathercharts/data/outtemp.raw
echo $headerLine > /scriptdir/weathercharts/data/outhumid.raw
echo $headerLine > /scriptdir/weathercharts/data/outpress.raw

# Run new script and capture PID
nohup /scriptdir/weathercharts/weathergrab.sh &
echo $! > /scriptdir/weathercharts/data/weathergrab.pid


