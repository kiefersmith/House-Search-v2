setwd("~/Desktop/Programming/R/House Search v2")
apex <- read_csv("~/Desktop/Programming/R/House Search v2/apex2.csv")
cary <- read_csv("~/Desktop/Programming/R/House Search v2/cary2.csv")

library(leaflet)
library(shiny)
library(readr)
library(tidyverse)
library(sp)
options('scipen' = 1000)

source("framework_twocities.R")
framework_twocities(apex)

source("googleAPI2.R")
#source("getZestVal2.R")
source("applyS .6 .R")
load("schools.RData")


if (interactive()){
  ui <- fluidPage(
      titlePanel("Comp Search"),
          
      fluidRow(
        column(6,
               selectInput("city", label = "City", c("Apex", "Cary")),
               textInput("address",label = "Insert Address", placeholder = "ex. The White House, 123 Main Street", value = "2219 Walden Creek Drive"),
                numericInput("footage",label = "Square Footage", value = 2000)
        ),
        column(6,
               selectInput("acres",label = "How Many Acres?", acresf),
                actionButton("submit","Submit")
        )
      ),
      
      hr(),
      
      fluidRow(
        column(12,
          column(8,
              leafletOutput("map01")
               ),
               column(4,
                      plotOutput("hist01", height = 200)
               ),
          
          
          hr(),
          
          fluidRow(
            column(12,
                   dataTableOutput("table01"))
          )
        )
)
  )

  server <- shinyServer(
    function(input, output, session) {
      
      observeEvent(input$city, {
        if(input$city == "Apex") {
          framework_twocities(apex)
        } else if(input$city == "Cary") {
          framework_twocities(cary)
        }
      })

      observeEvent(input$submit, {
        output$map01 <- renderLeaflet({distanceFrom(input$address, input$footage, input$acres)
      })
      })
      
      observeEvent(input$submit, {
        output$table01 <- renderDataTable({tableOut}, options = list(scrollX = TRUE)) #this was get ge0?
      })
      
     observeEvent(input$submit, { output$hist01 <- renderPlot({
        if (length(distance$`Sold Price`)  <= 1){
          return("Unable to generate graph.")} else{
        
          hist(distance$`Sold Price`,
             breaks = (50),
             main = "Sold Price Distribution",
             xlab = "Price",
             xlim = range(houses$`Sold Price`),
             col = '#00DD00',
             border = 'white')
        }
      })
     })
    })
  shinyApp(ui = ui, server = server)
}
