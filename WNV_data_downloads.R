#### Codes added by Babak: #########################
# Babak testing here:
rm(list = ls())

library(tidyverse)
library(httr)
library(XML)
library(glue)


download_set_of_files <- function(url, filename_patterns, relative_path=''){
  df <- readHTMLTable(content(GET(url), "text"))[[1]]
  filename_patterns <- paste(filename_patterns, collapse = "|")
  
  # Finding exact names of files to be downloaded
  dl_names <- df$Name[str_which(df$Name, filename_patterns)]
  
  # now attaching url to the names
  dl_links <- paste0(url, dl_names)
  
  dl_names <- paste0(relative_path, dl_names)
  # Now doing the real downloading
  safe_download <- safely(~ download.file(.x, .y, mode='wb'))
  walk2(dl_links, dl_names, safe_download)
  
}

# checking the function above

# precipietaion and temperature files
url <- "https://www1.ncdc.noaa.gov/pub/data/cirs/climdiv/"

filename_patterns <- c('climdiv-tmpccy-v1.0.0'
                       ,'climdiv-pcpncy-v1.0.0')

download_set_of_files(url, filename_patterns, relative_path = '../data/raw')

## ******* Part 2 ) Downloading SPI and SPEI
# Just downloaded manually!