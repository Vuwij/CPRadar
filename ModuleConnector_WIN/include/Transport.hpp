#ifndef TRANSPORTINTERFACE_HPP
#define TRANSPORTINTERFACE_HPP

#include <functional>

namespace XeThru
{

class Transport
{
public:
    virtual ~Transport() {}
    virtual int send_command(const Bytes & command) = 0;
    virtual Bytes send_command_single(
        const Bytes & command,
        const Bytes & comparator) = 0;
    virtual Bytes send_command_multi(
        const Bytes & command,
        const std::vector<Bytes> & comparator) = 0;
    virtual int subscribe(const std::string & name, const Bytes & comparator) = 0;
    virtual int subscribe(const std::string & name, const Bytes & comparator, std::function<bool(Bytes)> callback) = 0;
    virtual void unsubscribe(const std::string & name) = 0;
    //virtual std::vector<Bytes> get_all_packets(const std::string & name) = 0;
    virtual Bytes get_packet(const std::string & name) = 0;
    virtual unsigned int get_number_of_packets(const std::string & name) = 0;
    virtual void clear(const std::string & name) = 0;
};


}

#endif
