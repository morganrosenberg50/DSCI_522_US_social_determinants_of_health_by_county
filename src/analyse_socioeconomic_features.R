# author: Joshua Sia
# date: 2021-11-18

"This script performs an analysis on the socioeconomic features associated with COVID-19 cases
Usage: get_data.R --in_file=<in_file> --out_dir=<out_dir>

Options:
--in_file=<in_file>           Path including filename of processed data
--out_dir=<out_dir>           Directory of where to locally write the
                              figures and tables
" -> doc

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
    tidy(conf.int = TRUE) |>
    arrange(desc(estimate))

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

main(opt)











  