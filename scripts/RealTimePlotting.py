from pyqtgraph.Qt import QtGui, QtCore
import numpy as np
import pyqtgraph as pg


# Enable antialiasing for prettier plots
pg.setConfigOptions(antialias=True)

pw = pg.plot()

while True:
    pw.plot([1,2,3], [1,2,3], clear=True)
    pg.QtGui.QApplication.processEvents()