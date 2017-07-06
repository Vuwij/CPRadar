%% Experiment - Differences in frequency of single layer (sweep)
% This experiemnt collects datas a certin liquid is increased in thickness
% with different settings with the radar. The objective is to have
% a function of the resulting movement of the radar with respect to
% frequency

% Paths
addpath('../ModuleConnector_WIN/matlab');
addpath('../ModuleConnector_WIN/lib');
addpath('../ModuleConnector_WIN/include');
Lib = ModuleConnector.Library;
Lib.libfunctions

% Global radar settings
global FPS Duration PPS DACmin DACmax Iterations FrameStart FrameStop COM dataType radar;
FPS = 1;
Duration = 20;
PPS = 26;
DACmin = 949;
DACmax = 1100;
Iterations = 16;
FrameStart = 0.0; % meters.
FrameStop = 9.9; % meters.
COM = char(seriallist);
dataType = 'bb';

testName = 'plate_underwater_rising';

radar = BasicRadarClassX4(COM,FPS,dataType);
radar.open();
radar.init();

% Sweep frequencies
rf_data = acquire_radar_data(FPS, Duration);

% Saving data frames
filename = strcat('../data/time_sweeps/', testName, '.mat');
save(char(filename), 'rf_data');

radar.close();

%% Plot the time sweeps to find difference
figure;
hold on;
for i=1:Duration * FPS
    plot(abs(rf_data(i,:)));
end