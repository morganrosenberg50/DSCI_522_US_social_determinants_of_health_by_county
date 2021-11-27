# Joshua Sia
# 2021-11-26
#
# Driver script for analysis pipeline of socioeconomic features associated with COVID-19 cases
#
# Usage:
# bash runall.sh

# Download data file
Rscript src/get_kaggle_data.R --url=https://www.kaggle.com/johnjdavisiv/us-counties-covid19-weather-sociohealth-data --file=US_counties_COVID19_health_weather_data.csv --out_file=data/raw/US_counties_COVID19_health_weather_data.csv

# Perform data wrangling
Rscript src/data_wrangling.r --input=data/raw/US_counties_COVID19_health_weather_data.csv --output=data/processed

# EDA
Rscript src/eda_covid_socioeconomics.r --in_file=data/processed/cleaned_data.csv --out_dir=results

# Perform data analysis
Rscript src/analyse_socioeconomic_features.R --in_file=data/processed/cleaned_data.csv --out_dir=results

# Render report
Rscript -e "rmarkdown::render('doc/covid_socioeconomic_report.Rmd')"