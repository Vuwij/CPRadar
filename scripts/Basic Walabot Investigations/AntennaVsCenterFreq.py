import WalabotAPI as walabot
from pyqtgraph.Qt import QtGui
import pyqtgraph as pg
import numpy as np
from scipy.signal import hilbert
import time

'''
This is a Python script which continuously plots the peak frequency of the received signal for various receive antennas (transmitted by a single, constant transmit antenna that can be specified in the code)  
Parameters:
-R, theta, phi
-filtet type
-profile type
'''

walabot.Init('/usr/lib/libWalabotAPI.so')

#Connect to Walabot
walabot.ConnectAny()

#Configurations
#Set the scan profile
walabot.SetProfile(walabot.PROF_SHORT_RANGE_IMAGING)
# Set the dimensions of the arena
walabot.SetArenaR(1, 20, 1)  # Question: what values can this take on? What is the lowest resolution you can set?
walabot.SetArenaTheta(-20, 20, 1)
walabot.SetArenaPhi(-20, 20, 1)
# Set the filter type
walabot.SetDynamicImageFilter(walabot.FILTER_TYPE_NONE)

#Start the system in preparation for scanning
walabot.Start()

#Calibration to reduce signals from fixed targets
walabot.StartCalibration()
while walabot.GetStatus()[0] == walabot.STATUS_CALIBRATING:
    # Function which initiates a scan and records the signals
    walabot.Trigger()

# Create window for plots
pg.setConfigOptions(antialias=True)  # To make the plot prettier
app = QtGui.QApplication([])
win = pg.GraphicsWindow()
label = pg.LabelItem(justify='right')
win.addItem(label)
centerFreqPlot = win.addPlot(row=1, col=0)


def getCenterFreq(scanAntennaPair):
    #Returns the amplitude vector and corresponding time vector for the received signal
    timeDomainSignal = walabot.GetSignal(scanAntennaPair)
    timeDomainSignalX = timeDomainSignal[1]
    timeDomainSignalY = timeDomainSignal[0]
    #Perform an fftshift before taking the fourier transform
    timeDomainSignalY = np.fft.fftshift(timeDomainSignalY)


    #Fourier transforming the signal in the time domain
    N = len(timeDomainSignalX)
    Fs = 1.024 * 10 ** 11
    freqDomainSignalY = np.fft.fft(np.asarray(timeDomainSignalY))  # Perform fast fourier transform
    freqDomainSignalY = np.absolute(freqDomainSignalY)
    freqDomainSignalY = freqDomainSignalY[1:N / 2 + 1]
    freqDomainSignalX = np.multiply(np.arange(0, N / 2), Fs / N)

    # Obtain the center frequency
    maxIndex = np.argmax(freqDomainSignalY)
    centerFreq = freqDomainSignalX[maxIndex]
    return centerFreq

#Sort the list of antenna pairs
antennaPairs=walabot.GetAntennaPairs()
antennaPairs=sorted(antennaPairs, key=lambda element: (element[0], element[1]))

#Continuously plot the center frequency as a function of the receive antenna number (transmit antenna number is held constant)
transmitAntennaNum = 15
while True:
    # Step 5: Scan
    walabot.Trigger()
    y=[]
    #Go through all the receive antennas that will work with the specified transmit antenna and obtain the center frequency of the signal
    for i in range (len(antennaPairs)):
        scanAntennaPair = antennaPairs[i]
        if scanAntennaPair.txAntenna == transmitAntennaNum:
            y.append(getCenterFreq(scanAntennaPair))
    #Plot the data
    centerFreqPlot.plot(range(len(y)), y, clear=True)
    app.processEvents()


# Step 7: Stop and disconnect
walabot.Stop()
walabot.Disconnect()
print ("Terminated successfully")


