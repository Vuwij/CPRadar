Code implementation is as outlined in...
https://api.walabot.com/_flow.html
https://api.walabot.com/_sample.html

Several of these scripts use the pyqtgraph library for plotting which has been included in the folder. Make sure that whatever folder you are running these scripts from also contains the pyqtgraph folder. 

Description of all scripts:

AntennaPairDistvsPeakAmplitude:
Plots the peak amplitude of the received RF signal as a function of the proximity between the TX and RX antennas.
There is a slight negative correlation between peak amplitude and TX-RX antenna proximity (expected because it is likely due to direct leakage). However, it is very weak.
Parameters:
-R, theta, phi
-profile type
-filter used

AntennaVsCenterFreq:
Continuously plots the peak frequency of the received signal for various receive antennas (transmitted by a single, constant transmit antenna that can be specified in the code)
Parameters:
-R, theta, phi
-filtet type
-profile type

ObtainDistanceToTarget:
Estimates the distance to a target using the received radar signal. Receive and transmit antenna pair can be specified in the code. Method outlined in _____ was used to estimate the distance to the target by using the frequency spectrum of the received signal.
The distance was obtained to a few cm accuracy.
Parameters:
-profile type
-R, theta, phi
-filter used
-antenna pair used

ObtainRangeBounds:
Investigates the maximum range that can be set. It plots the maximum theta and phi for different values of R. It also plots the maximum volume of the scanning arena 
for various values of R. The maximum is at the place where an error is thrown for the arena size being too big. 
(R, theta, and phi are as defined in https://api.walabot.com/_features.html#_coordination)
Parameters:
-profile type

ObtainSignal:
Plots the following...
-radio frequency signal in time domain
-radio frequency signal in frequency domain 
-amplitude of downconverted signal
-phase of downconverted signal
-instantaneous frequency of time domain signal (centered around one frequency which is close to the central frequency of the rf signal)
-average frequency in slow time
Parameters:
-profile type (sensor, sensor narrow, or short range)
-dimensions of arena to be scanned
-filter to be used
-txAntenna and rxAntenna

PointsinSignalvsArenaSize:
Investigates how the number of points in the signal varies with arena size (fixed theta and phi, R ranging from 2 to 140). No matter what arena size is set, the number of points in the signal for a given profile stays the same (4096 for imaging mode, 8192 for both sensor modes).
*According to an email reply (), the set arena size was concluded to only affect the processing of the data, not the acquisition, which is why the number of points in the signal does not vary.
Parameters:
-profile type
-filter type
-theta
-phi

RangevsTriggerTime:
For a constant theta and phi, plots the range R vs the total amount of trigger time. 
*According to an email reply (), the set arena size was concluded to only affect the processing of the data, not the acquisition, which is why there does not seem to be any correlation between set arena size and trigger time.
Parameters:
-theta and phi
-profile type
-filter used

TimeBetweenSamplesVsResolution:
prints out the time between samples in the time domain signal received in the GetSignal() function. Various parameters (arena size, resolution of arena size, and antenna pair) can be specified. 
The conclusion from running this script for varying parameters is that the time between samples in the time domain STAYS constant at 9.765625 ps.

VisualizeRFSignal:
This just plots the rf signal received from the GetSignal() function without any baseline subtraction (can see TX-RX peak). 

