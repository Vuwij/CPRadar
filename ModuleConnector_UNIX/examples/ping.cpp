#include "ModuleConnector.hpp"
#include "X2M200.hpp"
#include <iostream>

/** \example ping.cpp
 * this is a small ModuleConnector usage example
 */

using namespace XeThru;

void usage()
{
    std::cout << "ping <com port or device file>" << std::endl;
}


int ping(const std::string & device_name)
{
    const unsigned int log_level = 5;
    ModuleConnector mc(device_name, log_level);
    X2M200 & x2m200 = mc.get_x2m200();
    unsigned int pong = 0;
    const int status = x2m200.ping(&pong);

    if(status != 0) {
        std::cout << "Something went wrong - error code: " << status << std::endl;
        return status;
    }

    std::cout << "pong: " << pong << std::endl;
    return 0;
}


int main(int argc, char ** argv)
{
    if (argc < 2) {
        usage();
        return -1;
    }

    const std::string device_name = argv[1];

    return ping(device_name);
}
