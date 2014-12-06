shinyUI(fluidPage(
  
  fluidRow(
    fluidRow(
      column(12,
             fluidRow(
               column(8,
                      h4('a8')
               ),
               column(2,
                      wellPanel(
                        dateRangeInput(inputId = 'date', 
                                       label = 'Select Date Range', 
                                       start = min(data$date), 
                                       end = max(data$date), 
                                       min = min(data$date), 
                                       max = max(data$date)),
                        selectizeInput('party_name', 'Party Name', c('All', unique(data$party_name)), 'All', multiple=TRUE),
                        selectizeInput('province', 'Province', c('All', unique(data$province)), 'All', multiple=TRUE),
                        selectizeInput('city', 'City', c('All', unique(data$city)), 'All', multiple=TRUE),
                        selectizeInput('flag.blank_contrib', 'Federal Contribution', c('All', unique(data$flag.blank_contrib)), 'All', multiple=TRUE),
                        selectizeInput('target_riding', 'Riding', c('All', unique(data$target_riding)), 'All', multiple=TRUE)
                        )                      
               ),
               column(2,
                      wellPanel(
                        selectizeInput('date_coh', 'Choose Date Cohort', c('Year', 'Year-Month', 'Year-Month_Day'), multiple=FALSE),
                        selectizeInput('coh1', 'Cohort 1', cohort_selection, multiple=FALSE),
                        selectizeInput('coh2', 'Cohort 2', cohort_selection, multiple=FALSE),
                        selectizeInput('coh3', 'Cohort 3', cohort_selection, multiple=FALSE),
                        selectizeInput('coh3', 'Cohort 3', cohort_selection, multiple=FALSE)
                        
                        
                        )
               )               
             )         
      )
    )
  )
))