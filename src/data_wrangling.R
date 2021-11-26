#author: Group 25
# date: 2021-11-24

"Cleans and organizes data from US Counties: COVID19 + Weather + Socio/Health data (https://www.kaggle.com/johnjdavisiv/us-counties-covid19-weather-sociohealth-data)
Writes the data to a separate feather file.

Usage: src/data_wrangling.r --input=<input> --output=<output>

Options:
--input=<input>       Path to the raw data, including the filename (e.g. data/file.csv)
--output=<output>     Path NOT including new filename for cleaned data (e.g. data/production)
" -> doc

library(tidyverse)
library(docopt)
library(here)
set.seed(2021)

opt <- docopt(doc)

main <- function(inpath, output){
  #read the data
  outpath <- here(output, "cleaned_data.csv")
  if (!file.exists(inpath)){
    stop("Input file not found")
  }
  if (!dir.exists(output)){
    stop("No output directory found")
  }
  
  raw_data <- read_csv(inpath)
  
  if (typeof(raw_data) != typeof(data.frame())){
    stop("Data type is not a dataframe")
  }
  filtered_data <- filter_data(raw_data)
  write_csv(filtered_data, outpath)
}

filter_data <- function(raw_data){
  col_list = c(
    "date", "county", "cases", "state", 
    "total_population", "num_deaths", "percent_smokers", 
    "percent_vaccinated", "income_ratio", 
    "population_density_per_sqmi", "percent_fair_or_poor_health",
    "percent_unemployed_CHR", "violent_crime_rate", 
    "chlamydia_rate", "teen_birth_rate"
  )
  filtered_data <- raw_data |>
    select(all_of(col_list)) |>
    drop_na() |> 
    group_by(county) |>
    mutate(cases_growth_rate= c(0, diff(cases)) / cases)|>
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
      cases_per_100k = max_cases*10**5/total_population,
    )
  ## important note: teen birth rate is per thousand females, all other rates are per 100
}

main(opt$input, opt$output)