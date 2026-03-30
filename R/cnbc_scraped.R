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
 for(section in names(cnbc_pages)) {
   
   # Get the current URL so that this loop reads the data every time 
   curr_url <- cnbc_pages[[section]]
   
   # Pull the data 
   page_html <- read_html(curr_url)
   
   # Get headlines 
   headlines_txt <- page_html |>
     html_elements(".Card-title") |> #CSS selector for headlines on website 
     html_text()
   
   # Temp tibble to hold the headline data 
   temp_tibble <- tibble(
     headline = headlines_txt,
     length = str_count(headline, "\\S+"), # Counts words
     source = section # names from the list 
   )
     
   # Put this into the main list 
   cnbc_data_list[[section]] <- temp_tibble
     
   # Sys.sleep for safety because the reddit stuff was so brutal 
   Sys.sleep(2)
 }
 
## Final Tibble! 
cnbc_tbl <- bind_rows(cnbc_data_list)

# Visualization 
cnbc_tbl |>
  group_by(source) |>
  summarize(mean_length = mean(length, na.rm = TRUE)) |> # Grouping by source and summarizing the average length based on source, this viz is tailored for the subsequent analysis 
  ggplot(aes(x = source, y = mean_length, fill = source)) +
  geom_col() +
  labs(
    title = "Mean Length of Title by CNBC Section",
    x = "CNBC Section", 
    y = "Mean length of Words"
  ) + #labels 
  theme(legend.position = "none") # got rid of legend, redundant information

# Anaylis 
 
