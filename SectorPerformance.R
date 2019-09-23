# Compare sectors
library(lattice)
library(ggplot2)
library(zoo)
library(xts)
library(quantmod)
library(stringr)

stockDataPath = "/Users/ehren/Documents/StockAnalysis/stockData/"

# Load tickers from existing list of instrument data in "stockData" directory
stockList = list.files(stockDataPath, pattern=".csv")

# remove the indexes that are in stockList (i.e. symbol starts with caret ^ )
startPoint= max(grep("\\^", stockList))  + 1 # uses regex to find indices of where the caret was found

stockList = stockList[startPoint:length(stockList)]

# Load the master Listing table (loads as dataframe by default)
masterListingTable = read.csv("/Users/ehren/Documents/StockAnalysis/masterListing.csv", header = TRUE, sep = ",")

# set the lookup period following syntax for xts references
thePeriod = '2016'

k=0

# increment thru stock list, using the masterListingTable symbols
for (ii in stockList) {
  
  symbol = substr(ii,1, nchar(ii)-4)
  
  data = as.xts(read.zoo(paste(stockDataPath,ii,sep=""), sep=",", header=TRUE))
  
  # currentAnnRet = last(annualReturn(data$close))  #current annual return
  # currentQrtRet = last(quarterlyReturn(data$close))  #current quarterly return

  # uncomment the two lines below to return to previous state of operation
  currentAnnRet = NULL
  currentQrtRet = NULL
  try(currentAnnRet <- annualReturn(data$close[thePeriod]), silent=TRUE)  #current annual return
  try(currentQrtRet <- quarterlyReturn(data$close[thePeriod]), silent=TRUE)  #current annual return
  
  #get location of stock data
  try(updateIndex <- match(symbol,masterListingTable$Symbol), silent = TRUE)

  
  if( ! is.null(updateIndex) && !is.null(currentAnnRet)){
  masterListingTable$QrtRet[updateIndex] = last(currentQrtRet)
  masterListingTable$AnnRet[updateIndex] = last(currentAnnRet)
  }
   
  else{
    print(paste("Symbol not found: ", symbol, sep=""))
    k=k+1
  }

} #end for loop

print(paste("Symbols not found in master listing: ", k, sep=""))

#compute the performance by factors
masterListingTable$Sector <- sub("^$","NONE", masterListingTable$Sector) #replace "" labels with "NONE"
masterListingTable$Sector <- as.factor(masterListingTable$Sector)
masterListingTable$Industry <- as.factor(masterListingTable$Industry)
masterListingTable$Exchange <- factor(masterListingTable$Exchange, levels=c("AMEX","NASDAQ","NYSE"))

#unfactor symbols, name, MarketCap
masterListingTable$Symbol <- as.character(masterListingTable$Symbol)
masterListingTable$Name <- as.character(masterListingTable$Name)
masterListingTable$MarketCap <- sub("\\$","",masterListingTable$MarketCap) #remove $
masterListingTable$MarketCap <- sub("\\.","",masterListingTable$MarketCap) #replace period with comma
masterListingTable$MarketCap <- sub("M","0000",masterListingTable$MarketCap) # 
masterListingTable$MarketCap <- sub("B","0000000",masterListingTable$MarketCap)
masterListingTable$MarketCap <- as.numeric(masterListingTable$MarketCap)
#masterListingTable$Symbol <- droplevels(masterListingTable$Symbol)

# Write the masterListingTable to new file in data
filePath = "/Users/ehren/Documents/StockAnalysis/"
fileName = paste("masterListingPerf",Sys.Date(),sep="_")

write.table(masterListingTable, paste(filePath, fileName, ".csv", sep=""), na="", sep=",", row.names=FALSE)
print(paste("file written: ", fileName), sep="")

############################
masterListingTable = read.csv("/Users/ehren/Documents/StockAnalysis/masterListing.csv", header = TRUE, sep = ",")
############################

tdf = masterListingTable
tdf = masterListingTable[masterListingTable$LastSale > 10, ]  #remove "penny" stocks

# box plot using ggplot
ggplot(masterListingTable, aes(y=masterListingTable$MarketCap, x=masterListingTable$Sector)) + geom_boxplot()


# plot Jitter plot of returns by sector
qplot(Sector, AnnRet, data=tdf, color = Sector, geom = "jitter",alpha =1/150)

# plot boxplot of sectors, colored by exchange
qplot(Sector, AnnRet, data=tdf, color = Exchange, geom = "boxplot")

# plot histogram of MarketCap
qplot(MarketCap, data = tdf, color = Exchange, geom = "histogram", binwidth = 100000000)

# plot histogram of Annual Returns colored by exchange and labeled
qplot(AnnRet, 
      data = tdf, 
      color = Sector, 
      geom = "histogram", 
      binwidth = .01, 
      main = paste("Annual Return by Exchange ", thePeriod, " (generated: ",Sys.Date(), ")", sep=""), 
      xlab = "Annual Return (%)", 
      ylab = "Count")

# abline(v = 0, untf = FALSE, col="black")

