# Docker file for the U.S. Social Determinants of Health by County Project
# Alex Yinan Guo, December 10, 2021
# Master of Data Science, UBC

# use rocker/tidyverse as the base image
FROM rocker/tidyverse

RUN apt-get update

RUN apt-get install libxt6

# install R packages
RUN Rscript -e "install.packages(c('docopt', 'httr', 'jsonlite', 'broom', 'plotly', 'here', 'knitr', 'testthat'), repos = 'http://cran.us.r-project.org')"

RUN apt-get install pandoc -y