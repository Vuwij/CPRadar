MATLAB scripts used to generate figures:
Center Frequency vs Saline Peak Amplitude_DAC-.fig: saline_freqvspeak.m
DAC Setting vs Error in Distance.fig: mean_freq_error.m
Distance from Radar vs Amplitude of Peak.fig: saline_depthvspeak.m

Some important points to note on the methods used to generate these figures:
-The baseline used was first 18 bins of the zero signal (taken at the corresponding frequency and DAC setting). Visually, it seemed that the zero signal was around/bit more than 18 bins long. Signals that came from beyond would be from other targets in the area, which the zero signal should not include. By restricting it to 18 bins, it is ensured that only the zero signal is getting subtracted. 
-All analysis on signals was done using the average of the 5 fast time signals

Important conclusions from the plots:
DAC Setting vs Error in Distance:
-This plot looks at the absolute value of the difference between the measured distance to the saline surface and the distance extracted from the signal for differt DAC settings and center frequencies
-A DAC setting of...
	1: 0 to 1400
	2: 100 to 1400
	3: 200 to 1400
	...
	11: 1000 to 1400
	12: 949 to 1100 (default)
-Evidently, the error in peak location usually stays constant over all DAC settings for a given plot and stays between 0-2 bins. 
-At 10.206 GHz, DAC settings of 900 to 1400 and 1000 to 1400 consistently give errors of around 10cm, which indicates that they may be cutting off significant signals. Apart from any outliers, 5.832 GHz, 7.29 GHz, and 10.206 GHz seem to give around the same magnitude of error. 8.748 GHz seems to give a greater magnitude of error over all DAC settings. For example, at 15.5cm, most DAC settings at 8.748 GHz give an error of around 5, while all other frequencies give an error of around 0.
Distance from Radar vs Amplitude of Peak:
-This plot looks at how the amplitude of the peak from the saline surface varies with the distance of the saline surface from the radar
-For all DAC settings except the the default (949 to 1100), there is a very clear decreasing trend in peak amplitude as the saline surface gets farther from the radar
-Generally, the 7.29 GHz gives the greatest peak amplitude, followed by 8.748 GHz, 5.832 GHz, then 10.206 GHz. Lower frequencies would provide greater penetration depth, and therefore a greater signal from the bottom saline container and the book underneath, results in a higher peak amplitude (the indivdual peaks from the saline surface and stuff beneath would sum to create one peak, since the pulse width is greater than the distance between them). However, 7.29 GHz and 8.748 GHz pulses lie within the receiver bandwidth and would therefore be taken in completely by the receiver, whereas 5.832 GHz and 10.206 GHz pulses would not be, resulting in a lower than expected amplitude. This same ordering in center frequency vs peak amplitude was observed in the figure chicken/Distance above Saline vs Peak_DAC-.fig
-As DACMIN gets higher, the peak amplitudes also get higher. However, the peak amplitudes are the highest at the default DAC setting (949 to 1100).
Center Frequency
-Despite the DAC setting used, 7.29 GHz provides the largest peak amplitude

