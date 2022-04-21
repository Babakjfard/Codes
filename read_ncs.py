import os
import numpy as np
import pandas as pd
import xarray as xr

'''
This is the file to extract the spi and  spei data from ncd files
and save them as csv files
Source is :
Key to polygon IDs can also be found in the same directory.
Babak J.Fard Apr 2022
'''

os.chdir('/Users/babak.jfard/projects/WNV/Codes')

# Reading the file
# spi = xr.open_dataset('../data/raw/spi1_REGIONS_PRISM.nc')
spi = xr.open_dataset('../data/raw/spei1_REGIONS_PRISM.nc')

# Getting polygon IDs of the counties to extract from the netcdf file
#============== 1) Getting the indices of the polygons we want in the xarray
IDs = pd.read_csv('../data/processed/lookup_revised.csv')

# Get a sample of how the final file should look like
spi_sample = pd.read_csv('../data/WNV_data_wrangling (1)/KSco_spi1_2022-03-15.csv')
spi_sample.head()

# Getting the polygon IDs into a list
poly_IDs = list(IDs.polygon)

#IDs of all polygons in xarray to then index those that are needed
ncd_poly_IDs = spi.polygon.to_index().astype('int64').to_list()

# Now getting the indices of the polygons that we care about
poly_indices = [ncd_poly_IDs.index(i) for i in poly_IDs]

# =========  2) Now getting the desired dates indices in the xarray
from datetime import datetime
start = datetime(1997,12, 30) # can be changed
end = datetime(2022, 4, 1)  # Can be changed

# now getting all the dates in spi and indexing the dates
ncd_time_IDs = spi.date.to_index()
dates = [(start <= i <= end) for i in ncd_time_IDs]
dates_indices = [i for i, x in enumerate(dates) if x]

# ===== 3) Extracting the data from the xarray
# Final data
final_data = spi.data[dates_indices, poly_indices]

# Get column and row IDS
col_ids = [ncd_poly_IDs[id] for id in poly_indices]
# ncd_poly_IDs = spi.polygon.to_index().astype('int64').to_list()
time_labels = spi.date.to_index()[dates_indices]

final_data = final_data.values

data_to_save = pd.DataFrame(data=final_data,
index=time_labels, columns=col_ids)

# data_to_save.to_csv('../data/processed/spi_initial.csv')
data_to_save.to_csv('../data/processed/spei_initial.csv')

# Later will change the saved file into the final format using tidyverse
