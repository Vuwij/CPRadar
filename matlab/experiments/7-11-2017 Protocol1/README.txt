MATLAB Scripts (open the scripts in MATLAB for more info):
sweep_frequencies.m
This is the matlab file that was run to acquire the signal data for each setup.
It sweeps through 12 DAC settings (0 to 1400, 100 to 1400, 200 to 1400, ..., 1000 to 1400, 949 to 1100 (default)) and creates a 5x186 table for each. Both rf (radio frequency) and bb (baseband) data are acquired.
obtain_data.m
Function which can be used to obtain a column vector of a single signal given it's folder, center frequency, bb/rf mode, DAC settings, and fast time sequence number (1 to 5)
obtain_mean_data.m
Function which can be used to obtain the mean column vector of a single signal (average of 5 fast time sequences) given it's folder, center frequency, bb/rf more, and DAC settings.
subtract_baseline.m
Script which can be used to visualize a signal (set in the script)  with a baseline (can be set in the script) subtracted from it. Also shows the signal and baseline on the same plot prior to subtraction.
Uses bb data.
obtain_greatest_peak.m:
Function which can be used to obtain the distance at which a peak occurs (from the radar) as well as it's amplitude AFTER baseline subtraction. The baseline that is to be used needs to be sed in obtain_mean_data.m
Uses bb data.
obtain_greatest_peak_between.m:
Function which does the same thing as obtain_greatest_peak.m, but the distance interval in which the peak needs to be found can be set. Ex. rather than returning the peak of the whole signal, it will find the peak of the signal between, say, 20cm and 40cm (these numbers are parameters of the function).
Uses bb data.
mean_freq_error.m:
Used in analyzing results from saline_only. Script which plots DAC setting vs. error in distance (abs(measured distance-distance at which peak occurs in signal). It does this for all 3 distance and all four frequencies, resulting in 12 subplots.
saline_freqvspeak.m:
Used in analyzing results from saline_only. Script which plots center frequency vs. amplitude of peak from saline. Results from the three distance are all shown on the same plot. DAC setting can be chosen in the script.
saline_depthvspeak:
Used in analyzing results from saline_only. Script which plots the measured distance from the saline surface vs. ampltude of peak from saline. Results from the four center frequencies are all shown on the same plot. 
object_depthvspeak:
Used in analyzing results from the chicken and three screws. Script which plots the depth of the object beneath the saline surface vs. both amplitude and location of peak (2 subplots). On each subplot, the results from the four center frequencies are overlayed. 


Data Folders:
saline_only 
Contains the data from step 6 of the protocol
chicken5x4x1cm
Contains the data from step 7 of the protocol
screw-2mm-0.8cm
Contains the data from step 8 of the protocol for a 2mm diameter screw with a length of 0.8cm
screw-3mm-1.2cm
Contains the data from step 8 of the protocol for a 3mm diameter screw with a length of 1.2cm.
screw-3mm-1.5cm.
Contains the data from step 8 of the protocol for a 3mm diameter screw with a length of 1.5cm.
zero
Contains zero data (taken using the setup found in  images/zero.jpg). Used for subtracting out the TX-RX coupling signal in the first (approx.) 18 bins.

Images of experimental setup:
Can be found in the /images/


