#### Preamble ####
# Purpose: testing and training data
# Author: Mariko Lee
# Date: 19 November 2024
# Contact: mariko.lee@mail.utoronto.ca
# License: MIT
# Pre-requisites: None


#### Workspace setup ####
library(dplyr)
library(rsample)
library(arrow)

# Read the cleaned sakura dataset
clean_sakura_data <- read_parquet("data/02-analysis_data/clean_sakura_data.parquet")

# Set seed for reproducibility
set.seed(123)  

# Split the data into 80% training and 20% testing
split <- initial_split(clean_sakura_data, prop = 0.8)

# Extract training and testing datasets
train_data <- training(split)
test_data <- testing(split)

# Save training and testing datasets as Parquet files
write_parquet(train_data, "data/03-model_data/train_data.parquet")
write_parquet(test_data, "data/03-model_data/test_data.parquet")
