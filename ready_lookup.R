# === This is just to make some small changes on Lookup table to be ready for 
# matching and extraction of netcdf data

rm(list = ls())
library(tidyverse)

lookup <- read_csv('../WNV_data_wrangling/lookup.csv')

# Checking what types of polygons are available
unique(lookup$type)

# Steps :
# 1) Only selct county type
# 2) separate state from the name of the county
# 3) Select only the six states of interest
# 4) make a table with columns (polygon, state, county)

states_keep <- c("North Dakota", "South Dakota", "Nebraska", "Kansas", "Oklahoma", "Texas")
lk_final <- lookup %>% filter(type=='county') %>% 
  separate(col = name, sep = " - ", into = c('state', 'county')) %>%
  filter(state %in% states_keep)

write_csv(lk_final, '../data/processed/lookup_revised.csv')

