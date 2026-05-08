#!/bin/bash

DB="/scriptdir/weathercharts/data/weather.sqlite"
TABLES="gusts humidity pressure temperature windspeed"
YESTERDAY=$(date -d 'yesterday' '+%Y-%m-%d')

for table in $TABLES; do
    echo "Processing ${table} for ${YESTERDAY}..."

    sqlite3 "$DB" <<EOF

# create full table of all values and all times
#
CREATE TABLE IF NOT EXISTS weather (
    date        TEXT NOT NULL,
    time        TEXT NOT NULL,
    temperature REAL,
    humidity    REAL,
    pressure    REAL,
    windspeed   REAL,
    gusts       REAL
);

DELETE FROM weather WHERE date = date('now', '-1 day');

INSERT INTO weather (date, time, temperature, humidity, pressure, windspeed, gusts)
SELECT
    COALESCE(t.date, h.date, p.date, w.date, g.date) AS date,
    COALESCE(t.time, h.time, p.time, w.time, g.time) AS time,
    t.value AS temperature,
    h.value AS humidity,
    p.value AS pressure,
    w.value AS windspeed,
    g.value AS gusts
FROM temperature t
LEFT JOIN humidity  h ON t.date = h.date AND t.time = h.time
LEFT JOIN pressure  p ON t.date = p.date AND t.time = p.time
LEFT JOIN windspeed w ON t.date = w.date AND t.time = w.time
LEFT JOIN gusts     g ON t.date = g.date AND t.time = g.time
WHERE t.date = date('now', '-1 day');


# Populate individual tables with unique values
#	
CREATE TABLE IF NOT EXISTS ${table}_clean (
    date  TEXT NOT NULL,
    time  TEXT NOT NULL,
    value REAL NOT NULL,
    unit  TEXT NOT NULL
);

DELETE FROM ${table}_clean WHERE date = '${YESTERDAY}';

INSERT INTO ${table}_clean (date, time, value, unit)
SELECT date, time, value, unit
FROM (
    SELECT date, time, value, unit,
           LAG(value) OVER (ORDER BY date, time) AS prev_value
    FROM ${table}
    WHERE date = '${YESTERDAY}'
)
WHERE prev_value IS NULL OR value != prev_value;
DELETE FROM ${table};
EOF

    if [ $? -eq 0 ]; then
        echo "  Done."
    else
        echo "  ERROR processing ${table}!" >&2
    fi
done

echo "All tables processed."

