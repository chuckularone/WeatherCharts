killpid=$(cat /scriptdir/data/weathergrab.pid)
dtg=$(date +"%Y%m%d.%H%M%S")
headerLine="date,time,value,unit"

# Kill old job if running
kill -9  $killpid

# Move off old outfiles
mv  /scriptdir/data/outtemp.raw /scriptdir/data/outtemp.$dtg.raw
mv  /scriptdir/data/outpress.raw /scriptdir/data/outpress.$dtg.raw
mv  /scriptdir/data/outhumid.raw /scriptdir/data/outhumid.$dtg.raw

# Create new outfiles
echo $headerLine > /scriptdir/data/outtemp.raw
echo $headerLine > /scriptdir/data/outhumid.raw
echo $headerLine > /scriptdir/data/outpress.raw

# Run new script and capture PID
nohup /scriptdir/weathergrab.sh &
echo $! > /scriptdir/data/weathergrab.pid

