# U.S. Social Determinants of Health per County

Authors: Joshua Sia, Morgan Rosenberg, Sufang Tan, Yinan Guo \[Group
25\]

Data analysis project for DSCI 522 (Data Science Workflows); a course in
the Master of Data Science program at the University of British
Columbia.

## **About**

The data set used in this project contains county-level data on health,
socioeconomics, weather, and COVID-19 cases compiled by John Davis. It
can be found
[here](https://www.kaggle.com/johnjdavisiv/us-counties-covid19-weather-sociohealth-data),
specifically, the `US_counties_COVID19_health_weather_data.csv` file.
Each row in the data set represents a date corresponding to the number
of COVID-19 cases in the county, as well as other features about the
county (e.g. smokers percentage, population, income ratio, etc.).

## **Report**

The final report can be found [here](https://github.com/UBC-MDS/DSCI_522_US_social_determinants_of_health_by_county/blob/main/doc/covid_socioeconomic_report.md). The final report can also be downloaded as a html file [here](https://github.com/UBC-MDS/DSCI_522_US_social_determinants_of_health_by_county/blob/main/doc/covid_socioeconomic_report.html). A preview of the final report as a html file can be viewed [here](https://htmlpreview.github.io/?https://github.com/joshsia/DSCI_522_US_social_determinants_of_health_by_county/blob/main/doc/covid_socioeconomic_report.html).

## Usage

To replicate the analysis, please have a `kaggle.json` file containing your Kaggle credentials and a `data` directory at the root containing the subdirectories `raw` and `processed`. To obtain your Kaggle credentials, follow the instructions on [Kaggle](https://www.kaggle.com/docs/api). Next, clone this GitHub repository, install the
dependencies listed below, and run the following
commands at the command line/terminal from the root directory of this
project:


    bash runall.sh
    
Alternatively, the scripts can be specified and run individually as:
    
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
    

## **Dependencies**
-   R version 4.1.1 and R packages:
    -   docopt=0.7.1
    -   tidyverse=1.3.1
    -   httr=1.4.2
    -   jsonlite=1.7.2
    -   broom=0.7.9
    -   plotly=4.10.0
    -   here=1.0.1
    -   knitr=1.33

## License:

The US social determinants of health by county data set is licensed under CC0 Public Domain.

## References
