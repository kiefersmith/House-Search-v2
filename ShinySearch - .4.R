  #maybe only load the fns needed?
setwd("~/Desktop/Programming/R/House Search v2")
library(leaflet)
library(shiny)
library(readr)
library(tidyverse)
library(sp)
Spreadsheet_1_ <- read_csv("Spreadsheet (1).csv")
source("googleAPI.R")
#source("getZestVal2.R")
source("applyS .4.R")

#getGeoInfo("2219 Walden Creek Drive") #arbitrary address
#distanceFrom("2219 Walden Creek Drive", "Walden Creek")

if (interactive()){
  ui <- fluidPage(
      titlePanel("Apex Comp Search"),
          
      mainPanel(
      textInput("address",label = "Insert Address", placeholder = "ex. The White House, 123 Main Street", value = "2219 Walden Creek Drive"),
      selectInput("subdiv",label = "Choose Subdivision", subs),
      sliderInput("year", label = "Year Built", min = 1920, max = 2017, value = c(1998, 2008)),
      actionButton("submit","Submit"),
      leafletOutput("map01"),
      plotOutput("hist01", height = 200)
      )
    )
  
  server <- shinyServer(
    function(input, output, session) {
      
      #what address is being rendered#
      #output$whatAdd <-renderText({input$address}) 

      observeEvent(input$submit, {
        distanceFrom(input$address, input$year, input$subdiv)
      })
      
      observeEvent(input$submit, {
        getGeoInfo(input$address)
      })
      
     observeEvent(input$submit, { output$hist01 <- renderPlot({
        if (length(distance$`Sold Price`)  <= 1)
          return("Unable to generate graph.")
        
        hist(distance$`Sold Price`,
             breaks = (length(distance$`Sold Price`)/2),
             main = "Sold Price Distribution",
             xlab = "Price",
             xlim = range(distance$`Sold Price`),
             col = '#00DD00',
             border = 'white')
      })
     })
      
      #if put a zestVal observeEvent it breaks#
      observeEvent(input$submit, {
        output$map01 <- renderLeaflet({
          leaflet() %>% 
            addTiles(group = "Base") %>%
            addProviderTiles("CartoDB.Positron") %>%
            addMarkers(lng = longitude, lat = latitude, popup = input$address) %>%
            addMarkers(lng = distance$Longitude, lat = distance$Latitude, popup = paste(distance$Address,distance$`Sold Price`, distance$`Distance From`, sep = "<br/>"))
      })
    })
    })
  shinyApp(ui = ui, server = server)
}
