% FPS - frames per second
% Duration - how long in seconds
% Frequency - 0 to 8. Range 2.9 to 13.122 Ghz
function [radarData] = acquire_radar_data(FPS, Duration, Frequency)
    global PPS DACmin DACmax Iterations FrameStart FrameStop dataType radar;
    if nargin < 3
        Frequency = 3;
    end
    load('../data/frequency_sweeps/zerobb-7.275ghz.mat');

    % Configure X4 chip.
    radar.radarInstance.x4driver_set_pulsesperstep(PPS);
    radar.radarInstance.x4driver_set_dac_min(DACmin);
    radar.radarInstance.x4driver_set_dac_max(DACmax);
    radar.radarInstance.x4driver_set_iterations(Iterations);
    radar.radarInstance.x4driver_set_tx_center_frequency(3);
    radar.radarInstance.x4driver_set_pif_register(101, Frequency * 16); %Frequency Register
    frequency = (Frequency + 2) * 1.455;
    % Frequency Registers
    % 0 - 2.9 Ghz
    % 16 - 4.314 Ghz
    % 32 - 5.832 Ghz
    % 48 - 7.29 Ghz
    % 64 - 8.748 Ghz
    % 80 - 10.206 Ghz
    % 96 - 11.664 Ghz
    % 112 - 13.122 Ghz
    
    % Configure frame area
    radar.radarInstance.x4driver_set_frame_area(FrameStart,FrameStop);
    [frameStart, frameStop] = radar.radarInstance.x4driver_get_frame_area();

    % Start streaming and subscribe to message_data_float.
    radar.start();
    
    fh = figure(5);
    clf(fh);
    ph = plot(0);
    ylabel('Normalized amplitude');
    xlabel('Range [m]');
    th = title(strcat('Frequency Spectrum (', num2str(frequency), ')'));
    grid on;

    i = 0;
    while ishandle(fh) && i < FPS * Duration
        % Peek message data float
        numPackets = radar.bufferSize();
        if numPackets > 0
            i = i+1;
            % Get frame (uses read_message_data_float)
            [frame, ctr] = radar.GetFrameNormalized();
            
            if i == 1
                numBins = length(frame);
                if strcmp('bb', dataType)
                    numBins = numBins/2;
                end
                radarData = zeros(FPS * Duration, numBins);
                binLength = (frameStop-frameStart)/(numBins-1);
                rangeVec = (0:numBins-1)*binLength + frameStart;
                ph.XData = rangeVec;
            end
            
            switch dataType
                case 'rf'
                    ph.YData = frame;
                    ylim([-1.2 1.2]);
                case 'bb'
                    frame = frame(1:end/2) + 1i*frame(end/2 + 1:end);
                    ph.YData = abs(frame - rf_data.'); 
                    ylim([-0.1 2]);
            end
            
            radarData(i,:) = frame;
            
            th.String = ['FrameNo: ' num2str(i) ' - Length: ' num2str(length(frame)) ' - FrameCtr: ' num2str(ctr)];

            drawnow;
            if mod(i,100)==0
                disp(['Packets available: ' num2str(radar.bufferSize())]);
            end 
        end
    end

    radar.stop();
end