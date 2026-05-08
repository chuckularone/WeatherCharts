#!/bin/bash

DB="/scriptdir/weathercharts/data/weather.sqlite"
TABLES="gusts"
YESTERDAY=$(date -d 'yesterday' '+%Y-%m-%d')

for table in $TABLES; do
    echo "Processing ${table} for ${YESTERDAY}..."

    sqlite3 "$DB" <<EOF
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
