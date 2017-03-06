reType <- function(df) {
  df$`Sold Price` <- as.numeric(gsub("[^0-9]","",df$`Sold Price`))
  df$`List Price` <- as.numeric(gsub("[^0-9]","",df$`List Price`))
  df$`Tax Value` <- as.numeric(gsub("[^0-9]","",df$`Tax Value`))
  #tax value 0 = na
  df$Fireplace <- as.numeric(df$Fireplace)
  df$`New Constr` <- as.factor(df$`New Constr`)
  df$Subdivisio <- as.factor(df$Subdivisio)
  df$Acres <- as.factor(df$Acres)
  df$`Property T` <- as.factor(df$`Property T`)
  return(df)
}
