import WalabotAPI as walabot

'''
Investigates how the number of points in the signal varies with arena size (fixed theta and phi, R ranging from 2 to 140). 
No matter what arena size is set, the number of points in the signal for a given profile stays the same
4096 data points always when the profile is set as short range/imaging mode
8192 data points always when the profile is set as long range/sensor mode
*According to an email reply, the set arena size was concluded to only affect the processing of the data, not the 
acquisition, which is why the number of points in the signal does not vary.
Parameters:
-profile type
-filter type
-theta
-phi
'''


walabot.Init('/usr/lib/libWalabotAPI.so')

#Step 1: Connect to Walabot
walabot.ConnectAny()

mean_trigger_times=[] #Vector to store the mean trigger times
calibration_times=[] #Vector to store the calibration times

theta=5
phi=5

#Go from a range of 1cm to 200cm (R in sphereical coordinates. Theta and Phi range are kept constant
for j in range(2,140,5):
    #Configurations
    #Set the scan profile as sensor (distance scanner with high resolution and slow update rate)
    walabot.SetProfile(walabot.PROF_SENSOR)
    #Set the dimensions of the arena
    walabot.SetArenaR(1,j,10) #Question: what values can this take on? What is the lowest resolution you can set?
    walabot.SetArenaTheta(-theta,theta,1)
    walabot.SetArenaPhi(-phi,phi,1)
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
