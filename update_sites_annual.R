basd <- "https://www.waterqualitydata.us/data/Result/search?"
bass <- "https://www.waterqualitydata.us/data/Station/search?" #my stations only
chr1 <- "characteristicName=Depth%2C%20Secchi%20disk%20depth"
chr2 <- "&characteristicName=Temperature%2C%20water"
proj <- "&project=Connecticut%20Lake%20Watch"
proj2 <- "&project=CTLakeWatch" #what i uploaded
sdat <- "&startDateLo=01-01-2021"
dprf <- "&dataProfile=resultPhysChem"
mime <- "&mimeType=csv"
zipt <- "&zip=no"
prvd <- "&providers=STORET"

data_http <- paste0(basd, chr1, chr2, proj, proj2, dprf, mime, zipt, prvd)
stations_http <- paste0(bass, chr1, proj, proj2, sdat, mime, zipt, prvd)

data <- read.csv(data_http)
wqx_stations <- read.csv(stations_http)
stations <- read.csv("stations.csv")

'%!in%' <- function(x,y)!('%in%'(x,y))

data <- data[ ,c(1,7,21,24,25,30,31,40,42,43)]
data <- data[data$ActivityStartDate > "2024-03-31",]
wqx_sites <- unique(data[c("MonitoringLocationIdentifier",
                           "MonitoringLocationName")])

new_sites <- wqx_sites[wqx_sites$MonitoringLocationIdentifier %!in% 
                         stations$MonitoringLocationIdentifier,]
new_sites <- merge(new_sites, wqx_stations[ ,c(3:5,12:13)], 
                   by = "MonitoringLocationIdentifier")

write.csv(new_sites, "new_rpt_sites_ctlakewatch_2024.csv", row.names = FALSE)