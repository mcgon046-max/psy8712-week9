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

### Extract dataframe from list 
rstats_threads_df <- rstats_upvotes$threads

### Select the url and upvotes 
rstats_upvotes_fr <- rstats_threads_df |>
  select(
    url, 
    upvotes
  )

### Pull title and comments from other data frame 
rstats_title_comments <- rstats_urls |>
  select(
    url, 
    title, 
    comments
  )

## Inner join based on URL to get clean data set 
rstats_clean <- inner_join(
  rstats_title_comments,
  rstats_upvotes_fr,
  by = "url"
)

## Final tibble 
rstats_tbl <- rstats_clean |>
  select(
    title, 
    comments,
    upvotes,) |> 
  rename(
    post = title 
  ) 
  


# Visualization 

# Analysis 