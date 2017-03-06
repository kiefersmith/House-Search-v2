framework_retype <- function(citydf) {
  #source("googleAPI2.R")
  source('reType.R')
  houses <- reType(citydf)
  
    

  sfrange <- range(houses$LvngAreaSF)
  assign("sfrange", sfrange, envir = .GlobalEnv)
  
  subs <- unique(houses$Subdivisio)
  assign("subs", subs, envir = .GlobalEnv)
  
  acresf <- readRDS('acres.RData')
  assign("acresf", acresf, envir = .GlobalEnv) 
  years <- unique(houses$YrBlt)
  years <- as.numeric(years)
  assign("years", years, envir = .GlobalEnv)
  
  assign("latitude", NA, envir = .GlobalEnv)
  assign("longitude", NA, envir = .GlobalEnv)
  assign("distance", NA, envir = .GlobalEnv)
  assign("houses", houses, envir = .GlobalEnv)
  assign("tableOut", NA, envir = .GlobalEnv)
}


