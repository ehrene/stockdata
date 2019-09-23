##########################################
## Update data files 
## adapted from thertrader@gmail.com - Nov. 2015
##########################################
getStockData <- function(symbols=NULL, path=NULL) {
  library(quantmod)
  library(xts)
  library(zoo)
  
  errorPath = "/Users/ehren/Documents/StockAnalysis/errors/"
  errorTable <- data.frame(NUMBER=NA,TIME=NA,SYMBOL=NA, ERROR=NA) # table to write error messages to
  startTime = Sys.time()
  
  # -------------------------------------------------------------------
  symbols = as.vector(symbols)
  
  if (is.null(path)) {
    path = "/Users/ehren/Documents/StockAnalysis/stockData/"
  }
  
  else {
    path <- path
  } #end else
 
  for (ii in symbols){

    while(!ok & k<5){
      
      newSymbol=NULL
      
      try(newSymbol <- getSymbols(ii, 
                               src = "yahoo", 
                               auto.assign = FALSE), silent = TRUE)
      
      ## Check if the request to yahoo worked
      if(!is.null(newSymbol)) { 
        
        colnames(newSymbol) = c("open","high","low","close","volume","adj.") # set column names 
        
        write.zoo(newSymbol,paste(path, symbol, ".csv", sep=""),sep=",",row.names=FALSE) 
        
        ok=TRUE # flag to exit while loop 
        }
      
      else {
        ok=FALSE
        k=k+1
        Sys.sleep(1.33)
        print(paste(ii, " just errored",sep=""))
        errorTable[(nrow(errorTable)+1),] <- NA
        rowNum <- nrow(errorTable)
        errorTable$NUMBER[rowNum] <- nrow(errorTable)
        errorTable$TIME[rowNum] <- paste(Sys.Date())
        errorTable$SYMBOL[rowNum] <- lookup
        errorTable$ERROR[rowNum] <- "web lookup error"
      } # end else 
      
    } # end while
    
  } # end main for loop
  
  write.table(errorTable,paste(errorPath,Sys.Date(),"_UPDATE_errors.csv", sep=""),sep=",",row.names=FALSE)
  
  print(Sys.time()-startTime)
  
} #end function
