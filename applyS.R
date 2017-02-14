distanceFrom <- function(address) {
  library(readr)
  library(tidyverse)
  library(sp)
  source("~/Desktop/Programming/R/House Search v2/googleAPI.R")
  setwd("~/Desktop/Programming/R/House Search v2")
  #not all of this needs to happen every time.
  Spreadsheet_1_ <- read_csv("Spreadsheet (1).csv")
  houses <- Spreadsheet_1_
  
  subs <- unique(houses$Subdivision)
  addresses <- houses$Address
  
  houses_filtered <- houses %>%
    filter(Subdivision == "Walden Creek") #this should be an input from the user
  
  #changed to addresses 2 so I can search big df with addresses and search google w addresses2
  addresses2 <- paste(houses_filtered$Address, "Apex NC", sep = " ")
  
  y <- matrix()
  
  for(a in addresses2) {
    getGeoInfo(a)
    y <- rbind(y, longitude, latitude)
  }
  
  y <- y[-1]
  z <- matrix(y, ncol = 2, byrow = TRUE)
  
  subj_address <- address
  getGeoInfo(subj_address)
  longitude_subj <- as.numeric(longitude)
  latitude_subj <- as.numeric(latitude)
  
  d <- spDistsN1(z, c(longitude_subj, latitude_subj), longlat = TRUE)
  d <- d/1.60934
  
  distance_from_subj<- cbind(addresses2, d)
  distance_from_subj <- as_tibble(distance_from_subj)
  distance_from_subj <- cbind(distance_from_subj, z)
  colnames(distance_from_subj) <- c("Addresses", "Distance From", "Longitude", "Latitude")
  assign("distance", distance_from_subj, envir = .GlobalEnv)
}


