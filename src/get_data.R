# author: Joshua Sia
# date: 2021-11-18

"This script downloads a dataset from a URL or a local file path.
Usage: get_data.R --url=<url> --out_file=<out_file>

Options:
--url=<url>             URL from where to download data
--out_file=<out_file>   Path including filename of where to locally write file
" -> doc

library(docopt)
library(tidyverse)
opt <- docopt(doc)

main <- function(opt) {
  df <- read_csv(opt$url)
  write.csv(df, opt$out_file, row.names = FALSE)
}

main(opt)
