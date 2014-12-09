library(googleVis)
library(dplyr)
library(rCharts)

load('data/data')

source('helper_functions/format_numbers.R')
source('helper_functions/give_nice_names.R')

nice_names <- list(party_name = 'Party Name',
                   province = 'Province',
                   city = 'City',
                   flag.blank_contrib = 'Federal Cont.',
                   target_riding = 'Riding',
                   n = 'Number of Contributions',
                   avg_3contribution = 'Average Cont.',
                   total_contribution = 'Total Cont.',
                   date = 'Date',
                   date_year = 'Date-Year',
                   date_year_month = 'Date-Month',
                   contributor_id = 'Contributor ID',
                   full_name = 'Full Name',
                   contribution_amount_dollars = 'Amount'
                   )

cohort_selection <- c('None', 
                      'Party Name', 'Province', 'City', 'Federal Cont.', 'Riding')

cohort_id <- c('coh1', 'coh2', 'coh3', 'coh4')

filter_id <- c("party_name", "province", "city", "flag.blank_contrib", "target_riding")

dat_filter <- c('date_coh')

data_to_json <- function(data, col_to_json=NULL, col_names=NULL) {
  
  if(!is.null(col_to_json)) {
    if(length(col_to_json)==1) {
      data <- data[col_to_json] 
    } else {
      data <- data[,col_to_json] 
    }
  }
  
  lapply(1:nrow(data), function(i) { 
    res <- as.list(data[i,]) 
    names(res) <- col_names
    return(res)
  })
}
