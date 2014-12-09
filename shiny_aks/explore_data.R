library(data.table)
library(lubridate)
library(ggplot2)
library(dplyr)

data <- read.csv('../munged_data/all_contributions_2004_to_2013.csv')
data <- data.table(data)

data$date <- data$contribution_date.adjusted
data$date_month <- month(data$contribution_date.adjusted)
data$date_year <- year(data$contribution_date.adjusted)
data$date_year_month <- paste(data$date_year, data$date_month, sep="-")

data$contribution_amount_dollars <- data$contribution_amount/100

# There are some duplicates. Issue or multiple donations in the same day
sum(duplicated(data))

d <- data %>% 
  group_by(date, party_nam) %>% 
  summarize(contribution=round(sum(contribution_amount_dollars))) %>% data.frame
ggplot(data=d, aes(x=date, y=contribution, color=party_name)) + geom_line()


d <- data %>% group_by(year) %>% group_by(party_name, year) %>% summarize(contribution=round(sum(contribution_amount_dollars))) %>% data.frame
ggplot(data=d, aes(x=year, y=contribution, color=party_name)) + geom_line()
