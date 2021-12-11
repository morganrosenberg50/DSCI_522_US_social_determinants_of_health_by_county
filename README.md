# U.S. Social Determinants of Health per County

Authors: Joshua Sia, Morgan Rosenberg, Sufang Tan, Yinan Guo \[Group
25\]

Data analysis project for DSCI 522 (Data Science Workflows); a course in
the Master of Data Science program at the University of British
Columbia.

## **About**

COVID-19 is a serious pandemic that has introduced a wide variety of challenges since 2019. By analysing the association of certain socioeconomic factors with COVID-19 prevalence, we hope to shed some light onto the societal features that may be associated with a high number of COVID-19 cases. Identifying the socioeconomic factors could also help policymakers and leaders make more informed decisions in combatting COVID-19.

Here, we attempt to build a multiple linear regression model which is used to quantify the influence of socioeconomic factors on the COVID-19 prevalence (measured by cases per 100,000 population) among all US counties. Factors such as percentage of smokers, income ratio, population density, percent unemployed, etc. are explored. Our final regression model suggests that the percentage of smokers, teenage birth rates, unemployment rate, and other interaction terms are significantly associated with COVID-19 prevalence at the 0.05 level. However, the original data set contained over 200 features and a subset of these features were chosen arbitrarily which means that there is still room to explore other socioeconomic features that are significantly associated with COVID-19 prevalence.

## **Report**

The final report can be read as a markdown file [here](https://github.com/UBC-MDS/DSCI_522_US_social_determinants_of_health_by_county/blob/main/doc/covid_socioeconomic_report.md), or a html file [here](https://ubc-mds.github.io/DSCI_522_US_social_determinants_of_health_by_county/doc/covid_socioeconomic_report.html).

## Usage

To replicate the analysis, please have a `kaggle.json` file containing your Kaggle credentials at the project root. To obtain your Kaggle credentials, follow the instructions on [Kaggle](https://www.kaggle.com/docs/api). 

There are two suggested ways to run this analysis:

#### 1\. Using Docker

*note - the instructions in this section also depends on running this in
a unix shell (e.g., terminal or Git Bash)*

To replicate the analysis, install
[Docker](https://www.docker.com/get-started). It may also be necessary to allocate more memory to the Docker container. To do this, open the Docker application, enter Settings, click on the Resources tab, and increase the Memory allocated using the slider.

To pull the Docker image from Docker Hub, run the following command:

    docker pull alexyinanguo/us_social_determinants_of_health_by_county

Clone this GitHub repository and run the following command at the command line/terminal
from the root directory of this project:

    docker run --rm -v /$(pwd):/home/rstudio/determinants_of_health alexyinanguo/us_social_determinants_of_health_by_county make -C /home/rstudio/determinants_of_health all
    
To reset the project to a clean state with no intermediate files, run the following command at the command line/terminal from the root directory of this project:

    docker run --rm -v /$(pwd):/home/rstudio/determinants_of_health alexyinanguo/us_social_determinants_of_health_by_county make -C /home/rstudio/determinants_of_health clean
    
#### 2\. Without using Docker

To replicate the analysis, clone this GitHub repository, install the
[dependencies](#dependencies) listed below, and run the following
command at the command line/terminal from the root directory of this
project:

    make all
    
To reset the project to a clean state, with no intermediate or results files, run the following command at the command line/terminal from the root directory of this project:

    make clean

The dependency diagram of the Makefile is shown below.
![Dependency diagram of Makefile](Makefile.png)

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
    -   testthat=3.0.4

## License:

The US social determinants of health by county data set is licensed under CC0 Public Domain.

## References
Davis, J. (2020, December 5). US social determinants of health by county. Kaggle. Retrieved December 2, 2021, from https://www.kaggle.com/johnjdavisiv/us-counties-covid19-weather-sociohealth-data. 
