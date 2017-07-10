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

% Material information
Filename = '../data/underwater_samples';
Material = 'screw';
Depth = '-10cm';

% Load information
datafile = matfile(Filename', 'Writable', true);
mtable = datafile.(Material);
mtablebb = datafile.(strcat(Material, '_bb'));

% Global radar settings
global FPS Duration PPS DACmin DACmax Iterations FrameStart FrameStop COM dataType radar;
FPS = 20;
Duration = 0.25;
PPS = 26;
DACmin = 949;
DACmax = 1300;
Iterations = 16;
FrameStart = 0.0; % meters.
FrameStop = 9.9; % meters.
COM = char(seriallist);
dataType = 'bb';

%% Using BasicRadarClassX4
radar = BasicRadarClassX4(COM,FPS,dataType);
radar.open();
radar.init();

% mtable(end+1,:) = mtable(end,:);
% mtable(end,1) = {Depth};
% mtablebb(end+1,:) = mtablebb(end,:);
% mtablebb(end,1) = {Depth};

% Sweep frequencies
for ftype=[0,1]
    radar.radarInstance.x4driver_set_downconversion(ftype);
    if ftype == 0
        dataType = 'rf';
    else
        dataType = 'bb';
    end
    
    for DACmin = [100, 200, 300, 400, 500, 600, 700, 800, 900, 949, 1000]
        for freq=[2,3,4,5]
            data = acquire_radar_data(FPS, Duration, freq);

            rowname = strcat(Depth);
            colname = strcat('dac', num2str(DACmin), 'f', num2str(freq));

            if ftype == 0
                mtable{rowname,colname} = {data};
            else
                mtablebb{rowname,colname} = {data};
            end
        end
    end
end

str = [Material,'= mtable;'];
eval(str);
save(Filename,Material,'-append');

str = [strcat(Material, '_bb'),'= mtablebb;'];
eval(str);
save(Filename,strcat(Material, '_bb'),'-append');

radar.close();
clear