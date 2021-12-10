# Docker file for the U.S. Social Determinants of Health by County Project
# Alex Yinan Guo, Dec 10, 2021

# use rocker/tidyverse as the base image
FROM rocker/tidyverse

# install R packages
RUN Rscript -e "install.packages(c('docopt', 'httr', 'jsonlite', 'broom', 'plotly', 'here', 'knitr', 'testthat'), repos = 'http://cran.us.r-project.org')"
