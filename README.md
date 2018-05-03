# hack4sweden2016
An application to determine the regional risk for floods in Sweden. This application was developped by Daniel A Brodén and Nicholas Honeth for the Hack for Sweden competition in March 12-13, 2016.

In this repositories you will find all necessary R files to reproduce or extend our application.

Folder descriptions:
- data (contains subfolders with .csv files downloaded from SMHI)
- www (contains the image to be uploaded on the application page)

R file descriptions:
- SwedishCounty.R (function that takes latitude and longitude coordinates and maps it to one of the 21 counties in Sweden)
- stationsdf.R (creates a data frame containing all active weather stations from SMHI and respective county names)
- countysubset.R (creates a list of data frames of the weather stations subsetted by county names)
- rainfall.R (downloads monthly rainfall data for year 2015 from all weather stations and computes averages per county)
- app.R (user interface and server for web application. Loads the final data frame to be displayed)

N.B. Some adjustments were made to the application following the Hackathon event
