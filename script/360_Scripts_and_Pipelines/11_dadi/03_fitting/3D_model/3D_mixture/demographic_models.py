"""
Custom demographic model for our example.
"""
import numpy
import dadi

def prior_onegrow_mig((nu1F, nu2B, nu2F, m, Tp, T), (n1,n2), pts):
    """
    Model with growth, split, bottleneck in pop2 , exp recovery, migration

    nu1F: The ancestral population size after growth. (Its initial size is
          defined to be 1.)
    nu2B: The bottleneck size for pop2
    nu2F: The final size for pop2
    m: The scaled migration rate
    Tp: The scaled time between ancestral population growth and the split.
    T: The time between the split and present

    n1,n2: Size of fs to generate.
    pts: Number of points to use in grid for evaluation.
    """
    # Define the grid we'll use
    xx = yy = dadi.Numerics.default_grid(pts)

    # phi for the equilibrium ancestral population
    phi = dadi.PhiManip.phi_1D(xx)
    # Now do the population growth event.
    phi = dadi.Integration.one_pop(phi, xx, Tp, nu=nu1F)

    # The divergence
    phi = dadi.PhiManip.phi_1D_to_2D(xx, phi)
    # We need to define a function to describe the non-constant population 2
    # size. lambda is a convenient way to do so.
    nu2_func = lambda t: nu2B*(nu2F/nu2B)**(t/T)
    phi = dadi.Integration.two_pops(phi, xx, T, nu1=nu1F, nu2=nu2_func, 
                                    m12=m, m21=m)

    # Finally, calculate the spectrum.
    sfs = dadi.Spectrum.from_phi(phi, (n1,n2), (xx,yy))
    return sfs

def prior_onegrow_mig_mscore((nu1F, nu2B, nu2F, m, Tp, T)):
    """
    ms core command corresponding to prior_onegrow_mig
    """
    # Growth rate
    alpha2 = numpy.log(nu2F/nu2B)/T

    command = "-n 1 %(nu1F)f -n 2 %(nu2F)f "\
            "-eg 0 2 %(alpha2)f "\
            "-ma x %(m)f %(m)f x "\
            "-ej %(T)f 2 1 "\
            "-en %(Tsum)f 1 1"

    # There are several factors of 2 necessary to convert units between dadi
    # and ms.
    sub_dict = {'nu1F':nu1F, 'nu2F':nu2F, 'alpha2':2*alpha2,
                'm':2*m, 'T':T/2, 'Tsum':(T+Tp)/2}

    return command % sub_dict

def bottleneck_in_two((nu2B, nu2F, m, Tb, T), (n1,n2), pts):
    """
    Model with split, bottleneck in pop2 , recovery, migration
    nu2B: The bottleneck size for pop2
    nu2F: The final size for pop2
    m: The scaled migration rate
    Tb: The duration of the pop2 bottleneck
    T: The time between the end of the pop2 bottleneck and present
    n1,n2: Size of fs to generate.
    pts: Number of points to use in grid for evaluation.
    """
    # Define the grid we'll use
    xx = yy = dadi.Numerics.default_grid(pts)
    # phi for the equilibrium ancestral population
    phi = dadi.PhiManip.phi_1D(xx)
    # Population size change in the ancestrial population
    # The divergence
    phi = dadi.PhiManip.phi_1D_to_2D(xx, phi)
    # The bottleneck in population 2
    phi = dadi.Integration.two_pops(phi, xx, Tb, nu1=1, nu2=nu2B, m12=0, m21=0)
    # The recovery of population 2
    phi = dadi.Integration.two_pops(phi, xx, T, nu1=1, nu2=nu2F,m12=m, m21=m)
    # Finally, calculate the spectrum.
    sfs = dadi.Spectrum.from_phi(phi, (n1,n2), (xx,yy))
    return sfs

def bottleneck_in_two_wom((nuA, nu2B, nu2F, T1, Tb, T), (n1,n2), pts):
    """
    Model with split, bottleneck in pop2 , recovery, without migration
    nu2B: The bottleneck size for pop2
    nu2F: The final size for pop2
    m: The scaled migration rate
    Tb: The duration of the pop2 bottleneck
    T: The time between the end of the pop2 bottleneck and present
    n1,n2: Size of fs to generate.
    pts: Number of points to use in grid for evaluation.
    """
    # Define the grid we'll use
    xx = yy = dadi.Numerics.default_grid(pts)
    # phi for the equilibrium ancestral population
    phi = dadi.PhiManip.phi_1D(xx)
    # Population size change in the ancestrial population
    phi = dadi.Integration.one_pop(phi, xx, T1, nuA)
    # The divergence
    phi = dadi.PhiManip.phi_1D_to_2D(xx, phi)
    # The bottleneck in population 2
    phi = dadi.Integration.two_pops(phi, xx, Tb, nu1=nuA, nu2=nu2B, m12=0, m21=0)
    # The recovery of population 2
    phi = dadi.Integration.two_pops(phi, xx, T, nu1=nuA, nu2=nu2F,m12=0, m21=0)
    # Finally, calculate the spectrum.
    sfs = dadi.Spectrum.from_phi(phi, (n1,n2), (xx,yy))
    return sfs

def three_pop_one_split((nus1,nus2,nus3,nus4,ma,mb,T1,T2,T3), (n1,n2,n3), pts):
    """
    """
    xx = dadi.Numerics.default_grid(pts)
    phi = dadi.PhiManip.phi_1D(xx)
    phi = dadi.PhiManip.phi_1D_to_2D(xx , phi)
    phi = dadi.Integration.two_pops(phi, xx, T1, nu1=1, nu2 =nus1, m12 = 0, m21 = 0)
    phi = dadi.PhiManip.phi_2D_to_3D_split_2(xx , phi)
    phi = dadi.Integration.three_pops(phi, xx, T2, nu1=1, nu2=nus1, nu3=nus2, m12 =0, m13=0, m21=0, m23 =0, m31=0, m32=0)
    phi = dadi.Integration.three_pops(phi, xx, T3, nu1=1, nu2=nus3, nu3=nus4, m12 =ma, m13=mb, m21=ma, m23 =0, m31=mb, m32=0)
    fs = dadi.Spectrum.from_phi(phi , (n1 ,n2 ,n3), (xx ,xx ,xx ))
    return fs

def three_pop_two_split((nus1,nus2,nus3,nus4,nus5,ma,mb,T1,T2,T3), (n1, n2, n3),pts):
    """
    """
    xx = dadi.Numerics.default_grid(pts)
    phi = dadi.PhiManip.phi_1D(xx)
    phi = dadi.PhiManip.phi_1D_to_2D(xx , phi)
    phi = dadi.Integration.two_pops(phi, xx, T1, nu1=1, nu2 =nus1, m12 =0, m21 = 0)
    phi = dadi.PhiManip.phi_2D_to_3D_split_1(xx , phi)
    phi = dadi.Integration.three_pops(phi, xx, T2, nu1= 1, nu2= nus1, nu3= nus2, m12=0, m21=0, m23=0, m32=0)
    phi = dadi.Integration.three_pops(phi, xx, T3, nu1= 1, nu2= nus3, nu3= nus4, m12=ma, m21=ma, m13=mb, m31=mb)
    fs = dadi.Spectrum.from_phi(phi,(n1,n2,n3),(xx ,xx ,xx ))
    return fs

def sthree_pop_one_split((nus1,nus2,nus3,nus4,ma,T1,T2,T3),(n1,n2,n3), pts):
    """
    """
    xx = dadi.Numerics.default_grid(pts)
    phi = dadi.PhiManip.phi_1D(xx)
    phi = dadi.PhiManip.phi_1D_to_2D(xx , phi)
    phi = dadi.Integration.two_pops(phi, xx, T1, nu1=1, nu2 =nus1, m12 =ma, m21 = ma)
    phi = dadi.PhiManip.phi_2D_to_3D_split_2(xx , phi)
    phi = dadi.Integration.three_pops(phi, xx, T2, nu1=1, nu2=nus1, nu3=nus2, m12 =ma, m13=ma, m21=ma, m23 =ma, m31=ma, m32=ma)
    phi = dadi.Integration.three_pops(phi, xx, T3, nu1=1, nu2=nus3, nu3=nus4, m12 =ma, m13=ma, m21=ma, m23 =ma, m31=ma, m32=ma)
    fs = dadi.Spectrum.from_phi(phi , (n1 ,n2 ,n3), (xx ,xx ,xx ))
    return fs

def sthree_pop_two_split((nus1,nus2,nus3,nus4,ma,T1,T2,T3),(n1,n2,n3), pts):
    """
    """
    xx = dadi.Numerics.default_grid(pts)
    phi = dadi.PhiManip.phi_1D(xx)
    phi = dadi.PhiManip.phi_1D_to_2D(xx , phi)
    phi = dadi.Integration.two_pops(phi, xx, T1, nu1=1, nu2 =nus1, m12 =ma, m21 = ma)
    phi = dadi.PhiManip.phi_2D_to_3D_split_1(xx , phi)
    phi = dadi.Integration.three_pops(phi, xx, T2, nu1=1, nu2=nus1, nu3=nus2, m12 =ma, m13=ma, m21=ma, m23 =ma, m31=ma, m32=ma)
    phi = dadi.Integration.three_pops(phi, xx, T3, nu1=1, nu2=nus3, nu3=nus4, m12 =ma, m13=ma, m21=ma, m23 =ma, m31=ma, m32=ma)
    fs = dadi.Spectrum.from_phi(phi , (n1 ,n2 ,n3), (xx ,xx ,xx ))
    return fs


###	Edited by lintao	lintao19870305@gmail.com	###

def three_pop_one_split_mig((nus2,nus3,ma,mb,T1,T2), (n1,n2,n3), pts):
    """
    Model with split in pop1, next, split in pop2, with migration
    #nus1: The ancestral population size. (Its initial size is defined to be 1.)
    nus2: Size of population 2 after split.
    nus3: Size of population 3 after split.
    ma: Migration rate between population 1 and population 2.
    mb: Migration rate between population 2 and population 3.
    #Tb: The duration of the ancestral population bottleneck.
    T1: The time between the split and present about population 2.
    T2: The time between the split and present about population 3.
    n1,n2,n3: Sample size of fs to generate.
    pts: Number of grid points to use in integration.
    """
    # Define the grid we'll use
    xx = dadi.Numerics.default_grid(pts)

    # phi for the equilibrium ancestral population
    phi = dadi.PhiManip.phi_1D(xx)
    # Now do the population growth event.
    ##phi = dadi.Integration.one_pop(phi, xx, Tb, nu=nus1)	# If the 
    # ancestral population is defined to 1, this command could be deleted.
    # When use this step, don't forget Tb.
    
    # The divergence 
    phi = dadi.PhiManip.phi_1D_to_2D(xx, phi)
    # The bottleneck in population 2
    phi = dadi.Integration.two_pops(phi, xx, T1, nu1=1, nu2=nus2, m12=ma, m21=ma)
    # The divergence between population 2 and population 3
    phi = dadi.PhiManip.phi_2D_to_3D_split_2(xx , phi)
    # The bottleneck in population 3
    phi = dadi.Integration.three_pops(phi, xx, T2, nu1=1, nu2=nus2, nu3=nus3, m12 =ma, m13=0, m21=ma, m23 =mb, m31=0, m32=mb)
    
    # Finally, calculate the spectrum.
    fs = dadi.Spectrum.from_phi(phi , (n1 ,n2 ,n3), (xx ,xx ,xx ))
    return fs



def three_pop_one_split_admix_1_to_3_mig((nus2,nus3,ma,mb,mc,T1,T2,f1,f3), (n1,n2,n3), pts):
    """
    Model with split in pop1, next, split in pop2, with migration
    #nus1: The ancestral population size. (Its initial size is defined to be 1.)
    nus2: Size of population 2 after split.
    nus3: Size of population 3 after split.
    ma: Migration rate between population 1 and population 2.
    mb: Migration rate between population 2 and population 3.
    mc: Migration rate between population 1 and population 3.
    #Tb: The duration of the ancestral population bottleneck.
    T1: The time between the split and present about population 2.
    T2: The time between the split and present about population 3.
    f1: Fraction of updated population 2 to be derived from population 1.
    f2: Fraction of updated population 2 to be derived from population 3.
        A fraction (1-f1-f3) will be derived from the original pop 2. 
    n1,n2,n3: Sample size of fs to generate.
    pts: Number of grid points to use in integration.
    """
    # Define the grid we'll use
    xx = dadi.Numerics.default_grid(pts)
    
    # phi for the equilibrium ancestral population
    phi = dadi.PhiManip.phi_1D(xx)
    # Now do the population growth event.
    ##phi = dadi.Integration.one_pop(phi, xx, Tb, nu=nus1)      # If the
    # ancestral population is defined to 1, this command could be deleted.
    # When use this step, don't forget Tb.
    
    # The divergence 
    phi = dadi.PhiManip.phi_1D_to_2D(xx, phi)
    # The bottleneck in population 2
    phi = dadi.Integration.two_pops(phi, xx, T1, nu1=1, nu2=nus2, m12=ma, m21=ma)
    # The divergence between population 2 and population 3
    phi = dadi.PhiManip.phi_2D_to_3D_split_2(xx , phi)
    # The bottleneck in population 3
    phi = dadi.Integration.three_pops(phi, xx, T2, nu1=1, nu2=nus2, nu3=nus3, m12 =ma, m13=mc, m21=ma, m23 =mb, m31=mc, m32=mb)

    # Admix population 1 and population 3 into population 2
    phi = dadi.PhiManip.phi_3D_admix_1_and_3_into_2(phi, f1, f3, xx, xx, xx)
    # f1: Fraction of updated population 2 to be derived from population 1.  
    # f3: Fraction of updated population 2 to be derived from population 3.  
    #     A fraction (1-f1-f3) will be derived from the original pop 2. 
    
    # Finally, calculate the spectrum.
    fs = dadi.Spectrum.from_phi(phi , (n1 ,n2 ,n3), (xx ,xx ,xx ))
    return fs

    
def three_pop_one_split_admix_1_to_3_mig_bottleneck((nus1,nus2B,nus2F,nus3B,nus3F,ma,mb,mc,T1,T2b,T2f,T3b,T3f,f1,f3), (n1,n2,n3), pts):
    """
    Model with split in pop1, next, split in pop2, with migration
    nus1: The ancestral population size. (Its initial size is defined to be 1.)
    nus2B: The bottleneck size for pop2.
	nus2F: The final size for pop2.
	nus3B: The bottleneck size for pop3.
    nus3F: The final size for pop3.
    ma: Migration rate between population 1 and population 2.
    mb: Migration rate between population 2 and population 3.
    mc: Migration rate between population 1 and population 3.
    T1: The duration of the ancestral population bottleneck.
    T2b: The duration of the pop2 bottleneck.
    T2f: The time between the end of the pop2 bottleneck and present.
	T3b: The duration of the pop3 bottleneck.
	T3f: The time between the end of the pop3 bottleneck and present.
    f1: Fraction of updated population 2 to be derived from population 1.
    f2: Fraction of updated population 2 to be derived from population 3.
        A fraction (1-f1-f3) will be derived from the original pop 2. 
    n1,n2,n3: Sample size of fs to generate.
    pts: Number of grid points to use in integration.
    """
    # Define the grid we'll use
    xx = dadi.Numerics.default_grid(pts)
    
    # phi for the equilibrium ancestral population
    phi = dadi.PhiManip.phi_1D(xx)
    # Now do the population growth event.
	# Population size change in the ancestrial population
    phi = dadi.Integration.one_pop(phi, xx, T1, nu=nus1) 
    # If the ancestral population is defined to 1, this command could be deleted.
    # When use this step, don't forget Tb.
    
    # The divergence 
    phi = dadi.PhiManip.phi_1D_to_2D(xx, phi)
    # The bottleneck in population 2
    phi = dadi.Integration.two_pops(phi, xx, T2b, nu1=nus1, nu2=nus2B, m12=ma, m21=ma)
	# The recovery of population 2
	phi = dadi.Integration.two_pops(phi, xx, T2f, nu1=nus1, nu2=nus2F, m12=ma, m21=ma)
    # The divergence between population 2 and population 3
    phi = dadi.PhiManip.phi_2D_to_3D_split_2(xx , phi)
    # The bottleneck in population 3
    phi = dadi.Integration.three_pops(phi, xx, T3b, nu1=nus1, nu2=nus2F, nu3=nus3B, m12=ma, m13=mc, m21=ma, m23=mb, m31=mc, m32=mb)
	# The recovery of population 3
	phi = dadi.Integration.three_pops(phi, xx, T3f, nu1=nus1, nu2=nus2F, nu3=nus3F, m12=ma, m13=mc, m21=ma, m23=mb, m31=mc, m32=mb)

    # Admix population 1 and population 3 into population 2
    phi = dadi.PhiManip.phi_3D_admix_1_and_3_into_2(phi, f1, f3, xx, xx, xx)
    # f1: Fraction of updated population 2 to be derived from population 1.  
    # f3: Fraction of updated population 2 to be derived from population 3.  
    #     A fraction (1-f1-f3) will be derived from the original pop 2. 
    
    # Finally, calculate the spectrum.
    fs = dadi.Spectrum.from_phi(phi , (n1 ,n2 ,n3), (xx ,xx ,xx ))
    return fs

    
###	lintao by lintao	lintao19870305@gmail.com	###
