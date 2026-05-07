#!/usr/bin/env python3

import json
from datetime import datetime

# Path to the input JSON file
input_file = "/scriptdir/weathercharts/data/data.json"

# Load JSON data from the file
with open(input_file, "r") as f:
    data = json.load(f)

# Extract the first observation
obs = data["observations"][0]
imp = obs["imperial"]

# Date Conversion
original = obs["obsTimeLocal"]
dt = datetime.strptime(original, "%Y-%m-%d %H:%M:%S")
formatted = dt.strftime("%H:%M on %m/%d/%Y")

# Conditional Formatting — returns inline style string for a <td>
def style_temp(value):
    if value > 82:
        return 'style="background-color:#FF0000; color:#FFFFFF;"'
    elif value <= 32:
        return 'style="background-color:#0000FF; color:#FFFFFF;"'
    else:
        return 'style="background-color:#FFFFFF; color:#000000;"'

def style_wind(speed, gust):
    if speed > 10 or gust > 15:
        return 'style="background-color:#FF0000; color:#FFFFFF;"'
    else:
        return 'style="background-color:#FFFFFF; color:#000000;"'

def style_humidity(value):
    if value > 70:
        return 'style="background-color:#00FFFF; color:#000000;"'
    elif value < 30:
        return 'style="background-color:#BAB068; color:#000000;"'
    else:
        return 'style="background-color:#FFFFFF; color:#000000;"'

# HTML content
html = f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="refresh" content="60">
  <title>KPAASTON20</title>
  <style>
    body {{
      font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
      margin: 0;
      padding: 24px;
      background: #f7f7f9;
      color: #111;
    }}
    .card {{
      max-width: 500px;
      margin: 0 auto;
      background: #fff;
      border-radius: 14px;
      box-shadow: 0 6px 24px rgba(0,0,0,.08);
      padding: 24px;
    }}
    h1 {{
      text-align: center;
      margin: 8px 0 18px;
      font-size: 1.4rem;
      letter-spacing: .5px;
    }}
    table {{
      width: 100%;
      border-collapse: collapse;
    }}
    th, td {{
      border: 1px solid #e5e7eb;
      padding: 10px 14px;
      text-align: left;
    }}
    th {{
      background: #fafafa;
      font-weight: 600;
      width: 45%;
    }}
    .muted {{
      color: #6b7280;
      font-size: .85rem;
      text-align: center;
      margin-top: 12px;
    }}
  </style>
  <script>
    window.resizeTo(540, 620);
  </script>
</head>
<body>
  <div class="card">
    <h1>Weather Observation for KPAASTON20</h1>
    <table>
      <tr><th>Station ID</th><td>The Shanty &ndash; {obs["stationID"]}</td></tr>
      <tr><th>Local Time</th><td>{formatted}</td></tr>
      <tr><th>Humidity</th><td {style_humidity(obs["humidity"])}>{obs["humidity"]}%</td></tr>
      <tr><th>Temperature</th><td {style_temp(imp["temp"])}>{imp["temp"]} &deg;F</td></tr>
      <tr><th>Heat Index</th><td {style_temp(imp["heatIndex"])}>{imp["heatIndex"]} &deg;F</td></tr>
      <tr><th>Wind Speed</th><td {style_wind(imp["windSpeed"], imp["windGust"])}>{imp["windSpeed"]} mph</td></tr>
      <tr><th>Wind Gust</th><td {style_wind(imp["windSpeed"], imp["windGust"])}>{imp["windGust"]} mph</td></tr>
      <tr><th>Wind Direction</th><td>{obs["winddir"]}&deg;</td></tr>
      <tr><th>Pressure</th><td>{imp["pressure"]} inHg</td></tr>
      <tr><th>Precipitation Rate</th><td>{imp["precipRate"]} in/hr</td></tr>
      <tr><th>Precipitation Total</th><td>{imp["precipTotal"]} in</td></tr>
    </table>
    <div class="muted">Auto-refreshes every 60 seconds.</div>
  </div>
</body>
</html>"""

# Write to an HTML file
output_file = "/var/www/html/weatherdata/weather_observation.html"
with open(output_file, "w") as f:
    f.write(html)
