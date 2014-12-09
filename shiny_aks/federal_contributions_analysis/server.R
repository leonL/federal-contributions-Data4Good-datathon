shinyServer(function(input, output) {
  
  
  
  filter_table_data <- reactive({
    
    # Filter date
    data_f <- data[data$date >= as.character(input$date[1]) & data$date <= as.character(input$date[2]),]
    
    
    for(f in filter_id) {
      if(!'All' %in% input[[f]]) {
          filter <- paste0('data_f <- filter(data_f, ', f, ' %in% c("', paste(input[[f]], collapse='","'), '"))')
          eval(parse(text=filter))
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
    
    return(list(data_final = data_final,
                grouping_variables = grouping_variables
    ))
    
  })
  
  output$table <- renderGvis({
    data_final <- final_table_data()$data_final %>%
      data.frame() %>%
      format_numbers(name_list = c('avg_contribution', 'total_contribution', 'n', 'contribution_amount_dollars'),
                     currency_list = c('avg_contribution', 'total_contribution', 'contribution_amount_dollars'), 
                     percentage_list = c()
      ) %>%
      give_nice_names(nice_names)
    gvisTable(data_final, options = list(page='enable', pageSize=30, bSort=FALSE), chartid = 'table')
    
  })
  
  output$graph <- renderChart2({
    
    validate(
      need(input$date_coh != 'None', 'Need time cohort')
    )
    
    validate(
      need(input$aggregation == 'Aggregated', 'Only works on Aggregated level')
    )
    
    data_final <- final_table_data()$data_final %>%
      data.frame()
    grouping_variables <- final_table_data()$grouping_variables
    
    last_filter_ind <- sum(names(data_final) %in% grouping_variables)
    
    if(last_filter_ind>1) {
      from <- 2
      data_final$cohorts_all <- apply(data_final[from:last_filter_ind], 1, paste, collapse="//")
      
    } else {
      data_final$cohorts_all <- 1
      
    }
    
    #data_final$cohorts_all <- apply(data_final[from:last_filter_ind], 1, paste, collapse="//")
    
    p <- Highcharts$new()
    p$chart(type='line')
    
    p$xAxis(categories = sort(unique(data_final[,1])), tickInterval=2, title=list(text='Time'))
    p$yAxis(title=list(text='Total Contribution'))
    p$title(text='Graph')
    p$legend(align = "right", verticalAlign = "right", layout = "vertical")
    
    
    for(c in unique(data_final$cohorts_all)) {
      
      temp <- filter(data_final, cohorts_all==c) %>%
        arrange_(names(data_final)[1])
      
      lines <- data_to_json(temp, col_to_json = c('total_contribution'), col_names = 'y') %>%
        p$series(data=.,
                 zIndex=1,
                 name=c,
                 marker=list(enabled=FALSE)
        )
      
    }
    return(p)
    
    
  })
  
  # Observer to control for widget selections
  observe({
    
    
  })
  
})