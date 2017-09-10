import WalabotAPI as walabot
import numpy as np
from scipy import stats



def getFrequencySpectrum(timeDomainSignal, baseline):
    timeDomainSignalX = timeDomainSignal[1]
    timeDomainSignalY = timeDomainSignal[0]
    timeDomainSignalY = list(np.array(timeDomainSignalY) - np.array(baseline[0]))
    #Obtaining the frequency spectrum
    N=len(timeDomainSignalX)
    Fs=1.024e11
    freqDomainSignalY=np.fft.fft(np.asarray(timeDomainSignalY)) #Perform fast fourier transform
    freqDomainSignalY=freqDomainSignalY[1:N/2+1] #Get rid of the negative frequencies
    freqDomainSignalX = np.multiply(np.arange(0, N / 2), Fs / N)
    return [freqDomainSignalX,freqDomainSignalY]

def getDistanceToTarget(timeDomainSignal, profile, baseline):
    [freqDomainSignalX, freqDomainSignalY]=getFrequencySpectrum(timeDomainSignal,baseline)
    # Get the magnitude and phase components of the frequency spectrum
    freqDomainSignalPhaseY = np.angle(freqDomainSignalY)
    if (profile==walabot.PROF_SHORT_RANGE_IMAGING):
        a=5e9
        b=8e9
    else:
        a=6.3e9
        b=8e9
    #Cut off the signal beyond 6.3-8 GHz
    index1=np.where(freqDomainSignalX==a)[0]
    index2 = np.where(freqDomainSignalX==b)[0]
    index2=index2-1
    index1=index1+1
    freqDomainSignalX=freqDomainSignalX[index1:index2]

    freqDomainSignalPhaseY = freqDomainSignalPhaseY[index1:index2]
    #Unwrap the phase signal to get a linear signal
    freqDomainSignalPhaseY=-np.unwrap(freqDomainSignalPhaseY)
    #Apply a linear regression to the phase to find it's slope
    slope, intercept, r_value, p_value, std_err = stats.linregress(freqDomainSignalX, freqDomainSignalPhaseY)
    #Calculate the distance to the target using the slope
    dist=slope*3e8/(4*np.pi)
    return dist