framework <- function() {
  #source("googleAPI2.R")
  
  apex <- read_csv("~/Desktop/Programming/R/House Search v2/apex2.csv")
  cary <- read_csv("~/Desktop/Programming/R/House Search v2/cary2.csv")
  houses$`Sold Price` <- as.numeric(gsub("[^0-9]","",houses$`Sold Price`))
  
  
  sfrange <- range(houses$LvngAreaSF)
  assign("sfrange", sfrange, envir = .GlobalEnv)
  
  subs <- unique(houses$Subdivision)
  assign("subs", subs, envir = .GlobalEnv)
  
  acresf <- unique(houses$Acres)
  assign("acresf", acresf, envir = .GlobalEnv) #this order is wrong
  years <- unique(houses$YrBlt)
  assign("years", years, envir = .GlobalEnv)
  
  assign("latitude", NA, envir = .GlobalEnv)
  assign("longitude", NA, envir = .GlobalEnv)
  assign("distance", NA, envir = .GlobalEnv)
  assign("houses", houses, envir = .GlobalEnv)
  
}


