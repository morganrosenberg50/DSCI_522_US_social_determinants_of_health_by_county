# author: Joshua Sia
# date: 2021-11-18

"This script downloads a dataset from a URL or a local file path.
Usage: get_data.R (--url=<url> | --path=<path>)

Options:
--url=<url>       Takes a URL as a string (either this or the path is a required option)
--path=<path>     Takes a local path as a string
" -> doc

library(docopt)
library(tidyverse)
opt <- docopt(doc)

main <- function(opt) {
  if (is.null(opt$url)) {
    df <- read_csv(opt$path)
  }
  else {
    df <- read_csv(opt$url)
  }
  write.csv(df, "data/rawdata.csv", row.names = FALSE)
}

main(opt)
