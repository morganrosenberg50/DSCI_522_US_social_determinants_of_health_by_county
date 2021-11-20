# author: Joshua Sia
# date: 2021-11-18

"This script downloads a dataset from a URL or a local file path.
Usage: get_data.R ((--url=<url> --file=<file>) | --path=<path>) [--save=save]

Options:
--url=<url>       URL from where to download data (either this or the path is a
                  required option)
--file=<file>     Filaname of Kaggle dataset to download (file must be
                  specified if using URL)
--path=<path>     Local path from where to read data
--save=save       Path including filename of where to locally write the file  
                  [default: data/rawdata.csv]
" -> doc

# --url=https://www.kaggle.com/johnjdavisiv/us-counties-covid19-weather-sociohealth-data
# --file=us_county_sociohealth_data.csv

library(httr)
library(jsonlite)
library(docopt)
library(tidyverse)
library(testthat)

opt <- docopt(doc)

main <- function(opt) {
  
  if (is.null(opt$url)) {
    df <- read_csv(opt$path)
  }
  else {
    user <- fromJSON("kaggle.json", flatten = TRUE)
    .kaggle_base_url <- "https://www.kaggle.com/api/v1"
    
    url <- get_url(opt$url, .kaggle_base_url, opt$file)
    
    rcall <- httr::GET(
      url,
      httr::authenticate(user$username, user$key, type="basic")
      )
    content_type <- rcall[[3]]$`content-type`

    if (grepl("zip", content_type)) {
      temp <- tempfile()
      download.file(rcall$url, temp)
      df <- read.csv(unz(temp, opt$file))
      unlink(temp)
    }
    else {
      stop("URL does not lead to a valid data set.")
    }
  }
  write.csv(df, opt$save, row.names = FALSE)
}

get_url <- function(url, .kaggle_base_url, filename) {
  idx <- str_locate(url, ".com")
  ref <- str_sub(url, start = idx[2] + 2, end = -1)
  paste0(.kaggle_base_url, "/datasets/download/", ref, "/", filename)
}

test_get_url <- function() {
  test_that("URL is parsed incorrectly", {
    expect_equal(
      get_url("kaggle.com/user/data", "https://www.kaggle.com/api/v1", "file"),
      "https://www.kaggle.com/api/v1/datasets/download/user/data/file"
      )
  })
  test_that("Output object should be a string", {
    expect_type(get_url("a", "b", "c"), "character")
  })
}

test_get_url()

main(opt)
