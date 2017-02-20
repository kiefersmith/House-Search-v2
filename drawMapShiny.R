  map <- leaflet() %>% 
    addTiles(group = "Base") %>%
    addProviderTiles("CartoDB.Positron") %>%
    addMarkers(lng = longitude, lat = latitude, popup = input$address) %>%
    addMarkers(lng = distance$Longitude, lat = distance$Latitude, popup = paste(distance$Address,distance$`Sold Price`, distance$`Distance From`, sep = "<br/>"))
map