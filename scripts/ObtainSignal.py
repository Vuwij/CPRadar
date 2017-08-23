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
walabot.SetArenaR(1,20,1) #Question: what values can this take on? What is the lowest resolution you can set?
walabot.SetArenaTheta(-20,20,1)
walabot.SetArenaPhi(-20,20,1)
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
signalPlot = win.addPlot(row=1, col=0)
signalPlot.setYRange(0,1)
bbAmplitudePlot = win.addPlot(row=2, col=0)
bbPhasePlot = win.addPlot(row=3, col=0)
freqDomainPlot=win.addPlot(row=1, col=1)
freqDomainPlot.setYRange(-20,20)
instFreqPlot=win.addPlot(row=2, col=1)
instFreqPlot.setYRange(1e9,11e9)
avgInstFreqPlot=win.addPlot(row=3,col=1)




y=[]
#Continuously scanning + recording and getting the processed data
while True:


    #Step 5: Scan
    walabot.Trigger()

    #Step 6: Get the scan

    #Plotting signal in time domain
    timeDomainSignal=walabot.GetSignal(scanAntennaPair) #Returns the amplitude vector and corresponding time vector for the received signal
    timeDomainSignalX=timeDomainSignal[1]
    timeDomainSignalY=timeDomainSignal[0]
    timeDomainSignalY=list(np.array(timeDomainSignalY)-np.array(baseline[0]))
    signalPlot.plot(timeDomainSignalX, timeDomainSignalY, clear=True)
    signalPlot.setTitle("RF Time Domain Signal")
    print (timeDomainSignalX[len(timeDomainSignalX)-1])
    print (len(timeDomainSignalX))

    #Plotting signal in freq domain
    N=len(timeDomainSignalX)
    Fs=1.024*10**11
    freqDomainSignalY=np.fft.fft(np.asarray(timeDomainSignalY)) #Perform fast fourier transform
    freqDomainSignalY=np.abs(freqDomainSignalY)
    freqDomainSignalY=freqDomainSignalY[1:N/2+1]
    freqDomainSignalX=np.multiply(np.arange(0,N/2),Fs/N)
    freqDomainPlot.plot(freqDomainSignalX, freqDomainSignalY, clear=True)
    print (len(freqDomainSignalX))

    #Obtaining the bandwidth and center frequency from the frequency spectrum
    bandwidth = (freqDomainSignalY > 0.01).sum()*(freqDomainSignalX[1]-freqDomainSignalX[0])
    bandwidth=bandwidth/(10.0**9)
    maxIndex=np.argmax(freqDomainSignalY)
    centerFreq = freqDomainSignalX[maxIndex]
    freqDomainPlot.setTitle("Bandwidth (GHz): %f, Center Frequency (GHz): %f" % (bandwidth, centerFreq/(10**9)))

    #Plotting the baseband signal
    hilbertTransform = np.imag(hilbert(timeDomainSignalY))
    basebandImag = np.multiply(hilbertTransform, np.cos(2 * np.pi *centerFreq*timeDomainSignalX))-np.multiply(timeDomainSignalY,np.sin(2 * np.pi *centerFreq*timeDomainSignalX))
    basebandReal = np.multiply(timeDomainSignalY, np.cos(2 * np.pi * centerFreq * timeDomainSignalX)) + np.multiply(hilbertTransform, np.sin(2 * np.pi * centerFreq * timeDomainSignalX))
    baseband=basebandReal+1j*basebandImag
    basebandX=timeDomainSignalX
    bbAmplitudePlot.plot(basebandX, np.absolute(baseband), clear=True)
    bbAmplitudePlot.setTitle("Amplitude of Equivalent BB Signal")
    bbPhasePlot.plot(basebandX, np.angle(baseband), clear=True)
    bbPhasePlot.setTitle("Phase of Equivalent BB Signal")

    #Plotting instantaenous frequency as a function of time
    analytic_signal = hilbert(timeDomainSignalY)
    amplitude_envelope = np.abs(analytic_signal)
    instantaneous_phase = np.unwrap(np.angle(analytic_signal))
    instantaneous_frequency = (np.diff(instantaneous_phase) /(2.0 * np.pi) * Fs)
    instFreqPlot.plot(timeDomainSignalX[1:],instantaneous_frequency,clear=True)
    instFreqPlot.setTitle("Instantaneous Frequency of RF Signal")

    #Plotting average instantaneous frequency over time
    y.append(np.mean(instantaneous_frequency))
    if(len(y)>100):
        y.pop(0)
    avgInstFreqPlot.plot(range(0,len(y)),y,clear=True)




    app.processEvents()


    time.sleep(0.05)

#Step 7: Stop and disconnect
walabot.Stop()
walabot.Disconnect()
print ("Terminated successfully")