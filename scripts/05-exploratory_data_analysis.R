#### Preamble ####
# Purpose: Models 
# Author: Mariko Lee
# Date: 19 November 2024
# Contact: mariko.lee@mail.utoronto.ca
# License: MIT
# Pre-requisites: None


#### Workspace setup ####
library(tidyverse)  
library(arrow)
library(ggplot2) 

#### Read data ####
clean_sakura_data <- read_parquet("data/02-analysis_data/clean_sakura_data.parquet")

#### Summary Statistics ####
# General overview of the dataset
glimpse(clean_sakura_data)

# Summary of numerical variables
summary(clean_sakura_data)

# Count of observations by source
clean_sakura_data %>%
  count(source) %>%
  mutate(percentage = n / sum(n) * 100)

# Check for missing values
clean_sakura_data %>%
  summarise(across(everything(), ~ sum(is.na(.)))) %>%
  pivot_longer(cols = everything(), names_to = "variable", values_to = "missing_count")

#### Visualizations ####

# 1. Trend of Flowering Dates Over Time
ggplot(clean_sakura_data, aes(x = year, y = day_of_year, color = source)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "loess", se = FALSE) +
  labs(title = "Trend of Sakura Flowering Dates Over Time",
       x = "Year", y = "Day of Year (Flowering Date)") +
  theme_minimal()

# 2. Relationship Between Temperature and Flowering Dates
ggplot(clean_sakura_data, aes(x = avg_temperature, y = day_of_year, color = source)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(title = "Relationship Between Temperature and Flowering Dates",
       x = "Average Temperature (°C)", y = "Day of Year (Flowering Date)") +
  theme_minimal()

# 3. Flowering Dates by Decade
clean_sakura_data %>%
  group_by(decade) %>%
  summarise(mean_day_of_year = mean(day_of_year, na.rm = TRUE),
            sd_day_of_year = sd(day_of_year, na.rm = TRUE)) %>%
  ggplot(aes(x = decade, y = mean_day_of_year)) +
  geom_line() +
  geom_point() +
  labs(title = "Average Flowering Date by Decade",
       x = "Decade", y = "Average Day of Year") +
  theme_minimal()

# 4. Flowering Range Distribution
clean_sakura_data %>%
  count(flowering_range) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  ggplot(aes(x = flowering_range, y = percentage, fill = flowering_range)) +
  geom_bar(stat = "identity") +
  labs(title = "Distribution of Flowering Ranges",
       x = "Flowering Range", y = "Percentage") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set3")

#### Correlation Analysis ####
# Correlation between temperature and flowering date
correlation <- clean_sakura_data %>%
  filter(!is.na(avg_temperature)) %>%
  summarise(correlation = cor(avg_temperature, day_of_year, use = "complete.obs"))

cat("Correlation between average temperature and flowering date:", correlation$correlation, "\n")
