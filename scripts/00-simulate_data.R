#### Preamble ####
# Purpose: Simulate the analysis dataset
# Author: Mariko Lee
# Date: 19 November 2024
# Contact: mariko.lee@mail.utoronto.ca
# License: MIT
# Pre-requisites: None

#### Workspace setup ####
library(tidyverse)
library(lubridate)
library(arrow)

#### Parameters for Simulation ####
set.seed(123)  

# Define the number of years for simulation
n_years <- 1000 
start_year <- 800
end_year <- start_year + n_years - 1

# Define temperature range and relationship
avg_temp_range <- c(5, 15)  
temp_effect_on_flowering <- -3  
baseline_flowering_day <- 100  

#### Simulate Data ####

# Simulate year
year <- seq(start_year, end_year)

# Simulate average temperature
avg_temperature <- runif(n_years, min = avg_temp_range[1], max = avg_temp_range[2])

# Simulate flowering day of year
day_of_year <- baseline_flowering_day + temp_effect_on_flowering * (avg_temperature - mean(avg_temp_range))
day_of_year <- round(day_of_year) 

# Simulate decade
decade <- floor(year / 10) * 10

# Simulate flowering range categories
flowering_range <- case_when(
  day_of_year <= 90 ~ "Early (Jan-Mar)",
  day_of_year > 90 & day_of_year <= 120 ~ "Mid (Apr)",
  day_of_year > 120 ~ "Late (May+)"
)

# Simulate lat/lon (random location in Kyoto area for demonstration)
lat <- runif(n_years, min = 34.9, max = 35.0)  # Latitude range
lon <- runif(n_years, min = 135.7, max = 135.8)  # Longitude range

# Source type (randomly assign historical/modern)
source <- sample(c("historical", "modern"), n_years, replace = TRUE, prob = c(0.7, 0.3))

#### Combine Simulated Data ####
simulated_data <- tibble(
  year = year,
  avg_temperature = avg_temperature,
  day_of_year = day_of_year,
  flowering_range = flowering_range,
  lat = lat,
  lon = lon,
  decade = decade,
  source = source
)


#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_sakura_data.csv")
