#setting working directory
Bison <- read.table("bison_local.txt", sep = "\t", header = TRUE, fill = TRUE, quote = "")

#reduce the dataset to latitude and longitude
Bison <- Bison[, c("decimallongitude", "decimallatitude")]

Bison <- na.omit(Bison) #Remove any values where latitude or longitude coordinates are NA

#only keep unique values - removes duplicate rows
Bison <- unique(Bison)