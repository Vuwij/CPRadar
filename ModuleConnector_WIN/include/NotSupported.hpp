#ifndef NOTSUPPORTEDINTERFACE_HPP
#define NOTSUPPORTEDINTERFACE_HPP



namespace XeThru {

struct DataFloat;

class NotSupported
{
public:
    virtual ~NotSupported() {}
    virtual Byte get_x4_io_pin_value(unsigned char pin) = 0;
    virtual int set_x4_io_pin_value(unsigned char pin, unsigned char value) = 0;
    virtual int set_x4_io_pin_mode(
        const unsigned char pin,
        const unsigned char mode) = 0;
    virtual int set_x4_io_pin_dir(
        const unsigned char pin,
        const unsigned char direction) = 0;
    virtual int set_x4_io_pin_enable(const unsigned char pin) = 0;
    virtual int set_x4_io_pin_disable(const unsigned char pin) = 0;
    virtual unsigned char read_x4_spi(const unsigned char address) = 0;
    virtual int write_x4_spi(
        unsigned char address,
        const unsigned char value) = 0;
    virtual int set_x4_fps(const uint32_t fps) = 0;
    virtual int subscribe_to_x4_desim(const std::string & name) = 0;
    virtual int get_x4_decim_frame(
        const std::string & name,
         uint32_t * frame_counter,
        double * frame_data,
        unsigned int max_length) = 0;
    virtual int subscribe_to_data_float(const std::string & name) = 0;
    virtual int subscribe_to_data_float(const std::string & name, std::function<bool(Bytes)> callback) = 0;
    virtual int peak_message_data_float(const std::string & name) = 0;
    virtual int read_message_data_float(XeThru::DataFloat * data_float) = 0;

    virtual unsigned int get_number_of_packets(const std::string & name) = 0;
    virtual Bytes get_packet(const std::string & name) = 0;
    virtual void clear(const std::string & name) = 0;
    virtual int set_profile_parameter_file(
        const std::string & filename,
        const std::string & data) = 0;
    virtual int get_profile_parameter_file(
        const std::string & filename) = 0;
    virtual void load_profile(const uint32_t profile_id) = 0;
    virtual int subscribe_to_trace(const std::string & name) = 0;
    virtual std::string get_trace(const std::string & name) = 0;
    virtual int subscribe_to_data_byte(const std::string & name) = 0;
    virtual int subscribe_to_data_byte(const std::string & name, std::function<bool(Bytes)> callback) = 0;


};

}

#endif
