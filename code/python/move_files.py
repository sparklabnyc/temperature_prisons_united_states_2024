############################################
#
#   Cascade Tuholske Feb 2022
#
#   Move tif files around into annual
#   dirs
#
#   Note Sep 2022: Changed from wbgtmax to himax. 
#   Make updates accordingly. CPT
#
############################################

# dependencies 
import os

# run it 

if __name__ == "__main__":
    
    # Set input file path
    path = os.path.join('/Users/cpt2136/Github/GeoClim/data/interim/himax_tifs/')
    
    # Set years for dirs to make
    years = list(range(1981, 2021+1))
    # years = [2021]
    
    # file handle 
    handle = 'PRISM_himax_stable_4kmD2_'
    
    # Move the .tif files
    for year in years:
        
        # turn year to str
        year = str(year) 
    
        # make file path
        out = handle+year+'0101_'+year+'1231'+'_tif'
        path_out = os.path.join(path+out)
        print(path_out)
        
        cmd = 'mkdir ' + path_out
        print(cmd)
        os.system(cmd)
    
        # move folders
        cmd = 'mv ' + path+handle+year+ '*.tif ' + path_out +'/'
        print(cmd, '\n')
        os.system(cmd)