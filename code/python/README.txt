README.txt
Cascade Tuholske, Feb 2022

https://prism.oregonstate.edu/recent/ - manual download daily tmax from 1982 - 2020
##########################################################################################################

See Spangler et al. 2018 for how to make RHmin from Tmax and VPDmax. 
See Tuholske et al. 2021 for how to make WBGTmax from HImax, and HImax from Tmax and RHmin.

Spangler, K. R., Weinberger, K. R., & Wellenius, G. A. (2019). Suitability of gridded climate datasets for use in environmental epidemiology. Journal of exposure science & environmental epidemiology, 29(6), 777-789.

Tuholske, C., Caylor, K., Funk, C., Verdin, A., Sweeney, S., Grace, K., ... & Evans, T. (2021). Global urban population exposure to extreme heat. Proceedings of the National Academy of Sciences, 118(41).

##########################################################################################################

After downloading the Tmax and VPDmax daily PRISM data and putting it in one directory follow these steps:

01_bil_to_tif.py - convert Tmax and VPDmax .bil tiles to .tif files
02_make_hi.py - make heat index 
03_hi-to-wbgt.py - Convert heat index max to wet bulb globe max