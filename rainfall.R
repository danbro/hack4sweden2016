# Download and average monthly rainfall data for year 2015 for all active weather stations

# load data with station numbers
load('data/stationsdf.Rda')
load('data/stationsli.Rda')
result <- data.frame(County = unique(stationsdf$County), Jan = 0, Feb = 0, Mar = 0, Apr = 0, Maj = 0, Jun = 0, Jul = 0, Aug = 0, Sep = 0, Okt = 0, Nov = 0, Dec = 0)

for (i in 1:21) {
  temp <- data.frame(Month = c("Jan","Feb","Mar","Apr","Maj","Jun","Jul","Aug","Sep","Okt","Nov", "Dec"))
  # Get measurements for each weather stations of county
  for (j in 1:dim(stationsli[[i]])[1]){
    currdf <- data.frame()
    URL <- paste("http://opendata-download-metobs.smhi.se/api/version/latest/parameter/23/station/",stationsli[[i]]$Stationsnummer[j],"/period/corrected-archive/data.csv",sep="")
    destfile <- paste("data/",stationsli[[i]]$Stationsnummer[j], ".csv", sep="")
    if(!file.exists(destfile)){
      download.file(URL, destfile)  # Download file if not already
    }
    currdf <- read.csv2(destfile, skip = grep(pattern="Datum",readLines(destfile))-1, stringsAsFactors = F)
    # subset values for time period of interest
    start <- grep('2015-01', currdf$Från.Datum.Tid..UTC.)
    stop <- grep('2015-12', currdf$Från.Datum.Tid..UTC.)
    # condition when data pattern of file is broken
    if (length(start) == 0 || length(stop) == 0) {
      temp[,j+1] <- rep(NA,12)
      names(temp)[j+1] <- stationsli[[i]]$Stationsnummer[j]
    } else if (length(start:stop) == 12) {
      temp[,j+1] <- as.numeric(currdf[start:stop, "Nederbördsmängd"])
      names(temp)[j+1] <- stationsli[[i]]$Stationsnummer[j]
    } else {
      temp[,j+1] <- rep(NA,12)
      names(temp)[j+1] <- stationsli[[i]]$Stationsnummer[j]
    }
  }
  # average accross county
  result[i,2:dim(result)[2]] <- rowMeans(temp[,2:dim(temp)[2]], na.rm = TRUE)
}

# normalize results and reshape data frame
xmax <- max(result[,2:13])
xmin <- min(result[,2:13])
result[,2:13] <- (result[,2:13] - xmin)/(xmax - xmin)
data <- data.frame(matrix(ncol = 22, nrow = 12))
names(data) <- c(('Date'), levels(result[,1]))
data$Date <- 1:12
data[,2] <- as.numeric(result[result$County == "Norrbotten", 2:13])
data[,3] <- as.numeric(result[result$County == "Västerbotten", 2:13])
data[,4] <- as.numeric(result[result$County == "Stockholm", 2:13])
data[,5] <- as.numeric(result[result$County == "Västra Götaland", 2:13])
data[,6] <- as.numeric(result[result$County == "Jämtland", 2:13])
data[,7] <- as.numeric(result[result$County == "Uppsala", 2:13])
data[,8] <- as.numeric(result[result$County == "Dalarna", 2:13])
data[,9] <- as.numeric(result[result$County == "Värmland", 2:13])
data[,10] <- as.numeric(result[result$County == "Örebro", 2:13])
data[,11] <- as.numeric(result[result$County == "Västernorrland", 2:13])
data[,12] <- as.numeric(result[result$County == "Gotland", 2:13])
data[,13] <- as.numeric(result[result$County == "Västmanland", 2:13])
data[,14] <- as.numeric(result[result$County == "Östergötland", 2:13])
data[,15] <- as.numeric(result[result$County == "Kronoberg", 2:13])
data[,16] <- as.numeric(result[result$County == "Halland", 2:13])
data[,17] <- as.numeric(result[result$County == "Skåne", 2:13])
data[,18] <- as.numeric(result[result$County == "Södermanland", 2:13])
data[,19] <- as.numeric(result[result$County == "Gävleborg", 2:13])
data[,20] <- as.numeric(result[result$County == "Blekinge", 2:13])
data[,21] <- as.numeric(result[result$County == "Kalmar", 2:13])
data[,22] <- as.numeric(result[result$County == "Jönköping", 2:13])

# save data frame
save(data, file = "data/data.Rda")