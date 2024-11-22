#### Preamble ####
# Purpose: Tests for Cleaned Dataset
# Author: Mariko Lee
# Date: 19 November 2024
# Contact: mariko.lee@mail.utoronto.ca
# License: MIT
# Pre-requisites: Run 03-clean_data.R script
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)
library(arrow)

#### Test Data ####
clean_sakura_data <- read_parquet("data/02-analysis_data/clean_sakura_data.parquet")

#### Initialize validation flag ####
all_tests_passed <- TRUE

# Test 1: Check for missing values
cat("Test 1: Checking for missing values...\n")
missing_values <- clean_sakura_data %>%
  summarise(across(everything(), ~ sum(is.na(.)))) %>%
  pivot_longer(cols = everything(), names_to = "variable", values_to = "missing_count")
print(missing_values)
if (any(missing_values$missing_count > 0)) {
  cat("FAILED: Missing values found in the dataset.\n")
  all_tests_passed <- FALSE
} else {
  cat("PASSED: No missing values found.\n")
}

# Test 2: Validate column count
cat("\nTest 2: Validating column count...\n")
expected_columns <- c("year", "flowering_date", "avg_temperature",
                      "day_of_year", "decade", "flowering_range", "source")
if (ncol(clean_sakura_data) != length(expected_columns)) {
  cat("FAILED: Column count mismatch. Expected:", length(expected_columns), "but found:", ncol(clean_sakura_data), "\n")
  all_tests_passed <- FALSE
} else {
  cat("PASSED: Column count matches expectations.\n")
}

# Test 3: Validate `avg_temperature` range
cat("\nTest 3: Validating avg_temperature range...\n")
if (!all(clean_sakura_data$avg_temperature >= 5 & clean_sakura_data$avg_temperature <= 15)) {
  cat("FAILED: Some avg_temperature values are outside the valid range (5-15°C).\n")
  all_tests_passed <- FALSE
} else {
  cat("PASSED: All avg_temperature values are within the valid range.\n")
}

# Test 4: Validate `day_of_year` range
cat("\nTest 4: Validating day_of_year range...\n")
if (!all(clean_sakura_data$day_of_year >= 1 & clean_sakura_data$day_of_year <= 365)) {
  cat("FAILED: Some day_of_year values are outside the valid range (1-365).\n")
  all_tests_passed <- FALSE
} else {
  cat("PASSED: All day_of_year values are within the valid range.\n")
}

# Test 5: Validate `flowering_range` categories
cat("\nTest 5: Validating flowering_range categories...\n")
expected_flowering_ranges <- c("Early (Jan-Mar)", "Mid (Apr)", "Late (May+)")
if (!all(clean_sakura_data$flowering_range %in% expected_flowering_ranges)) {
  cat("FAILED: Unexpected categories found in flowering_range.\n")
  all_tests_passed <- FALSE
} else {
  cat("PASSED: All flowering_range values are valid.\n")
}

# Test 6: Check for duplicate rows
cat("\nTest 6: Checking for duplicate rows...\n")
duplicates <- clean_sakura_data %>%
  duplicated() %>%
  sum()
if (duplicates > 0) {
  cat("FAILED: Found", duplicates, "duplicate rows.\n")
  all_tests_passed <- FALSE
} else {
  cat("PASSED: No duplicate rows found.\n")
}

# Test 7: Count missing years
cat("\nTest 7: Checking for missing years...\n")
expected_years <- seq(min(clean_sakura_data$year), max(clean_sakura_data$year))
missing_years <- setdiff(expected_years, clean_sakura_data$year)
if (length(missing_years) > 0) {
  cat("FAILED: Missing years detected:", paste(missing_years, collapse = ", "), "\n")
  all_tests_passed <- FALSE
} else {
  cat("PASSED: No missing years detected.\n")
}

#### Final Test Results ####
if (all_tests_passed) {
  cat("\nAll tests passed successfully! The analysis dataset is valid and ready for modeling.\n")
} else {
  cat("\nSome tests failed. Please review the issues above and correct the data.\n")
}
