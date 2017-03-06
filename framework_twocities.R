framework_twocities <- function(citydf) {
  #source("googleAPI2.R")
  
  reType <- function(citydf) {
    houses <- citydf
    houses$`Sold Price` <- as.numeric(gsub("[^0-9]","",houses$`Sold Price`))
    houses$`List Price` <- as.numeric(gsub("[^0-9]","",houses$`List Price`))
    houses$`Tax Value` <- as.numeric(gsub("[^0-9]","",houses$`Tax Value`))
    #tax value 0 = na
    houses$Fireplace <- as.numeric(houses$Fireplace)
    houses$`New Constr` <- as.factor(houses$`New Constr`)
    houses$Subdivisio <- as.factor(houses$Subdivisio)
    houses$Acres <- as.factor(houses$Acres)
    houses$`Property T` <- as.factor(houses$`Property T`)
  }
  
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


