# creating plot for contribution by party over time

## load the libraries required
library(scales)
library("data.table")
library(zoo)
library("reshape2")
library("ggplot2")



# read in the data set
data_set <- read.csv("all_contributions_2004_to_2013.csv")



# transforming the data
## change the contribution amounts into dollars 
data_set <- transform(data_set, contribution.amount.dollars = contribution_amount / 100)

## convert the dates
data_set <- transform(data_set, year.month.day = 
                              as.Date(as.POSIXlt(data_set$contribution_date.adjusted)))
data_set$contribution.year.month <- as.yearmon(data_set$year.month.day, "%b %Y")

### assumption (federal and riding both go to federal)



# load data into data table
dt <- data.table(data_set)



# summarize data 
dt.sum <- dt[,list(contribution.amount.dollars=sum(contribution.amount.dollars)), 
             by=list(party_name, contribution.year.month, province, city)]

dt.sum[,list(contribution.amount.dollars=sum(contribution.amount.dollars)), by=list(party_name)]

## summarize by party and contribution year/month
dt.party.time <- dt.sum[,list(contribution.amount.dollars=sum(contribution.amount.dollars)), 
                        by=list(party_name, contribution.year.month)]

### convert date format
dt.party.time$contribution.year.month <- as.Date(dt.party.time$contribution.year.month)

dt.party.time.melt <- melt(dt.party.time, 
                           id.vars = c("party_name", "contribution.year.month"), 
                           measure.vars = "contribution.amount.dollars")



# establish election dates
## federal
fed.election.dates <- as.Date(c("2004-06-28", "2006-01-23", "2008-10-14", 
                                "2011-05-02"))

## provincial
by.elections <- read.csv(file="by_election_dates.csv", header=TRUE)
by.election.dates <- unique(as.Date(by.elections$Date))



# setup plotting colours by party
party.palette <- c("pink", "blue", "green", "red", "orange")



# create plot
ggplot(dt.party.time.melt, aes(x=contribution.year.month, y=value, 
                                    group = party_name, colour = party_name)) +
        geom_line() +
        geom_point( size=1, shape=21, fill="white") +
        scale_colour_manual(values=party.palette) +
        labs(title="Contributions by Party by Year", x="Year", 
             y="Contribution in CDN Dollars", colour = "Party") +
        geom_vline(xintercept = as.numeric(fed.election.dates)) ## +
        ## by elections        geom_vline(xintercept = as.numeric(by.election.dates), colour = "blue")



# does santa contribute to any political parties?
santa <- data_set[grep("H0H0H0", data_set$postal_code), ]

### looks like there is and she's a liberal



# what party gets the most contribution from estates?

estate <- data_set[grep("Estate", data_set$full_name),]
write.csv(estate, file="donations_from_estates.csv", row.names=FALSE)