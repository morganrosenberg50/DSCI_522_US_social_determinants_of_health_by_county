# docker run --rm -it -p 8888:8888 -v $PWD:/home/jovyan/work/data_anlaysis jupyter/r-notebook:r-4.1.1
FROM jupyter/r-notebook:r-4.1.1

RUN Rscript -e "install.packages(c('tidyverse', 'docopt', 'httr', 'jsonlite', 'broom', 'plotly', 'here', 'knitr', 'testthat'), repos = 'http://cran.us.r-project.org')"

# Building from Dockerfile
# docker build --tag test-r-notebook:0.1 .

# Check existence of packages
# docker run --rm test-r-notebook:0.1 Rscript -e "library(tidyverse)"

# Running make all
# docker run --rm -v $PWD:/home/jovyan test-r-notebook:0.1 make all

# Running make clean
# docker run --rm -v $PWD:/home/jovyan test-r-notebook:0.1 make clean

# Running built Docker image
# docker run --rm -it -p 8888:8888 -v $PWD:/home/jovyan test-r-notebook:0.1
