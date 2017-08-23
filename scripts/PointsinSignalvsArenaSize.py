import WalabotAPI as walabot
import matplotlib.pyplot as plt
import numpy as np
import time

'''
This is a Python script which plots the radio frequency signal received and transmitted by specified antennas on the Walabot.
Parameters:
-profile type (sensor, sensor narrow, or short range)
-dimensions of arena to be scanned
-filter to be used
-txAntenna and rxAntenna
4096 data points always when the profile is set as short range.
8192 data points always when the profile is set as long range. 
'''


walabot.Init('/usr/lib/libWalabotAPI.so')

#Step 1: Connect to Walabot
walabot.ConnectAny()

mean_trigger_times=[] #Vector to store the mean trigger times
calibration_times=[] #Vector to store the calibration times

#Go from a range of 1cm to 200cm (R in sphereical coordinates. Theta and Phi range are kept constant
for j in range(2,140,5):
    #Configurations
    #Set the scan profile as sensor (distance scanner with high resolution and slow update rate)
    walabot.SetProfile(walabot.PROF_SENSOR)
    #Set the dimensions of the arena
    walabot.SetArenaR(1,j,10) #Question: what values can this take on? What is the lowest resolution you can set?
    walabot.SetArenaTheta(-5,5,1)
    walabot.SetArenaPhi(-5,5,1)
    #Set the filter type
    walabot.SetDynamicImageFilter(walabot.FILTER_TYPE_NONE)

    #Start the system in preparation for scanning
    walabot.Start()

    walabot.Trigger()

    timeDomainSignal=walabot.GetSignal(walabot.GetAntennaPairs()[0]) #Returns the amplitude vector and corresponding time vector for the received signal
    timeDomainSignalX=timeDomainSignal[1]
    timeDomainSignalY=timeDomainSignal[0]

    print(len(timeDomainSignalX))
    print(timeDomainSignalX[1]-timeDomainSignalX[0])






    walabot.Stop()







walabot.Disconnect()
