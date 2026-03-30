# Script Settings and Resources 
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(RedditExtractoR)

# Data Import and Cleaning

## Pulls data from reddit based on assignment specifications (posts from the last month)
rstats_urls <- find_thread_urls(
  keywords = NA, 
  sort_by = "top",
  subreddit = "rstats", 
  period = "month"
) 

## Get upvotes by passing the url as a vector to get_thread
rstats_upvotes <- get_thread_content(rstats_urls$url)

### Extract dataframe from list 
rstats_threads_df <- rstats_upvotes$threads

### Select the relevant columns and rename to post 
rstats_upvotes_fr <- rstats_threads_df |>
  select(
    title, 
    upvotes, 
    comments) |>
  rename(post = title)



# Visualization 


# Analysis 