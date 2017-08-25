import WalabotAPI as walabot
from pyqtgraph.Qt import QtGui
import pyqtgraph as pg
import numpy as np
from scipy.signal import hilbert
import time
import matplotlib.pyplot as plt

'''
This is a Python script which plots the following...
-radio frequency signal in time domain
-radio frequency signal in frequency domain (has a sharp peak at around 7.0-7.2 GHz with a bandwidth of ~1.5 GHz)
-amplitude of downconverted signal
-phase of downconverted signal
-instantaneous frequency of time domain signal (centered around one frequency which is close to the central frequency of the rf signal)
-average frequency in slow time
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
walabot.SetProfile(walabot.PROF_SENSOR_NARROW)
#Set the dimensions of the arena
walabot.SetArenaR(1,100,1) #Question: what values can this take on? What is the lowest resolution you can set?
walabot.SetArenaTheta(-10,10,1)
walabot.SetArenaPhi(-10,10,1)
#Set the filter type
walabot.SetDynamicImageFilter(walabot.FILTER_TYPE_NONE)

#Step 3: Start the system in preparation for scanning
walabot.Start()

scanAntennaPair=walabot.GetAntennaPairs()[0] #Use antenna #1 as tx and antenna #2 as rx (numberings are as specified in the tech spec sheet)

# #Step 4: Calibration to reduce signals from fixed targets
walabot.StartCalibration()
while walabot.GetStatus()[0] == walabot.STATUS_CALIBRATING:
     #Function which initiates a scan and records the signals
    walabot.Trigger()
    baseline = walabot.GetSignal(scanAntennaPair)

#Create window for plots
pg.setConfigOptions(antialias=True) #To make the plot prettier
app = QtGui.QApplication([])
win = pg.GraphicsWindow()
label = pg.LabelItem(justify='right')
win.addItem(label)
freqDomainRealPlot=win.addPlot(row=1, col=0)
freqDomainRealPlot.setYRange(-20,20)
freqDomainRealPlot.setXRange(6.3e9,8e9)
freqDomainImagPlot=win.addPlot(row=1, col=1)
freqDomainImagPlot.setYRange(-np.pi,np.pi)
freqDomainImagPlot.setXRange(6.3e9,8e9)
timeDomainRealPlot=win.addPlot(row=2, col=0)
timeDomainRealPlot.setYRange(-0.5,0.5)
timeDomainImagPlot=win.addPlot(row=2, col=1)
timeDomainImagPlot.setYRange(-0.5,0.5)



y=[]
#Continuously scanning + recording and getting the processed data
while True:


    #Step 5: Scan
    walabot.Trigger()

    #Step 6: Get the scan

    #Getting signal in time domain
    timeDomainSignal=walabot.GetSignal(scanAntennaPair) #Returns the amplitude vector and corresponding time vector for the received signal
    timeDomainSignalX=timeDomainSignal[1]
    timeDomainSignalY=timeDomainSignal[0]
    timeDomainSignalY=list(np.array(timeDomainSignalY)-np.array(baseline[0]))


    #Plotting signal in freq domain
    N=len(timeDomainSignalX)
    Fs=1.024*10**11
    freqDomainSignalY=np.fft.fft(np.asarray(timeDomainSignalY)) #Perform fast fourier transform
    freqDomainSignalY=freqDomainSignalY[1:N/2+1]
    freqDomainSignalRealY=np.abs(freqDomainSignalY)
    freqDomainSignalImagY=np.angle(freqDomainSignalY)
    freqDomainSignalX=np.multiply(np.arange(0,N/2),Fs/N)
    freqDomainRealPlot.plot(freqDomainSignalX, freqDomainSignalRealY, clear=True)
    freqDomainRealPlot.setTitle("Magnitude")
    freqDomainImagPlot.plot(freqDomainSignalX, freqDomainSignalImagY, clear=True)
    freqDomainImagPlot.setTitle("Phase")

    #Getting the inverse fourier transform
    timeDomainSignalY=np.fft.ifft(freqDomainSignalY)
    # a=np.arccos(timeDomainSignalX)*(3e8)/(-4*np.pi)
    # print((freqDomainSignalX))
    # timeDomainSignalX=np.divide(a, freqDomainSignalX)
    # timeDomainRealPlot.plot(np.abs(timeDomainSignalY),clear=True)
    # timeDomainRealPlot.setTitle("Magnitude")
    # timeDomainImagPlot.plot(np.angle(timeDomainSignalY),clear=True)
    # timeDomainImagPlot.setTitle("Phase")



    app.processEvents()


    time.sleep(0.05)

#Step 7: Stop and disconnect
walabot.Stop()
walabot.Disconnect()
print ("Terminated successfully")