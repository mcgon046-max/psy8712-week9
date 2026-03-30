# Script Settings and Resources 
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(rvest)

# Data Import and Cleaning 
## Subpages of cnbc into a list
cnbc_pages <- list(
  Business = "https://www.cnbc.com/business/",
  Investing = "https://www.cnbc.com/investing/",
  Tech = "https://www.cnbc.com/technology/",
  Politics = "https://www.cnbc.com/politics/"
)

## Empty list to hold scraped content for assignment 
cnbc_data_list <- list()

## For loop to get all the data
 for(section in names(cnbc_pages) {
   
   # Get the current URL so that this loop reads the data every time 
   curr_url <- cnbc_pages[[section]]
   
   # Pull the data 
   page_html <- read_html(curr_url)
   
   # Get headlines 
   headlines_txt <- page_html |>
     html_elements(".Card-title") |> #CSS selector for headlines on website 
     html_text()
   
   # Data fram
     
   
     
     
   
 }