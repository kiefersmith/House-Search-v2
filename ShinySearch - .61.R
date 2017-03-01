#setwd("~/Desktop/Programming/R/House Search v2")
library(readr)
apex <- read_csv("~/Desktop/Programming/R/House Search v2/apex2.csv")
cary <- read_csv("~/Desktop/Programming/R/House Search v2/cary2.csv")

library(leaflet)
library(shiny)
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
               textInput("address",label = "Insert Subject Property Address", placeholder = "ex. The White House, 123 Main Street", value = "2219 Walden Creek Drive"),
                numericInput("dist", label = "Miles from Subject", value = 1, max = 10)
        ),
        column(6,
               numericInput("footage",label = "Square Footage", value = 2000),
               selectInput("acres",label = "How Many Acres?", acresf),
                actionButton("submit","Submit")
        )
      ),
      
      hr(),
      
      fluidRow(
        column(12,
          column(8,
              leafletOutput("map01"),
              renderText("This information is deemed reliable, but not guaranteed.  Data courtesy of the Triangle Multiple Listing Service.")
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
          #cityschools <-schoolsdf$features.properties %>%
            #filter(ADDRCITY_1 == "Apex")
          #assign("cityschools", cityschools, envir = .GlobalEnv)
        } else if(input$city == "Cary") {
          framework_twocities(cary)
          #cityschools <-schoolsdf$features.properties %>%
            #filter(ADDRCITY_1 == "Cary")
          #assign("cityschools", cityschools, envir = .GlobalEnv)
        }
      })

      observeEvent(input$submit, {
        output$map01 <- renderLeaflet({distanceFrom(input$address, input$footage, input$acres,tol = .15, input$dist)
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
