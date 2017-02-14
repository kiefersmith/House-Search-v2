  #maybe only load the fns needed?
library(leaflet)
library(shiny)
library(readr)
library(tidyverse)
library(sp)
Spreadsheet_1_ <- read_csv("Spreadsheet (1).csv")
houses <- Spreadsheet_1_
source("googleAPI.R")
#source("getZestVal2.R")
source("applyS2.R")

getGeoInfo("2219 Walden Creek Drive") #arbitrary address
distanceFrom("2219 Walden Creek Drive", "Walden Creek")

if (interactive()){
  ui <- fluidPage(
    titlePanel("Comp Search"),
    
    mainPanel(
      textInput("address",label = "Insert Address", placeholder = "ex. The White House, 123 Main Street", value = "2219 Walden Creek Drive"),
      selectInput("subdiv",label = "Choose Subdivision", subs),
      actionButton("submit","Submit"),
      verbatimTextOutput("whatAdd"),
      leafletOutput("map01")
    )
  )
  
  server <- shinyServer(
    function(input, output, session) {
      
      #what address is being rendered#
      #output$whatAdd <-renderText({input$address}) 

      #subs <- reactive({select subs})
      
      #stores results of getGeoInfo#
      observeEvent(input$submit, {
        distanceFrom(input$address, input$subdiv)
      })
      
      observeEvent(input$submit, {
        getGeoInfo(input$address)
      })
      
      #if put a zestVal observeEvent it breaks#
      observeEvent(input$submit, {
        output$map01 <- renderLeaflet({
          leaflet() %>% 
            addTiles(group = "Base") %>%
            addProviderTiles("CartoDB.Positron") %>%
            addMarkers(lng = longitude, lat = latitude) %>%
            addMarkers(lng = distance$Longitude, lat = distance$Latitude)
      })
    })
      #observe({
       # leafletProxy("map01") %>%
       # clearShapes() %>%
       # addMarkers("map01", lng = longitude, lat = latitude)
        #addMarkers(output$map01, lng = distance$Longitude, lat = distance$Latitude)
      })
  shinyApp(ui = ui, server = server)
}
