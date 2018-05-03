# load required packages and processed data
library(shiny)
library(shinythemes)
library(googleVis)
load("data.Rda")

# create a data frame which holds current values to display
currdata <- data.frame(matrix(nrow = 21, ncol = 2))
names(currdata) <- c('Region','Risk')
currdata$Region <- names(data)[-1]

# Server function
server <- function(input, output, session) {
  # Update risk for all regions at specific point in time
  risk <- reactive({
    as.vector(data[input$time,-1],mode="numeric")
  })
  
  # Top 3 regions at risk
  sortedRisk <- reactive({sort(risk(),decreasing=TRUE)})
  top1 <- reactive({currdata[order(risk(),decreasing=TRUE),1][1]})
  top2 <- reactive({currdata[order(risk(),decreasing=TRUE),1][2]})
  top3 <- reactive({currdata[order(risk(),decreasing=TRUE),1][3]})
  output$top1 <- renderText(paste("1. ",top1(),sep=""))
  output$top2 <- renderText(paste("2. ",top2(),sep=""))
  output$top3 <- renderText(paste("3. ",top3(),sep=""))
  
  # Produce chart
   output$gvis <- 
           renderGvis({
                  currdata$Risk <- risk()
                  # hardcode to keep same scale 0-1 on graph at all times
                  currdata[22,1] <- 'Min'
                  currdata[22,2] <- 0
                  currdata[23,1] <- 'Max'
                  currdata[23,2] <- 1
                  gvisGeoChart(data=currdata, locationvar = "Region",
                                colorvar = "Risk", hovervar = ,
                                options = list(region="SE", displayMode="regions",
                                               resolution="provinces",
                                               backgroundColor="2049a1",
                                               colors = "['#27ae60', '#f1c40f', '#e74c3c']",
                                               width=900, height=556))
           })
  
}

# User interface function
ui <- navbarPage(title="Observation of regional risks for floods in Sweden", theme = shinytheme("spacelab"),
                   tabPanel(title="Chart",
                            sidebarLayout(
                              sidebarPanel(
                                h4("How to use "),
                                "Click the play icon or drag the slider to compare the regional risk for floods throughout 2015. The top three regions at risk
                                are displayed below",
                                br(),
                                br(),
                                br(),
                                br(),
                                sliderInput("time", "January to December (1-12)",
                                            min = min(data$Date), max = max(data$Date),
                                            value = 1, step=1, animate = TRUE),
                                br(),
                                br(),
                                br(),
                                h4("Top 3 regions at risk:"),
                                verbatimTextOutput("top1"),
                                verbatimTextOutput("top2"),
                                verbatimTextOutput("top3")
                              ),
                              mainPanel(
                                fluidRow(
                                  column(12,
                                         htmlOutput("gvis"),
                                         br(),
                                         tags$em("Green (0) = Low risk; Yellow = Moderate risk; Red (1) = High risk"),
                                         tags$hr()
                                  )
                                  )
                              )
                            )
                   ),
                   tabPanel(title="About",
                            sidebarLayout(
                              sidebarPanel(
                                h4("Government agency data"),
                                br(),
                                tags$a(href="http://www.smhi.se/en", "The Swedish Meteorological and Hydrological Institute"),
                                br(),
                                br(),
                                "Get the R code for this application on",
                                tags$a(href="https://github.com/danbro/hack4sweden2016.git", "Github"),
                                br()
                              ),
                              mainPanel(
                                fluidRow(
                                  column(12,
                                         br(),
                                         "The application was created using rainfall data from the Swedish Meteorological and Hydrological Institute (SMHI).
                                         The simplified assumption was made to model the risk for floods based on the amount of monthly rainfall in different regions of Sweden. Rainfall data from a total of 666 
                                         weather stations were collected, averaged, and normalized per region for the year 2015. Further data can be used to more accurately model the risk for floods
                                         such as the location of rivers and streams, or landscape and terrain charactersitics. The R code for this application is available on Github for anyone interested to further extend this work.",
                                         br(),
                                         br(),
                                         "N.B. Some adjustments were made to the application following the Hackathon event"
                                  )
                                  )
                                  )
                                  )
                                  ),
                   tabPanel(title="Contact",
                            sidebarLayout(
                              sidebarPanel(
                                br(),
                                h3("Team PoweR"),
                                h4("Daniel A. Broden (Team Captain)"),
                                "Ph.D Candidate at the Royal Institute of Technology, Stockholm, Sweden",
                                br(),
                                "Email: danbro@kth.se",
                                br(),
                                "Link to",
                                tags$a(href="https://www.kth.se/profile/danbro/", "profile page"),
                                br(),
                                h4("Nicholas Honeth"),
                                "Ph.D Candidate at the Royal Institute of Technology, Stockholm, Sweden",
                                br(),
                                "Email: honeth@kth.se",
                                br(),
                                "Link to",
                                tags$a(href="https://www.kth.se/profile/honeth", "profile page"),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                "Hack for Sweden 12-13 March 2016",
                                br()
                              ),
                              mainPanel(
                                img(src='smhipic.png', align = "middle", keepAspectRatio=T, width=600),
                                br(),
                                tags$em("Left to right: (SMHI), Daniel A. Broden (KTH), Nicholas Honeth (KTH), Rolf Brennerfelt (CEO SMHI)")
                                
                              )
                            )
                   )
                 )

# Run application
shinyApp(ui = ui, server = server)