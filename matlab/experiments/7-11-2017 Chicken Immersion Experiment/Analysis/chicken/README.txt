object_depthvspeak.m was used to generate these figures.
Some important points to note on the methods used to generate these figures:
-The baseline used was the chicken at 10cm below the surface of the saline
	-This was done because the saline without the chicken submerged would not have the same distance to the radar as the saline with the chicken submerged
	-This is justified as the chicken at -10cm would only create a faint signal, so it's presence will not impact the subtraction signficantly
-All analysis on signals was done using the average of the 5 fast time signals
-The peak location was restricted between 20cm and 40cm so as to exclude peaks from targets other than the saline/chicken 
	-Since the saline surface was 27.2cm from the radar and the chicken lowered from 0cm to 10cm, the peak from the saline/chicken will be between 20cm and 40cm
	-Moreover, due to the large width of the transmitted pulse, only one peak can be found in an interval of 20cm -> therefore, the peak that we obtain is guaranteed to be the peak from the saline/chicken

Important conclusions from the plots:
-In all 4 plots, there is a noticeable decreasing trend in the amplitude of the peak as the chicken goes deeper and deeper into the water, which suggests that the presence of the chicken is indeed affecting the signal.  
	-However, the decreasing trend is not signifcant enough to conclude that the chicken was getting detected. 
-For the DAC settings of 0 to 1400, 500 to 1400, 949 to 1100 (default), the location of the peak is centered around 30.84cm (despite the depth of the chicken) for all frequencies, with deviations that are within 1-2 bins
	-Although the baseline is getting subtracted to get rid of the saline signal, the location of the peak seems to stay constant at around 30.84cm as the chicken moves from 0cm to -10cm. Since the saline was located 27.2cm from the radar, seemingly, the peak from the saline is still dominant after baseline s		ubtraction. As a result, these plots must be analyzed, keeping in mind that the peak from the chicken (if it exists) is hidden within the peak from the saline, despite the baseline subtraction. 
	-The DAC setting of 1000 to 1400 likely cuts off small, but signfiicant signals. Moreover, in the analysis of only the saline surface, this DAC setting seems to create the most error in peak location (see saline_surface/DAC Setting vs Error in Distance.fig). This explains why it's plot for peak location is not in line with the three other peak location plots. 
-Inexplicably, there does not seem to be any noticeable decreasing trend in the location of the peak as the chicken goes deeper into the water. Although it is evident that the peak from the chicken is hidden within the saline peak, as the chicken moves farther away, the sum of the saline peak and chicken peak should produce a peak that moves farther away as the chicken moves deeper (not necessarily in 1cm increments, since we are looking at the sum of the chicken and saline peak, rather than just the chicken peak). 
-There seems to be a fairly consistent relationship between peak amplitude and center frequency. 7.29 GHz produces the largest peak amplitude, followed by 8.748 GHz, then 5.832 GHz, then 10.206 GHz. Although the peak from the chicken should have a lower amplitude at higher frequencies, the frequency band of the receiver must also be considered. Pulses with 7.29 GHz and 8.748 GHz as center frequencies would be accepted completely by the receiver, whereas 5.832 GHz and 10.206 GHz would not be. This is a possible explanation for the ordering of the center frequencies with respect to the peak amplitude that they produce. 

