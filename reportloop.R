#script for generating lake watch reports on a loop
setwd("P:/R/ctlakewatch/reports")

library(dplyr)
library(rmarkdown)

stations <- read.csv("stations.csv")
siteIDs <- unique(stations$MonitoringLocationName) # my loop variables

for (i in siteIDs) {
  # filter stations to current iteration
  station <- filter(stations, MonitoringLocationName == i)
  
  # get comID and stationID for loop params
  comID <- unique(station$ComID) # unique means it wont break for multiple stations per waterbody
  stationID <- unique(station$MonitoringLocationName)
  
  # base file to modify
  base <- readLines("lakewatchReportv2.Rmd")
  
  # replace the parameter
  base <- gsub("SiteID: .*", paste("SiteID:", stationID), base)
  
  # write files to reports subfolder
  outputFile <- file.path("P:/R/ctlakewatch/reports", paste0(comID, ".Rmd"))
  writeLines(base, outputFile)
  
  # render rmd file
  render(input = outputFile, 
         output_file = file.path("P:/R/ctlakewatch/reports", paste0(comID, ".html")),
         output_format = "html_document")  # Adjust output_format as needed
}