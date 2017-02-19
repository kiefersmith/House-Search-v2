distanceFrom <- function(subj_address, sqft, acres, tol = .10, dist = 3) {

  #setwd("~/Desktop/Programming/R/House Search v2")
  
  houses_filtered <- houses %>%
    filter(Acres == acres)%>%
    filter(LvngAreaSF >= ((1-tol)*sqft)) %>%
    filter(LvngAreaSF <= ((1+tol)*sqft)) 
  
  if(length(houses_filtered$Address) <= 0) {
    stop("No houses found.  Try fewer search constraints.")
  } else {
    
    addresses <- houses$Address
    addresses2 <- paste(houses_filtered$Address, "Apex NC", sep = " ")
    y <- matrix()
    
    for(a in addresses2) {
      getGeoInfo(a)
      y <- rbind(y, longitude, latitude)
    }
    
    y <- y[-1]
    z <- matrix(y, ncol = 2, byrow = TRUE)
    
    getGeoInfo(subj_address)
    longitude_subj <- as.numeric(longitude)
    latitude_subj <- as.numeric(latitude)
    
    d <- spDistsN1(z, c(longitude_subj, latitude_subj), longlat = TRUE)
    d <- d/1.60934
    d <- substr(d, 0,4)
    
    distance_from_subj<- cbind(houses_filtered$Address, d)
    distance_from_subj <- as_tibble(distance_from_subj)
    distance_from_subj <- cbind(distance_from_subj, z)
    colnames(distance_from_subj) <- c("Address", "Distance From", "Longitude", "Latitude")
    distance_from_subj <- left_join(houses_filtered, distance_from_subj, by = "Address")
    assign("distance", distance_from_subj, envir = .GlobalEnv)
  }
  
  distance%>%
    filter(`Distance From` <= dist)%>%
    drawMap()
}


