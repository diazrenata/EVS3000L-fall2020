# Modifications of https://www.neonscience.org/osis-pheno-temp-series and Modified_code_R_NEON-pheno-temp-timeseries_03-plot-discrete-continuous-data-pheno-temp.R to run on UFApps

##### From RMD - Setting working directories for UFApps
setwd("~")

if(!dir.exists("EVS3000L")) {
  dir.create("EVS3000L")
}

if(!dir.exists("EVS3000L/week6")) {
  dir.create("EVS3000L/week6")
}

setwd("EVS3000L/week6/")

install.packages("gridExtra")


# Load required libraries
library(ggplot2)
library(dplyr)
library(gridExtra)
library(scales) # From RMD

options(stringsAsFactors=F) #keep strings as character type not factors

temp_day <- read.csv('NEON-pheno-temp-timeseries_v2/NEON-pheno-temp-timeseries/NEONsaat_daily_SCBI_2018.csv') # RMD modified paths

phe_1sp_2018 <- read.csv('NEON-pheno-temp-timeseries_v2/NEON-pheno-temp-timeseries/NEONpheno_LITU_Leaves_SCBI_2018.csv') # RMD modified paths


# Convert dates
temp_day$Date <- as.Date(temp_day$Date)
# use dateStat - the date the phenophase status was recorded
phe_1sp_2018$dateStat <- as.Date(phe_1sp_2018$dateStat)


## ----stacked-plots----------------------------------------------------------------------------
# first, create one plot 
phenoPlot <- ggplot(phe_1sp_2018, aes(dateStat, countYes)) +
  geom_bar(stat="identity", na.rm = TRUE) +
  ggtitle("Total Individuals in Leaf") +
  xlab("") + ylab("Number of Individuals")

# create second plot of interest
tempPlot_dayMax <- ggplot(temp_day, aes(Date, dayMax)) +
  geom_point() +
  ggtitle("Daily Max Air Temperature") +
  xlab("Date") + ylab("Temp (C)")

# Then arrange the plots - this can be done with >2 plots as well.
grid.arrange(phenoPlot, tempPlot_dayMax) 



## ----format-x-axis-labels---------------------------------------------------------------------
# format x-axis: dates
phenoPlot <- phenoPlot + 
  (scale_x_date(breaks = date_breaks("1 month"), labels = date_format("%b")))

tempPlot_dayMax <- tempPlot_dayMax +
  (scale_x_date(breaks = date_breaks("1 month"), labels = date_format("%b")))

grid.arrange(phenoPlot, tempPlot_dayMax) 



## ----set-x-axis-------------------------------------------------------------------------------
# first, lets recreate the full plot and add in the 
phenoPlot_setX <- ggplot(phe_1sp_2018, aes(dateStat, countYes)) +
  geom_bar(stat="identity", na.rm = TRUE) +
  ggtitle("Total Individuals in Leaf") +
  xlab("") + ylab("Number of Individuals") +
  scale_x_date(breaks = date_breaks("1 month"), 
               labels = date_format("%b"),
               limits = as.Date(c('2018-01-01','2018-12-31')))

# create second plot of interest
tempPlot_dayMax_setX <- ggplot(temp_day, aes(Date, dayMax)) +
  geom_point() +
  ggtitle("Daily Max Air Temperature") +
  xlab("Date") + ylab("Temp (C)") +
  scale_x_date(date_breaks = "1 month", 
               labels=date_format("%b"),
               limits = as.Date(c('2018-01-01','2018-12-31')))

# Plot
grid.arrange(phenoPlot_setX, tempPlot_dayMax_setX) 


## ----align-datasets-replot--------------------------------------------------------------------
# filter to only having overlapping data
temp_day_filt <- filter(temp_day, Date >= min(phe_1sp_2018$date) & 
                          Date <= max(phe_1sp_2018$date))

# Check 
range(phe_1sp_2018$date)
range(temp_day_fit$Date)

#plot again
tempPlot_dayMaxFiltered <- ggplot(temp_day_filt, aes(Date, dayMax)) +
  geom_point() +
  scale_x_date(breaks = date_breaks("months"), labels = date_format("%b")) +
  ggtitle("Daily Max Air Temperature") +
  xlab("Date") + ylab("Temp (C)")


grid.arrange(phenoPlot, tempPlot_dayMaxFiltered)


##### From RMD - Saving plots for submission
jpeg("pheno_and_temp.jpg")
grid.arrange(phenoPlot_setX, tempPlot_dayMax_setX) 
dev.off()