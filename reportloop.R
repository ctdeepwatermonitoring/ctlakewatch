# script for generating lake watch reports on a loop
# setwd("P:/R/ctlakewatch/reports")

library(dplyr)
library(rmarkdown)

stations <- read.csv("stations.csv") # manually tweaking stations file due to data sources
siteIDs <- unique(stations$MonitoringLocationName) # my loop variables

for (i in siteIDs) {
  # filter stations to current iteration
  station <- filter(stations, MonitoringLocationName == i)
  # get comID and stationID for loop params
  comID <- unique(station$ComID) # unique means it wont break for multiple stations per waterbody
  stationID <- unique(station$MonitoringLocationName)
  maxDepth <- unique(station$MaxDepth)
  # base file to modify
  base <- readLines("C:/Users/deepuser/Documents/Projects/ProgramDev/ctlakewatch/lakewatchReportv2.Rmd")
  # replace the station
  base <- gsub("SiteID: .*", paste("SiteID:", stationID), base)
  # replace the depth
  base <- gsub("MaxDepth: .*", paste("MaxDepth:", maxDepth), base)
  # write files to reports subfolder
  lfPath <- "C:/Users/deepuser/Documents/Projects/ProgramDev/ctlakewatch/"
  outputFile <- file.path(lfPath, paste0(comID, ".Rmd"))
  writeLines(base, outputFile)
  # render rmd file
  render(input = outputFile, 
         output_file = file.path(paste0(lfPath,"reports"), paste0(comID, ".html")),
         output_format = "html_document")  
}

