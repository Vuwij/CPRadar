"""@package pymoduleconnector.moduleconnector

Entrypoint functionality.
"""
from .moduleconnectorwrapper import \
        PythonModuleConnector, PyDataRecorder, PyDataReader, PyDataPlayer

class ModuleConnector(PythonModuleConnector):
    """ Inherits pymoduleconnector.moduleconnectorwrapper.PythonModuleConnector

    @see create_mc

    Examples:
        >>> from pymoduleconnector import ModuleConnector
        >>> mc = ModuleConnector("/dev/ttyACM0", log_level=9)
        >>> x2m200 = mc.get_x2m200()
        >>> print(hex(x2m200.ping()))
        0xaaeeaeeaL
    """
    def __init__(self, device_name = None, log_level = 0):
        if not device_name:
            super(ModuleConnector, self).__init__(log_level)
        else:
            super(ModuleConnector, self).__init__(device_name, log_level)

class DataRecorder(PyDataRecorder):
    """ Inherits pymoduleconnector.moduleconnectorwrapper.PyDataRecorder
    """
    pass

class DataReader(PyDataReader):
    """ Inherits pymoduleconnector.moduleconnectorwrapper.PyDataReader
    """
    pass

class DataPlayer(PyDataPlayer):
    """ Inherits pymoduleconnector.moduleconnectorwrapper.PyDataPlayer
    """
    pass

from contextlib import contextmanager
import weakref

@contextmanager
def create_mc(*args, **kwargs):
    """Initiate a context managed ModuleConnector object.

    Convenience function to get a context managed ModuleConnector object.

    All references to the object is deleted, thus the serial port connection is
    closed.

    Examples:
        >>> from pymoduleconnector import create_mc
        >>> with create_mc('com11') as mc:
        >>>     print(hex(mc.get_x2m200().ping()))
        0xaaeeaeeaL
    """
    mc = ModuleConnector(*args, **kwargs)
    yield weakref.proxy(mc)
    del mc
