# Sakura Flowering Trend Analysis

## Overview

This project explores the relationship between historical and modern sakura (cherry blossom) flowering dates and climate change, focusing on how warming temperatures impact phenological patterns. Combining historical records from Kyoto (dating back to 812 CE) and modern observations from the Japan Meteorological Agency, the analysis examines trends in flowering dates, their relationship with March temperatures, and the implications for future climate scenarios.

The analysis uses the data `sakura-historical`, `sakura-modern`, and `temperatures-modern` soured from [Alex Cookson's dataset](https://github.com/tacookson/data).

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