#ifndef X4M300_INTERFACE_H
#define X4M300_INTERFACE_H

#include "NotSupportedData.hpp"
#include "Data.hpp"
#include "Bytes.hpp"

#include <cinttypes>
#include <string>
#include <vector>
#include <memory>

struct RadarInterface;

namespace XeThru {

class X4M300Private;

/**
 * @class X4M300
 *
 * TODO
 *
 */
class X4M300
{
public:
    /**
     * Constructor
     *
     * @param[in] internale object used to interface the radar
     */
    X4M300(RadarInterface &radar_interface);

    /**
     * Destructor
     *
     */
    ~X4M300();


    /**
     * Sets debug level in the Xethru module.
     *
     * @param[in]  level New debug level. Valid range [0-9].
     * @return status : success in case of 0 / failure in any other case
     */
    int set_debug_level(unsigned char level);

    /**
     * Make sure there is a connection to FW on the Xethru X4M300  module
     *
     * @return status : success in case of 0 / failure in any other case
     */
    int ping(uint32_t *pong_value);

    /**
     * Returns a string containing system information given by infocode:<br>
     *  XTID_SSIC_ITEMNUMBER = 0x00 -> Returns the product Item Number, including revision.\  This is programmed in Flash during manufacturing<br>
     *  XTID_SSIC_ORDERCODE = 0x01 -> Returns the product order code<br>
     *  XTID_SSIC_FIRMWAREID = 0x02 -> Returns the installed Firmware ID.\  As viewed from the "highest" level of the software, "X4M300"<br>
     *  XTID_SSIC_VERSION = 0x03 -> Returns the installed Firmware Version.\  As viewed from the "highest" level of the software<br>
     *  XTID_SSIC_BUILD = 0x04 -> Returns information of the SW Build installed on the device<br>
     *  XTID_SSIC_SERIALNUMBER = 0x06 -> Returns the product serial number<br>
     *  XTID_SSIC_VERSIONLIST = 0x07 ->Returns ID and version of all components.\ Calls all components and compound a string E.g.\  "X4M300:1.0.0.3;XEP:2.3.4.5;X4C51:1.0.0.0;DSP:1.1.1.1"
     * @return status : success in case of 0 / failure in any other case
     */
    int get_system_info(const uint8_t info_code, std::string *system_info);

    /**
     * Resets and restart the module.
     * This is a convenience method that calls module_reset(), disconnects the communication port, and then reestablishes connection with the module.
     *
     * @return status : success in case of 0 / failure in any other case
     */
    int reset();

    /**
     * Resets the module.
     * The client must perform a close and then an open on the ModuleConnector to reeastablish connection.
     *
     * @return status : success in case of 0 / failure in any other case
     */
    int module_reset();

    /**
     * Enters the bootloader for FW upgrades
     *
     * @return status : success in case of 0 / failure in any other case
     */
    int start_bootloader();

    /**
     * Runs the different manufacturing tests identified by testcode. Can return any number of results depending on test_mode. Host must know how to parse test results.
     *
     * @param[in] testcode:
     * @param[out] data:
     * @return status : success in case of 0 / failure in any other case
     */
    int system_run_test(const uint8_t testcode, Bytes * data);

    /**
     * Loads the profile given by profileid. If another profile is already loaded, the other profile is unloaded before the new profile is loaded.
     * The profile does not start, the module remains idle. <br>
     * profileid = 0x014d4ab8 : presence profile
     *
     * @param[in] profileid: the id of the profile to load
     * @return status : success in case of 0 / failure in any other case
     */
    int load_profile(const uint32_t profileid);

    /**
     * Control the execution mode of the sensor.
     *
     * @param[in] mode: see xtid.h for profileid values.<br>
     * Run - Start profile execution<br>
     * Idle - Halts profile execution. Can be resumed by setting mode to Run.<br>
     * Stop - Stops profile execution. Must do load_profile to continue.<br>
     * Manual - Routes X4 radar data directly to host rather than to profile execution. Can then interact directly with XEP / X4Driver. Will disrupt profile performance.<br>
     * @param[in] param: Not used, ignored, can be 0.
     * @return status : success in case of 0 / failure in any other case
     */
    int set_sensor_mode(const uint8_t mode, const uint8_t param);

    /**
     * Sets the overall sensitivity
     *
     * @param[in] sensitivity : 0 to 9, 0 = low, 9 = high
     * @return status : success in case of 0 / failure in any other case
     */
    int set_sensitivity(const uint32_t sensitivity);

    /**
     * Sets the current detection zone. Rules: See X4M300 datasheet.
     * The actual detection zone is determined by profile configuration. Use the get_detection_zone command to get the actual values
     *
     * @param[in] start: start of detection zone in meters
     * @param[in] end: end of detection zone in meters
     * @return status : success in case of 0 / failure in any other case
     */
    int set_detection_zone(const float start, const float end);
    /**
     * Returns the actual detection zone.
     *
     * @param[out] start: start of detection zone in meters
     * @param[out] end: end of detection zone in meters
     * @return status : success in case of 0 / failure in any other case
     */
    int get_detection_zone(float * start, float * end);

    /**
     * Returns the potential settings of detection zone from the module.
     *
     * @param[out] min: smallest value for detection zone start
     * @param[out] max: largest value for detection zone end
     * @param[out] step: detection zone start and end step size
     * @return status : success in case of 0 / failure in any other case
     */
    int get_detection_zone_limits(float * min, float * max, float * step);

    /**
     * This command configures the LED mode.<br>
     *
     * @param[in] mode:
     * mode = 0 : OFF
     * mode = 1 : simple
     * mode = 2 : full (default)
     * @param[in] intensity: 0 to 100, 0=low, 100=high, not implemented yet
     * @return status : success in case of 0 / failure in any other case
     */
    int set_led_control(const uint8_t mode, uint8_t intensity);

    /**
     * Control module profile output. Enable and disable data messages. Several calls can be made, one for each available output message the profile provides.
     * @param[in] output_feature: see values in xtid.h.<br>
     * Possible features are:<br>
     * PresenceSingle<br>
     * PresenceMovingList<br>
     * BasebandIQ<br>
     * BasebandAP<br>
     * @param[in] output_control: see values in xtid.h<br>
     * Typical values:
     * 0 = disable<br>
     * 1 = enable<br>
     *
     * @return status : success in case of 0 / failure in any other case
     */
    int set_output_control(const uint32_t output_feature, const uint32_t output_control);

    /**
     * Return number of PresenceSingleData messages available in queue.
     *
     * @return: size: number of messages in queue
     */
    int peek_message_presence_single();
    /**
     * Read a single PresenceSingleData item from the queue. Blocks if queue is empty.
     *
     * @param[in] presence_single: pointer to returned PresenceSingleData item
     * @return status : success in case of 0 / failure in any other case
     */
    int read_message_presence_single(PresenceSingleData * presence_single);

    /**
     * Return number of PresenceMovingListData messages available in queue.
     *
     * @return size: number of messages in buffer
     */
    int peek_message_presence_movinglist();

    /**
     * Read a single PresenceMovingListData item from the queue. Blocks if queue is empty.
     *
     * @param[in] presence_moving_list: pointer to returned PresenceMovingListData item

     * @return status : success in case of 0 / failure in any other case
     */
    int read_message_presence_movinglist(
        PresenceMovingListData * presence_moving_list);

    /**
     * Return number of BasebandApData messages available in queue.
     *
     * @return size: number og messages in buffer
     */
    int peek_message_baseband_ap();

    /**
     * Read a single BasebandApData item from the queue. Blocks if queue is empty.
     *
     * @param[out] baseband_ap: pointer to returned BasebandApData item
     * @return status : success in case of 0 / failure in any other case
     */
    int read_message_baseband_ap(BasebandApData * baseband_ap);

    /**
     * Return number of BasebandIqData messages available in queue.
     *
     * @return size: number og messages in buffer
     */
    int peek_message_baseband_iq();

    /**
     * Read a single BasebandIqData item from the queue. Blocks if queue is empty.
     *
     * @param[out] baseband_iq: pointer to returned BasebandIqData item
     * @return status : success in case of 0 / failure in any other case
     */
    int read_message_baseband_iq(BasebandIqData * baseband_iq);

private:
    std::unique_ptr<X4M300Private> d_ptr;
};

} // namespace Novelda

#endif // X4M300_INTERFACE_H
