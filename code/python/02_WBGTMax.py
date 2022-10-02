##################################################################################
#
#   HI to WBGT
#
#   By Cascade Tuholske, 2021.02.15, updated Feb 2022
#
#   Take PRISM Tmax and VDPmax to create HImax following:
#
#   Spangler, K. R., Weinberger, K. R., & Wellenius, G. A. (2019). Suitability of 
#   gridded climate datasets for use in environmental epidemiology. Journal of exposure 
#   science & environmental epidemiology, 29(6), 777-789.
#   
#   Convert HI values to WBGT using the equation from:
#   Bernard, T. E., & Iheanacho, I. (2015). Heat index and adjusted temperature 
#   as surrogates for wet bulb globe temperature to screen for occupational heat stress. 
#   Journal of occupational and environmental hygiene, 12(5), 323-333.
#
#   Full process broadly follows: Tuholske, C., Caylor, K., Funk, C., Verdin, A., Sweeney, S., 
#   Grace, K., ... & Evans, T. (2021). Global urban population exposure to extreme heat. 
#   Proceedings of the National Academy of Sciences, 118(41).
#
#   PRISM Data is here: https://prism.oregonstate.edu/
#
#################################################################################

# Dependencies
import numpy as np
import pandas as pd
import xarray 
import os
import glob
import rasterio
import time
import multiprocessing as mp 
from multiprocessing import Pool
import multiprocessing
import ClimFuncs
import time

# Functions
def make_wbgt(fns):
    
    """ Makes daily WBGTmax from PRISM Tmax and VPDmax .tif files. First, HImax is calculated and WBGTmax
    is approximated. See documentation above and in Clim Funcs. Designed to run in parallel from zipped 
    Tmax and VPDmax files. 
    
    Note: check file names are correct for your naming convetion, not mine. 
    
    Args:
        fns = From zipped listed of tuple file paths to Tmax and VPDmax (Tmax, VPDmax)
    """  
    
    print(multiprocessing.current_process())
     
    # open tmax and vpdmax
    tmax_fn = fns[0]
    print(tmax_fn)
    vpdmax_fn = fns[1]
    tmax = xarray.open_rasterio(tmax_fn)
    vpdmax = xarray.open_rasterio(vpdmax_fn)
    
    # Get meta data
    meta = rasterio.open(tmax_fn).meta

    # create himax file name
    date_list = tmax_fn.split('_tmax_')[1].split('.tif')[0].split('-')
    date = date_list[0]+date_list[1]
    print(date, '\n')
    
    # Make RHmin & HImax
    rhmin = ClimFuncs.make_rh(tmax, vpdmax)
    himax = ClimFuncs.heatindex(Tmax = tmax, RH = rhmin, unit_in = 'C', unit_out = 'C')
    
    # get himax array
    himax_arr = himax.data[0]
    himax_arr = himax_arr.astype('float32') # to save space 
    
    # reset NaN values
    himax_arr[himax_arr <= -999] = -9999
    
    # Write himax
    himax_handle = 'PRISM_himax_stable_4kmD2_'
    himax_fn = os.path.join(fns[0].split('tmax_tifs')[0],'himax_tifs/', himax_handle+date+'.tif')
    print(fns[0])
    print(himax_fn, '\n')
    
    with rasterio.open(himax_fn, 'w', **meta) as out:
        out.write_band(1,  himax_arr)
    
    # Make wbgtmax 
    wbgtmax = ClimFuncs.hi_to_wbgt(ClimFuncs.C_to_F(himax_arr))
    wbgtmax_arr = wbgtmax.astype('float32') # to save space 
    
    # reset NaN values
    wbgtmax_arr[wbgtmax_arr <= -999] = -9999
    
    # Write wbgtmax 
    wbgtmax_handle = 'PRISM_wbgtmax_stable_4kmD2_'
    wbgtmax_fn = os.path.join(fns[0].split('tmax_tifs')[0],'wbgtmax_tifs/', wbgtmax_handle+date+'.tif')
    print(fns[0])
    print(himax_fn, '\n')
    
    with rasterio.open(wbgtmax_fn, 'w', **meta) as out:
        out.write_band(1,  wbgtmax_arr)   

def parallel_loop(function, start_list, cpu_num):
    """Run a routine in parallel
    Args: 
        function = function to apply in parallel
        start_list = list of args for function to loop through in parallel
        cpu_num = numper of cpus to fire  
    """ 
    start = time.time()
    pool = Pool(processes = cpu_num)
    pool.map(function, start_list)
    pool.close()

    end = time.time()
    print(end-start)

# Run it 
if __name__ == "__main__":
    
    # Set up file paths
    tmax_path = os.path.join('/Users/cpt2136/Github/GeoClim/data/interim/tmax_tifs/')
    vpdmax_path = os.path.join('/Users/cpt2136/Github/GeoClim/data/interim/vpdmax_tifs/')
    
    # Get VPDmax and Tmax daily .tif files
    tmax_fns = sorted(glob.glob(tmax_path+'/*2021-*'))
    vpdmax_fns = sorted(glob.glob(vpdmax_path+'/*2021-*'))
    
    # Zip the daily VPDmax and Tmax .tif files
    zipped_fns = list(zip(tmax_fns, vpdmax_fns))
    
#     for fn in vpdmax_fns:
#         print(fn)
    
    # Test
    # zipped_fns = zipped_fns[:50]
    
    # Run it
    parallel_loop(function = make_wbgt, start_list = zipped_fns, cpu_num = 6)