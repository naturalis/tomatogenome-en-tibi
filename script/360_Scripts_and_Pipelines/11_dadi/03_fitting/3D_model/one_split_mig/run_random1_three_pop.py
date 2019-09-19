# Numpy is the numerical library dadi is built upon
import numpy
from numpy import array

import dadi

# In demographic_models.py, we've defined a custom model for this problem
import demographic_models		##models by myself

# Load the data
data = dadi.Spectrum.from_file('../../../../02.fs/random1/three_pop.fs')
data=data.fold()
#data.mask[1]=data.mask[2]=data.mask[3]=data.mask[4]=data.mask[5]=data.mask[6]=data.mask[50]=data.mask[51]=data.mask[52]=data.mask[53]=data.mask[54]=data.mask[55]=data.mask[56]=data.mask[57]=data.mask[58]=data.mask[59]=data.mask[60]=data.mask[47]=data.mask[48]=data.mask[49]= True
#data.mask[1]=data.mask[2]=data.mask[3]=data.mask[4]=data.mask[5]=data.mask[6]=True

ns = data.sample_sizes

# These are the grid point settings will use for extrapolation.
pts_l = [40,50,60]

# The Demographics1D and Demographics2D modules contain a few simple models,
func = demographic_models.three_pop_one_split_mig
# ll for this model: -1136.61
params = array([0.01,0.01,0.001,0.001,0.01,0.01])
upper_bound = [100, 100, 100, 100, 100, 100]
lower_bound = [0, 0, 0, 0, 0, 0]

# Makde the extrapolating version of our demographic model function.
func_ex = dadi.Numerics.make_extrap_log_func(func)
# Calculate the model AFS.
model = func_ex(params, ns, pts_l)
# Likelihood of the data given the model AFS.
ll_model = dadi.Inference.ll_multinom(model, data)
print 'Model log-likelihood:', ll_model
# The optimal value of theta given the model.
theta = dadi.Inference.optimal_sfs_scaling(model, data)

# Perturb our parameter array before optimization. This does so by taking each
# parameter a up to a factor of two up or down.
p0 = dadi.Misc.perturb_params(params, fold=1, upper_bound=upper_bound)
# Do the optimization. By default we assume that theta is a free parameter,
# since it's trivial to find given the other parameters. If you want to fix
# theta, add a multinom=False to the call.
# (This is commented out by default, since it takes several minutes.)
# The maxiter argument restricts how long the optimizer will run. For production
# runs, you may want to set this value higher, to encourage better convergence.
popt = dadi.Inference.optimize_log(p0, data, func_ex, pts_l, 
                                   lower_bound=lower_bound,
                                   upper_bound=upper_bound,
                                   verbose=len(params),
                                   maxiter=3)
print 'Optimized parameters', repr(popt)
model = func_ex(popt, ns, pts_l)
ll_opt = dadi.Inference.ll_multinom(model, data)
print '../../../../02.fs/random1/three_pop.fs', ll_opt

# Plot a comparison of the resulting fs with the data.
#import pylab
#pylab.figure()
#dadi.Plotting.plot_1d_comp_multinom(model, data)
# This ensures that the figure pops up. It may be unecessary if you are using
# ipython.
#pylab.show()
#pylab.savefig('YRI_CEU.png', dpi=50)

# Let's generate some data using ms, if you have it installed.
#mscore = demographic_models.prior_onegrow_mig_mscore(params)
# I find that it's most efficient to simulate with theta=1 and then scale up.
#mscommand = dadi.Misc.ms_command(1., ns, mscore, int(1e6))
## We use Python's os module to call this command from within the script.
## If you have ms installed, uncomment these lines to see the results.
#import os
#os.system('%s > test.msout' % mscommand)
#msdata = dadi.Spectrum.from_ms_file('test.msout')
#pylab.figure()
#dadi.Plotting.plot_2d_comp_multinom(model, theta*msdata, vmin=1,
#                                    pop_ids=('YRI','CEU'))
#pylab.show()

# Below here we compare uncertainty estimates from folded and unfolded spectra.
# Estimates are done using the hessian (Fischer Information Matrix).
# Due to linkage in the data, these are underestimates. It is still
# informative, however, to compare the two methods.

## These are the optimal parameters when the spectrum is folded. They can be
## found simply by passing fold=True to the above call to optimize_log.
#pfold =  array([1.907,  0.073,  1.830,  0.899,  0.425,  0.113])
#
## The interface to hessian computation is designed for general functions, so we
## need to define the specific functions of interest here. These functions
## calculate -ll given the logs of the parameters. (Because we work in log
## parameters, the uncertainties we estimate will be *relative* parameter
## uncertainties.)
#from dadi.Inference import ll_multinom
#func = lambda lp: -ll_multinom(func_ex(numpy.exp(lp), ns, pts_l), data)
#foldfunc = lambda lp: -ll_multinom(func_ex(numpy.exp(lp), ns, pts_l).fold(), 
#                                   data.fold()) 
#
## Calculate the two hessians
#h = dadi.Hessian.hessian(func, numpy.log(params), 0.05)
#hfold = dadi.Hessian.hessian(foldfunc, numpy.log(pfold), 0.05)
#
## Now we calculate the *relative* parameter uncertainties.
#uncerts = numpy.sqrt(numpy.diag(numpy.linalg.inv(h)))
#uncerts_folded = numpy.sqrt(numpy.diag(numpy.linalg.inv(hf)))
#
## The increase in uncertainty is not too bad. Tp increasing by 50% is the only
## substantial one.
#print uncerts_folded/uncerts - 1
