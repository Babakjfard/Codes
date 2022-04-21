# Preparing datasets for the study
rm(list = ls())

library(tidyverse)

# This reads the fwf file into a dataframe and cleans it the way that is asked for (temp and prcp data)
get_prcp_tmp <- function(file_link, start_positions, end_positions, col_names, condition_column, condition_values, name){
  result <- read_fwf(file_fwf , fwf_positions(start = start_positions, end = end_positions, col_names = col_names))
  result <- result[result[condition_column]==condition_values,]
  
  result <- result %>% select(-c(ELEMENT_CODE)) %>% pivot_longer(cols = '1':'12', names_to = 'month', values_to = name)
  return(result)
}

start_positions <- c(1, 3, 6, 8, 12, seq(19, 89, by=7))
end_positions <- c(2, 5, 7, 11, seq(18, 95, by=7))
col_names <- c("STATE_CODE",  "DIVISION_NUMBER", "ELEMENT_CODE", "YEAR", c('1':'12'))

condition_column <- 'STATE_CODE'
condition_values = c('32', '39', '25', '14', '34', '41') #North Dakota, South Dakota, Nebraska, Kansas, Oklahoma, Texas

PRCP <- get_prcp_tmp("../data/raw/rawclimdiv-pcpncy-v1.0.0-20220304", start_positions, end_positions,
                     col_names, condition_column, condition_values, 'ppt')
TMP <- get_prcp_tmp("../data/raw/rawclimdiv-tmpccy-v1.0.0-20220304", start_positions, end_positions,
                    col_names, condition_column, condition_values, 'temp')
prcp_tmp <- merge(PRCP, TMP, by=c("STATE_CODE", "DIVISION_NUMBER", "YEAR", "month" ))

write_csv(prcp_tmp, "../data/processed/temp_prcp.csv")
