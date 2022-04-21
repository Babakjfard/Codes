# This is the final touch on the csv created from the ncd file(s)
# The main work is done in python

rm(list = ls())
library(tidyverse)

lookup <- read_csv('../data/processed/lookup_revised.csv') %>% select(-c(type))
ncd_file <- '../data/processed/spi_initial.csv'
# ncd_file <- '../data/processed/spei_initial.csv'

ncd <- read_csv(ncd_file)

spi <- ncd %>% separate(col = month, sep = '-', into = c('year', 'month', 'day')) %>%
 select(-c(day)) %>% pivot_longer(cols = 3:dim(spi)[2], names_to = 'polygon', values_to = 'spi')

# spei <- ncd %>% separate(col = month, sep = '-', into = c('year', 'month', 'day')) %>%
#  select(-c(day)) %>% pivot_longer(cols = 3:dim(spi)[2], names_to = 'polygon', values_to = 'spei')

#last step : Attaching the state and county names
spi_counties <- merge(lookup, spi, by="polygon")
spei_counties <- merge(lookup, spei, by="polygon")

droughts <- merge(spi_counties, spei_counties, by=c("polygon", "state", "county", "year", "month")) %>%
  select(-c(polygon))
write_csv(droughts, '../data/processed/spi_spei.csv')
