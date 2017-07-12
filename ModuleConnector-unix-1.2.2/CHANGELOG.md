## Changelog {#changelog}

1.2.2 (2017.06.23)

	Added set_noisemap_control to X4M300 and X4M200 interfaces
	Added set_parameter_file to X4M300 and X4M200 interfaces
	Added get_profileid to X4M300 and X4M200 interfaces
	Added support for X4M200 interface
	Added support for storing the sensor's parameter file to disk when recording
	Added support for storing the sensor's profile id in recording meta header
	Fixed library issues on Raspberry Pi
	Fixed bug in DataPlayer preventing backwards seek_ms from working correctly
	Fixed bug in DataPlayer causing problems with pulse doppler float packets

1.1.8 (2017.05.23)

	Added support for playback of recorded data via DataPlayer interface
	DataRecorder stores parameter file from module (currently no support in FW)
	DataReader improved performance
	DataReader fixed bug related to filtering of data
	Added function to disable baseband output from X2M200
	Improved performance when accessing const Byte references from Python
	Added module file system API to XEP interface.
	Added set_baudrate() to X4M300 interface.
	Added reset_to_factory_preset() to X4M300 interface.
	Renamed methods from peak_*  to peek_*

1.1.5 (2017.03.08)

	Add support for X4M300 and XEP interfaces.

1.0.0 (2017.02.01)

	This is the initial release of ModuleConnector which support communication with X2M200 and data recording.

