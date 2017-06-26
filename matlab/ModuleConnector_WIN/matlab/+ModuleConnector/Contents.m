%% ModuleConnector.
% XeThru Module Connector is the SW used to communicate with all XeThru modules
% on a host computer over a serial communication channel. XeThru Module Connector
% is implemented and distributed as a Shared Object / Dynamic Link Library (DLL)
% and can linked in runtime and accessed through an API from a number of different
% host environments including Matlab, Python, C++ and Labview. This document
% contains all information required to configure XeThru Module Connector for
% the different host environments, as well as a reference to the entire API.
%
% Associated with XeThru Module Connector is XeThru Module Communication Library.
% This is a C library distributed as code. The library implements functions for
% endoding and decoding all serial protocol byte stream commands. The intended
% use of the library is if the module user needs to interface the XeThru module
% itself from another embedded platform, and therefore is required to write
% the driver layer. XeThru Module Communication Library simplifies this task.
%
% Using the XeThru Module Communication Library with MATLAB requires
% configuratuin of a C compiler. This can be done by installing the
% "MATLAB Support for the MinGW-w64 C/C++ Compiler from TDM-GCC" add-on,
% available in the MATLAB Add-On Explorer.
% NOTE: There is a known bug in MATLAB which may cause the installer to
% fail fetching the necessary files. According to Mathworks, they are
% working on a solution. In the meantime, a workaround can be found <a href="matlab: web('http://www.mathworks.com/matlabcentral/answers/313286-why-do-i-see-a-java-util-zip-zipexception-error-in-my-installer-log-file-when-i-try-to-install-the')">here</a>.
%
% XeThru Module Connector has been tested with the following MATLAB
% versions:
% - MATLAB R2017a 64-bit for Windows 10
% - MATLAB R2016b 64-bit for Windows 10
% - MATLAB R2016a 64-bit for Windows 10
%
% Novelda AS can not guarantee functionality of ModuleConnector for MATLAB
% versions other than the ones specified in the list above.
%
%% ModuleConnector functional description
%
% The ModuleConnector supports both synchronous and asynchronoous messages.
% Ping is and example of a synchronous message. When ping is called it does
% not return before it either receives a response (pong) or it times out.
%
% Asynchronous messages are sent from the Xethru module not directly based on
% commands from the host, but rather based on events in the Xethru module itself.
% For example various radar frames are sent from the module to the host whenever
% the frames arrive from the radar chip. To get hold of the asynchronous data
% packets you need to subscribe to them. The code below show an example of how
% to subscribe to amplitude phase data. You have to give the subsctiption a name.
% All the amplitude phase baseband packets will then be collected in buffers or
% queues. It is the possible to get the length of the queue and fetch packets
% from the queue.
%
%
% Files
%   ModuleConnector      - This class handles connections to the Xethru
%                          module and provides the interfaces listed below.
%   Library              - This class handles loading and unloading of the
%                          XeThru Module Communication Library.
%
%
% Interfaces
%   X2M200              - This class provides the Xethru respritaion & sleep
%                         based on the Xethru X2 SOC.
%   X4M300              - This class provides the Xethru presence
%                         based on the Xethru X4 SOC.
%   X2                  - This class provides a set of parameterized low
%                         level X2 commands and responses.
%   XEP                 - This class provides a set of parameterized low
%                         level X4 commands and responses.
%   DataRecorder        - This class allows recording of XeThru data types.
%   DataReader          - This class allows reading of XeThru recordings
%                         done using DataRecorder.
%
% Usage
% For more examples of usage, see matlab/examples
%
%   % Update paths
%   addpath('<working_directory/<SWpackage>/matlab/');
%   addpath('<working_directory/<SWpackage>/include/');
%   addpath('<working_directory/<SWpackage>/lib/');
%
%   % Load and link runtime
%   LIB = ModuleConnector.Library;                 % Load library
%
%   % Create a module connector
%   mc = ModuleConnector.ModuleConnector('COM3');  % Module is attached to port COM3
%
%   % Create an interface to the X2 chip
%   x2 = mc.get_x2();
%
%   % Access a X2 register
%   ChipID = x2.get_x2_register(2);                 % Read X2 chip register
%
%   % Clean up
%   clear x2
%   clear mc
%   LIB.unloadlib();                                % Unload library
%
%
% Methods
%
% X2M200
%    X2M200.X2M200                                             -  Constructor
%    X2M200.clear                                              -  Clears the in-buffer of the named subscription.
%    X2M200.delete                                             -  Destructor
%    X2M200.disable_resp_output                                -  disables respiration output
%    X2M200.enable_baseband                                    -  Enable baseband output.
%    X2M200.enable_baseband_ap                                 -  Enable amplitude/phase baseband output.
%    X2M200.enable_baseband_iq                                 -  Enable I/Q baseband output.
%    X2M200.enable_resp_output                                 -  enables respiration output. A subscription must be defined before this call can be made.
%    X2M200.get_app_id_list                                    -  Get a list of supported profiles.
%    X2M200.get_baseband_ap_data                               -  Get one buffered baseband AP data message. Order is FIFO.
%    X2M200.get_baseband_iq_data                               -  Get one buffered baseband IQ data message. Order is FIFO.
%    X2M200.get_build_info                                     -  Returns information of the SW Build installed on the device.
%    X2M200.get_firmware_id                                    -  Returns the installed Firmware ID.
%    X2M200.get_firmware_version                               -  Returns the installed Firmware Version.
%    X2M200.get_item_number                                    -  Returns the internal Novelda PCBA Item Number, including revision.
%    X2M200.get_number_of_packets                              -  Returns the number of packets buffered
%    X2M200.get_order_code                                     -  Returns the PCBA Order Code.
%    X2M200.get_packet                                         -
%    X2M200.get_respiration_data                               -  Get one buffered respiration data message. Order is FIFO.
%    X2M200.get_serial_number                                  -  Returns the PCB serial number.
%    X2M200.get_sleep_data                                     -  Get one buffered sleep data message. Order is FIFO.
%    X2M200.load_respiration_profile                           -  Load the respiration profile.
%    X2M200.load_sleep_profile                                 -  Load the sleep profile.
%    X2M200.reset                                              -  Resets the module to it's last recovered state.
%    X2M200.set_detection_zone                                 -  Set the desired detection zone.
%    X2M200.set_led_control                                    -  Configures the module LED mode.
%    X2M200.set_sensitivity                                    -  Set module sensitivity.
%    X2M200.set_sensor_mode_idle                               -  Set the sensor in idle mode.
%    X2M200.set_sensor_mode_run                                -  Run sensor application
%    X2M200.start_bootloader                                   -  Enters the bootloader for FW upgrades.
%    X2M200.subscribe_to_baseband_ap                           -  Start buffering baseband_ap messages.
%    X2M200.subscribe_to_baseband_iq                           -  Start buffering baseband_iq messages.
%    X2M200.subscribe_to_resp_status                           -  Subscribe to respiration status data messages.
%    X2M200.subscribe_to_sleep_status                          -  Subscribe to sleep status data messages.
%    X2M200.unsubscribe                                        -  Unsubscribe to a named subscription.
%
% X4M300
%    X4M300.X4M300                                             -  Constructor
%    X4M300.clear                                              -  Clears the in-buffer of the named subscription.
%    X4M300.delete                                             -  Destructor
%    X4M300.get_detection_zone                                 -  Returns the actual range window.
%    X4M300.get_detection_zone_limits                          -  Returns the potential settings of detection zone from the module.
%    X4M300.get_output_control                                 -  Returns the output control of the specified output feature.
%    X4M300.get_system_info                                    -  Returns a string containing system information given an infocode
%    X4M300.load_profile                                       -  Loads the a preset profile.
%    X4M300.module_reset                                       -  Resets and restart the module.
%    X4M300.peek_message_baseband_ap                           -  Return the number of buffered baseband ap messages.
%    X4M300.peek_message_baseband_iq                           -  Return the number of buffered baseband iq messages.
%    X4M300.peek_message_presence_movinglist                   -  Return the number of buffered presence movinglist messages.
%    X4M300.peek_message_presence_single                       -  Return the number of buffered presence single messages.
%    X4M300.read_message_baseband_ap                           -  Get one buffered baseband AP data message. Order is FIFO.
%    X4M300.read_message_baseband_iq                           -  Get one buffered baseband IQ data message. Order is FIFO.
%    X4M300.read_message_presence_movinglist                   -  Get one buffered presence movinglist message. Order is FIFO.
%    X4M300.read_message_presence_single                       -  Get one buffered presence_single data message. Order is FIFO.
%    X4M300.reset_to_factory_preset                            -  Resets the module to factory preset settings.
%    X4M300.set_debug_level                                    -  Set the debug level of the profile.
%    X4M300.set_detection_zone                                 -  Set the desired detection zone.
%    X4M300.set_led_control                                    -  Configures the module LED mode.
%    X4M300.set_output_control                                 -  Control module profile output.
%    X4M300.set_sensitivity                                    -  Set module sensitivity.
%    X4M300.set_sensor_mode                                    -  Control the sensor module mode of execution.
%
% X2
%    X2.X2                                                     -  returns an interface object for low level  functionality
%    X2.capture_single_normalized_frame                        -  Start a single sweep and capture the radar data.
%    X2.clear                                                  -  Clears the in-buffer of the named subscription.
%    X2.delete                                                 -  Destructor
%    X2.get_number_of_packets                                  -  Returns the number of packets buffered
%    X2.get_raw_normalized_frame                               -  Start a subscription on raw normalized radar data.
%    X2.get_system_info                                        -  Request system info from the module.
%    X2.get_x2_float                                           -  Calls Radarlib method NVA_X2_GetFloatVariable().
%    X2.get_x2_int                                             -  Calls Radarlib method NVA_X2_GetIntVariable().
%    X2.get_x2_register                                        -  Calls Radarlib method NVA_X2_ReadRegisterFieldId().
%    X2.git_sha                                                -
%    X2.ping                                                   -  Send a ping message to the module. Responds with a pong value to indicate
%    X2.run_timing_measurement                                 -  Starts a timing measurement on module.
%    X2.set_debug_level                                        -  Set debug level.
%    X2.set_fps                                                -  Select module sweep control frequency. When in a running mode, the
%    X2.set_sensor_mode                                        -  Control the sensor module mode of execution.
%    X2.set_sensor_mode_idle                                   -  Pause application execurion. Equal to set_sensor_mode('XTS_SM_IDLE')
%    X2.set_sensor_mode_manual                                 -  Disable application execution. Equal to set_sensor_mode('XTS_SM_MANUAL');
%    X2.set_x2_float                                           -  Calls Radarlib method NVA_X2_SetFloatVariable().
%    X2.set_x2_int                                             -  Calls Radarlib method NVA_X2_SetIntVariable().
%    X2.set_x2_register                                        -  Calls Radarlib method NVA_X2_WriteRegisterFieldId().
%    X2.subscribe_to_raw_normalized                            -  Start a subscription on raw normalized radar data.
%    X2.unsubscribe                                            -  Unsubsribe from a previously enabled data subscription.
%
% DataRecorder
%    DataRecorder.DataRecorder                                 -  Constructor
%    DataRecorder.clear_basename_for_data_types                -  Resets the basename(s) to default value(s) for the specified data type(s).
%    DataRecorder.delete                                       -  Destructor
%    DataRecorder.get_basename_for_data_type                   -  Gets the basename for the specified data type.
%    DataRecorder.get_session_id                               -  By default, this function returns an universally unique identifier (UUID) if no custom id is set.
%    DataRecorder.process                                      -  Process the specified data for a given data type.
%    DataRecorder.set_basename_for_data_type                   -  Sets the basename for the specified data type.
%    DataRecorder.set_data_rate_limit                          -  Sets the data rate (ms) the recorder will read data from the module.
%    DataRecorder.set_directory_split_byte_count               -  Sets the preferred directory split size specified as number of bytes.
%    DataRecorder.set_directory_split_duration                 -  Sets the preferred directory split size specified in seconds.
%    DataRecorder.set_directory_split_fixed_daily_hour         -  Sets the preferred directory split size to a fixed daily hour.
%    DataRecorder.set_file_split_byte_count                    -  Sets the preferred file split size specified as number of bytes.
%    DataRecorder.set_file_split_duration                      -  Sets the preferred file split size specified in seconds.
%    DataRecorder.set_file_split_fixed_daily_hour              -  Sets the preferred file split size to a fixed daily hour.
%    DataRecorder.set_session_id                               -  Sets the session id as specified.
%    DataRecorder.set_user_header                              -  Sets a custom header applied to the beginning of the recorded file.
%    DataRecorder.start_recording                              -  Starts recording the specified data type(s).
%    DataRecorder.stop_recording                               -  Stops recording the specified data type(s).
%
% XEP
%    XEP.XEP                                                   -  Constructor
%    XEP.delete                                                -  Destructor
%    XEP.get_iopin_value                                       -  Returns value of io pin specified by pinId
%    XEP.get_system_info                                       -  Returns a string containing system information given an infocode
%    XEP.module_reset                                          -  Resets and restart the module.
%    XEP.peek_message_data_float                               -  Returns queue size of data float messages
%    XEP.peek_message_data_string                              -  Returns queue size of data string messages
%    XEP.ping                                                  -  Send a ping message to the module. Responds with a pong value to indicate
%    XEP.read_message_data_float                               -  Reads one data float message
%    XEP.read_message_data_string                              -  Reads one data string message
%    XEP.set_iopin_control                                     -  Enable or disable GPIO feature.
%    XEP.set_iopin_value                                       -  If IO pin control is used to set pin_id as output, the pin level or value will be set to pin_value.
%    XEP.x4driver_get_fps                                      -  Gets configured fps.
%    XEP.x4driver_get_frame_area                               -  Get frame area zone.
%    XEP.x4driver_get_frame_area_offset                        -  Get frame area offset
%    XEP.x4driver_get_pif_register                             -  Gets PIF register value.
%    XEP.x4driver_get_prf_div                                  -  Gets Pulse Repetition Frequency(PRF) divider
%    XEP.x4driver_get_spi_register                             -  Get spi register on radar chip.
%    XEP.x4driver_get_xif_register                             -  Gets XIF register value.
%    XEP.x4driver_init                                         -  Will make sure that enable is set, 8051 SRAM is programmed, ldos are enabled, and that the external oscillator
%    XEP.x4driver_set_dac_max                                  -  Sets dac max.
%    XEP.x4driver_set_dac_min                                  -  Sets dac min.
%    XEP.x4driver_set_dac_step                                 -  Sets X4 dac step.
%    XEP.x4driver_set_downconversion                           -  Sets downconversion.
%    XEP.x4driver_set_enable                                   -  Set enable for X4 enable pin.
%    XEP.x4driver_set_fps                                      -  Sets frame rate for frame streaming.
%    XEP.x4driver_set_frame_area                               -  Set frame area zone assuming air as transmitter medium. Start and end in meter.
%    XEP.x4driver_set_frame_area_offset                        -  Offset to adjust frame area reference depending on module product.
%    XEP.x4driver_set_iterations                               -  Sets Iterations.
%    XEP.x4driver_set_pif_register                             -  Sets PIF register value.
%    XEP.x4driver_set_prf_div                                  -  Sets Pulse Repetition Frequency(PRF) divider
%    XEP.x4driver_set_pulsesperstep                            -  Sets pulses per step.
%    XEP.x4driver_set_spi_register                             -  Set spi register on radar chip.
%    XEP.x4driver_set_tx_center_frequency                      -  Sets the frequency band used by the radar.
%    XEP.x4driver_set_tx_power                                 -  Set the radar transmitter power.
%    XEP.x4driver_set_xif_register                             -  Sets XIF register value.