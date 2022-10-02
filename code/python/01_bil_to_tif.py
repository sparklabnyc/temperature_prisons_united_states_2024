############################################
#
#   bil to tif
# 
#   Cascade Tuholske June 2021
#
#   Take a bunch of .bil files and 
#   make tif files in parallel
#   
#   READ BELOW <------------------------------ LOOK
#
#   Note to update Path + clim (vpdmax or tmax) both in function and 
#   in main because globals are not shared
#   for tmax and vpd
#
############################################

# Dependencies
import os
import glob
from multiprocessing import Pool
import time
import multiprocessing

# Functions
def bil_to_tif(bil_fn):
    """ Opens a bill file based on an event date and saves it out as a .tif in a temp folder
    Args:
        bil_fn = file path/name of .bil file
        date = event date 
    """
    
    # In path/names
    path = '../../data/'
    clim = 'tmax'
    input_dir = os.path.join('raw/PRISM/'+clim+'/')
    input_path = os.path.join(path, input_dir)
        
    # Out path/names
    out = 'interim/'+clim+'_tifs/'
    out_path = os.path.join(path,out)
    
    # print process
    print(multiprocessing.current_process())
    
    # get date
    date = bil_fn.split('4kmD2_')[1].split('_')[0]
    date = date[:4]+"-"+date[4:] # add dash so we can search years by MMDD 

    # path/file name to write out tif
    rst_fn = os.path.join(out_path,'PRISM_'+clim+'_'+date+'.tif') 
    
    # gdal cmd
    cmd = 'gdal_translate -of GTiff '+bil_fn+' '+rst_fn
    os.system(cmd)
    print('Saved', rst_fn)

# start pools
def parallel_loop(function, dir_list, cpu_num):
    """Run the temp-ghs routine in parallel
    Args: 
        function = function to apply in parallel
        dir_list = list of dir to loop through 
        cpu_num = numper of cpus to fire  
    """ 
    start = time.time()
    pool = Pool(processes = cpu_num)
    pool.map(function, dir_list)
    # pool.map_async(function, dir_list)
    pool.close()

    end = time.time()
    print(end-start)
    
# Run it
if __name__ == "__main__":
    
    print('Starting')
    
    # In path/names
    path = '../../data/'
    clim = 'tmax'
    input_dir = os.path.join('raw/PRISM/'+clim+'/')
    input_path = os.path.join(path, input_dir)
                 
    # Get list of .bil files 
    bil_fns = glob.glob(input_path+'*.bil')

    # set number of cpus
    cpu = 6
          
    # Run processes in parallel
    parallel_loop(bil_to_tif, bil_fns, cpu)
    print('done')