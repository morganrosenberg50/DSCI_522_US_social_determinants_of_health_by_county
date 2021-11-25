#author: Morgan Rosenberg
# date: 2021-11-24
"Cleans and organizes data from US Counties: COVID19 + Weather + Socio/Health data (https://www.kaggle.com/johnjdavisiv/us-counties-covid19-weather-sociohealth-data)
Writes the data to a separate feather file.

Usage:

Options:
--input=<input>       Path to the raw data, including the filename (e.g. data/file.csv)
--col_list=<col_list>  List of columns which may be analyzed
--output=<output>     Path NOT including new filename for cleaned data (e.g. data/production)
" -> doc

library(tidyverse)
library(docopt)
library(here)
set.seed(2021)

opt <- docopt(doc)

main <- function(input, output){
  #read the data
  inpath = here(strsplit(input, "/"))
  outpath = here(strsplit(output, "/"), "cleaned_data.csv")
  if (!file.exists(path))
    stop("Invalid path")
  
  raw_data <- read_csv(path)
  filtered_data <- filtere_data(raw_data)
}

filter_data <- function(raw_data){
  filtered_data <- raw_data |>
    select(all_of(col_list)) |>
    drop_na() |> 
    group_by(state) |>
    mutate(
      cases_growth_rate = (cases - lag(cases)) / lag(cases))|> 
    ungroup() |> 
    group_by(county) |>
    summarize(
      state = first(state),
      max_cases = max(cases),
      avg_growth_rate = mean(cases_growth_rate, na.rm = TRUE),
      max_growth_rate = max(cases_growth_rate, na.rm = TRUE),
      across(total_population:teen_birth_rate, mean)) |>
    mutate(
      total_cases = max_cases*10**5/total_population,
      deaths_per_100k = num_deaths*10**5/total_population,
      teen_birth_rate = teen_birth_rate*100
    )
  ## important note: teen birth rate is per thousand females, all other rates are per 100
}

  try({
    dir.create(output)
  })
  saveRDS()
}