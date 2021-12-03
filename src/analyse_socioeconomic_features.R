# author: Joshua Sia
# date: 2021-11-25

"This script performs an analysis on the socioeconomic features associated with COVID-19 cases
Usage: analyse_socioeconomic_features.R --in_file=<in_file> --out_dir=<out_dir>

Options:
--in_file=<in_file>           Path including filename of processed data
--out_dir=<out_dir>           Directory of where to locally write the
                              figures and tables
" -> doc

# Rscript src/analyse_socioeconomic_features.R --in_file=data/processed/cleaned_data.csv --out_dir=results

library(tidyverse)
library(testthat)
library(broom)
library(docopt)
library(here)

opt <- docopt(doc)

main <- function(opt) {
  df <- read_csv(opt$in_file)
  
  # Specify response and features
  response <- "cases_per_100k"
  
  model_features <- c(
    "percent_smokers", "percent_vaccinated", "income_ratio",
    "population_density_per_sqmi", "percent_fair_or_poor_health",
    "percent_unemployed_CHR", "violent_crime_rate", "chlamydia_rate",
    "teen_birth_rate")

  # Standardize features data
  standardised_data <- standardise_features(df, model_features)

  # Build model
  mlr <- lm(cases_per_100k ~ .,
            data = standardised_data |>
              select(c(response, model_features)))

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
  
  saved_mlr <- mlr_tidy |>
    select(term, estimate, conf.low, conf.high, p.value, is_sig)
  saveRDS(saved_mlr, file = here(opt$out_dir, "mlr_model.rds"))
}

standardise_features <- function(data, features) {
  #' Standardise features in the data frame
  #'
  #' Standardises features in the data frame such that it is centered at 0
  #' and has a standard deviation of 1
  #'
  #' @param data Input data frame
  #' @param features List of features to standardise
  #'
  #' @return Data frame with standardised features
  #' @export
  #'
  #' @examples
  #' test_df <- data.frame(response = c(1, 0), feature1 = c(1, 0))
  #' standardise_features(test_df, c("feature1"))
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

test_standardise_features()

main(opt)