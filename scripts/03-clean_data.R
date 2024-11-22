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
  select(year, flower_date, full_bloom_date) %>%  # Exclude lat and lon
  rename(flowering_date = flower_date) %>%
  mutate(
    flowering_date = ymd(flowering_date),
    source = "modern"
  )

# Clean temperatures dataset
temperatures <- temperatures %>%
  filter(month == "Mar") %>%
  group_by(year) %>%
  summarize(avg_temperature = mean(mean_temp_c, na.rm = TRUE), .groups = "drop")

# Combine historical and modern flowering data
clean_sakura_data <- bind_rows(historical, modern)

# Join with temperature data
clean_sakura_data <- clean_sakura_data %>%
  left_join(temperatures, by = "year")

# Remove rows with missing flowering dates
clean_sakura_data <- clean_sakura_data %>% filter(!is.na(flowering_date))

# Clip avg_temperature to valid range
clean_sakura_data <- clean_sakura_data %>%
  mutate(avg_temperature = pmin(pmax(avg_temperature, 5), 15))

# Add derived columns
clean_sakura_data <- clean_sakura_data %>%
  mutate(
    day_of_year = yday(flowering_date),
    decade = floor(year / 10) * 10,
    flowering_range = case_when(
      day_of_year <= 90 ~ "Early (Jan-Mar)",
      day_of_year > 90 & day_of_year <= 120 ~ "Mid (Apr)",
      day_of_year > 120 ~ "Late (May+)"
    )
  ) %>%
  select(year, flowering_date, avg_temperature, day_of_year, 
         decade, flowering_range, source)  

# Filter out rows with all NA values for critical variables
clean_sakura_data <- clean_sakura_data %>%
  filter(!is.na(flowering_date) & !is.na(avg_temperature))

# Handle duplicate rows
clean_sakura_data <- clean_sakura_data %>% distinct()

# Sort by year
clean_sakura_data <- clean_sakura_data %>% arrange(year)

# Save the cleaned dataset in multiple formats
write_parquet(clean_sakura_data, "data/02-analysis_data/clean_sakura_data.parquet")
