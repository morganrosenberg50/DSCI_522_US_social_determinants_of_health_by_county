library(tidyverse)
library(testthat)
library(broom)

df <- read_csv("data/US_counties_COVID19_health_weather_data.csv")

interesting_features <- c(
  "date", "county", "cases", "state", 
  "total_population", "num_deaths", "percent_smokers", 
  "percent_vaccinated", "income_ratio", 
  "population_density_per_sqmi", "percent_fair_or_poor_health",
  "percent_unemployed_CHR", "violent_crime_rate", 
  "chlamydia_rate", "teen_birth_rate"
)

clean_df <- df |>
  select(interesting_features) |>
  drop_na()

model_df <- clean_df |>
  select(-c("date", "state")) |>
  group_by(county) |>
  summarise(
    total_cases = max(cases),
    across(total_population:teen_birth_rate, mean)) |>
  mutate(cases_per_capita = total_cases / total_population)

model_features <- colnames(model_df)[c(-1, -2, -length(colnames(model_df)))]

standardised_data <- model_df |>
  mutate_at(model_features, ~(scale(.) %>% as.vector))

mlr <- lm(cases_per_capita ~ percent_smokers +
            percent_vaccinated + income_ratio +
            population_density_per_sqmi + percent_fair_or_poor_health +
            percent_unemployed_CHR + violent_crime_rate + chlamydia_rate +
            teen_birth_rate,
          data = standardised_data)

mlr_tidy <- mlr |>
  tidy() |>
  arrange(p.value)

print(mlr_tidy)




  