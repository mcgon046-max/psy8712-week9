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
rstats_tbl <- rstats_threads_df |>
  select(
    title, 
    upvotes, 
    comments) |>
  rename(post = title)

# Visualization 
rstats_tbl |>
  ggplot(aes(x = comments, y = upvotes)) +
  geom_point(alpha = 0.6) + # Made alpha a bit lower to better see cluster(s)
  labs(
    title = "Scatter Plot of Comments and Upvotes for /r/rstats over Last Month",
    x = "Number of Comments",
    y = "Number of Upvotes"
  ) +
  geom_smooth(method = "lm") # Added line because we're looking at the correlation later on, also
 ## Note: Scatter plot makes the most sense when looking at a linear correlation between two variables here. 

# Analysis 

