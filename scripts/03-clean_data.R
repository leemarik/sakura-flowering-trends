#### Preamble ####
# Purpose: Cleans the raw data 
# Author: Mariko Lee
# Date: 19 November 2024
# Contact: mariko.lee@mail.utoronto.ca
# License: MIT
# Pre-requisites: None

#### Workspace setup ####
library(tidyverse)
library(lubridate)

# Load datasets
historical <- read_csv("data/01-raw_data/sakura-historical.csv")
modern <- read_csv("data/01-raw_data/sakura-modern.csv")
temperatures <- read_csv("data/01-raw_data/temperatures-modern.csv")

# Clean historical dataset
historical <- historical %>%
  select(year, flower_date, temp_c_recon) %>%  
  rename(
    flowering_date = flower_date,
    temperature_recon = temp_c_recon
  ) %>%
  mutate(flowering_date = ymd(flowering_date)) 

# Clean modern dataset
modern <- modern %>%
  select(year, flower_date, full_bloom_date, latitude, longitude) %>%  # Relevant columns
  rename(
    flowering_date = flower_date,     
    full_bloom_date = full_bloom_date,  
    lat = latitude,
    lon = longitude
  ) %>%
  mutate(flowering_date = ymd(flowering_date),
         full_bloom_date = ymd(full_bloom_date))

# Clean temperatures dataset
temperatures <- temperatures %>%
  filter(month == "03") %>% 
  select(year, mean_temp_c) %>% 
  rename(avg_temperature = mean_temp_c)

# Combine historical and modern flowering data
sakura <- bind_rows(historical, modern)

# Join with temperature data
sakura <- sakura %>%
  left_join(temperatures, by = "year")

# Remove rows with missing flowering dates
sakura <- sakura %>%
  filter(!is.na(flowering_date))

# Add derived columns
sakura <- sakura %>%
  mutate(
    day_of_year = yday(flowering_date),  
    decade = floor(year / 10) * 10    
  )

# Save the cleaned dataset
write_csv(sakura, "data/02-analysis_data/sakura_cleaned.csv")

