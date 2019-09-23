# computeTechnicals computes several technical indicators for stocks saved in the tickers.txt file

#load the tickers.txt file
#tab separated file with list of tickers generated in SaveTickers.R

tickers <- read.delim("~/Documents/StockAnalysis/tickers.txt", header=FALSE, row.names=NULL, stringsAsFactors=FALSE)

#Write to file, tab separated
#use get(x) to access the xts object for the nth object
testTicker <- tickers[4,1]
getSymbols(testTicker)
testIndex <- index(get(testTicker))
tickerDF <-data.frame(testIndex, get(testTicker))
names(tickerDF)[1] <- "Date" #name the xts index column "Date"
#write.table(get(test), file="testTicker.txt", na="", sep="\t", row.names = FALSE)
write.table(tickerDF, file="testTicker.txt", na="", sep="\t", row.names = FALSE)

#MOVING AVERAGE (must point to the value being calculated (e.g. Close))
testSMA <- SMA(tickerDF[c('XXX.Close')], n=20)
testSMA[1:20,1] #print the first 20 values
getsymbols("^DJA") #Loads Dow Jones Composite Index as xts
SMA20 <-   SMA(DJA[,"DJA.Volume"], 20) #ENTER COLUMN IN QUOTES

#http://www.r-chart.com/2010/06/stock-analysis-using-r.html
chartSeries(DJA, subset='last 3 months')

#read the file created into memory as a data frame
# data = read.csv(file="spy_historical_data.txt")
technicalsFrame <- read.delim("testTicker.txt", header=TRUE, sep="\t",quote="\"")