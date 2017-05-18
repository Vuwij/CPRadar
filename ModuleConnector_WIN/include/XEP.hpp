#ifndef XEP_INTERFACE_H
#define XEP_INTERFACE_H

#include "RecordingOptions.hpp"

#include <cinttypes>
#include <string>
#include <vector>
#include <memory>

struct RadarInterface;

namespace XeThru {

struct FrameArea;
struct DataFloat;
class XEPPrivate;

/**
 * @class XEP
 *
 * XEP class gives access to XEP functionality on target via module connector.
 *
 */
class XEP
{
public:
    /**
    * @brief XEP constructor.
    *
    * @return instance
    */
    XEP(RadarInterface &radar_interface);

   /**
    * @brief XEP destructor
    *
    * @return destroys instance.
    */
    ~XEP();

    /**
    * @brief Resets module
    *
    * @return execution status.
    */
    int module_reset();

    /**
    * @brief Returns a string containing system information given by infocode:
    XTS_SSIC_FIRMWAREID = 0x02 -> Returns the installed Firmware ID, "XEP"
    XTS_SSIC_VERSION = 0x03 -> Returns the installed Firmware Version.
    XTS_SSIC_BUILD = 0x04 -> Returns information of the SW Build installed on the device
    XTS_SSIC_VERSIONLIST = 0x07 ->
    Returns ID and version of all components. Calls all components and compound a string.
    E.g. "XEP:2.3.4.5;X4C51:1.0.0.0"
    *
    * @return execution status
    */
    int get_system_info(uint8_t info_code, std::string *system_info);

    /**
    * @brief Send ping to module in order to validate that connection both ways is OK
    *
    * @return execution status
    */
    int ping(uint32_t *pong_value);

    /**
    * @brief Sets frame rate for frame streaming.
    *
    * @return execution status
    */
    int x4driver_set_fps(float fps);

    /**
    * @brief Gets configured FPS.
    *
    * @return execution status
    */
    int x4driver_get_fps(float * fps);

    /**
    * @brief Set enable for X4 enable pin.
    *
    * @return execution status
    */
    int x4driver_set_enable(uint8_t value);

    /**
    * @brief Will make sure that enable is set, X4 controller is programmed, ldos are enabled, and that the external oscillator has been enabled.
    *
    * @return execution status
    */
    int x4driver_init();

    /**
    * @brief Sets Iterations. See X4 datasheet for details.
    *
    * @return execution status
    */
    int x4driver_set_iterations(uint32_t iterations);
//    int x4driver_get_iterations(uint32_t *iterations);

    /**
    * @brief Sets pulses per step. See X4 datasheet for details.
    *
    * @return execution status
    */
    int x4driver_set_pulses_per_step(uint32_t pps);
//    int x4driver_get_pulses_per_step(uint32_t *pps);

    /**
    * @brief Sets X4 dac step. See X4 datasheet for details.
    *
    * @return execution status
    */
    int x4driver_set_dac_step(uint8_t dac_step);
//    int x4driver_get_dac_step(uint8_t *dac_step);

    /**
    * @brief Sets dac min. See X4 datasheet for details.
    *
    * @return execution status
    */
    int x4driver_set_dac_min(uint32_t dac_min);
//    int x4driver_get_dac_min(uint32_t *dac_min);

    /**
    * @brief Sets dac max. See X4 datasheet for details.
    *
    * @return execution status
    */
    int x4driver_set_dac_max(uint32_t dac_max);
//    int x4driver_get_dac_max(uint32_t *dac_max);

    /**
    * @brief Set the radar transmitter power. 0 = transmitter off. See X4 datasheet for details.
    *
    * @return execution status
    */
    int x4driver_set_tx_power(uint8_t tx_power);
//    int x4driver_get_tx_power(uint8_t *tx_power);

    /**
    * @brief Sets downconversion. 0=no downconversion, i.e. rf data. 1=downconversion.
    *
    * @return execution status
    */
    int x4driver_set_downconversion(uint8_t enable);
//    int x4driver_get_downconversion(uint8_t *enable);
//    int x4driver_get_frame_bin_count(uint32_t *bins);

    /**
    * @brief Set frame area, i.e. the range in distance where the radar is observing. Assume air as transmitter medium. Start and end in meter.
    *
    * @return execution status
    */
    int x4driver_set_frame_area(float start, float end);

    /**
    * @brief Get frame area
    *
    * @return execution status
    */
    int x4driver_get_frame_area(FrameArea * frame_area);

    /**
    * @brief Set offset to adjust frame area reference point (location of frame area start at zero) depending on sensor hardware.
    *
    * @return execution status
    */
    int x4driver_set_frame_area_offset(float offset);

    /**
    * @brief Get offset to adjust frame area reference.
    *
    * @return execution status
    */
    int x4driver_get_frame_area_offset(float * offset);

    /**
    * @brief Set radar TX center frequency
    *
    * @return execution status
    */
    int x4driver_set_tx_center_frequency(uint8_t tx_frequency);
//    int x4driver_get_tx_center_frequency(uint8_t *tx_frequency);

    /**
    * @brief Set spi register on radar chip. See X4 datasheet for details.
    *
    * @return execution status
    */
    int x4driver_set_spi_register(uint8_t address, uint8_t value);

    /**
    * @brief Get spi register on radar chip. See X4 datasheet for details.
    *
    * @return execution status
    */
    int x4driver_get_spi_register(uint8_t address, uint8_t *value);

    /**
    * @brief Sets PIF register value. See X4 datasheet for details.
    *
    * @return execution status
    */
    int x4driver_set_pif_register(uint8_t address, uint8_t value);

    /**
    * @brief Gets PIF register value. See X4 datasheet for details.
    *
    * @return  execution status
    */
    int x4driver_get_pif_register(uint8_t address, uint8_t *value);

    /**
    * @brief Sets XIF register value. See X4 datasheet for details.
    *
    * @return execution status
    */
    int x4driver_set_xif_register(uint8_t address, uint8_t value);

    /**
    * @brief Gets XIF register value. See X4 datasheet for details.
    *
    * @return execution status
    */
    int x4driver_get_xif_register(uint8_t address, uint8_t *value);

    /**
    * @brief Sets Pulse Repetition Frequency(PRF) divider. See X4 datasheet for details.
    *
    * @return execution status
    */
    int x4driver_set_prf_div(uint8_t prf_div);

    /**
    * @brief Gets Pulse Repetition Frequency(PRF) divider. See X4 datasheet for details.
    *
    * @return execution status
    */
    int x4driver_get_prf_div(uint8_t *prf_div);

    /**
    * @brief Enable or disable GPIO feature.
    * pin_id : which io pin to configure
    *
    * pin_setup : control pin setup
    * 0 = input
    * 1 = output
    *
    * pin_feature : control pin feature
    * 0 = Disable all iopin features ( not implemented, will return error)
    * 1 = Configure according to datasheet default( not implemented, will return error)
    * 2 = Passive - Set and get iopin level from host
    *
    * @return execution status
    */
    int set_iopin_control(uint32_t pin_id, uint32_t pin_setup, uint32_t pin_feature);

    /**
    * @brief If IO pin control is used to set pin_id as output, the pin level or value will be set to pin_value.
    *
    * @return execution status
    */
    int set_iopin_value(uint32_t pin_id, uint32_t pin_value);

    /**
    * @brief Read IO pin level or value.
    *
    * @return execution status
    */
    int get_iopin_value(uint32_t pin_id, uint32_t *pin_value);

    /**
    * @brief Returns number of data float packets in internal queue.
    *
    * @return Returns number of data float packets in internal queue
    */
    int peek_message_data_float();

    /**
    * @brief Reads a single data float message from internal queue.
    *
    * @return execution status
    */
    int read_message_data_float(XeThru::DataFloat * data_float);

    /**
    * @brief Returns number of data string packets in internal queue.
    *
    * @return  Returns number of data string packets in internal queue.
    */
    int peek_message_data_string();

    /**
    * @brief Reads a single data string message from internal queue.
    *
    * @return execution status
    */
    int read_message_data_string(uint32_t *content_id, uint32_t *info, std::string *data);

   /**
    * @brief Returns number of system packets in internal queue.
    *
    * @return void
    */
   int peek_message_system();

    /**
    * @brief Reads a single data system message from internal queue.
    *
    * @return execution status
    */
   int read_message_system(uint32_t *responsecode);

private:
    std::unique_ptr<XEPPrivate> d_ptr;
};

} // namespace Novelda

#endif // XEP_INTERFACE_H
