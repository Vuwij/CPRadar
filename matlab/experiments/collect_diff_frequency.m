%% Experiment - Differences in frequency of single layer (sweep)
% This experiemnt collects datas a certin liquid is increased in thickness
% with different settings with the radar. The objective is to have
% a function of the resulting movement of the radar with respect to
% frequency

% Global radar settings
FPS = 60;

% Start the radar
Lib = ModuleConnector.Library;
Lib.libfunctions
COM = char(seriallist);
radar = BasicRadarClassX4(COM,FPS,dataType);
radar.open();

% Sweep frequencies
for i=1:2
   % Some radar settings 
   
end

function [radarData] = collect_radar_data(Duration)
    radar.start();
    tstart = tic;

    radarData = zeros(FPS * Duration, 186);

    while ishandle(fh) && i < FPS * Duration
        % Peek message data float
        numPackets = radar.bufferSize();
        if numPackets > 0
            i = i+1;
            
            % Get frame (uses read_message_data_float)
            [frame, ctr] = radar.GetFrameNormalized();
            frame = frame(1:end/2) + 1i*frame(end/2 + 1:end);
            radarData(i,:) = frame;
        end
    end

    radar.stop();
    radar.close();
end