distanceFrom <- function(subj_address, sqft, acres, tol = .10, dist = 3) {
  assign("subj_address", subj_address, envir = .GlobalEnv)
  
  houses_filtered <- houses %>%
    filter(Acres == acres)%>%
    filter(LvngAreaSF >= ((1-tol)*sqft)) %>%
    filter(LvngAreaSF <= ((1+tol)*sqft)) 
  
  if(length(houses_filtered$Address) <= 0) {
    stop("No houses found.  Try fewer search constraints.")
  } else {
    
    getGeoInfo(subj_address)
    longitude_subj <- as.numeric(longitude)
    latitude_subj <- as.numeric(latitude)
    
    xy <- houses_filtered[,1:2]
    xy <- as.matrix(xy)
    
    d <- spDistsN1(xy, c(longitude_subj, latitude_subj), longlat = TRUE)
    d <- d/1.60934
    d <- substr(d, 0,4)
    
    houses_filtered$`Distance From` <- as.numeric(d)
    assign("distance", houses_filtered, envir = .GlobalEnv)
    
    distance <- distance%>%
      filter(`Distance From` <= dist)
    
    source("drawMap.R")
  }
  return(map)
}


