# NEON + UF EnvironmentaL Science Lab Class
# Oct. 5, 2020
# NEON Data Download Example
# Felipe Sanchez, fsanchez@battelleecology.org

##### From RMD - Setting working directories for UFApps

setwd("~")

if(!dir.exists("EVS3000L")) {
  dir.create("EVS3000L")
}

if(!dir.exists("EVS3000L/week6")) {
  dir.create("EVS3000L/week6")
}

setwd("EVS3000L/week6/")

# Part 1) Loading BARC temperature data downloaded from the NEON Portal
# using stackByTable and readTableNEON.
# 
# stackByTable(filepath = "NEON_temp-air-single.zip",
#              savepath = "BARCTempData", saveUnzippedFiles = T)
# 
# BARC_temp <- readTableNEON(
#   dataFile = "BARCTempData/stackedFiles/SAAT_30min.csv",
#   varFile = "BARCTempData/stackedFiles/variables_00002.csv")
# 
# Part 2) Dowloading FLNT temperature data from the NEON Portal 
# via NEON API wrapper zipsByProduct, and loading using
# stackBytable and readTableNEON.
# 
# zipsByProduct(dpID = "DP1.00002.001", site = "FLNT",
#               startdate = "2019-11", enddate = "2019-12",
#               package = "basic", check.size = T)
# 
# stackByTable(filepath = "filesToStack00002",
#              savepath = "FLNT_all_temp")
# 
# FLNT_temp <- readTableNEON(
#   dataFile = "FLNT_all_temp/stackedFiles/SAAT_30min.csv",
#   varFile = "FLNT_all_temp/stackedFiles/variables_00002.csv")

# Part 3) Downloading and loading SUGG,BARC,and FLNT temperature data 
# using loadbyProduct downloaded from the NEON Portal

Temp_SBF <- loadByProduct(dpID = "DP1.00002.001", site =c("SUGG","BARC","FLNT"),
                          startdate = "2019-11", enddate = "2019-12",
                          package = "basic", avg = 30, check.size =F )

# Extract all dataframes from the list object created from loadByProduct()

list2env(Temp_SBF, .GlobalEnv)


View(SAAT_30min)

Temp_all_sites <- SAAT_30min

table(Temp_all_sites$siteID)

#Plot temperature data for all three sites
ggplot(Temp_all_sites, aes(x=startDateTime, y=tempSingleMean,color = siteID))+
  geom_line()+
  ggtitle("30 min Mean Single Aspirated Temperature at D03 BARC,SUGG,and FLNT sites")+
  xlab("Date")+ylab("Temperature (C)")



