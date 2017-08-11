import WalabotAPI as walabot
from pyqtgraph.Qt import QtGui
import pyqtgraph as pg
import math
import time

'''
This is a Python script which plots the peak amplitude of the received RF signal as a function of the proximity between the TX and RX antennas.
'''

walabot.Init('/usr/lib/libWalabotAPI.so')

# Step 1: Connect to Walabot
walabot.ConnectAny()

# Step 2: Configurations
# Set the scan profile
walabot.SetProfile(walabot.PROF_SENSOR)
# Set the dimensions of the arena
walabot.SetArenaR(1, 20, 1)  # Question: what values can this take on? What is the lowest resolution you can set?
walabot.SetArenaTheta(-20, 20, 1)
walabot.SetArenaPhi(-20, 20, 1)
# Set the filter type
walabot.SetDynamicImageFilter(walabot.FILTER_TYPE_NONE)

# Step 3: Start the system in preparation for scanning
walabot.Start()

# Step 4: Calibration to reduce signals from fixed targets
walabot.StartCalibration()
while walabot.GetStatus()[0] == walabot.STATUS_CALIBRATING:
    # Function which initiates a scan and records the signals
    walabot.Trigger()




def getPeakAmplitude(scanAntennaPair):
    # Plotting signal in time domain
    timeDomainSignal = walabot.GetSignal(
        scanAntennaPair)  # Returns the amplitude vector and corresponding time vector for the received signal
    timeDomainSignalX = timeDomainSignal[1]
    timeDomainSignalY = timeDomainSignal[0]

    return max(timeDomainSignalY) #return the peak amplitude

def getAntennaPairDist(scanAntennaPair):
    x1=getAntennaRow(scanAntennaPair.txAntenna)
    y1=getAntennaCol(scanAntennaPair.txAntenna)
    x2=getAntennaRow(scanAntennaPair.rxAntenna)
    y2=getAntennaCol(scanAntennaPair.rxAntenna)

    return math.sqrt((x2-x1)**2+(y2-y1)**2)


def getAntennaRow(antennaNum):
    if antennaNum==18:
        return 4
    elif antennaNum%4==0:
        return antennaNum/4-1
    else:
        return antennaNum/4
def getAntennaCol(antennaNum):
    if antennaNum==18:
        return 3
    else:
        return antennaNum%4-1




#Sort the antenna pairs
antennaPairs=walabot.GetAntennaPairs()
antennaPairs=sorted(antennaPairs, key=lambda element: (element[0], element[1]))


#Create window for plots
pg.setConfigOptions(antialias=True) #To make the plot prettier
app = QtGui.QApplication([])
win = pg.GraphicsWindow()
label = pg.LabelItem(justify='right')
win.addItem(label)
signalPlot = win.addPlot(row=1, col=0)

while True:
    x=[]
    y=[]
    walabot.Trigger()
    for i in range (len(antennaPairs)):
        scanAntennaPair = antennaPairs[i]
        x.append(getAntennaPairDist(scanAntennaPair))
        y.append(getPeakAmplitude(scanAntennaPair))
    signalPlot.plot(x,y,clear=True,pen=None, symbol='o')
    signalPlot.setTitle("Distance Between txAntenna and rxAntenna vs Peak Amplitude")
    app.processEvents()
    time.sleep(0.05)

# Step 7: Stop and disconnect
walabot.Stop()
walabot.Disconnect()
print ("Terminated successfully")



time.sleep(100)



