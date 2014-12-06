load('data/data')
source('helper_functions/sort_by_count.R')
make_na_last <- function(x) c(x[!is.na(x), 'N/A'])

#presets
province <- sort_by_count(data, 'province') %>% make_na_last
city <- sort_by_count(data, 'city') %>% make_na_last
target_riding <- sort_by_count(data, 'target_riding') %>% make_na_last

nice_names <- list(party_name = 'Party Name',
                   province = 'Province',
                   city = 'City',
                   federal_contribution = 'Federal Contribution',
                   target_riding = 'Riding'
                   )

cohort_selection <- c('None', 'Party Name', 'Province', 'City', 'Federal Contribution', 'Riding')

cohort_id <- c('coh1', 'coh2', 'coh3', 'coh4')
