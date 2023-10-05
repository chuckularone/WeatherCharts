import pandas as pd
import matplotlib.pyplot as plt
import time

current_time = time.ctime()

pressure_file = "/scriptdir/data/outpress.raw"
temperature_file = "/scriptdir/data/outtemp.raw"
humidity_file = "/scriptdir/data/outhumid.raw"

df1=pd.read_csv(pressure_file)
df2=pd.read_csv(temperature_file)
df3=pd.read_csv(humidity_file)

fig, ax = plt.subplots(figsize=(10,8))
df1.plot.line(x='time', y='value',color='crimson', ax=ax)
plt.title(current_time)
plt.ylabel("Pressure in inHg")
plt.xlabel("Time of reading")
plt.savefig('/var/www/html/image/pressure.png')

fig, ax = plt.subplots(figsize=(10,8))
df2.plot.line(x='time', y='value',color='crimson', ax=ax)
plt.title(current_time)
plt.ylabel("Temperature in F")
plt.xlabel("Time of reading")
plt.savefig('/var/www/html/image/temperature.png')

fig, ax = plt.subplots(figsize=(10,8))
df3.plot.line(x='time', y='value',color='crimson', ax=ax)
plt.title(current_time)
plt.ylabel("Humidity in %")
plt.xlabel("Time of reading")
plt.savefig('/var/www/html/image/humidity.png')
