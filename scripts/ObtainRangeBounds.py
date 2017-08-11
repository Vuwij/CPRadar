import WalabotAPI as walabot
from pyqtgraph.Qt import QtGui
import pyqtgraph as pg
import numpy as np
import time

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
no_error=True
y=[]
#Go through several R ranges
for i in range (2,100,1):
    j=1
    no_error=True
    while (no_error):
        try:
            walabot.SetArenaTheta(-j,j,1)
            walabot.SetArenaPhi(-j,j,1)
            walabot.SetArenaR(1, i, 1)
            j=j+1
        except walabot.WalabotError:
            no_error=False
            y.append(j-1)

print(y)




