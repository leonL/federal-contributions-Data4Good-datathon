shinyServer(function(input, output) {
  

  
  filter_table_data <- reactive({
    
    # Filter date
    data_f <- data[data$date >= as.character(input$date[1]) & data$date <= as.character(input$date[2]),]
    
    
    for(f in filter_id) {
      if(input[[f]] != 'All') {
        data_f <- data_f %>%
          filter_(f %in% input[[f]])        
      }
      
    }  
    
    return(data_f)
    
  })
  
  cohort_table_data <- reactive({
    
    data_c <- filter_table_data()
    
    grouping_variables <- c()
    date_input <- input[['date_coh']]
    
    if(date_input == 'Year') {
      grouping_variables <- c(grouping_variables, 'date_year')
  
    } else if(date_input == 'Year-Month') {
      grouping_variables <- c(grouping_variables, 'date_year_month')
      
    } else if(date_input == 'Year-Month-Day') {
      grouping_variables <- c(grouping_variables, 'date')
      
    }
    
    for(c in cohort_id) {
      if(input[[c]] != 'None') {
        column_name <- names(nice_names[nice_names == input[[c]]])
        grouping_variables <- c(grouping_variables, column_name)
        
      }  
    }
    
    if(length(grouping_variables) != 0) {
      grouping <- paste0('data_c <- group_by(data_c, ', paste(grouping_variables, collapse=', '), ')')
      eval(parse(text=grouping))
      
    }
    
    return(list(data_c = data_c,
                grouping_variables = grouping_variables))
    
  })
  
  final_table_data <- reactive({
    
    data_c <- cohort_table_data()$data_c
    grouping_variables <- cohort_table_data()$grouping_variables 
    variables_selected <- c('contributor_id', 'full_name', 'contribution_amount_dollars')
    
    number_of_records <- input[['number_records']]
    
    if(input[['aggregation']] == 'Aggregated') {
      data_final <- data_c %>%
        summarize(n = n(),
                  total_contribution = sum(contribution_amount_dollars, na.rm = TRUE))
      
    } else if(input[['aggregation']] == 'Individual') {
      data_final <- data_c %>%    
        arrange(desc(contribution_amount_dollars)) %>%
        mutate(rank = dense_rank(-contribution_amount_dollars)) %>%
        filter(rank <= number_of_records)
        
        if(length(grouping_variables) != 0) {
          selecting <- paste0('data_final <- select(data_final, ', paste(c(grouping_variables, variables_selected), collapse = ', '), ')')
          
        } else {
         selecting <- paste0('data_final <- select(data_final, ', paste(variables_selected, collapse = ', '), ')')
      
        }  
      
      eval(parse(text=selecting))
      
    }
    
    return(data_final)
    
  })
  
  output$table <- renderGvis({
    data_final <- final_table_data() %>%
      data.frame() %>%
      format_numbers(name_list = c('avg_contribution', 'total_contribution', 'n', 'contribution_amount_dollars'),
                     currency_list = c('avg_contribution', 'total_contribution', 'contribution_amount_dollars'), 
                     percentage_list = c()
                      ) %>%
      give_nice_names(nice_names)
    gvisTable(data_final, options = list(), chartid = 'table')
    
  })
  
  # Observer to control for widget selections
  observe({
    
    
  })
  
})