import WalabotAPI as walabot
from pyqtgraph.Qt import QtGui
import pyqtgraph as pg
import numpy as np
import math
import matplotlib.pyplot as plt
import time

'''
This is a Python script which plots the radio frequency signal received by specified antennas on thnp.e Walabot.
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
vol=[]
max_R=700
#Go through several R ranges
for i in np.arange(2,max_R,0.1):
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
            vol.append((4*(j-1)/3)*math.sin(j-1)*(i**3-1))


plt.plot(np.arange(2,max_R,0.1),y,'ro')
plt.title("R vs Maximum Theta and Phi")
plt.figure()
plt.plot(np.arange(2,max_R,0.1),map(abs,vol),'ro')
plt.title("R vs Range Volume")



print(y)
print vol

plt.show()





