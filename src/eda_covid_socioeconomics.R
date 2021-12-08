# Authors: Yinan Guo, Joshua Sia
# Date: 2021-11-24

"Generates figures and tables from EDA of COVID-19 cases and socioeconomics in the US data set

Usage: eda_covid_socioeconomics.r --in_file=<in_file> --out_dir=<out_dir>

Options:
--in_file=<in_file>   Path to the raw data, including the filename (e.g. data/file.csv)
--out_dir=<out_dir>   Directory of where to save the figures and tables (e.g. results)
" -> doc

# Rscript src/eda_covid_socioeconomics.R --in_file=data/processed/cleaned_data.csv --out_dir=results

library(tidyverse)
library(plotly)
library(broom)
library(knitr)
library(here)
library(docopt)

set.seed(2021)

opt <- docopt(doc)

main <- function(inpath, output){
  covid_data <- read_csv(inpath)
  n_nas <- nrow(covid_data) - (drop_na(covid_data) %>% tally())
  
  print("Getting summary statistics...")
  
  # summary_df <- summary(covid_data)
  # saveRDS(summary_df, file = here(output, "summary_data.rds"))
  
  # head_df <- head(covid_data)
  # saveRDS(head_df, file = here(output, "head_data.rds"))
  
  # tail_df <- tail(covid_data)
  # saveRDS(tail_df, file = here(output, "tail_data.rds"))
  
  # unique_vals <- apply(covid_data, 2, function(x) length(unique(x)))
  # saveRDS(unique_vals, file = here(output, "unique_vals.rds"))
  
  covid_prevalence_table_county <- covid_data %>%
    select(county,
           cases_per_100k, 
           percent_smokers, 
           income_ratio, 
           percent_unemployed_CHR) %>%
    arrange(desc(cases_per_100k)) 
  
  highest_covid_growths <- head(data.frame(covid_prevalence_table_county))
  saveRDS(highest_covid_growths, file = here(output, "highest_covid_cases.rds"))
  
  lowest_covid_growths <- tail(data.frame(covid_prevalence_table_county))
  saveRDS(lowest_covid_growths, file = here(output, "lowest_covid_cases.rds"))
  
  covid_data_group_by_sate <- covid_data %>%
    group_by(county) %>%
    summarize(cases_per_100k = sum(cases_per_100k, na.rm=TRUE),
              percent_smokers = mean(percent_smokers),
              income_ratio = mean(income_ratio),
              population_density_per_sqmi = mean(population_density_per_sqmi),
              percent_unemployed_CHR = mean(percent_unemployed_CHR),
              violent_crime_rate = mean(violent_crime_rate),
              chlamydia_rate = mean(chlamydia_rate),
              percent_fair_or_poor_health = mean(percent_fair_or_poor_health),
              teen_birth_rate = mean(teen_birth_rate)) 
  
  print("Getting EDA figures...")
  par(mfrow=c(3, 4))
  
  numeric_feats_dist <- covid_data_group_by_sate %>%
    select_if(is.numeric) %>%
    pivot_longer(everything()) %>%
    ggplot(aes(x=value)) + 
    geom_density(fill='grey') +
    facet_wrap(~name, scales='free') + 
    theme(strip.text = element_text(size=7),
          axis.text.x = element_text(size=5), 
          axis.text.y = element_text(size=5), 
          plot.title = element_text(hjust = 0.5)) +
    labs(x ="", 
         y = "Density") 
  
  ggsave(here(output, "numeric_feats_dist.png"), width = 7, height = 5)
  
  covid_data_group_by_sate_long <- covid_data_group_by_sate %>%
    select_if(is.numeric) %>%
    pivot_longer(-c(cases_per_100k)) 
  
  par(mfrow=c(3, 4))
  case_per_100k_plot <- covid_data_group_by_sate_long %>%
    ggplot(aes(x=value, y=cases_per_100k)) + 
    geom_point(alpha = 0.2, size = 1) +
    geom_smooth(method = 'lm', se = FALSE, linetype = "dashed",
                size = 0.5, color = "red") +
    facet_wrap(~name, scales='free') +
    theme(strip.text = element_text(size=7),
          axis.text.x = element_text(size=7), 
          axis.text.y = element_text(size=7)) +
    labs(x ="", 
         y = "COVID-19 cases per 100k") +
    scale_x_continuous(labels = scales::label_number_si()) +
    scale_y_continuous(labels = scales::label_number_si())
  
  ggsave(here(output, "cases_per_100k.png"), width = 7, height = 5)
  
}

main(opt$in_file, opt$out_dir)