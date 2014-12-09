#'@title 
#'Give Nice Names
#'
#'@description 
#'This function changes data.frame column names to specified nice names
#'
#'
#'@param data is a data.frame
#'@param name_list a list where key is an ugly_name and value is a nice_name
#'
#'@examples
#'data <- data.frame(ugly1 = runif(10), ugly2 = runif(10))
#'nice_names <- list(ugly1 = 'Very Nice 1', ugly2 = 'Very Nice 2')
#'data <- give_nice_names(data, nice_names)
#'
#'@export

give_nice_names <- function(data, name_list) {
  for(name in names(data)) {
    if(name %in% names(name_list)) {      
      name_data_index <- which(names(data)==name)      
      names(data)[name_data_index] <- name_list[[name]]
    }
  }
  return(data)
}