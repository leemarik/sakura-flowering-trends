# Sakura Flowering Trends

## Overview

This study analyzes the long-term trends and their relationship with climate change using data of over 1,200 years of cherry blossom (sakura) flowering dates in Kyoto sourced from the [Alex Cookson’s datasets](https://github.com/tacookson/data).

## File Structure

The repo is structured as:

-   `data/00-simulated_data` contains the simulated dataset that was constructed.
-   `data/01raw_data` contains the raw data as obtained from Alex Cookson GitHub.
-   `data/02-analysis_data` contains the cleaned dataset that was constructed.
-   `data/03-model_data` contains the parquet format saved test and train data.
-   `model` contains fitted models. 
-   `other` contains datasheet, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, test simulated data, clean data, test analysis data, exploratory data analysis, model, and train. 


## Statement on LLM usage

ChatGPT v4.0 was used to assist in coding. The entire chat history is avialable in `other/llm_usage/usage.txt`