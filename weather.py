import pandas as pd
import matplotlib.pyplot as plt
import time

nowinfo = open("/scriptdir/data/currStats.out")
rawdata = nowinfo.read()
datalist = rawdata.splitlines()

current_time = time.ctime()

pressure_file = "/scriptdir/data/outpress.raw"
temperature_file = "/scriptdir/data/outtemp.raw"
humidity_file = "/scriptdir/data/outhumid.raw"
windspeed_file = "/scriptdir/data/outspeed.raw"

df1=pd.read_csv(pressure_file)
df2=pd.read_csv(temperature_file)
df3=pd.read_csv(humidity_file)
df4=pd.read_csv(windspeed_file)

humidTitle = current_time + ' - ' + datalist[1] + ' inHg'
print(humidTitle)

fig, ax = plt.subplots(figsize=(10,8))
df1.plot.line(x='time', y='value',color='crimson', ax=ax)
plt.title(humidTitle)
plt.ylabel("Pressure in inHg")
plt.xlabel("Time of reading")
plt.savefig('/var/www/html/image/pressure.png')

tempTitle = current_time + ' - ' + datalist[0] + ' F'
print(tempTitle)

fig, ax = plt.subplots(figsize=(10,8))
df2.plot.line(x='time', y='value',color='crimson', ax=ax)
plt.title(tempTitle)
plt.ylabel("Temperature in F")
plt.xlabel("Time of reading")
plt.savefig('/var/www/html/image/temperature.png')

pressTitle = current_time + ' - ' + datalist[2] + '%'
print(pressTitle)

fig, ax = plt.subplots(figsize=(10,8))
df3.plot.line(x='time', y='value',color='crimson', ax=ax)
plt.title(pressTitle)
plt.ylabel("Humidity in %")
plt.xlabel("Time of reading")
plt.savefig('/var/www/html/image/humidity.png')


speedTitle = current_time + ' - ' + datalist[3] + ' MPH'
print(speedTitle)

fig, ax = plt.subplots(figsize=(10,8))
df4.plot.line(x='time', y='value',color='crimson', ax=ax)
plt.title(speedTitle)
plt.ylabel("Wind Speed in MPH")
plt.xlabel("Time of reading")
plt.savefig('/var/www/html/image/speed.png')
