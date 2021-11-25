# author: Joshua Sia
# date: 2021-11-23

"This script performs an analysis on the socioeconomic features associated with COVID-19 cases
Usage: analyse_socioeconomic_features.R --in_file=<in_file> --out_dir=<out_dir>

Options:
--in_file=<in_file>           Path including filename of processed data
--out_dir=<out_dir>           Directory of where to locally write the
                              figures and tables
" -> doc

# Rscript src/analyse_socioeconomic_features.R --in_file=data/US_counties_COVID19_health_weather_data.csv --out_dir=results

library(tidyverse)
library(testthat)
library(broom)
library(docopt)
library(here)

opt <- docopt(doc)

main <- function(opt) {
  df <- read_csv(opt$in_file)

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
  
  non_features <- c("county", "total_cases", "num_deaths",
                    "total_population", "cases_per_capita")
  
  model_features <- get_features(model_df, non_features)

  standardised_data <- standardise_features(model_df, model_features)

  mlr <- lm(cases_per_capita ~ percent_smokers +
              percent_vaccinated + income_ratio +
              population_density_per_sqmi + percent_fair_or_poor_health +
              percent_unemployed_CHR + violent_crime_rate + chlamydia_rate +
              teen_birth_rate,
            data = standardised_data)

  mlr_tidy <- mlr |>
    tidy(conf.int = TRUE) |>
    arrange(desc(estimate)) |>
    mutate(is_sig = p.value < 0.05)

  print(mlr_tidy)

  estimate_plot <- mlr_tidy |>
    ggplot(aes(x = estimate, y = factor(term, levels = term))) +
    geom_point() +
    geom_errorbar(aes(xmin = conf.low, xmax = conf.high), width = 0.2) +
    labs(x = "Coefficient",
         y = "") +
    theme_bw() +
    theme(text = element_text(size = 12))

  ggsave(here(opt$out_dir, "feature_coefs.png"), width = 7, height = 3)
  
}

get_features <- function(data, non_features) {
  if (!is.data.frame(data)) {
    stop("Input data argument is not a data frame")
  }
  data |>
    select(!all_of(non_features)) |>
    colnames()
}

test_get_features <- function() {
  test_df <- data.frame(a = c(1, 2),
                        b = c(2, 3),
                        c = c(3, 4),
                        d = c(4, 5))
  
  res_features <-get_features(test_df, c("b", "c"))
  
  test_that("Features should exclude all non-features", {
    expect_equal(res_features, c("a", "d"))
  })
}

standardise_features <- function(data, features) {
  if (!is.data.frame(data)) {
    stop("Input data argument is not a data frame")
  }
  data |>
    mutate_at(features, ~(scale(.) %>% as.vector))
}

test_standardise_features <- function() {
  test_df <- data.frame(response = c(1, 0),
                        feature1 = c(1, 0),
                        feature2 = c(1, -1))
  
  standardised_test_df <- standardise_features(
    test_df,
    c("feature1", "feature2"))
  
  test_that("Feature values are not standardised as expected", {
    expect_equal(standardised_test_df$feature1, c(0.7071068, -0.7071068),
                 tolerance = 0.01)
    expect_equal(standardised_test_df$feature2, c(0.7071068, -0.7071068),
                 tolerance = 0.01)
  })
  test_that("Input data should be a data frame", {
    expect_error(standardise_features(c(1, 2), c("feature1", "feature2")))
  })
}

test_get_features()
test_standardise_features()

main(opt)