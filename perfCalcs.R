#########################################################
## Compute performance from technicalsLoop.R output
## [in stockTechnicals folder]


perfSource = "/Users/ehren/Documents/StockAnalysis/stockTechnicals/"
destinationPath = "/Users/ehren/Documents/StockAnalysis/dailySummaries/"
perfFiles = list.files(path=perfSource,pattern=".csv")
fileDate <- Sys.Date()
fileCount = 0

dailyData <- read.zoo(paste(perfSource,"A.csv",sep=""), header = TRUE, sep = ",")
dailyData <- data.frame(dailyData[end(dailyData),])
dailyData <- data.frame(Symbols=NA,coredata(dailyData))


for (ii in perfFiles){
  
  data <- read.zoo(paste(perfSource,ii,sep=""), header = TRUE, sep = ",")
  data <- data[end(data),]
  data <- data.frame(Date=index(data),coredata(data))
  ## ticker string
  Symbol <- substr(ii,1,nchar(ii)-4)
  
  data <- data.frame(Symbols=NA,coredata(data))
  #start() and end() for xts indexes
  data$Symbols[1] <- Symbol
  
  names(data)[names(data) == 'Delt.1.arithmetic'] <- 'Delta-1'
  names(data)[names(data) == 'Delt.5.arithmetic'] <- 'Delta-5'
  names(data)[names(data) == 'atr'] <- 'ATR'
  
 # newrow = as.data.frame(data[Sys.Date(),])
#   newrow$ticker <- NA
#   newrow$ticker[fileDate,] <- ticker
  
  dailyData <- rbind(dailyData,data)
  
  ## Get the column with the max value for RSI
  # RSIList <- data[max(data$RSI, na.rm=TRUE),]
  ##########################################
#   get max of column max(data$RSI, na.rm=TRUE)
#   And to sort:
#     
  # ozone[order(ozone$Solar.R),]
  print(ii," completed.")
}

## Get data sorted for top ten biggest movers of the day...
dailyData[order(dailyData$Delt.1.arithmetic),]
topDecreases <- dailyData[(nrow(dailyData)-10:nrow(dailyData)),]
topIncreases <- dailyData[1:10,]
dailyDelt_1 <- rbind(topIncreases,topDecreases)

## Write the Daily Delts (1-day) to a .csv file at destintionPath location
write.table(dailyDelt_1, file=paste(destinationPath, fileDate,"_DailyDelt_1.csv",sep=""), na="", sep=",", row.names = FALSE)


