library(sqldf)
library(xts)
library(xlsx)
library(geoplot)



##Place where files are stored (point to your directory)
file_lib = '/home/kyle/Documents/Data4good/december/federal-contributions-analysis-master/munged_data'


##Party list
parties = c('Bloc','Conservative','Green','Liberal','NDP')

##Make big fat data frame
comprehensive_data_frame = NULL
##Loop to create objects
for(party in parties){
  step1 = paste0(file_lib,"/",party)
  step2 = list.files(step1)
  for( some_stuff in step2){
    temp_name = sub("_contributions.csv","",some_stuff)
    eval(parse(text=paste0(temp_name,"= read.csv(file='",paste0(step1,"/",some_stuff),"',header=TRUE)")))
  comprehensive_data_frame = rbind(comprehensive_data_frame,get(temp_name))
  }
}
##Append year
comprehensive_data_frame$year = as.numeric(substr(comprehensive_data_frame$contribution_date.adjusted,1,4))


##Objective 1 Total Contributions per person / year
for(i in 2004:2013){
  temp_1 = comprehensive_data_frame[comprehensive_data_frame$year==i,]
 # contributor_list = levels(as.factor(temp_1$contributor_id))
 eval(parse(text=paste0("contribs_",i,"= sqldf('select sum(contribution_amount)/100 as total_contribution,contributor_id,postal_code from temp_1 group by 2')")))
eval(parse(text=paste0("colnames(contribs_",i,") = c('total_contribution','contributor_id')")))
}

##Logic to check for da tax cheetah's
check_for_cheaters = function(x,year_limit){
 
  combined_matrix = sqldf('select contributor_id, count(distinct(full_name)) as number_of_people
, count(distinct(party_name)) as number_of_parties ,sum(contribution_amount) as total_contribution
from x group by 1')
  combined_matrix$max_contribution = 2*year_limit*combined_matrix$number_of_people*combined_matrix$number_of_parties
  combined_matrix$cheat_flag = ifelse(combined_matrix$total_contribution/100>combined_matrix$max_contribution,1,0)
  
  return(combined_matrix)
}


###Objective 1 ex estate
##Objective 1 Total Contributions per person / year
contribution_list = c(5000,5100,5200,1100,1100,1100,1100,1100,1200,1200)
for(i in 2004:2013){
  temp_1 = comprehensive_data_frame[comprehensive_data_frame$year==i,]
  temp_1 = temp_1[!grepl("Estate",temp_1$full_name),]
  # contributor_list = levels(as.factor(temp_1$contributor_id))
  eval(parse(text=paste0("contribs_ex_estate_",i,"= sqldf('select sum(contribution_amount)/100 as total_contribution,contributor_id,postal_code from temp_1 group by 2')")))
  ##Tax cheats per year
  
  year_lim=contribution_list[i-2003]
  eval(parse(text=paste0("contribs_ex_estate_",i,"$cheat_flag = ifelse(contribs_ex_estate_",i,"$total_contribution>2400,1,0)")))
  eval(parse(text=paste0("cheat_matrix_",i," = check_for_cheaters(temp_1,year_lim)")))

}

### Cheat results table
cheat_results_table = data.frame(year=2004:2013)
cheat_results_table$cheat_count = NA

for(i in 2004:2013){
  cheat_results_table[cheat_results_table$year==i,
                      ]$cheat_count = sum(get(paste0("cheat_matrix_",i))$cheat_flag)
  
}


## Objective 3 Seasonality

##Remove estates as dead people don't determine when they die
alive_comprehensive_data_frame = comprehensive_data_frame[!grepl("Estate",comprehensive_data_frame$full_name),]
colnames(alive_comprehensive_data_frame)[9] = 'contribution_date'
##Get total contributions on a given date
daily_contribs = sqldf('select sum(contribution_amount)/100 as daily_contribution, contribution_date
                       from alive_comprehensive_data_frame group by 2 ')

daily_contribs = xts(daily_contribs$daily_contribution,order.by=as.Date(daily_contribs$contribution_date))

daily_contribs_bloc = sqldf("select sum(contribution_amount)/100 as daily_contribution, contribution_date
                       from alive_comprehensive_data_frame where party_name = 'Bloc Québécois' group by 2")

daily_contribs_bloc = xts(daily_contribs_bloc$daily_contribution,order.by=as.Date(daily_contribs_bloc$contribution_date))

daily_contribs_cons = sqldf("select sum(contribution_amount)/100 as daily_contribution, contribution_date
                       from alive_comprehensive_data_frame where party_name = 'Conservative Party of Canada' group by 2")

daily_contribs_cons = xts(daily_contribs_cons$daily_contribution,order.by=as.Date(daily_contribs_cons$contribution_date))

daily_contribs_ndp = sqldf("select sum(contribution_amount)/100 as daily_contribution, contribution_date
                       from alive_comprehensive_data_frame where party_name = 'New Democratic Party' group by 2")

daily_contribs_ndp = xts(daily_contribs_ndp$daily_contribution,order.by=as.Date(daily_contribs_ndp$contribution_date))



daily_contribs_libs = sqldf("select sum(contribution_amount)/100 as daily_contribution, contribution_date
                       from alive_comprehensive_data_frame where party_name = 'Liberal Party of Canada' group by 2")

daily_contribs_libs = xts(daily_contribs_libs$daily_contribution,order.by=as.Date(daily_contribs_libs$contribution_date))

daily_contribs_green = sqldf("select sum(contribution_amount)/100 as daily_contribution, contribution_date
                       from alive_comprehensive_data_frame where party_name = 'Green Party of Canada' group by 2")

daily_contribs_green = xts(daily_contribs_green$daily_contribution,order.by=as.Date(daily_contribs_green$contribution_date))

all_contribs = merge.xts(daily_contribs_bloc,daily_contribs_cons,daily_contribs_green,daily_contribs_libs,daily_contribs_ndp)
colnames(all_contribs) = c('Bloc','Cons','Green','Libs','NDP')


###December effect for combined

ans_table = data.frame(year=2004:2013,matrix(nrow=10,ncol=5))
colnames(ans_table) = c('year',colnames(all_contribs))



for( year in 2004:2013){
  numerat0r = all_contribs[paste0(year,"-12-31")]
  denominator = colSums(all_contribs[paste0("./",year,"-12-30")],na.rm=T)
  ans_table[ans_table$year==year,2:6]=round(numerat0r/denominator,4)*100
  
  
  
}




##Remove estates as dead people don't determine when they die
##Seasonlality for ridings
alive_comprehensive_data_frame_riding = alive_comprehensive_data_frame[!alive_comprehensive_data_frame$federal_contribution,]
##Get total contributions on a given date
daily_contribs = sqldf('select sum(contribution_amount)/100 as daily_contribution, contribution_date
                       from alive_comprehensive_data_frame_riding group by 2 ')

daily_contribs = xts(daily_contribs$daily_contribution,order.by=as.Date(daily_contribs$contribution_date))

daily_contribs_bloc = sqldf("select sum(contribution_amount)/100 as daily_contribution, contribution_date
                            from alive_comprehensive_data_frame_riding where party_name = 'Bloc Québécois' group by 2")

daily_contribs_bloc = xts(daily_contribs_bloc$daily_contribution,order.by=as.Date(daily_contribs_bloc$contribution_date))

daily_contribs_cons = sqldf("select sum(contribution_amount)/100 as daily_contribution, contribution_date
                            from alive_comprehensive_data_frame_riding where party_name = 'Conservative Party of Canada' group by 2")

daily_contribs_cons = xts(daily_contribs_cons$daily_contribution,order.by=as.Date(daily_contribs_cons$contribution_date))

daily_contribs_ndp = sqldf("select sum(contribution_amount)/100 as daily_contribution, contribution_date
                           from alive_comprehensive_data_frame_riding where party_name = 'New Democratic Party' group by 2")

daily_contribs_ndp = xts(daily_contribs_ndp$daily_contribution,order.by=as.Date(daily_contribs_ndp$contribution_date))



daily_contribs_libs = sqldf("select sum(contribution_amount)/100 as daily_contribution, contribution_date
                            from alive_comprehensive_data_frame_riding where party_name = 'Liberal Party of Canada' group by 2")

daily_contribs_libs = xts(daily_contribs_libs$daily_contribution,order.by=as.Date(daily_contribs_libs$contribution_date))

daily_contribs_green = sqldf("select sum(contribution_amount)/100 as daily_contribution, contribution_date
                             from alive_comprehensive_data_frame_riding where party_name = 'Green Party of Canada' group by 2")

daily_contribs_green = xts(daily_contribs_green$daily_contribution,order.by=as.Date(daily_contribs_green$contribution_date))

all_contribs_riding = merge.xts(daily_contribs_bloc,daily_contribs_cons,daily_contribs_green,daily_contribs_libs,daily_contribs_ndp)
colnames(all_contribs_riding) = c('Bloc','Cons','Green','Libs','NDP')


###December effect for riding

ans_table_riding = data.frame(year=2004:2013,matrix(nrow=10,ncol=5))
colnames(ans_table_riding) = c('year',colnames(all_contribs_riding))



for( year in 2004:2013){
  numerat0r = all_contribs_riding[paste0(year,"-12-31")]
  denominator = colSums(all_contribs_riding[paste0("./",year,"-12-30")],na.rm=T)
  ans_table_riding[ans_table_riding$year==year,2:6]=round(numerat0r/denominator,4)*100
  
  
  
}



##Remove estates as dead people don't determine when they die
##Seasonliaty for the federal party
alive_comprehensive_data_frame_federal = alive_comprehensive_data_frame[alive_comprehensive_data_frame$federal_contribution,]
##Get total contributions on a given date
daily_contribs = sqldf('select sum(contribution_amount)/100 as daily_contribution, contribution_date
                       from alive_comprehensive_data_frame_federal group by 2 ')

daily_contribs = xts(daily_contribs$daily_contribution,order.by=as.Date(daily_contribs$contribution_date))

daily_contribs_bloc = sqldf("select sum(contribution_amount)/100 as daily_contribution, contribution_date
                            from alive_comprehensive_data_frame_federal where party_name = 'Bloc Québécois' group by 2")

daily_contribs_bloc = xts(daily_contribs_bloc$daily_contribution,order.by=as.Date(daily_contribs_bloc$contribution_date))

daily_contribs_cons = sqldf("select sum(contribution_amount)/100 as daily_contribution, contribution_date
                            from alive_comprehensive_data_frame_federal where party_name = 'Conservative Party of Canada' group by 2")

daily_contribs_cons = xts(daily_contribs_cons$daily_contribution,order.by=as.Date(daily_contribs_cons$contribution_date))

daily_contribs_ndp = sqldf("select sum(contribution_amount)/100 as daily_contribution, contribution_date
                           from alive_comprehensive_data_frame_federal where party_name = 'New Democratic Party' group by 2")

daily_contribs_ndp = xts(daily_contribs_ndp$daily_contribution,order.by=as.Date(daily_contribs_ndp$contribution_date))



daily_contribs_libs = sqldf("select sum(contribution_amount)/100 as daily_contribution, contribution_date
                            from alive_comprehensive_data_frame_federal where party_name = 'Liberal Party of Canada' group by 2")

daily_contribs_libs = xts(daily_contribs_libs$daily_contribution,order.by=as.Date(daily_contribs_libs$contribution_date))

daily_contribs_green = sqldf("select sum(contribution_amount)/100 as daily_contribution, contribution_date
                             from alive_comprehensive_data_frame_federal where party_name = 'Green Party of Canada' group by 2")

daily_contribs_green = xts(daily_contribs_green$daily_contribution,order.by=as.Date(daily_contribs_green$contribution_date))

all_contribs_federal = merge.xts(daily_contribs_bloc,daily_contribs_cons,daily_contribs_green,daily_contribs_libs,daily_contribs_ndp)
colnames(all_contribs_federal) = c('Bloc','Cons','Green','Libs','NDP')


###December effect for federal 

ans_table_federal = data.frame(year=2004:2013,matrix(nrow=10,ncol=5))
colnames(ans_table_federal) = c('year',colnames(all_contribs_federal))



for( year in 2004:2013){
  numerat0r = all_contribs_federal[paste0(year,"-12-31")]
  denominator = colSums(all_contribs_federal[paste0("./",year,"-12-30")],na.rm=T)
  ans_table_federal[ans_table_federal$year==year,2:6]=round(numerat0r/denominator,4)*100
  
  
  
}



###Load Census data

census_2006=read.csv(file="/home/kyle/Documents/Data4good/december/income2006_shared.csv",head=TRUE)
##Parse Strings
census_2006$Census_Area = substr(census_2006$Geography,1,3)
##clean out non cma
census_2006=census_2006[!is.na(as.numeric(substr(census_2006$Census_Area,2,2))),]
colnames(census_2006) = c('Geography','Populations','Immigrants','Employment_rate','Median_Income',
                          'Average_Income','Census_Area')

##Load GEO Data
raw_geo_data=read.csv(file="/home/kyle/Documents/Data4good/december/Canada.csv",header=FALSE,sep=",")
##Average location by FSA
colnames(raw_geo_data) = c('Postal_Code','Lat','Long','city','province')
raw_geo_data$FSA = substr(raw_geo_data$Postal_Code,1,3)
avg_geo_data = sqldf('select fsa,avg(Lat) as lat, avg(Long) as long from raw_geo_data group by 1')


##Compute geospacial averages and output
for(i in 2004:2013){
  temp_1 = comprehensive_data_frame[comprehensive_data_frame$year==i,]
  temp_1$fsa = substr(temp_1$postal_code,1,3)
  #   temp_1 = temp_1[!grepl("Estate",temp_1$full_name),]
  # contributor_list = levels(as.factor(temp_1$contributor_id))
  eval(parse(text=paste0("contribs_count_",i,"= sqldf('select count(distinct(contributor_id)) as count_of_contributors, avg(contribution_amount)/100 as avg_con, sum(contribution_amount)/100 as sum_contribution, fsa
                         from temp_1 group by fsa')")))
  eval(parse(text=paste0("contribs_count_",i,"= sqldf('select a.*,b.lat,b.long from contribs_count_",i," a left join avg_geo_data
                         b on a.fsa=b.fsa')")))
  
  
  
  ###CHANGE HERE FOR YOUR FOLDER
  eval(parse(text=paste0("write.csv(contribs_count_",i,"[!is.na(contribs_count_",i,"$lat),],
                       file='/home/kyle/Documents/Data4good/december/geo_data_",i,".csv')")))
}

some_data_in_2006 = sqldf('select a.*,b.Immigrants,b.Populations,b.Employment_Rate,
                          b.Median_Income,b.Average_Income,b.Census_Area, a.count_of_contributors/b.Populations pct_contrib_pop,a.avg_con/b.Average_Income pct_donation_income from contribs_count_2006 a 
                          left join census_2006 b on a.fsa = b.census_area')

##WORKBOOK OUTPUT CHANGE FILE LOCATIONS
write.csv(some_data_in_2006,file="/home/kyle/Documents/Data4good/december/donations_Census_2006.csv")
write.xlsx(ans_table,file="/home/kyle/Documents/Data4good/december/december_book.xlsx",sheetName='December effect')
write.xlsx(all_contribs,file="/home/kyle/Documents/Data4good/december/december_book.xlsx",sheetName='Donations_over_Time',append=TRUE)
write.xlsx(ans_table_riding,file="/home/kyle/Documents/Data4good/december/december_book.xlsx",sheetName='December effect riding',append=TRUE)
write.xlsx(ans_table_federal,file="/home/kyle/Documents/Data4good/december/december_book.xlsx",sheetName='December effect federal',append=TRUE)
write.xlsx(all_contribs_riding,file="/home/kyle/Documents/Data4good/december/december_book.xlsx",sheetName='Donations_over_Time_Riding',append=TRUE)
write.xlsx(all_contribs_federal,file="/home/kyle/Documents/Data4good/december/december_book.xlsx",sheetName='Donations_over_Time_Federal',append=TRUE)
write.xlsx(cheat_results_table,file="/home/kyle/Documents/Data4good/december/december_book.xlsx",sheetName='cheaters',append=TRUE)
