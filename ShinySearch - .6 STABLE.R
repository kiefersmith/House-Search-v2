  #maybe only load the fns needed?
setwd("~/Desktop/Programming/R/House Search v2")
library(leaflet)
library(shiny)
library(readr)
library(tidyverse)
library(sp)

houses <- read_csv("~/Desktop/Programming/R/House Search v2/findable.csv")
source("framework.R")
framework()

source("googleAPI2.R")
#source("getZestVal2.R")
source("applyS .6 .R")


if (interactive()){
  ui <- fluidPage(
      titlePanel("Apex Comp Search"),
          
      mainPanel(
      textInput("address",label = "Insert Address", placeholder = "ex. The White House, 123 Main Street", value = "2219 Walden Creek Drive"),
      numericInput("footage",label = "Square Footage", value = 2000),
      selectInput("acres",label = "How Many Acres?", acresf),
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
        output$map01 <- renderLeaflet({distanceFrom(input$address, input$footage, input$acres)
      })
      })
      
      observeEvent(input$submit, {
        getGeoInfo(input$address)
      })
      
     #observeEvent(input$submit, { output$hist01 <- renderPlot({
        #if (length(distance$`Sold Price`)  <= 1)
          #return("Unable to generate graph.")
        
        #hist(distance$`Sold Price`,
             #breaks = (length(distance$`Sold Price`)/2),
             #main = "Sold Price Distribution",
             #xlab = "Price",
             #xlim = range(distance$`Sold Price`),
             #col = '#00DD00',
             #border = 'white')
      })
    # })
    #})
  shinyApp(ui = ui, server = server)
}
