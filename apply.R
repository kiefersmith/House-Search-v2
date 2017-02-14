distanceFrom <- function(address) {
  library(readr)
  library(tidyverse)
  library(sp)
  
  Spreadsheet_1_ <- read_csv("~/Downloads/Spreadsheet (1).csv")
  houses <- Spreadsheet_1_
  
  subs <- unique(houses$Subdivision)
  addresses <- houses$Address
  
  houses_filtered <- houses %>%
    filter(Subdivision == "Not in a Subdivision") #this should be an input from the user
  
  #changed to addresses 2 so I can search big df with addresses and search google w addresses2
  addresses2 <- paste(houses_filtered$Address, "Apex NC", sep = " ")
  
  y <- matrix()
  
  source("~/Desktop/Programming/R/House Search v2/googleAPI.R")
  
  for(a in addresses2) {
    getGeoInfo(a)
    y <- rbind(y, longitude, latitude)
  }
  
  y <- y[-1]
  z <- matrix(y, ncol = 2, byrow = TRUE)
  
  subj_address <- "2756 Weaver Hill Drive"
  getGeoInfo(subj_address)
  longitude_subj <- as.numeric(longitude)
  latitude_subj <- as.numeric(latitude)
  
  d <- spDistsN1(z, c(longitude_subj, latitude_subj), longlat = TRUE)
  d <- d/1.60934
  
  distance_from_subj<- cbind(addresses2, d)
  distance_from_subj <- as_tibble(distance_from_subj)
  #attach coordinates too
  
}










addresses <- as.matrix(addresses)
coords_matrix <- cbind2(z, addresses)
coords_matrix <- as.data.frame(coords_matrix)
#these fns fuck up data type
#did this do it?
#coords_matrix[,1] <- as.numeric(coords_matrix[,1])
#coords_matrix[,2] <- as.numeric(coords_matrix[,2])
coords_matrix$V1 <- as.numeric(coords_matrix$V1)
coords_matrix$V2 <- as.numeric(coords_matrix$V2)

