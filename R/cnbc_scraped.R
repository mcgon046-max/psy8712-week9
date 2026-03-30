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
  geom_col() + # better than geom_bar for pre-summarized data
  labs(
    title = "Mean Length of Title by CNBC Section",
    x = "CNBC Section", 
    y = "Mean length of Words"
  ) + #labels 
  theme(legend.position = "none") # got rid of legend, redundant information

# Analysis 
anova_mod <- cnbc_tbl |>
  aov(length ~ source, data = _) #Aov for straightforward ANOVA

anova_summary <- summary(anova_mod) # Created variable to make extraction easier 

## Pulling out relevant variables for publication section 
dfn <- anova_summary[[1]]$Df[1] # Degrees of freedom numerator
dfd <- anova_summary[[1]]$Df[2] # Degrees of freedom denominator
f_stat <- anova_summary[[1]]$`F value`[1] # F statistc
p_val <- anova_summary[[1]]$`Pr(>F)`[1] # P value 

# Publication 
# The results of an ANOVA comparing lengths across sources was F(3, 130) = 2.46, p = .07. This test was not statistically significant.
signif <- ifelse(p_val < 0.05, "was", "was not") # Logic for significant statement using if else 

dfn_fmt <- round(dfn) # Rounded so no digits are displayed
dfd_fmt <- round(dfd) # same as above 

f_fmt <- sprintf("%.2f", f_stat) #Formatted f statistic sprint f to keep 2 decimal places

p_temp <- sprintf("%.2f", p_val) # Also keeps only 2 decimals after p-val 
p_fmt <- sub("^0", "", p_temp) # Regex to replace leading 0 with empty string 

## Paste to console based on assignment parameters 
final_text <- paste0(
  "The results of an ANOVA comparing lengths across sources was F(", 
  dfn_fmt, ", ", dfd_fmt, ") = ", f_fmt, ", p = ", p_fmt, 
  ". This test ", signif, " statistically significant."
) 

cat(final_text) # final paste to console, cat > paste here because we're concatenating the string.
