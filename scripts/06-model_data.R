#### Preamble ####
# Purpose: Model
# Author: Mariko Lee
# Date: 19 November 2024
# Contact: mariko.lee@mail.utoronto.ca
# License: MIT
# Pre-requisites: None

#### Workspace setup ####
library(tidyverse)
library(mgcv)  # For GAM modeling
library(arrow) # For data input/output
library(broom) # For tidying model results

#### Read cleaned data ####
clean_sakura_data <- read_parquet("data/02-analysis_data/clean_sakura_data.parquet")

#### Prepare data ####
# Filter data to ensure no missing critical variables
filtered_data <- clean_sakura_data %>%
  filter(!is.na(avg_temperature) & !is.na(day_of_year))

#### Baseline Model: Linear Regression ####
# Linear regression with temperature and year as predictors
lm_model <- lm(day_of_year ~ avg_temperature + year, data = filtered_data)

# Summary of the Linear Regression model
cat("\n--- Linear Regression Model Summary ---\n")
summary(lm_model)

# Diagnostics: Residual Plot
par(mfrow = c(2, 2))
plot(lm_model)

# Tidy the linear regression model output for interpretation
lm_results <- tidy(lm_model)
cat("\n--- Linear Regression Coefficients ---\n")
print(lm_results)

#### Generalized Additive Model (GAM) ####
# GAM model with smooth terms for temperature and year
gam_model <- gam(day_of_year ~ s(avg_temperature) + s(year),
                 data = filtered_data,
                 method = "REML")  # Restricted Maximum Likelihood

# Summary of the GAM model
cat("\n--- GAM Model Summary ---\n")
summary(gam_model)

# Diagnostics: GAM Residuals and Smooth Terms
par(mfrow = c(2, 2))
gam.check(gam_model)

# Plot the smooth terms for temperature and year
par(mfrow = c(1, 2))
plot(gam_model, select = 1, shade = TRUE, rug = TRUE, seWithMean = TRUE, main = "Effect of Temperature")
plot(gam_model, select = 2, shade = TRUE, rug = TRUE, seWithMean = TRUE, main = "Effect of Year")

#### Compare Models ####
# Compare models based on AIC (Akaike Information Criterion)
cat("\n--- Model Comparison ---\n")
aic_comparison <- AIC(lm_model, gam_model)
print(aic_comparison)

#### Predictions for Future Climate Scenarios ####
# Hypothetical future scenarios: +1°C, +2°C, and +3°C temperature increase
future_years <- seq(max(filtered_data$year) + 1, max(filtered_data$year) + 50, by = 1)
scenarios <- tibble(
  year = rep(future_years, 3),
  avg_temperature = c(rep(mean(filtered_data$avg_temperature) + 1, length(future_years)),
                      rep(mean(filtered_data$avg_temperature) + 2, length(future_years)),
                      rep(mean(filtered_data$avg_temperature) + 3, length(future_years))),
  scenario = rep(c("+1°C", "+2°C", "+3°C"), each = length(future_years))
)

# Predict with the GAM model
scenarios <- scenarios %>%
  mutate(predicted_day_of_year = predict(gam_model, newdata = scenarios))

#### Visualize Predictions ####
# Plot predictions for each climate scenario
ggplot(scenarios, aes(x = year, y = predicted_day_of_year, color = scenario)) +
  geom_line(size = 1.2) +
  labs(title = "Predicted Sakura Flowering Dates under Climate Scenarios",
       x = "Year", y = "Predicted Day of Year (Flowering Date)") +
  theme_minimal() +
  scale_color_manual(values = c("+1°C" = "blue", "+2°C" = "green", "+3°C" = "red"))

#### Save Models ####
# Save the fitted models
saveRDS(lm_model, "models/lm_model.rds")
saveRDS(gam_model, "models/gam_model.rds")


