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
FPS = 20;
Duration = 1;
PPS = 26;
DACmin = 949;
DACmax = 1100;
Iterations = 16;
FrameStart = 0.0; % meters.
FrameStop = 9.9; % meters.
COM = char(seriallist);
dataType = 'rf';

depth = 'zero2-';

%% Using BasicRadarClassX4
radar = BasicRadarClassX4(COM,FPS,dataType);
radar.open();
radar.init();

% Sweep frequencies
for freq=0:7
    data = acquire_radar_data(FPS, Duration, freq);
    rf_data = data(20,:);
    % Averaging frames
    filename = strcat('../data/frequency_sweeps/', depth, num2str((freq + 2) * 1.455), 'ghz.mat');
    save(char(filename), 'rf_data');
end

radar.close();
clear