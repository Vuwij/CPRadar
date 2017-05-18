#!/usr/bin/env python
# -*- coding: utf-8 -*-
""" \example xep_example.py

This is an example of how to use the XEP interface from python.
"""

from pymoduleconnector import ModuleConnector
from optparse import OptionParser
import pymoduleconnector
import sys
import time


def  try_xep(device_name):

    log_level = 1
    mc = ModuleConnector(device_name, log_level)
    # we have to go to manual mode
    x4m300 = mc.get_x4m300()


def main():
    parser = OptionParser()
    parser.add_option(
        "-d",
        "--device",
        dest="device_name",
        help="device file to use",
        metavar="FILE")

    (options, args) = parser.parse_args()

    if not options.device_name:
        print "you have to specify device, e.g.: python record.py -d /dev/ttyACM0"
        sys.exit(1)

    try_xep(options.device_name)

if __name__ == "__main__":
    main()
