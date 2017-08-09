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


#Create window for plots
pg.setConfigOptions(antialias=True) #To make the plot prettier
app = QtGui.QApplication([])
win = pg.GraphicsWindow()
label = pg.LabelItem(justify='right')
win.addItem(label)
signalPlot = win.addPlot(row=1, col=0)


#Continuously scanning + recording and getting the processed data
while True:
    #Step 5: Scan
    walabot.Trigger()

    #Step 6: Get the scan
    timeDomainSignal=walabot.GetSignal(scanAntennaPair) #Returns the amplitude vector and corresponding time vector for the received signal
    timeDomainSignalX=timeDomainSignal[1]
    timeDomainSignalY=timeDomainSignal[0]
    timeDomainSignalY = np.fft.fftshift(timeDomainSignalY)
    #Plotting the signal in time domain
    signalPlot.plot(timeDomainSignalX, timeDomainSignalY, clear=True)
    signalPlot.setTitle("RF Time Domain Signal")

    app.processEvents()

    time.sleep(0.05)

#Step 7: Stop and disconnect
walabot.Stop()
walabot.Disconnect()
print ("Terminated successfully")