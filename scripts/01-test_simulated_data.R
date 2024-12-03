#### Preamble ####
# Purpose: Tests the structure and validity of the Simulated Data.
# Author: Mariko Lee
# Date: 19 November 2024
# Contact: mariko.lee@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)
library(arrow)

#### Load simulated data ####
simulated_data <- read_csv("data/00-simulated_data/simulated_sakura_data.csv")

#### Test if the data was successfully loaded ####
if (exists("simulated_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}

#### Test Simulated Data ####

# Expected ranges and categories
expected_flowering_ranges <- c("Early (Jan-Mar)", "Mid (Apr)", "Late (May+)")
expected_sources <- c("historical", "modern")
expected_lat_range <- c(34.9, 35.0)  # Kyoto latitude range
expected_lon_range <- c(135.7, 135.8)  # Kyoto longitude range
expected_temp_range <- c(5, 15)  # Temperature range
expected_day_of_year_range <- c(1, 365)  # Valid day of year range

# Test 1: Check for missing values
cat("Checking for missing values...\n")
missing_values <- simulated_data %>%
  summarise(across(everything(), ~ sum(is.na(.)))) %>%
  pivot_longer(cols = everything(), names_to = "variable", values_to = "missing_count")
print(missing_values)
stopifnot(all(missing_values$missing_count == 0))

# Test 2: Validate `avg_temperature` range
cat("Validating avg_temperature range...\n")
stopifnot(all(simulated_data$avg_temperature >= expected_temp_range[1] & 
                simulated_data$avg_temperature <= expected_temp_range[2]))

# Test 3: Validate `day_of_year` range
cat("Validating day_of_year range...\n")
stopifnot(all(simulated_data$day_of_year >= expected_day_of_year_range[1] & 
                simulated_data$day_of_year <= expected_day_of_year_range[2]))

# Test 4: Validate `flowering_range` categories
cat("Validating flowering_range categories...\n")
stopifnot(all(simulated_data$flowering_range %in% expected_flowering_ranges))

# Test 5: Validate `source` categories
cat("Validating source categories...\n")
stopifnot(all(simulated_data$source %in% expected_sources))

# Test 6: Validate latitude and longitude ranges
cat("Validating latitude and longitude ranges...\n")
stopifnot(all(simulated_data$lat >= expected_lat_range[1] & 
                simulated_data$lat <= expected_lat_range[2]))
stopifnot(all(simulated_data$lon >= expected_lon_range[1] & 
                simulated_data$lon <= expected_lon_range[2]))

# Test 7: Check if years are sequential
cat("Validating sequential years...\n")
stopifnot(all(diff(simulated_data$year) == 1))  # Ensure years are sequential

#### Test Results ####
cat("All tests passed successfully! The simulated dataset meets the expected criteria.\n")