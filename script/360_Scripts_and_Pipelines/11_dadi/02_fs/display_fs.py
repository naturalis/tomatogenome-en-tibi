import numpy
import dadi

fs=dadi.Spectrum.from_file('new2D.indian_eastasian.fs')

import pylab
dadi.Plotting.plot_single_2d_sfs(fs, vmin=0.1)
pylab.show()
