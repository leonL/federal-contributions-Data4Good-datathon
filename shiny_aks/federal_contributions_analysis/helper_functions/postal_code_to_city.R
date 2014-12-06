## Scrape a list of postal codes to their corresponding city names

#LOAD contributions dataset
#setwd("/Users//polong//Documents/federal-contributions-analysis/munged_data/")
dataset <- read.csv("all_contributions_2004_to_2013.csv", stringsAsFactors = FALSE)

#LOAD postal-city dataset
#CSV file found here: http://geocoder.ca/onetimedownload/Canada.csv.gz
postal_codes <- read.csv("data/Canada.csv", header = FALSE)
names(postal_codes) <- c("postal_code", "V2", "V3", "cityTRUE", "provinceTRUE")
postal_codes$V2 <- NULL
postal_codes$V3 <- NULL

#MERGE dataset and postal_codes
dataset <- merge(dataset, postal_codes, by= "postal_code")