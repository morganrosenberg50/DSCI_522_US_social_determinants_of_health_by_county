# author: Joshua Sia
# date: 2021-11-18

"This script downloads a dataset from a URL or a local file path.
Usage: get_data.R ((--url=<url> --file=<file>) | --path=<path>) [--save=save]

Options:
--url=<url>       Takes a URL as a string (either this or the path is a
                  required option)
--file=<file>     Takes a filename as a string (file must be specified
                  if using URL)
--path=<path>     Takes a local path as a string
--save=save       Takes a local path to save the output file to as a string  
                  [default: data/rawdata.csv]
" -> doc

# --url="https://www.kaggle.com/johnjdavisiv/us-counties-covid19-weather-sociohealth-data"
# --file="us_county_sociohealth_data.csv"

library(httr)
library(jsonlite)
library(docopt)
library(tidyverse)
opt <- docopt(doc)

main <- function(opt) {
  
  if (is.null(opt$url)) {
    df <- read_csv(opt$path)
  }
  else {
    idx <- str_locate(opt$url, ".com")
    ref <- str_sub(opt$url, start = idx[2] + 2, end = -1)
    user <- fromJSON("kaggle.json", flatten = TRUE)
    .kaggle_base_url <- "https://www.kaggle.com/api/v1"
    
    url <- paste0(.kaggle_base_url, "/datasets/download/", ref, "/", opt$file)
    
    rcall <- httr::GET(url, httr::authenticate(user$username, user$key, type="basic"))
    content_type <- rcall[[3]]$`content-type`
    
    if (grepl("zip", content_type)) {
      temp <- tempfile()
      download.file(rcall$url, temp)
      df <- read.csv(unz(temp, opt$file))
      unlink(temp)
    }
  }
  write.csv(df, opt$save, row.names = FALSE)
}

main(opt)
