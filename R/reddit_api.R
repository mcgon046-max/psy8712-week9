# Script Settings and Resources 
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(httr2) # Apparently this is the updated httr library 
library(jsonlite)
library(RedditExtractoR)

# Data Import and Cleaning

## Pulls data from reddit based on assignment specifications (posts from the last month)
rstats_urls <- find_thread_urls(
  keywords = NA, 
  sort_by = "top",
  subreddit = "rstats", 
  period = "month"
) 

## Get upvotes 
rstats_upvotes <- get_thread_content(rstats_urls$url)

# Visualization 

# Analysis 