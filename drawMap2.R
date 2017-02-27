  map <- leaflet() %>% 
    addTiles(group = "Base") %>%
    addProviderTiles("CartoDB.Positron") %>%
    addCircleMarkers(lng = longitude, lat = latitude, popup = subj_address, fillColor = "red", fillOpacity = .5, radius = 10, stroke = FALSE) %>%
    addCircleMarkers(lng = distance$X, lat = distance$Y, popup = paste(distance$Address,distance$`Sold Price`, distance$`Distance From`, sep = "<br/>"), fillColor = "Blue", fillOpacity = .5, radius = 6, stroke = FALSE)
map