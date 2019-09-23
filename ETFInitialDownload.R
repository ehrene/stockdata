##########################################
## Daily prices from Yahoo 
## Based on The R Trader listing 
## thertrader@gmail.com - Nov. 2015
##########################################
library(quantmod)

thePath = "/Users/ehren/Documents/StockAnalysis/stockData/"

theInstruments <- read.csv("/Users/ehren/Documents/StockAnalysis/ETFList.csv", header=FALSE)
numSymbols <- NROW(theInstruments)

for (i in 1:numSymbols){
  print(paste(theInstruments[i,]," (",i,")",sep=""))
  data = getSymbols(paste(theInstruments[i,]),
                    src = "yahoo", 
                    auto.assign = FALSE)
  colnames(data) = c("open","high","low","close","volume","adj.")
  write.zoo(data,paste(thePath,theInstruments[i,],".csv",sep=""),sep=",",row.names=FALSE)
}
# MFLA, 822
# ROLA, 1028