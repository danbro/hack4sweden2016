# function that returns name of Swedish county in case of match
# to Swedish counties based on lat and lon input
# main assumptions:
# - rectangular borders used to delimit lat and lon area of counties
# - multiple matches handled by determining shortest distance to rectangle midpoint

SwedishCounty <- function(lat, lon){
  # creating rectangular borders to delimit counties
  # using google maps to manually find lat & lon coordinates
  rectangular_borders <- data.frame(county = 
                                      c('Blekinge','Dalarna','Gävleborg','Gotland','Halland',
                                        'Jämtland','Jönköping','Kalmar','Kronoberg','Norrbotten',
                                        'Örebro','Östergötland','Skåne','Södermanland','Stockholm',
                                        'Uppsala','Värmland','Västerbotten','Västernorrland',
                                        'Västmanland','Västra Götaland'),
                                    topleft_lat = 
                                      c(56.457557, 62.267900, 62.321581, 57.944764, 57.532348, 65.100525, 58.151824, 58.102824, 57.252840, 69.051090, 60.117255, 59.041126, 56.423101, 59.532372, 60.208527, 60.750114, 60.999882, 66.359484, 64.128184, 60.208307, 59.251240),
                                    topleft_lon = 
                                      c(14.409907, 12.042741, 14.555861, 17.988895, 11.659929, 11.684848, 13.087852, 15.233343, 13.126429, 15.422068, 13.899320, 14.501167, 12.414181, 15.549504, 17.173814, 16.439938, 11.189163, 13.566477, 14.643013, 15.324657, 10.576216),
                                    bottomright_lat = 
                                      c(56.005674, 59.910952, 60.237113, 56.855751, 56.345781, 61.669730, 56.961405, 56.171833, 56.371878, 64.940066, 58.651616, 57.669505, 55.326106, 58.526122, 58.698441, 59.379749, 58.825259, 63.347136, 61.895851, 59.205333, 57.168376),
                                    bottomright_lon = 
                                      c(16.024897, 16.689957, 17.280470, 19.318241, 13.610002, 16.672640, 15.592734, 17.013128, 15.818079, 24.233103, 15.701077, 17.049995, 14.589474, 17.680851, 19.365587, 18.758053, 14.605911, 21.531565, 19.356147, 16.983592, 14.751021)
                                    )
  # check for matches & calculate midpoint of rectangle borders
  matches <- c(rep(FALSE, 21))
  midpoint <- data.frame(lat = c(rep(0,21)), lon = c(rep(0,21)))
  for (i in 1:21) {
    # if lat, lon within rectangle set true
    if (lat > rectangular_borders$bottomright_lat[i] && lat < rectangular_borders$topleft_lat[i]
        && lon > rectangular_borders$topleft_lon[i] && lon < rectangular_borders$bottomright_lon[i]) {
      matches[i] <- TRUE
    }
    # calculate midpoints for later use
    midpoint$lat[i] <- (rectangular_borders$topleft_lat[i] + rectangular_borders$bottomright_lat[i])/2
    midpoint$lon[i] <- (rectangular_borders$topleft_lon[i] + rectangular_borders$bottomright_lon[i])/2
  }
  # determine county match
  if (sum(matches) > 1) {
    # select county based on shortest distance to midpoint
    match_index <- grep(TRUE, matches)
    distance <- c(rep(0,length(match_index)))
    for (i in 1:length(match_index)) {
      distance[i] <- sqrt((midpoint$lon[match_index[i]] - lon)^2 + (midpoint$lat[match_index[i]] - lat)^2)
    }
    county_index <- match_index[match(min(distance),distance)]
    result <- as.character(rectangular_borders$county[county_index])
    print(result)
  } else if (sum(matches) == 1) {
    result <- as.character(rectangular_borders$county[match(TRUE, matches)])
    print(result)
  } else {
    result <- "No match was made"
    print(result)
  }
}