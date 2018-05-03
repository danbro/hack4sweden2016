# Read lat and lon of stations from csv file and match them to respective Swedish counties
# Data source http://opendata-download-metobs.smhi.se/explore/#
# between 2015-01-01 to 2015-12-31

# Uncomment to set locale for Swedish characters
# Sys.setlocale(category = "LC_ALL", locale = "sv_SE.UTF-8")

file <- 'data/test_sites_nederbord_manadssumma_view.csv'
df <- read.csv2(file, stringsAsFactors = FALSE)
df$Latitud <- as.numeric(df$Latitud)
df$Longitud <- as.numeric(df$Longitud)
lat <- df$Latitud
lon <- df$Longitud

# match lat and lon to Swedish counties
county <- c(rep("",length(lat)))
for (i in 1:length(lat)) {
  county[i] <- SwedishCounty(lat[i],lon[i])
}

# create new data frame
stationsdf <- df
stationsdf$County <- county

# count number of non-matches
index_nomatch <- grep("No match was made", county)
num_nomatch <- length(index_nomatch)

# manually input data for no-match using google maps
stationsdf$County[index_nomatch[1]] <- 'Västerbotten'
stationsdf$County[index_nomatch[2]] <- 'Gotland'
stationsdf$County[index_nomatch[3]] <- 'Gotland'
stationsdf$County[index_nomatch[4]] <- 'Gävleborg'
stationsdf$County[index_nomatch[5]] <- 'Stockholm'
stationsdf$County[index_nomatch[6]] <- 'Stockholm'
stationsdf$County[index_nomatch[7]] <- 'Kalmar'
stationsdf$County[index_nomatch[8]] <- 'Kalmar'

# save new data frame
save(stationsdf, file = "data/stationsdf.Rda")