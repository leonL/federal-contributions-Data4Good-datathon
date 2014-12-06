library(googleVis)
library(dplyr)

load('data/data')
source('helper_functions/sort_by_count.R')
make_na_last <- function(x) c(x[!is.na(x), 'N/A'])

#presets
province <- sort_by_count(data, 'province') %>% make_na_last
city <- sort_by_count(data, 'city') %>% make_na_last
target_riding <- sort_by_count(data, 'target_riding') %>% make_na_last

source('helper_functions/format_numbers.R')
source('helper_functions/give_nice_names.R')

nice_names <- list(party_name = 'Party Name',
                   province = 'Province',
                   city = 'City',
                   flag.blank_contrib = 'Federal Cont.',
                   target_riding = 'Riding',
                   n = 'Number of Contributions',
                   avg_contribution = 'Average Cont.',
                   total_contribution = 'Total Cont.',
                   date = 'Date',
                   date_year = 'Date-Year',
                   date_year_month = 'Date-Month'
                   )

cohort_selection <- c('None', 
                      'Party Name', 'Province', 'City', 'Federal Cont.', 'Riding')

cohort_id <- c('coh1', 'coh2', 'coh3', 'coh4')

filter_id <- c("party_name", "province", "city", "flag.blank_contrib", "target_riding")

dat_filter <- c('date_coh')