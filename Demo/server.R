library(shiny)
library(googleVis)

#load("stationslist.Rda")
#load("stationslist_2015.Rda")
load("stationslist_2015mini.Rda")
stationslist <- stationslist_2015mini

shinyServer(
        function(input, output, session) {
                
                # extract risk factor from list at a specific point in time
                currdata <- reactive({
                        listdata <- sapply(stationslist, function(x) x[as.numeric(input$time),c("risk.all","latlong")])
                        listdata <- unlist(listdata)
                        x1 <- listdata[seq(1,length(listdata),2)]
                        x2 <- listdata[seq(2,length(listdata),2)]
                        currdata <- data.frame(latlong=x2,risk.all=as.numeric(x1),stringsAsFactors = F)
                })
                
                
                # Produce chart
                 output$gvis <- 
                         renderGvis({
                                gvisGeoChart(data=currdata(), locationvar = "latlong",
                                              colorvar = "risk.all", hovervar = ,
                                              options = list(region="SE", displayMode="markers",
                                                            resolution="provinces",
                                                             backgroundColor="2049a1",
                                                            colors = "['#0000E5', '#0058E1', '#00AEDD', '#00D9B1','#00D559','00D204','4DCE00','9CCA00','C6A400']",
                                                             width=900, height=556))
                         })
                
                }
)



