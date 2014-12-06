
# Assuming the data formats are unchanged.
g_2004 = read.csv("/home/kry/repos/Data for Good/Samathar/federal-contributions-master/as submitted/Green/Green Party.2004.csv", header = FALSE)
g_2005 = read.csv("/home/kry/repos/Data for Good/Samathar/federal-contributions-master/as submitted/Green/Green Party.2005.csv", header = FALSE)

colnames(g_2004)[8] = "PostCode"
colnames(g_2005)[8] = "PostCode"

g_2004$PostCode = as.character(g_2004$PostCode)
g_2005$PostCode = as.character(g_2005$PostCode)


# download zipcodeset.txt from
# http://geocoder.ca/?freedata=1
zipCode = read.table("/home/kry/repos/Data for Good/Samathar/federal-contributions-master/as submitted/zipcodeset.txt", header = FALSE, fill = TRUE, sep = ",")
colnames(zipCode) = c("PostCode", "Longitude", "Latitude","City","Province")
zipCode$PostCode = as.character(zipCode$PostCode)

library(plyr)

enriched_g_2004 = join(g_2004, zipCode, by = PostCode, type = "left", match = "all")
enriched_g_2005 = join(g_2005, zipCode, by = PostCode, type = "left", match = "all")



