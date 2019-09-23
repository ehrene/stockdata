#########################################################
## Compute performance from technicalsLoop.R output
## [in stockTechnicals folder]

stockPerfScripts <- function() {

library(quantmod)
  
perfSource = "/Users/ehren/Documents/StockAnalysis/stockTechnicals/"
destinationPath = "/Users/ehren/Documents/StockAnalysis/dailySummaries/"
perfFiles = list.files(path=perfSource,pattern=".csv")
totalFiles = length(perfFiles)
fileCount = 0
startTime = Sys.time()

dailyData <- read.zoo(paste(perfSource,"A.csv",sep=""), header = TRUE, sep = ",")
fileDate <- end(dailyData) #get latest date from data
dailyData <- data.frame(Symbols=NA,Date=index(dailyData),coredata(dailyData)) #add column for symbol

#dailyData <- dailyData[nrow(dailyData),] 
dailyData <- dailyData[! is.na(dailyData$Symbols),]


for (ii in perfFiles){
  
  data <- read.zoo(paste(perfSource,ii,sep=""), header = TRUE, sep = ",")
  data <- data[end(data),]
  data <- data.frame(Date=index(data),coredata(data)) #name the index column "Date"
  ## ticker string
  Symbol <- substr(ii,1,nchar(ii)-4)
  
  data <- data.frame(Symbols=NA,coredata(data))
  #start() and end() for xts indexes
  data$Symbols[1] <- Symbol
  
  dailyData <- rbind(dailyData,data)

  fileCount = fileCount + 1
    
 # print(paste(ii, " of", fileCount, " of ", totalFiles, " completed.", sep=""))
} #end main for loop


## Fix sloppy looking names of columns
names(dailyData)[names(dailyData) == 'Delt.1.arithmetic'] <- 'Delta1*'

names(dailyData)[names(dailyData) == 'Delt.5.arithmetic'] <- 'Delta5*'

names(dailyData)[names(dailyData) == 'atr'] <- 'ATR'

#chop out the date column since it's repetitive
# dailyData <- dailyData[,! colnames(dailyData) %in% c("Date")]

## Get data sorted for top ten biggest relative movers of the day...
dailyData <- dailyData[order(dailyData$Delta1),]
# Remove any data that is not from today's price history
dailyData <- dailyData[dailyData$Date == max(dailyData$Date),]
#Get worst Delt performers
topDecreases <- dailyData[((nrow(dailyData)-9):nrow(dailyData)),]
# Get best Delt Performers
topIncreases <- dailyData[1:10,]
# Bind the two sets
dailyDelt1 <- rbind(topIncreases,topDecreases)

## Write the Daily Delts (1-day) to a .csv file at destintionPath location
write.table(dailyDelt1, file=paste(destinationPath, fileDate,"_DailyDelt_1.csv",sep=""), na="", sep=",", row.names = FALSE)

print("Analysis completed.")
print(Sys.time() - startTime)
print(fileCount)

}
