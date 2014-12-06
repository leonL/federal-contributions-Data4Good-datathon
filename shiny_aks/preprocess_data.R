library(lubridate)
library(dplyr)

setwd("~/Projects/datathon/federal-contributions-analysis/shiny_aks/")
data <- read.csv('../munged_data/all_contributions_2004_to_2013.csv')

data <- data %>% mutate(date=contribution_date.adjusted, 
                        date_month = month(contribution_date.adjusted),
                        date_year = year(contribution_date.adjusted),
                        date_year_month = paste(date_year, date_month, sep=""))

data$date <- as.Date(data$date)

data$contribution_amount_dollars <- data$contribution_amount/100