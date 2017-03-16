#setwd("~/Desktop/Programming/R/House Search v2")
library(readr)
apex <- read_csv("apex2.csv")
cary <- read_csv("cary2.csv")
raleigh <- read_csv("raleigh.csv")

library(leaflet)
library(shiny)
library(tidyverse)
library(sp)
#library(modelr)
options('scipen' = 1000)

source("reType.R")
source("framework_retype.R")
framework_retype(apex)

source("googleAPI2.R")
#source("getZestVal2.R")
source("applyS .6 .R")
load("schools.RData", envir = .GlobalEnv)



#if (interactive()){
ui <- navbarPage("Comp Search v0.8",
                 tabPanel("Map",
                          fluidPage(
                            
                            fluidRow(
                              column(6,
                                     selectInput("city", label = "City", c("Apex", "Cary", "Raleigh")),
                                     textInput("address",label = "Insert Subject Property Address", value = "2219 Walden Creek Drive"),
                                     numericInput("dist", label = "Miles from Subject", value = 5, max = 20)
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
                                            textOutput("This information is deemed reliable, but not guaranteed.  Data courtesy of the Triangle Multiple Listing Service.")
                                     ),
                                     column(4,
                                            plotOutput("hist01", height = 200)
                                     )
                              )
                            ),
                            fluidRow(
                              column(12,
                                     dataTableOutput("table01")
                              )
                            )
                          )),
                 
                 tabPanel("Model",
                          fluidRow(
                            column(6,
                                   selectInput("subdiv",label = "What subdivision?", subs), #need a not listed option
                                   selectInput("new", label = "New construction?", c("No", "Yes")),
                                   selectInput("type", label = "What type?", c("Attached" ,"Condo", "Detached" ,"Manufactured")),
                                   numericInput("year", label = "Year built?", value = 2000, min = 1920, max = 2017)),
                            column(6,
                                   numericInput("footageOther", label = "Other square footage?", value = 0),
                                   numericInput("fire", label = "How many fireplaces?", value = 1),
                                   numericInput("garage", label = "How many garages?", value = 1),
                                   actionButton("submitModel","Submit")
                            ),
                            
                            hr(),
                            
                            column(12,
                                   textOutput("pred")
                            )
                          )
                 )
)

server <- shinyServer(
  function(input, output, session) {
    
    observeEvent(input$city, {
      if(input$city == "Apex") {
        framework_retype(apex)
        cityschools <-schoolsdf$features.properties %>%
          filter(ADDRCITY_1 == "Apex")
        assign("cityschools", cityschools, envir = .GlobalEnv)
      } else if(input$city == "Cary") {
        framework_retype(cary)
        cityschools <-schoolsdf$features.properties %>%
          filter(ADDRCITY_1 == "Cary")
        assign("cityschools", cityschools, envir = .GlobalEnv)
      } else if(input$city == "Raleigh") {
        framework_retype(raleigh)
        cityschools <-schoolsdf$features.properties %>%
          filter(ADDRCITY_1 == "Raleigh")
        assign("cityschools", cityschools, envir = .GlobalEnv)
    }}
  )
    
    observeEvent(input$submit, {
      output$map01 <- renderLeaflet({distanceFrom(input$address, input$footage, input$acres,tol = .15, input$dist)
      })
    })
    
    observeEvent(input$submit, {
      output$table01 <- renderDataTable({tableOut}, options = list(scrollX = TRUE, pageLength = 10)) #this was get ge0?
    })
    
    observeEvent(input$submit, { output$hist01 <- renderPlot({
      if (length(distance$`Sold Price`)  <= 1){
        return("Unable to generate graph.")} else{   #different renders here
          
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
    observeEvent(input$submitModel, {
      model <- lm(data = houses, `Sold Price` ~ LvngAreaSF + Subdivisio + YrBlt + `Total Othe` + `New Constr` + Fireplace + Garage + Acres + `Property T`)
      subjData <- as.data.frame(cbind(input$footage, input$subdiv, input$year, input$footageOther, input$new, input$fire, input$garage, input$acres, input$type), stringsAsFactors = FALSE)
      assign("subjData", subjData, envir = .GlobalEnv)
      #subjData <- reType(subjData)
      colnames(subjData) <- c("LvngAreaSF", "Subdivision", "YrBlt", "Total Othe", "New Constr", "Fireplace", "Garage", "Acres", "Property T")
      subjData$LvngAreaSF <- as.numeric(subjData$LvngAreaSF)
      subjData$Subdivisio <- as.factor(subjData$Subdivisio)
      subjData$YrBlt <- as.integer(subjData$YrBlt)
      subjData$`Total Othe` <- as.numeric(subjData$`Total Othe`)
      subjData$`New Constr` <- as.factor(subjData$`New Constr`)
      subjData$Fireplace <- as.numeric(subjData$Fireplace)
      subjData$Garage <- as.integer(subjData$Garage)
      subjData$Acres <- as.factor(subjData$Acres)
      subjData$`Property Type` <- as.factor(subjData$`Property T`)
      assign("subjData", subjData, envir = .GlobalEnv)
      pred <- predict.lm(object = model, newdata = subjData, interval = "predict")
      pred <- as.data.frame(pred)
      lwr <- pred$lwr
      fit <- pred$fit
      upr <- pred$upr
      output$pred <- renderText(paste("Lower:", lwr,"Predicted:", fit,"Upper:", upr, sep = "  "))
    })
  })

app <- shinyApp(ui = ui, server = server)
assign("app", app, envir = .GlobalEnv) 
app