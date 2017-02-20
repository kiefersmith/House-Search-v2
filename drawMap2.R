  map <- leaflet() %>% 
    addTiles(group = "Base") %>%
    addProviderTiles("CartoDB.Positron") %>%
    addMarkers(lng = longitude, lat = latitude, popup = subj_address) %>%
    addMarkers(lng = distance$X, lat = distance$Y, popup = paste(distance$Address,distance$`Sold Price`, distance$`Distance From`, sep = "<br/>"))
map