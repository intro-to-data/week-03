## Get MPG
## A script written for the Intro To Data Class to download and process
## actual EPA data and make it available for class.


# SETUP ========================================================================
# Loads any packages, defines variables needed later.
library(tidyverse)
library(readxl)

data_url <- "https://www.fueleconomy.gov/feg/epadata/20data.zip"
local_file <- "mpg2020.zip"


# DATA =========================================================================

# Downloads the data as a ZIP file and unzips it locally.
download.file(url = data_url, destfile = local_file)
unzip(local_file)

# Opens the ZIP file and imports the data.
data_file <- dir(pattern = "xlsx")
if (length(data_file) == 1) {
  mpg2020 <- read_excel(data_file)
} else {
  stop("The ZIP file contains more than one Excel file.")
}


# TIDY =========================================================================
attributes(mpg2020)$labels <- names(mpg2020)
col_names <- names(mpg2020)

## Generic Changes
col_names <- gsub("- Conventional Fuel", "", col_names, fixed = TRUE)
col_names <- gsub("- Alternative Fuel", "", col_names, fixed = TRUE)
col_names <- gsub(" ", "", col_names, fixed = TRUE)
col_names <- gsub(".", "", col_names, fixed = TRUE)
col_names <- gsub("?", "", col_names, fixed = TRUE)
col_names <- gsub(",", "", col_names, fixed = TRUE)
col_names <- gsub("-", "", col_names, fixed = TRUE)
col_names <- gsub("(", "", col_names, fixed = TRUE)
col_names <- gsub(")", "", col_names, fixed = TRUE)
col_names <- gsub("=", "", col_names, fixed = TRUE)
col_names <- gsub("%", "", col_names, fixed = TRUE)
col_names <- gsub("#", "N", col_names, fixed = TRUE)


# Specific Tweaks
col_names[6] <- "Indexed"
col_names[10] <- "City"
col_names[11] <- "Hwy"
col_names[12] <- "Comb"
col_names[13] <- "CityUnadj"
col_names[14] <- "HwyUnadj"
col_names[15] <- "CombUnadj"
col_names[16] <- "CityUnrdUnadj"
col_names[17] <- "HwyUnrdUnadj"
col_names[18] <- "CombUnrdUnadj"
col_names[19] <- "Guzzler"
col_names[30] <- "MaxEthanolGasoline"
col_names[31] <- "MaxBiodiesel"
col_names[32] <- "Range1CF"
col_names[33] <- "FuelUsageCF"
col_names[151] <- "MoneySaved5Year"
col_names[152] <- "MoneySpend5Year"
col_names[157] <- "ChargeTimeat240volts"
col_names[158] <- "ChargeTimeat120volts"
col_names[159] <- "PHEVRange"

# Fix it up.
names(mpg2020) <- col_names


# SAVE & CLEAN UP ==============================================================
write_csv(mpg2020, "data/mpg2020.csv")
unlink(local_file)
unlink(data_file)
