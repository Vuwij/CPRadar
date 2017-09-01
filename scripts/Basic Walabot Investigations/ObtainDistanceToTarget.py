import WalabotAPI as walabot
from pyqtgraph.Qt import QtGui
import pyqtgraph as pg
import numpy as np
from scipy import stats
import time

'''
This is a Python script which estimates the distance to a target using the received the radar signal. Receive and transmit antenna pair can be specified in the code.  
Parameters:
-profile type
-R, theta, phi
-filter used
-antenna pair used
'''


walabot.Init('/usr/lib/libWalabotAPI.so')

#Step 1: Connect to Walabot
walabot.ConnectAny()

#Step 2: Configurations
#Set the scan profile as sensor (distance scanner with high resolution and slow update rate)
walabot.SetProfile(walabot.PROF_SHORT_RANGE_IMAGING)
#Set the dimensions of the arena
walabot.SetArenaR(1,100,1) #Question: what values can this take on? What is the lowest resolution you can set?
walabot.SetArenaTheta(-10,10,1)
walabot.SetArenaPhi(-10,10,1)
#Set the filter type
walabot.SetDynamicImageFilter(walabot.FILTER_TYPE_NONE)

#Step 3: Start the system in preparation for scanning
walabot.Start()

#Choose an antenna pair
scanAntennaPair=walabot.GetAntennaPairs()[0]

# #Step 4: Calibration to reduce signals from fixed targets
walabot.StartCalibration()
while walabot.GetStatus()[0] == walabot.STATUS_CALIBRATING:
     #Function which initiates a scan and records the signals
    walabot.Trigger()
     #Obtain a baseline signal during calibration
    baseline = walabot.GetSignal(scanAntennaPair)

#Create window for plots
pg.setConfigOptions(antialias=True) #To make the plot prettier
app = QtGui.QApplication([])
win = pg.GraphicsWindow()
label = pg.LabelItem(justify='right')
win.addItem(label)
freqDomainMagPlot=win.addPlot(row=1, col=0)
freqDomainMagPlot.setYRange(-20,20)
freqDomainMagPlot.setXRange(6.3e9,8e9)
freqDomainPhasePlot=win.addPlot(row=1, col=1)
freqDomainPhasePlot.setYRange(-np.pi,np.pi)
freqDomainPhasePlot.setXRange(6.3e9,8e9)
freqDomainPhaseUnwrappedPlot=win.addPlot(row=2, col=0.5)
freqDomainPhaseUnwrappedPlot.setYRange(-np.pi,np.pi)
freqDomainPhaseUnwrappedPlot.setXRange(6.3e9,8e9)



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


    #Obtaining the frequency spectrum
    N=len(timeDomainSignalX)
    Fs=1.024e11
    freqDomainSignalY=np.fft.fft(np.asarray(timeDomainSignalY)) #Perform fast fourier transform
    freqDomainSignalY=freqDomainSignalY[1:N/2+1] #Get rid of the negative frequencies
    freqDomainSignalX = np.multiply(np.arange(0, N / 2), Fs / N)

    #Get the magnitude and phase components of the frequency spectrum
    freqDomainSignalMagY=np.abs(freqDomainSignalY)
    freqDomainSignalPhaseY=np.angle(freqDomainSignalY)

    #Plotting the magnitude
    freqDomainMagPlot.plot(freqDomainSignalX, freqDomainSignalMagY, clear=True)
    freqDomainMagPlot.setTitle("Magnitude of Frequency Spectrum Between 6.3 and 8 GHz")
    freqDomainMagPlot.getAxis('bottom').setLabel('Frequency')
    freqDomainMagPlot.getAxis('left').setLabel('Magnitude')

    #Plotting the phase
    freqDomainPhasePlot.plot(freqDomainSignalX, freqDomainSignalPhaseY, clear=True)
    freqDomainPhasePlot.setTitle("Phase of Frequency Spectrum Between 6.3 and 8 GHz")
    freqDomainPhasePlot.getAxis('bottom').setLabel('Frequency')
    freqDomainPhasePlot.getAxis('left').setLabel('Phase')


    #Cut off the signal beyond 6.3-8 GHz
    index1=np.where(freqDomainSignalX==6.3e9)[0]
    index2 = np.where(freqDomainSignalX == 8e9)[0]
    freqDomainSignalX=freqDomainSignalX[index1:index2+1]
    freqDomainSignalPhaseY = freqDomainSignalPhaseY[index1:index2+1]
    #Unwrap the phase signal to get a linear signal
    freqDomainSignalPhaseY=-np.unwrap(freqDomainSignalPhaseY)

    #Plotting the unwrapped phase
    freqDomainPhaseUnwrappedPlot.plot(freqDomainSignalX, freqDomainSignalPhaseY, clear=True)
    freqDomainPhaseUnwrappedPlot.getAxis('bottom').setLabel('Frequency')
    freqDomainPhaseUnwrappedPlot.getAxis('left').setLabel('Unwrapped Phase')

    #Apply a linear regression to the phase to find it's slope
    slope, intercept, r_value, p_value, std_err = stats.linregress(freqDomainSignalX, freqDomainSignalPhaseY)

    #Calculate the distance to the target using the slope
    dist=slope*3e8/(4*np.pi)
    freqDomainPhaseUnwrappedPlot.setTitle("Unwrapped Phase, Distance to Target(m): %f" % dist)


    app.processEvents()


    time.sleep(0.1)

#Step 7: Stop and disconnect
walabot.Stop()
walabot.Disconnect()
print ("Terminated successfully")