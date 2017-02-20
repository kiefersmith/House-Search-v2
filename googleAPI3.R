getGeoInfo <- function(address) {
    require(jsonlite)
    require(stringr)
    ##put google id in getGapi##
    googleid <-"AIzaSyDbbAu4rY4Dy-WegZ70oRgdirmoIKe_1p0"
    #should generalize this#
    getGapi <- function(key=googleid,a=address) {
      mapsapi <- "https://maps.googleapis.com/maps/api/geocode/"
      output <- "json"
      #make typed address readable by api call#
      address <- str_replace_all(a," ","+")
      #put it together#
      gcall <- paste(mapsapi,output,"?","address=",address,"&","key=",key,sep="")
      return(gcall)
    }  
  
    gcall <- getGapi(googleid,address)
    lines <- readLines(gcall,warn="F")
    dat <- fromJSON(lines)
    lat <- dat$results$geometry$location$lat
    lng <- dat$results$geometry$location$lng
    # addcomp <- dat$results$address_components
    # addcomp <- as.data.frame(addcomp)
    # citystate<- paste(addcomp[4,2], addcomp[7,2],sep = ",+")
    
    # assign globally ------------------------------------------------------------------
    return(c(lng, lat))
}