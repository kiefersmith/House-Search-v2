framework_twocities <- function(citydf) {
  #source("googleAPI2.R")
  
  houses <- citydf
  houses$`Sold Price` <- as.numeric(gsub("[^0-9]","",houses$`Sold Price`))
  
  
  sfrange <- range(houses$LvngAreaSF)
  assign("sfrange", sfrange, envir = .GlobalEnv)
  
  subs <- unique(houses$Subdivision)
  assign("subs", subs, envir = .GlobalEnv)
  
  acresf <- readRDS('acres.RData')
  assign("acresf", acresf, envir = .GlobalEnv) 
  years <- unique(houses$YrBlt)
  assign("years", years, envir = .GlobalEnv)
  
  assign("latitude", NA, envir = .GlobalEnv)
  assign("longitude", NA, envir = .GlobalEnv)
  assign("distance", NA, envir = .GlobalEnv)
  assign("houses", houses, envir = .GlobalEnv)
  
}


