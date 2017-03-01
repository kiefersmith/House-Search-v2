  map <- leaflet() %>% 
    addTiles(group = "Detailed") %>%
    addProviderTiles("CartoDB.Positron", group = "Simple") %>%
    addAwesomeMarkers(lng = longitude, lat = latitude, popup = subj_address, icon = awesomeIcons(icon='home', markerColor = 'red'), group = "Subject Property") %>%
    addAwesomeMarkers(lng = distance$X, lat = distance$Y, popup = paste(distance$Address,distance$`Sold Price`, distance$distanceFrom, sep = "<br/>"), icon = awesomeIcons(icon = 'home', markerColor = 'blue'), group = "Comps")%>%
    addAwesomeMarkers(lng = schoolsdf$long, lat = schoolsdf$lat, icon = awesomeIcons(icon = 'graduation-cap',library = 'fa', markerColor = 'green', iconColor = '#FFFFFF'), popup = schoolsdf$features.properties$NAMELONG, group = "Schools")%>%
    addLayersControl(
      baseGroups = c("Simple", "Detailed"),
      overlayGroups = c("Subject Property", "Comps", "Schools"),
      options = layersControlOptions(collapsed = FALSE))
  
map %>% hideGroup(group = "Schools")
#addCircleMarkers radius arg