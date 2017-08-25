import WalabotAPI as walabot
from pyqtgraph.Qt import QtGui
import pyqtgraph as pg
import numpy as np
import time
import matplotlib.pyplot as plt
import matplotlib
from mpl_toolkits.mplot3d import Axes3D

'''
This is a Python script which plots the radio frequency signal received by specified antennas on the Walabot.
Parameters:
-profile type (sensor, sensor narrow, or short range)
-dimensions of arena to be scanned
-filter to be used
-txAntenna and rxAntenna
'''


walabot.Init('/usr/lib/libWalabotAPI.so')

#Step 1: Connect to Walabot
walabot.ConnectAny()

#Step 2: Configurations
#Set the scan profile as sensor (distance scanner with high resolution and slow update rate)
walabot.SetProfile(walabot.PROF_SHORT_RANGE_IMAGING)
#Set the dimensions of the arena
walabot.SetArenaR(1,20,1) #Question: what values can this take on? What is the lowest resolution you can set?
walabot.SetArenaTheta(-20,20,1)
walabot.SetArenaPhi(-20,20,1)
#Set the filter type
walabot.SetDynamicImageFilter(walabot.FILTER_TYPE_NONE)
#Set the antenna pair to be used
scanAntennaPair=walabot.GetAntennaPairs()[0] #Use antenna #1 as tx and antenna #2 as rx (numberings are as specified in the tech spec sheet)

#Step 3: Start the system in preparation for scanning
walabot.Start()

#Step 4: Calibration to reduce signals from fixed targets
walabot.StartCalibration()
while walabot.GetStatus()[0] == walabot.STATUS_CALIBRATING:
    #Function which initiates a scan and records the signals
    walabot.Trigger()


#Create the figure
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
plt.show()
#matplotlib.interactive(True)
#Step 5: Scan
walabot.Trigger()

#Step 6: Get the scan
image=walabot.GetRawImageSlice()
rasterImage=image[0]
sizeX=image[1]
sizeY=image[2]
size_tot=sizeX*sizeY


x_list=[]
y_list=[]
z_list=np.ndarray.flatten(np.array(rasterImage))

#Populate x_list
for i in range(sizeY):
    for j in range(sizeX):
        x_list.append(i)

#Populate y_list
for i in range(sizeY):
    for j in range(sizeX):
        y_list.append(j)



ax.scatter(x_list, y_list, z_list, cmap=plt.hot())


plt.draw()


#Step 7: Stop and disconnect
walabot.Stop()
walabot.Disconnect()
print ("Terminated successfully")