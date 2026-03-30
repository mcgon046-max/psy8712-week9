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
rstats_cor <- rstats_tbl |>
  cor.test(~ comments + upvotes, data = _)

## Variables for subsequent publication section 
df_val <- rstats_cor$parameter # Degrees of 
cor_val <- rstats_cor$estimate
p_val <- rstats_cor$p.value

# Publication 
# The correlation between upvotes and comments was r(71) = .34, p = .00. This test was statistically significant.
signif <- ifelse(p_val < 0.05, "was", "was not") # Significance logic for subsequent console output 

df_fmt <- round(df_val) # Rounded so no 0s 

cor_temp <- sprintf("%.2f", cor_val) # temporary variable to only have lst two digits of correlation 
p_temp   <- sprintf("%.2f", p_val) # same as above but for p value

cor_fmt <- sub("^0", "", cor_temp) # Gets rid of leading 0 in correlation 
p_fmt <- sub("^0", "", p_temp) # Same as above for p value 

# Final string to be produced in console 
final_text <- paste0(
  "The correlation between upvotes and comments was r(", 
  df_fmt, ") = ", cor_fmt, ", p = ", p_fmt, 
  ". This test ", signif, " statistically significant."
)

cat(final_text)
