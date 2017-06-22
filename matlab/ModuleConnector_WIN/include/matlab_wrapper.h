#ifndef LIBFILE1_HPP
#define LIBFILE1_HPP

#include <stdint.h>
#include "matlab_recording_api.h"
#include "datatypes.h"

#ifdef __cplusplus
extern "C" {
#endif

struct RadarInterface;

const unsigned int ERROR = 1;
const unsigned int OK = 0;

typedef struct ModuleConnector_Type
{
    struct RadarInterface * radar_interface;
} ModuleConnector;

typedef struct X2M200_Type
{
    struct RadarInterface * radar_interface;
} X2M200;

typedef struct X2_Type
{
    struct RadarInterface * radar_interface;
} X2;

typedef struct XEP_Type
{
    struct RadarInterface *radar_interface;
    void *nva_xep_instance;
} XEP;


/*********************************************************************************
 * ModuleConnector
 *********************************************************************************/
ModuleConnector * nva_create_module_connector(
    const char * device_name,
    unsigned int level);

void nva_destroy_module_connector(
    ModuleConnector * mc);

// DataRecorder
DataRecorder * nva_get_data_recorder(ModuleConnector *mc);

// X2
X2 * nva_get_x2(ModuleConnector * mc);
void nva_destroy_X2_interface(X2 * x2);

// XEP
XEP * nva_get_xep(ModuleConnector *mc);
void nva_destroy_XEP_interface(XEP *xep);


void nva_set_log_level(ModuleConnector * mc, int log_level);
const char * nva_git_sha();


//*********************************************************************************
//*  X2M200
//*********************************************************************************
int nva_get_item_number(X2 * instance, char * result, unsigned int max_length);
int nva_get_order_code(X2 * instance, char * result, unsigned int max_length);
int nva_get_firmware_id(X2 * instance, char * result, unsigned int max_length);
int nva_get_firmware_version(X2 * instance, char * result, unsigned int max_length);
int nva_get_serial_number(X2 * instance, char * result, unsigned int max_length);
int nva_get_build_info(X2 * instance, char * result, unsigned int max_length);
int nva_get_app_id_list(X2 * instance, char * result, unsigned int max_length);
int nva_reset(X2 * instance);
int nva_enter_bootloader(X2 * instance);
int nva_set_sensor_mode_run(X2 * instance);
int nva_set_sensor_mode_idle(X2 * instance);
int nva_load_sleep_profile(X2 * instance);
int nva_load_respiration_profile(X2 * instance);
int nva_enable_baseband(X2 * instance, int );
int nva_enable_baseband_ap(X2 * instance);
int nva_enable_baseband_iq(X2 * instance);
int nva_set_detection_zone(X2 * instance, float start, float end);
int nva_set_sensitivity(X2 * instance, uint32_t new_sensitivity);
int nva_set_led_control(X2 * instance, uint8_t mode, uint8_t intensity);
int nva_subscribe_to_resp_status(X2 * instance, const char * name);
int nva_subscribe_to_sleep_status(X2 * instance, const char * name);
int nva_subscribe_to_baseband_ap(X2 * instance, const char * name);
int nva_subscribe_to_baseband_iq(X2 * instance, const char * name);

int nva_disable_resp_output(X2 * instance);
int nva_enable_resp_output(X2 * instance);
int nva_get_respiration_data(
    X2 * instance,
    const char * name,
    uint32_t * frame_counter,
    uint32_t * sensor_state,
    uint32_t * respiration_rate,
    float * distance,
    float * movement,
    uint32_t * signal_quality);
int nva_get_sleep_data(
    X2 * instance,
    const char * name,
    uint32_t * frame_counter,
    uint32_t * sensor_state,
    float * respiration_rate,
    float * distance,
    uint32_t * signal_quality,
    float * movement_slow,
    float * movement_fast);


int nva_get_baseband_iq_data(
    X2 * instance,
    const char * name,
    uint32_t * frame_counter,
    uint32_t * num_bins,
    float * bin_length,
    float * sample_frequency,
    float * carrier_frequency,
    float * range_offset,
    float * i_data,
    float * q_data,
    uint32_t max_length);
int nva_get_baseband_ap_data(
    X2 * instance,
    const char * name,
    uint32_t * frame_counter,
    uint32_t * num_bins,
    float * bin_length,
    float * sample_frequency,
    float * carrier_frequency,
    float * range_offset,
    float * amplitude,
    float * phase,
    uint32_t max_length);






//*********************************************************************************
//*  X2
//*********************************************************************************
int nva_set_debug_level(X2 * instance, unsigned char level);
int nva_ping(X2 * instance, unsigned int * pong);
int nva_get_system_info(
    X2 * instance,
    uint8_t info_code,
    char * result,
    unsigned int max_length);
int nva_set_X2_float(X2 * instance, uint32_t id, float value);
int nva_get_x2_float(X2 * instance, uint32_t id, float * result);
int nva_set_X2_int(X2 * instance, uint32_t id, uint32_t value);
int nva_get_x2_int(X2 * instance, uint32_t id, uint32_t * result);
int nva_set_X2_register(X2 * instance, uint32_t register_id, uint32_t value);
int nva_get_x2_register(
    X2 * instance,
    uint32_t register_id,
    uint32_t * value);
int nva_run_timing_measurement(X2 * instance);
int nva_set_fps(X2 * instance, unsigned int fps);
int nva_capture_single_normalized_frame(
    X2 * instance,
    uint32_t * frame_counter,
    float * frame_data,
    unsigned int * length,
    unsigned int max_length);
int nva_set_sensor_mode(X2 * instance, unsigned char mode);
int nva_set_sensor_mode_and_submode(
    X2 * instance,
    unsigned char mode,
    unsigned char submode);
int nva_subscribe_to_raw_normalized(X2 * instance, const char * name);
int nva_unsubscribe(X2 * instance, const char * name);
int nva_get_raw_normalized_frame(
    X2 * instance,
    const char * name,
    uint32_t * frame_counter,
    float * frame_data,
    uint32_t * length,
    unsigned int max_length);
int nva_get_number_of_packets(
    X2 * instance,
    const char * name,
    uint32_t * result);
int nva_clear(X2 * instance, const char * name);


// should maybe be removed
void nva_wait(unsigned int seconds);
void nva_log(X2 * instance, const char * string);
int nva_set_sensor_mode_manual(X2 * instance);


//*********************************************************************************
//*  Transport
//*********************************************************************************
int nva_send_command(
    X2 * instance,
    const unsigned char * command,
    unsigned int length);

//Bytes send_command_single(const Bytes & command, const Bytes & comparator);
int nva_send_command_single(
    X2 * instance,
    const unsigned char * command,
    unsigned int length,
    const unsigned char * comparator,
    unsigned int comp_length,
    unsigned char * response,
    unsigned int max_length);

/* virtual Bytes send_command_multi( */
/*     const Bytes & command, */
/*     const std::vector<Bytes> & comparator) = 0; */

int nva_subscribe(
    X2 * instance,
    const char * name,
    const unsigned char * comparator,
    unsigned int comp_length);

int nva_get_packet(
    X2 * instance,
    const char * name,
    unsigned char * packet,
    unsigned int max_length);



/*********************************************************************************/
/*  NotSupported API */
/*********************************************************************************/
int nva_get_x4_io_pin_value(
    X2 * instance,
    unsigned char pin,
    unsigned char * result );

int nva_set_x4_io_pin_value(
    X2 * instance,
    unsigned char pin,
    unsigned char value);

int nva_set_x4_io_pin_mode(
    X2 * instance,
    const unsigned char pin,
    const unsigned char mode);

int nva_set_x4_io_pin_dir(
    X2 * instance,
    const unsigned char pin,
    const unsigned char direction);

int nva_set_x4_io_pin_enable(
    X2 * instance,
    const unsigned char pin);

int nva_set_x4_io_pin_disable(
    X2 * instance,
    const unsigned char pin);

int nva_read_x4_spi(
    X2 * instance,
    const unsigned char address,
    unsigned char * result);

int nva_write_x4_spi(
    X2 * instance,
    unsigned char address,
    const unsigned char value);

int nva_set_x4_fps(
    X2 * instance,
    const uint32_t fps);

int nva_subscribe_to_x4_decim(
    X2 * instance,
    const char * name);

int nva_get_x4_decim_frame(
    X2 * instance,
    const char * name,
    uint32_t * frame_counter,
    double * frame_data,
    unsigned int max_length);

int nva_subscribe_to_data_float(
    X2 * instance,
    const char * name);

int nva_peek_message_data_float(X2 * instance);

int nva_read_message_data_float(
    X2 * instance,
    uint32_t * content_id,
    uint32_t * info,
    float * frame_data,
    uint32_t * length,
    unsigned int max_length);

int nva_set_profile_parameter_file(
    X2 * instance,
    const char * filename,
    const char * data);

int nva_get_profile_parameter_file(
    X2 * instance,
    const char * filename);

int nva_load_profile(
    X2 * instance,
    const uint32_t profile_id);

int nva_get_trace(X2 * instance, const char * name, char * trace, unsigned int max_length);
int nva_subscribe_to_trace(X2 * instance, const char * name);
int nva_subscribe_to_data_byte(X2 * instance, const char * name);

//*********************************************************************************
//*  X4M300
//*********************************************************************************
int nva_get_detection_zone(X2 * instance, float * start, float * end);
int nva_get_detection_zone_limits(X2 * instance, float * start, float * end, float * step);

//int nva_subscribe_to_presence_single(X2 * instance);
int nva_peek_message_presence_single(X2 * instance);
int nva_read_message_presence_single(
    X2 * instance,
    uint32_t * frame_counter,
    uint32_t * presence_state,
    float * distance,
    uint8_t * direction,
    uint32_t * signal_quality);

//int nva_subscribe_to_presence_movinglist(X2 * instance);
int nva_peek_message_presence_movinglist(X2 * instance);
int nva_read_message_presence_movinglist(
    X2 * instance,
    uint32_t * frame_counter,
    uint32_t * state,
    uint32_t * interval_count,
    uint32_t * detection_count,
    float * movement_slow,
    float * movement_fast,
    float * distance,
    float * radar_cross_section,
    float * velocity,
    uint32_t max_length);






//*********************************************************************************
//*  XEP
//*********************************************************************************
int xep_x4driver_set_fps(XEP * instance, const float fps);
int xep_x4driver_set_iterations(XEP * instance, const uint32_t iterations);
int xep_x4driver_set_pulsesperstep(XEP * instance, const uint32_t pulsesperstep);
int xep_x4driver_set_downconversion(XEP * instance, const uint8_t downconversion);
int xep_x4driver_set_frame_area(XEP * instance, const float start, const float end);
int xep_x4driver_init(XEP * instance);
int xep_x4driver_set_dac_step(XEP * instance, const uint8_t dac_step);
int xep_x4driver_set_dac_min(XEP * instance, const uint32_t dac_min);
int xep_x4driver_set_dac_max(XEP * instance, const uint32_t dac_max);
int xep_x4driver_set_frame_area_offset(XEP * instance, const float offset);
int xep_x4driver_set_enable(XEP * instance, const uint8_t enable);
int xep_x4driver_set_tx_center_frequency(XEP * instance, const uint8_t tx_center_frequency);
int xep_x4driver_set_tx_power(XEP * instance, const uint8_t tx_power);
int xep_x4driver_get_fps(XEP * instance, float * fps);
int xep_x4driver_set_spi_register(XEP * instance, const uint8_t address, const uint8_t value);
int xep_x4driver_get_spi_register(XEP * instance, const uint8_t address, uint8_t * value);
int xep_x4driver_set_pif_register(XEP * instance, const uint8_t address, const uint8_t value);
int xep_x4driver_get_pif_register(XEP * instance, const uint8_t address, uint8_t * value);
int xep_x4driver_set_xif_register(XEP * instance, const uint8_t address, const uint8_t value);
int xep_x4driver_get_xif_register(XEP * instance, const uint8_t address, uint8_t * value);
int xep_x4driver_set_prf_div(XEP * instance, const uint8_t prf_div);
int xep_x4driver_get_prf_div(XEP * instance, uint8_t * prf_div);
int xep_x4driver_get_frame_area(XEP * instance, float * start, float * end);
int xep_x4driver_get_frame_area_offset(XEP * instance, float * offset);
int xep_set_iopin_control(XEP * instance, const uint32_t pin_id, const uint32_t pin_setup, const uint32_t pin_feature);
int xep_set_iopin_value(XEP * instance, const uint32_t pin_id, const uint32_t pin_value);
int xep_get_iopin_value(XEP * instance, const uint32_t pin_id, uint32_t * pin_value);
int xep_peek_message_data_string(XEP *instance);
int xep_read_message_data_string(XEP *instance, uint32_t *content_id, uint32_t *info,
                                 char *data, uint32_t *length, uint32_t max_length);

int nva_peek_message_baseband_iq(X2 * instance);
int nva_peek_message_baseband_ap(X2 * instance);
int nva_read_message_baseband_iq(
    X2 * instance,
    uint32_t * frame_counter,
    uint32_t * num_bins,
    float * bin_length,
    float * sample_frequency,
    float * carrier_frequency,
    float * range_offset,
    float * i_data,
    float * q_data,
    uint32_t max_length);

int nva_read_message_baseband_ap(
    X2 * instance,
    uint32_t * frame_counter,
    uint32_t * num_bins,
    float * bin_length,
    float * sample_frequency,
    float * carrier_frequency,
    float * range_offset,
    float * amplitude,
    float * phase,
    uint32_t max_length);

int nva_set_output_control(
    X2 * instance,
    const uint32_t output_feature,
    const uint32_t output_control);


#ifdef __cplusplus
}
#endif


#endif
