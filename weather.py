import pandas as pd
import matplotlib.pyplot as plt
import time

nowinfo = open("/scriptdir/weathercharts/data/currStats.out")
rawdata = nowinfo.read()
datalist = rawdata.splitlines()

outDir = "/var/www/html/image/"

current_time = time.ctime()

pressure_file = "/scriptdir/weathercharts/data/outpress.raw"
temperature_file = "/scriptdir/weathercharts/data/outtemp.raw"
humidity_file = "/scriptdir/weathercharts/data/outhumid.raw"
windspeed_file = "/scriptdir/weathercharts/data/outspeed.raw"


df0=pd.read_csv(pressure_file)
df1=pd.read_csv(temperature_file)
df2=pd.read_csv(humidity_file)
df3=pd.read_csv(windspeed_file)

class ImageOut:
    def __init__(self, chartTitle, rawVal, unit, valList, outFile):
        self.chartTitle = chartTitle
        self.rawVal = rawVal
        self.unit = unit
        self.valList = valList
        self.outFile = outFile

    def createImage(self):
        now_time = time.ctime()
        printTitle = now_time + ' - ' + self.rawVal + self.unit
        fig, ax = plt.subplots(figsize=(10,8))
        self.valList.plot.line(x='time', y='value',color='crimson', ax=ax)
        plt.title(printTitle)
        plt.ylabel(self.chartTitle)
        plt.xlabel("Time of reading")
        plt.savefig(outDir + self.outFile)

myImage0 = ImageOut('Pressure in inHg',  datalist[0], ' inHg', df0, 'pressure.png')
myImage1 = ImageOut('Temperature in F',  datalist[1], ' F',    df1, 'temperature.png')
myImage2 = ImageOut('Humidity in %',     datalist[2], '%',     df2, 'humidity.png')
myImage3 = ImageOut('Wind Speed in MPH', datalist[3], ' MPH',  df3, 'speed.png')
myImage0.createImage()
myImage1.createImage()
myImage2.createImage()
myImage3.createImage()
