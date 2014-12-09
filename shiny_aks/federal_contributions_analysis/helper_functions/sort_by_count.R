sort_by_count <- function(data, col_name){
  (data %>% 
     group_by_(col_name) %>% 
     summarize(n=n()) %>% 
     arrange(-n) %>% 
     select_(col_name) %>% 
     data.frame)[,1]
}
