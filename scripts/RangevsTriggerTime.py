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
'''


walabot.Init('/usr/lib/libWalabotAPI.so')

#Step 1: Connect to Walabot
walabot.ConnectAny()

mean_trigger_times=[] #Vector to store the mean trigger times
calibration_times=[] #Vector to store the calibration times

#Go from a range of 1cm to 200cm (R in sphereical coordinates. Theta and Phi range are kept constant
for j in range(2,140,5):
    print j
    #Configurations
    #Set the scan profile as sensor (distance scanner with high resolution and slow update rate)
    walabot.SetProfile(walabot.PROF_SHORT_RANGE_IMAGING)
    #Set the dimensions of the arena
    walabot.SetArenaR(1,j,1) #Question: what values can this take on? What is the lowest resolution you can set?
    walabot.SetArenaTheta(-5,5,1)
    walabot.SetArenaPhi(-5,5,1)
    #Set the filter type
    walabot.SetDynamicImageFilter(walabot.FILTER_TYPE_NONE)

    #Start the system in preparation for scanning
    walabot.Start()

    #Calibration to reduce signals from fixed targets
    walabot.StartCalibration()
    start_time=time.time()
    while walabot.GetStatus()[0] == walabot.STATUS_CALIBRATING:
        #Function which initiates a scan and records the signals
        walabot.Trigger()
    calibration_times.append(time.time()-start_time)

    trigger_times=[] #Vector to store 50 trigger times
    for i in range(20):
        #Time the triggering process
        start_time=time.time()
        walabot.Trigger()
        trigger_times.append(time.time()-start_time)
        #time.sleep(0.05)

    mean_trigger_times.append(np.mean(trigger_times))

    walabot.Stop()


#Plotting the results
plt.plot(range(2,140,5), mean_trigger_times, 'ro')
plt.title("Range vs Average Trigger Time (Seconds)")

plt.figure()
plt.plot(range(2,140,5), calibration_times, 'ro')
plt.title("Range vs Calibration Time (Seconds)")

plt.show()

time.sleep(100)

walabot.Disconnect()
