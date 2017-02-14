distanceFrom <- function(subj_address, subdiv) {

  setwd("~/Desktop/Programming/R/House Search v2")
  #not all of this needs to happen every time.
  houses <- Spreadsheet_1_
  houses$`Sold Price` <- as.numeric(gsub("[^0-9]","",houses$`Sold Price`))
  
  subs <- unique(houses$Subdivision)
  assign("subs", subs, envir = .GlobalEnv)
  
  addresses <- houses$Address
  
  houses_filtered <- houses %>%
    filter(Subdivision == subdiv) #this should be an input from the user
  
  #changed to addresses 2 so I can search big df with addresses and search google w addresses2
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


