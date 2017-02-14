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
source("applyS3.R")

getGeoInfo("2219 Walden Creek Drive") #arbitrary address
distanceFrom("2219 Walden Creek Drive", "Walden Creek")

if (interactive()){
  ui <- fluidPage(
    titlePanel("Comp Search"),
    
    mainPanel(
      textInput("address",label = "Insert Address", placeholder = "ex. The White House, 123 Main Street", value = "2219 Walden Creek Drive"),
      selectInput("subdiv",label = "Choose Subdivision", subs),
      actionButton("submit","Submit"),
      plotOutput("hist01", height = 200),
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
      
     observeEvent(input$submit, { output$hist01 <- renderPlot({
        if (length(distance$`Sold Price`) == 0)
          return("No properties to show.")
        
        hist(distance$`Sold Price`,
             breaks = (length(distance$`Sold Price`)/1.5),
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
