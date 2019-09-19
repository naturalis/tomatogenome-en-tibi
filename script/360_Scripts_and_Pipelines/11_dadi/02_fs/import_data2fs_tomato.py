import numpy
import dadi

cfs=dadi.Misc.make_data_dict("dadi.input")

#fsi=dadi.Spectrum.from_data_dict(cfs,['Indian'],[60])
#fsc=dadi.Spectrum.from_data_dict(cfs,['EastAsian'],[74])
#fse=dadi.Spectrum.from_data_dict(cfs,['Eurasian'],[58])
#fsx=dadi.Spectrum.from_data_dict(cfs,['Xishuangbanna'],[38])
#fscultivated=dadi.Spectrum.from_data_dict(cfs,['Cultivated'],[230])		#number is population * 2
fsPimp=dadi.Spectrum.from_data_dict(cfs,['Pimp'],[120])		#number is population * 2
fsCerasi=dadi.Spectrum.from_data_dict(cfs,['Cerasi'],[214])		#number is population * 2
fsBig=dadi.Spectrum.from_data_dict(cfs,['Big'],[328])		#number is population * 2

#fsi.to_file('indian.fs')
#fsc.to_file('eastasian.fs')
#fse.to_file('eurasian.fs')
#fsx.to_file('xishuangbanna.fs')
#fscultivated.to_file('cultivated.fs')
fsPimp.to_file('Pimp.fs')
fsCerasi.to_file('Cerasi.fs')
fsBig.to_file('Big.fs')

#fsic=dadi.Spectrum.from_data_dict(cfs,['Indian','EastAsian'],[60,74])
#fsie=dadi.Spectrum.from_data_dict(cfs,['Indian','Eurasian'],[60,58])
#fsix=dadi.Spectrum.from_data_dict(cfs,['Indian','Xishuangbanna'],[60,38])
#fsicultivated=dadi.Spectrum.from_data_dict(cfs,['Indian','Cultivated'],[64,230])
fsiCerasi_Pimp=dadi.Spectrum.from_data_dict(cfs,['Pimp','Cerasi'],[120,214])
fsiBig_Pimp=dadi.Spectrum.from_data_dict(cfs,['Pimp','Big'],[120,328])
fsiCerasi_Big=dadi.Spectrum.from_data_dict(cfs,['Pimp','Big'],[120,328])

#fsic.to_file('indian_eastasian.fs')
#fsie.to_file('indian_eurasian.fs')
#fsix.to_file('indian_xishuangbanna.fs')
#fsicultivated.to_file('indian_cultivated.fs')
fsiCerasi_Pimp.to_file('Pimp_Cerasi.fs')
fsiBig_Pimp.to_file('Pimp_Big.fs')
fsiCerasi_Big.to_file('Cerasi_Big.fs')


#fs=dadi.Spectrum.from_data_dict(cfs, ['Indian','EastAsian','Eurasian'], [60,74,58])
fs=dadi.Spectrum.from_data_dict(cfs, ['Pimp','Cerasi','Big'], [120,214,328])

#fs.to_file('three_pop_syn.fs')
fs.to_file('three_pop.fs')

import pylab
dadi.Plotting.plot_3d_spectrum(fs, vmin=0.1)
pylab.show()
