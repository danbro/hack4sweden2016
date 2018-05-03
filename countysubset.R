# create a list of data frames subsetted by Swedish counties

# load data frame
load("stationsdf.Rda")
stationsdf$County <- as.factor(stationsdf$County)
stationsli <- vector("list", 21)
names(stationsli) <- unique(stationsdf$County)

countySubset <- function(county) {
  result <- subset(stationsdf, County == county)
  return(result)
}

for (i in 1:21) {
  stationsli[[i]] <- countySubset(names(stationsli)[i])
}

# save list
save(stationsli, file = "stationsli.Rda")