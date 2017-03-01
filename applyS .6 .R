distanceFrom <- function(subj_address, sqft, acres, tol = .15, dist) {
  assign("subj_address", subj_address, envir = .GlobalEnv)
  dist <- as.numeric(dist)
  assign("dist", dist, envir = .GlobalEnv)
  
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
    
    houses_filtered$distanceFrom <- as.numeric(d)
    
    distance <- houses_filtered %>%
      filter(distanceFrom <= dist)
    
    assign("distance", distance, envir = .GlobalEnv)
    
    source("drawMapGroups.R")
    
    tableOut <- distance %>%
      select(Address, Subdivisio, LvngAreaSF, YrBlt, Beds, FBths, HBths, `Tax Rate`, `Tax Value`, Fireplace, Garage, Cumulative, `Closing Da`, distanceFrom)
    
    tableOut <- tableOut[order(tableOut$distanceFrom),]
    assign("tableOut", tableOut, envir = .GlobalEnv)
  }
  return(map)
}


