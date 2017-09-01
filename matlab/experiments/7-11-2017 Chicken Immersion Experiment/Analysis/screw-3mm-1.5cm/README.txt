object_depthvspeak.m was used to generate these figures.
Some important points to note on the methods used to generate these figures:
-The baseline used was the screw at 10cm below the surface of the saline
	-This was one because the screw without the saline submerged would not have the same distance to the radar as the saline with the screw submerged
	-This is justified as the chicken at -10cm would only create a faint signal, so it's presence will not impact the subtraction significantly
-All analysis on signals was done using the average of the 5 fast time signals
-The peak location was restricted between 20cm and 40cm so as to exclude peaks from targets other than the saline/screw
	-Since the saline surface was 27.2cm from the radar and the screw lowered from 0cm to 10cm, the peak, from the saline/screw will be between 20cm and 40cm
	-Moreover, due to the large width of the transmitted pulse, only one peak can be found in an interval of 20cm -> therefore, the peak that we obtain is guarenteed to be the peak from the saline/screw

Important conclusions from the plots:
-In all 4 plots, there is a noticeable decreasing trend in the amplitude of the peak as the screw goes deeper and deepter into the water, which suggests that the presence of the screw is indeed affecting the signal.
	-It is very similar in shape to the amplitude vs depth graph for the screw
	-However, as with the chicken, the decreasing trend is not signiciant enough to conclude that the screw is getting detected
-Unlike the results from the chicken, the screw does not have a generally condition peak location. For all DAC settings, it varies between around 20cm and 35cm, which is equivalent to approximately 3 bins
-As with the chicken results, a center frequency of 7.29 GHz maximizes the peak amplitude, followed by 8.748 GHz, then 5.832GHz, then 10.206 GHz
