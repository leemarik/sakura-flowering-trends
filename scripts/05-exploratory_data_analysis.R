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
library(patchwork)
library(ggplot2)

#### Read data ####
clean_sakura_data <- read_parquet("data/02-analysis_data/clean_sakura_data.parquet")

#### Summary Statistics ####
# Summary of the key variables
summary_stats <- clean_sakura_data %>%
  summarize(
    min_year = min(year),
    max_year = max(year),
    avg_temp_mean = mean(avg_temperature, na.rm = TRUE),
    avg_temp_sd = sd(avg_temperature, na.rm = TRUE),
    day_of_year_mean = mean(day_of_year, na.rm = TRUE),
    day_of_year_sd = sd(day_of_year, na.rm = TRUE)
  )
print(summary_stats)

#### Visualizations ####

# 1. Distribution of Flowering Dates (day_of_year)
plot_flowering_distribution <- ggplot(clean_sakura_data, aes(x = day_of_year)) +
  geom_histogram(binwidth = 5, fill = "steelblue", color = "black") +
  labs(
    title = "Distribution of Sakura Flowering Dates",
    x = "Day of Year (Flowering Date)",
    y = "Frequency"
  ) +
  theme_minimal()

# 2. Average Temperature Distribution
plot_temperature_distribution <- ggplot(clean_sakura_data, aes(x = avg_temperature)) +
  geom_histogram(binwidth = 1, fill = "coral", color = "black") +
  labs(
    title = "Distribution of Average Temperatures",
    x = "Average Temperature (°C)",
    y = "Frequency"
  ) +
  theme_minimal()

# 3. Trend of Flowering Dates Over Time
plot_flowering_trend <- ggplot(clean_sakura_data, aes(x = year, y = day_of_year)) +
  geom_point(alpha = 0.5, color = "darkgreen") +
  geom_smooth(method = "loess", color = "blue", se = TRUE) +
  labs(
    title = "Trend of Sakura Flowering Dates Over Time",
    x = "Year",
    y = "Day of Year (Flowering Date)"
  ) +
  theme_minimal()

# 4. Trend of Average Temperatures Over Time
plot_temperature_trend <- ggplot(clean_sakura_data, aes(x = year, y = avg_temperature)) +
  geom_point(alpha = 0.5, color = "darkorange") +
  geom_smooth(method = "loess", color = "red", se = TRUE) +
  labs(
    title = "Trend of Average Temperatures Over Time",
    x = "Year",
    y = "Average Temperature (°C)"
  ) +
  theme_minimal()

# 5. Flowering Dates by Source (Historical vs Modern)
plot_flowering_source <- ggplot(clean_sakura_data, aes(x = source, y = day_of_year, fill = source)) +
  geom_boxplot() +
  labs(
    title = "Comparison of Flowering Dates by Data Source",
    x = "Source",
    y = "Day of Year (Flowering Date)"
  ) +
  theme_minimal() +
  scale_fill_manual(values = c("historical" = "lightblue", "modern" = "lightgreen"))

# 6. Flowering Range by Decade
plot_flowering_decade <- clean_sakura_data %>%
  count(decade, flowering_range) %>%
  ggplot(aes(x = decade, y = n, fill = flowering_range)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "Flowering Range by Decade",
    x = "Decade",
    y = "Count",
    fill = "Flowering Range"
  ) +
  theme_minimal()

# 7. Temperature vs. Flowering Date
plot_temp_vs_flowering <- ggplot(clean_sakura_data, aes(x = avg_temperature, y = day_of_year)) +
  geom_point(alpha = 0.5, color = "purple") +
  geom_smooth(method = "lm", color = "black", se = TRUE) +
  labs(
    title = "Relationship Between Temperature and Flowering Date",
    x = "Average Temperature (°C)",
    y = "Day of Year (Flowering Date)"
  ) +
  theme_minimal()

# Combine Some Plots for Better Visualization
combined_trends <- plot_flowering_trend + plot_temperature_trend +
  plot_layout(ncol = 2, guides = "collect") +
  plot_annotation(title = "Trends in Flowering Dates and Temperature Over Time")

#### Save Plots ####
ggsave("plots/flowering_distribution.png", plot_flowering_distribution, width = 8, height = 6)
ggsave("plots/temperature_distribution.png", plot_temperature_distribution, width = 8, height = 6)
ggsave("plots/flowering_trend.png", plot_flowering_trend, width = 8, height = 6)
ggsave("plots/temperature_trend.png", plot_temperature_trend, width = 8, height = 6)
ggsave("plots/flowering_source.png", plot_flowering_source, width = 8, height = 6)
ggsave("plots/flowering_decade.png", plot_flowering_decade, width = 8, height = 6)
ggsave("plots/temp_vs_flowering.png", plot_temp_vs_flowering, width = 8, height = 6)

# Print Combined Trends Plot
ggsave("plots/combined_trends.png", combined_trends, width = 12, height = 6)

#### Output Summary ####
summary_stats