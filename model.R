model <- lm(data = houses, `Sold Price` ~ (LvngAreaSF*Beds) + (LvngAreaSF*FBths) + (LvngAreaSF*HBths) + Subdivisio + YrBlt + `Total Othe` + `New Constr` + Fireplace + Garage + Acres + `Property T`)

model <- lm(data = houses, `Sold Price` ~ LvngAreaSF + Subdivisio + YrBlt + `Total Othe` + `New Constr` + Fireplace + Garage + Acres + `Property T`)



names <- c("LvngAreaSF", "Subdivisio", "YrBlt", "Total Othe", "New Constr", "Fireplace", "Garage", "Acres", "Property T")
subjData <- as.data.frame(c(input$footage, input$subdiv, input$year, input$footageOther, input$new, input$fire, input$garage, input$acres, input$type), stringsAsFactors = FALSE, col.names = names)
  subjData$LvngAreaSF <- as.numeric(subjData$LvngAreaSF)
  subjData$Subdivisio <- as.factor(subjData$Subdivisio)
  subjData$YrBlt <- as.integer(subjData$YrBlt)
  subjData$LvngAreaSF <- as.numeric(subjData$`Total Othe`)
  subjData$`New Constr` <- as.factor(subjData$`New Constr`)    
  subjData$Fireplace <- as.numeric(subjData$Fireplace)
  subjData$Garage <- as.integer(subjData$Garage)
  subjData$Acres <- as.factor(subjData$Acres)
  subjData$`Property T` <- as.factor(subjData$`Property T`)
  
          assign("subjData", subjData, envir = .GlobalEnv)

preds <- predict(model, subjData, interval = "predict")
preds

