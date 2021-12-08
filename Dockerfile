# docker run --rm -it -p 8787:8787 -e PASSWORD=test --platform linux/amd64 -v $PWD:/home/rstudio/data_analysis rocker/tidyverse:4.1
FROM rocker/tidyverse:4.1

RUN Rscript -e "install.packages(c('docopt', 'httr', 'jsonlite', 'broom', 'plotly', 'here', 'knitr', 'testthat'), repos = 'http://cran.us.r-project.org')"

# Building from Dockerfile
# docker build --tag test-r-notebook:0.1 .

# Check existence of packages
# docker run --rm --platform linux/amd64 test-r-notebook:0.1 Rscript -e "library(tidyverse)"

# Running make all
# docker run --rm --platform linux/amd64 -v $PWD:/home/rstudio test-r-notebook:0.1 make -C /home/rstudio all

# Running make clean
# docker run --rm --platform linux/amd64 -v $PWD:/home/rstudio test-r-notebook:0.1 make -C /home/rstudio clean

# Running built Docker image
# docker run --rm -it -p 8888:8888 -e PASSWORD=test --platform linux/amd64 -v $PWD:/home/rstudio test-r-notebook:0.1
