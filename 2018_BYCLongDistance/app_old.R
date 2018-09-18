#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(viridis)
library(leaflet)
library(ggplot2)
library(tidyverse)

load("expdat.rda")
load("mark.rda")

expdat$polar_bsp_perc[is.infinite(expdat$polar_bsp_perc)] <- NA

#plot variables
plotchoices <- c("bsp", "awa", "aws", "twa", "tws", "twd", "cog", "sog", "polar_bsp_target", "polar_bsp_perc")

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("2018 BYC Long Distance Race"),
   
   sidebarLayout(
     sidebarPanel(
       sliderInput("endtime", "Visible Time",
                   min=as.POSIXct("2018-09-15 15:00:00 EDT"), 
                   max=as.POSIXct("2018-09-15 21:00:00 EDT"), 
                   value=c(as.POSIXct("2018-09-15 15:00:00 EDT"), as.POSIXct("2018-09-15 21:00:00 EDT") ), 
                   timeFormat = "%a %H:%M", animate = TRUE, width = "100%"), 
       
       selectInput(inputId = "plotvar", "Plot Variable", choices = plotchoices, selected = "bsp"),
       selectInput(inputId = "colorvar", "Color Variable", choices = plotchoices, selected = "bsp")
     ),
     mainPanel(
       leafletOutput("mymap", height=500),
       plotOutput("plot1", width=400,height=200)#, 
       #plotOutput("plot2", width=400,height=200), 
       #plotOutput("hist", width=400, height=300)
     )
   )
)
   
     
     


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  perfData <- reactive({
    
    expdat <- expdat[expdat$time > input$endtime[1] & expdat$time < input$endtime[2], ]
    
  })
  
 
  output$mymap <- renderLeaflet({
    
    m <- leaflet() %>%  addTiles()
    #m <- m %>% addPolylines(data=df, lng=~lon, lat=~lat)
    #m <- m %>% addPolylines(data=tuna, lng=~lon, lat=~lat, color="red")
    
    expdat <- perfData()
    
    m <- m %>% addPolylines(data=expdat, lng=~lon, lat=~lat, 
                            color="red", weight=2, opacity=100) %>%
               addMarkers(data=marks, lng=~mk.lon,  lat=~mk.lat)
  
    #m <- m %>% addCircleMarkers(data=marks, lng=~mk.lon, lat=~mk.lat, color="Orange", radius = 3)
    
    
  })
  
  output$plot1 <- renderPlot({
    
    expdat <- perfData()
    
    colorrange <- quantile(expdat[, input$colorvar], c(.01, .99), na.rm=TRUE)
    plotrange <- quantile(expdat[, input$plotvar], c(.01, .99), na.rm=TRUE)
    
    ggplot(expdat) + geom_path(aes_string(x="time", y=input$plotvar, color=input$colorvar))+
      scale_color_viridis_c(limits=colorrange) + 
      scale_y_continuous(limits=plotrange)
    
  })
  
  # output$plot2 <- renderPlot({
  #   
  #   expdat <- perfData()
  #   
  #   colorrange <- quantile(expdat[, input$colorvar], c(.01, .99), na.rm=TRUE)
  #   plotrange <- quantile(expdat[, input$plotvar], c(.01, .99), na.rm=TRUE)
  #   
  #   ggplot(expdat) + geom_path(aes_string(x="time", y=input$plotvar, color=input$colorvar))+
  #     scale_color_viridis_c(limits=colorrange) + 
  #     scale_y_continuous(limits=plotrange)
  #   
  # })

  output$hist <- renderPlot({
    
    expdat <- perfData()
    
    plotrange <- quantile(expdat[, input$plotvar], c(.01, .99), na.rm=TRUE)
    
    ggplot(expdat) + 
      geom_histogram(aes_string(x=input$plotvar), bins = 50) + scale_x_continuous(limits=plotrange)
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

