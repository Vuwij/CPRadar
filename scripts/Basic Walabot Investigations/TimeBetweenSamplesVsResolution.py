import WalabotAPI as walabot
from pyqtgraph.Qt import QtGui
import pyqtgraph as pg
import numpy as np
from scipy.signal import hilbert
import time

'''
This is a Python script which prints out the time between samples. Various parameters (arena size, resolution of arena size, and antenna pair) can be specified. 
The conclusion from running this script for varying parameters is that the time between samples STAYS constant
'''

# Create window for plots
pg.setConfigOptions(antialias=True)  # To make the plot prettier
app = QtGui.QApplication([])
win = pg.GraphicsWindow()
label = pg.LabelItem(justify='right')
win.addItem(label)
resolutionPlot = win.addPlot(row=1, col=0)

walabot.Init('/usr/lib/libWalabotAPI.so')

# Step 1: Connect to Walabot
walabot.ConnectAny()

# Step 2: Configurations
# Set the scan profile
walabot.SetProfile(walabot.PROF_SHORT_RANGE_IMAGING)
# Set the filter type
walabot.SetDynamicImageFilter(walabot.FILTER_TYPE_NONE)

# Step 3: Start the system in preparation for scanning
walabot.Start()


for i in np.arange(0.7,5,0.1):
    # Set the dimensions of the arena
    walabot.SetArenaR(1, 20, 0.7)  # Question: what values can this take on? What is the lowest resolution you can set?
    walabot.SetArenaTheta(-20, 20, 1)
    walabot.SetArenaPhi(-20, 20, 1)


    # Step 4: Calibration to reduce signals from fixed targets
    walabot.StartCalibration()
    while walabot.GetStatus()[0] == walabot.STATUS_CALIBRATING:
        # Function which initiates a scan and records the signals
        walabot.Trigger()

    walabot.Trigger()
    antennaPairs=walabot.GetAntennaPairs()
    timeDomainSignal = walabot.GetSignal(antennaPairs[1])  # Returns the amplitude vector and corresponding time vector for the received signal
    timeDomainSignalX = timeDomainSignal[1]


    print timeDomainSignalX[1]-timeDomainSignalX[0]



# Step 7: Stop and disconnect
walabot.Stop()
walabot.Disconnect()
print ("Terminated successfully")
