##########################################
## Loop thru files in stockData and compute technicals for each 
## technicals computed are: SMA10, EMA10, ATR, RSI, Delta-1, Delta-5
##########################################
##########################################
technicalsLoop <- function(){

  library(quantmod)

sourcePath = "/Users/ehren/Documents/StockAnalysis/stockData/"
destinationPath = "/Users/ehren/Documents/StockAnalysis/stockTechnicals/"
errorPath = "/Users/ehren/Documents/StockAnalysis/errors/"
theFiles = list.files(path=sourcePath,pattern=".csv")
errorTable <- data.frame(TIME=0,SYMBOL=0, ERROR=0)
k=0 # error counter for insufficient data
fileCount = 0
startTime = Sys.time()

for (ii in theFiles){
  
  #data = read.csv(paste(sourcePath,ii,sep=""))
  ## read .csv file as zoo
  data <- read.zoo(paste(sourcePath,ii,sep=""), header = TRUE, sep = ",")
  #print(paste(ii," loaded", sep=""))
  
  if (NROW(data) > 14) {
    ## Compute the Simple Moving Average (SMA) with a 10 day period
    data$SMA10 <- SMA(data$close, n=10)
    #print(paste("SMA10 calculated for ", ii, sep=""))
    
    ## Compute the Exponential Moving Average (EMA) with a 10 day period
    data$EMA10 <- EMA(data$close,n=10,wilder=FALSE, ratio=NULL)
    #print(paste("EMA10 calculated for ", ii, sep=""))
    
    ## compute ATR with a 14 day period
    data <- cbind(data, ATR(data[,c("high","low","close")], n=14)) 

    ## Compute RSI for the CLOSE price w/ period of 14
    data$RSI <- RSI(data$close, n = 14)
    
    ## Compute the relative "Delt" in the price over last 1 and 5 days
    data <- cbind(data, Delt(data$close, k= c(1,5), type = "arithmetic"))
  } 
    ## Compute the MACD data with standard parameters
  if (nrow(data)>=30){
    data <- cbind(data,MACD(data$close, nFast = 26, nSlow = 12, maType = "EMA", percent = FALSE))
    # print(paste(fileCount,": ", ii," MACD"))
    # data <- cbind(data,MACD(data$volume, nFast = 26, nSlow = 12, percent = TRUE))
  } #end MACD check
    
   else {
    k=k+1
    data$SMA10 <- NA
    data$EMA10 <- NA
    data$atr   <- NA
    data$RSI   <- NA
    data$RSI   <- NA
    data$Delt.1.arithmetic <- NA
    data$Delt.5.arithmetic <- NA
    data$macd <- NA
    data$signal <- NA
    # error logging functions
    errorTable[k,] <- NA
    errorTable$TIME[k] <- paste(Sys.time())
    errorTable$SYMBOL[k] <- ii
    errorTable$ERROR[k] <- "Insufficient data"
    #print(paste("Insufficient data for: ", ii, sep=""))
  }
  
  ## remove the "tr", "trueLow", and "trueHigh" columns from ATR calculation
  data <- data[,! colnames(data) %in% c("tr","trueLow","trueHigh")]
 
  # rename ATR
  names(data)[names(data) == "atr"] <- "ATR"

  names(data)[names(data) == "macd"] <- "MACD"
  names(data)[names(data) == "signal"] <- "MACD Signal"
  
  #### INSERT OTHER TECHNICALS  ####
  
  ## REMOVE EXCESS COLUMNS FROM PRICE DATA
  data <- data[,! colnames(data) %in% c("open","high","low","volume","adj.")]
  
  ## Write the technicals to a .csv file at destintionPath location
  write.zoo(data,paste(destinationPath, ii,sep=""),sep=",",row.names=FALSE)
  
  fileCount = fileCount + 1
  
}

write.table(errorTable,paste(errorPath,Sys.Date(),"_tech_errors.csv", sep=""),sep=",",row.names=FALSE)

print(Sys.time()-startTime)
print(fileCount)

} #end function loop

