tcreditcalc <- function(donation){

#setwd("C:/datathon/federal-contributions-analysis-master/munged_data")
#see more info at http://www.elections.ca/content.aspx?section=res&dir=ces&document=part6&lang=e
#section Tax Credits for Political Contributions

#donation is the amount of donation per person per year

if (donation <= 40000){ 
    credits <- donation * 0.75
    } else if (donation <= 75000){
    credits <- 40000 * 0.75 + (donation - 40000)* 0.50    
    } else credits <- 40000 * 0.75 + 35000 * 0.50 + min((donation - 75000)* 1/3,65000)

return(credits)
}  
  


