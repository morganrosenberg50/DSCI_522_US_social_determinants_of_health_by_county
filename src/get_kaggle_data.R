# author: Joshua Sia
# date: 2021-11-18

"This script downloads a dataset from a URL or a local file path.
Usage: get_data.R (--url=<url> --file=<file>) --out_dir=<out_dir>

Options:
--url=<url>             URL from where to download data
--file=<file>           Filaname of Kaggle dataset to download (file must be
                        specified when using URL)
--out_dir=<out_dir>     Directory (without filename) of where to
                        locally write the file
" -> doc

# --url=https://www.kaggle.com/johnjdavisiv/us-counties-covid19-weather-sociohealth-data
# --out_dir=data/raw

library(httr)
library(jsonlite)
library(docopt)
library(tidyverse)
library(testthat)

opt <- docopt(doc)

main <- function(opt) {
  if (!file.exists("kaggle.json")) {
    stop("Make sure you have a kaggle.json file")
  }
  user <- fromJSON("kaggle.json", flatten = TRUE)
  .kaggle_base_url <- "https://www.kaggle.com/api/v1"
    
  url <- get_url(opt$url, .kaggle_base_url, opt$file)
    
  rcall <- httr::GET(
    url,
    httr::authenticate(user$username, user$key, type="basic")
    )
  
  if (rcall[[2]] != 200){
    stop("Invalid URL")
  }
  
  content_type <- rcall[[3]]$`content-type`

  print("Downloading data from URL...")
  if (grepl("zip", content_type)) {
    temp <- tempfile(fileext = ".zip")
    download.file(rcall$url, temp)
  }
  else {
    stop("URL does not lead to a valid data set.")
  }
  
  print("Saving data into csv file...")
  zip::unzip(temp, file = opt$file, exdir = opt$out_dir, junkpaths = TRUE)
  unlink(temp)
}

get_url <- function(url, .kaggle_base_url, filename) {
  #' Get the Kaggle URL where the data file resides
  #'
  #' Formats the URL to use the Kaggle API to download data
  #'
  #' @param url URL of Kaggle data page
  #' @param .kaggle_base_url Base Kaggle
  #' API URL ("https://www.kaggle.com/api/v1")
  #' @param filename .csv file to download from the Kaggle data page
  #'
  #' @return Formatted URL with Kaggle API
  #' @export
  #'
  #' @examples
  #' url <- "https://www.kaggle.com/johnjdavisiv/us-counties-covid19-weather-sociohealth-data"
  #' .kaggle_base_url <- "https://www.kaggle.com/api/v1"
  #' file <- "us_county_sociohealth_data.csv"
  #' get_url(url, .kaggle_base_url, file)
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
