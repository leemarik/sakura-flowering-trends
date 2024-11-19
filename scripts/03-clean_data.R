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
library(arrow)

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
  mutate(
    flowering_date = ymd(flowering_date),
    source = "historical"
  )

# Clean modern dataset
modern <- modern %>%
  select(year, flower_date, full_bloom_date, latitude, longitude) %>%
  rename(
    flowering_date = flower_date,
    lat = latitude,
    lon = longitude
  ) %>%
  mutate(
    flowering_date = ymd(flowering_date),
    source = "modern"
  )

# Clean temperatures dataset
temperatures <- temperatures %>%
  filter(month == "Mar") %>%
  group_by(year) %>%
  summarize(avg_temperature = mean(mean_temp_c, na.rm = TRUE)) %>%
  ungroup()

# Combine historical and modern flowering data
clean_sakura_data <- bind_rows(historical, modern)

# Join with temperature data
clean_sakura_data <- clean_sakura_data %>%
  left_join(temperatures, by = "year")

# Remove rows with missing flowering dates
clean_sakura_data <- clean_sakura_data %>%
  filter(!is.na(flowering_date))

# Add derived columns
clean_sakura_data <- clean_sakura_data %>%
  mutate(
    day_of_year = yday(flowering_date),
    decade = floor(year / 10) * 10,
    flowering_range = case_when(
      day_of_year <= 90 ~ "Early (Jan-Mar)",
      day_of_year > 90 & day_of_year <= 120 ~ "Mid (Apr)",
      day_of_year > 120 ~ "Late (May+)"
    ),
    avg_temperature = ifelse(is.na(avg_temperature), temperature_recon, avg_temperature)
  ) %>%
  select(year, flowering_date, temperature_recon, avg_temperature, 
         day_of_year, decade, flowering_range, lat, lon, source)

# Save the cleaned dataset in multiple formats
write_parquet(clean_sakura_data, "data/02-analysis_data/clean_sakura_data.parquet")
