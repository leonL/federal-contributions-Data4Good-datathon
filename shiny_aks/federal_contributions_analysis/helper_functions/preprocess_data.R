library(data.table)
library(lubridate)
library(dplyr)
source('helper_functions/coerce_to_alpha.R')
setwd("~/Projects/datathon/federal-contributions-analysis/shiny_aks/federal_contributions_analysis")

data <- read.csv('../../munged_data/all_contributions_2004_to_2013.csv', stringsAsFactors = FALSE, encoding = "UTF-16")

#data <- data[1:1000,]

data <- data %>% mutate(date=contribution_date.adjusted, 
                        date_month = month(contribution_date.adjusted),
                        date_year = year(contribution_date.adjusted),
                        date_year_month = paste(date_year, date_month, sep=""))

# ## clean up cities 
# postal_codes <- read.csv("data/Canada.csv", header = FALSE, stringsAsFactors=FALSE, encoding = "UTF-16")
# names(postal_codes) <- c("postal_code", "V2", "V3", "cityFromPostalCode", "provinceFromPostalCode")
# postal_codes$V2 <- postal_codes$V3 <- NULL
# data <- left_join(data, postal_codes, by='postal_code')
# 
# # clean up provinces. Use human ground truth (courtesy of John Turner), and for ambiguous records, look up postal code.
# prov_fixed <- read.csv('data/fixup.csv', stringsAsFactors = FALSE, encoding = "UTF-16")
# prov_fixed$X <- NULL
# names(prov_fixed) <- c('province', 'provinceHumanGroundTruth')
# prov_fixed$provinceHumanGroundTruth[prov_fixed$provinceHumanGroundTruth == ""] <- NA
# 
# data <- left_join(data, prov_fixed, by= 'province')
# 
# data$province <- data$provinceHumanGroundTruth
# missing <- is.na(data$province)
# data$province[missing] <- data$provinceFromPostalCode[missing] #if we don't have human ground truth, use data from postal code
# 
# data$city <- data$cityFromPostalCode

#data <- data[,-match(c("cityFromPostalCode", "provinceFromPostalCode", "provinceHumanGroundTruth"), names(data))]

data$contribution_amount_dollars <- data$contribution_amount/100

#data <- data[sample(nrow(data), 1e5),]

#remove special characters
char_col <- c("party_name", "province", "city", "target_riding", "contributors_riding_name", "party_riding", "full_name")
data[, char_col] <- apply(data[,char_col], MARGIN=2, FUN=coerce_to_alpha)

save(file='data/data', list='data')