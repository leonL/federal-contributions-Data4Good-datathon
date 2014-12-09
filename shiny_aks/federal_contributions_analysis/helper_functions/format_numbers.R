#'@title 
#'Format Numbers
#'
#'@description 
#'This function formats numbers
#'
#'@details
#'This function adds $ to currency variables, % to percentage variable, 
#'adds thousands separator to numbers greater than 999 and rounds number to specified decimal places.
#'Should be used \strong{before} \code{\link[ukenChisel]{give_nice_names}}
#'
#'@param data data.frame with the data
#'@param name_list list or vector of variables that need to be formatted
#'@param currency_list vector of variables that show currency values
#'@param percentage_list vector of variables that are proportions
#'@param decimal_places decimal places to keep
#'
#'@export

format_numbers <- function(data, name_list=NULL, currency_list=NULL, percentage_list=NULL, decimal_places=2) {
  if(is.null(name_list)) {
    names <- c(currency_list, percentage_list)
  } else {
    if(is.list(name_list)) {
      names <- names(name_list)
    } else {
      names <- name_list
    }
  }
  
  for(name in names(data)) {
    if(name %in% names) {
      data[,name] <- as.numeric(data[,name])
      try(data[, name][which(data[, name] > 100)] <- round(data[, name][which(data[, name] > 100)]), silent = TRUE)
      try(data[, name][which(data[, name] < 100)] <- round(data[, name][which(data[, name] < 100)], decimal_places), silent = TRUE)
      
      if(name %in% currency_list & !is.null(currency_list)) {
        try(data[, name] <- paste0('$', format(as.numeric(data[, name]), big.mark=',', scientific=FALSE)), silent=T)
        
      } else if (name %in% percentage_list & !is.null(percentage_list))  { 
        try(data[, name] <- paste0(format(as.numeric(data[, name]), big.mark=',', scientific=FALSE), '%'), silent=T)
        
      } else {
        try(data[, name] <- format(as.numeric(data[, name]), big.mark=',', scientific=FALSE), silent=T)
      }     
    }
  }
  
  return(data)
  
}