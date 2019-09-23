

VolAnalysis <- function(priceThreshold = NULL) {

  ######### FUNCTION VARIABLES ##################
  priceThreshold = 10 #priceThreshold # penny stock price threshold
  volSummary = data.frame(Symbol=NA, Date = NA, TenDayChange=NA, VolMax=NA)
  
  ######### BOOKEEPING STUFF ####################
  thePath = "/Users/ehren/Documents/StockAnalysis/volatilityData/"
  theFiles = list.files(path=thePath, pattern=".csv")
  errorTable <- data.frame(NUMBER=NA, TIME=NA, SYMBOL=NA, ERROR=NA) # table to write error messages to
  errorPath = "/Users/ehren/Documents/StockAnalysis/volatilityData/errorLog/"
  pennyCount = 0
  k=1
  row=1
  ###############################################  
  
  while (k <= length(theFiles)) {
    
    vdata <- read.zoo(paste(thePath,theFiles[k], sep=""), header = TRUE, sep=",")
  
    if ( last(vdata$adj. > priceThreshold && ncol(vdata) > 2) ) {
      # vdata[as.Date('2016-06-02'),]
      volChange <- diff(vdata$tenVol[(nrow(vdata)-1):nrow(vdata),])
      volMax <- last(vdata$tenVol)
      
      volSummary[(nrow(volSummary)+1),] <- NA
      volSummary$Symbol[row] = substr(theFiles[k], 1, nchar(theFiles)-4)
      volSummary$Date[row] = as.Date(index(vdata[nrow(vdata)]))
      volSummary$TenDayChange[row] = volChange
      volSummary$VolMax[row] = volMax
      row = row + 1
      k = k + 1
      print(k)
      } # end priceThreshold if
    
    else {
      pennyCount = pennyCount + 1
      print(paste("Penny stock count = ", pennyCount, sep=""))
      k = k + 1
    } # end priceThreshold else
    
    }# end while
  
  return(volSummary)
  
} #end function
