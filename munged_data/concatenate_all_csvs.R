library("GetoptLong")

official_party_names <-
  c(Bloc="Bloc Québécois",
    Conservative="Conservative Party of Canada",
    Green="Green Party of Canada",
    Liberal="Liberal Party of Canada",
    NDP="New Democratic Party")

subfolders <- names(official_party_names)

data_set <- data.frame()

for(subfolder in subfolders) {
  files <- list.files(subfolder)

  print(GetoptLong::qq("Concatenating CSVs in subfolder @{subfolder}..."))
  for(file in files) {
    print(file)
    current_year <- strsplit(file, ".", fixed=TRUE)[[1]][2]

    csv <- read.csv(
      GetoptLong::qq("@{subfolder}/@{file}"), encoding="UTF-8"
    )
    data_set <- rbind(data_set, csv)
  }
}

write.csv(
  data_set, file="all_contributions_2004_to_2013.csv", row.names=FALSE
)