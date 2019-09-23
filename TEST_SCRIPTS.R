## Test file for developing scripts for stockData

stockPath = "/Users/ehren/Documents/StockAnalysis/stockData/"
technicalsPath = "/Users/ehren/Documents/StockAnalysis/stockTechnicals/"

theSymbol = "T.csv"
theFiles = list.files(path=thePath, pattern=".csv")

stockData = read.zoo(paste(stockPath,theSymbol,sep=""),header=TRUE, sep=",")
techData = read.zoo(paste(technicalsPath,theSymbol,sep=""),header=TRUE, sep=",")

test = match(theSymbol, theFiles)

# colnames(data) = c("open","high","low","close","volume","adj.")

data = xts(data[,c("open","high","low","close","volume","adj.")],
           order.by = as.Date(data[,"Index"],format="%Y-%m-%d"))

symbolDelt = Delt(data$close,k=1,type=c("arithmetic","log"))


# dat <- matrix(runif(40,1,20),ncol=4) # make data
matplot(dat, type = c("b"),pch=1,col = 1:4) #plot
legend("topleft", legend = 1:4, col=1:4, pch=1)


###### build a matrix with rollmeans of data for MACD
pdat = as.xts(techData$MACD)
pdat <- pdat['2014/2015']
colnames(pdat)[1]= paste(substr(theSymbol,1,nchar(theSymbol)-4),"_MACD",sep = "")
                           

# nrow(rollmean(pdat,5,na.pad = TRUE))
plotdat <- cbind(pdat, rollmean(pdat,5),
                 rollmean(pdat,10),
                 rollmean(pdat,15))

# colnames(pdat)[2]="RM_5"
colnames(plotdat)=c(paste(substr(theSymbol,1,nchar(theSymbol)-4)),"RM_5", "RM_10", "RM_15")
start=nrow(plotdat)
plotdat <- na.omit(plotdat)
enddat=nrow(plotdat)
print(start-enddat)

matplot(plotdat, type = c("b"),pch=1,col = 1:4) #plot
legend("topleft", legend = 1:4, col=1:4, pch=1)

pdat<-pdat[,! colnames(pdat) %in% c("crap","crap1")]


                    # roll = 2
                    # start = 1
                    # maxes = data.frame(open=NA,high=NA,low=NA,close=NA,volume=NA,adj=NA)
                    # rownames(maxes) <- maxes$Index
                    # maxes$Index=NULL
                    # 
                    # maxes = xts(open=NA,high=NA,low=NA,close=NA,volume=NA,adj=NA)
                    # attributes(maxes)$index[1] <- as.POSIXct("2000-01-01")
                    # # maxes=as.xts(maxes)
                    # order.by = as.Date(data[,"Index"],format="%Y-%m-%d")

########################################################
######## USE WHICH.MAX TO FIND MAXIMA
## CREATE Starting Data
stockData=as.xts(stockData)
stockData=stockData['2008-7']
nrow(stockData)

maxes = read.zoo(paste(stockPath,"AAPL.csv",sep=""),header=TRUE, sep=",")
maxes = as.xts(maxes)
maxes = maxes[1,]
maxes[1,] = NA
attributes(maxes)$index[1] <- as.POSIXct("2000-01-01")

####
endrow = nrow(stockData)
####

localMaxIndex = which.max(stockData$close) #get first local maximum
localMaxIndex
nextMax = stockData[localMaxIndex,]
nextMax
maxes=rbind(maxes,nextMax)
maxes
stockData = stockData[(localMaxIndex+2):nrow(stockData),]
nrow(stockData)
maxes

##########################################################
# MAKE POINTS for plotting  - does not work right now

maxes=na.omit(maxes) #remove the NA row in initial xts object for maxes

stockData = read.zoo(paste(stockPath,theSymbol,sep=""),header=TRUE, sep=",")

plot.xts(stockData$close)

points( maxes$close, col="red", pch=19, cex=15  )


###### COMPARE TICKER SYMBOLS LIST ##########################################################

oldSymbolFile = '//Users/ehren/Documents/StockAnalysis/tickerSymbols_01.csv'
newSymbolFile = '//Users/ehren/Documents/StockAnalysis/tickerSymbols.csv'
ETFListFile = '//Users/ehren/Documents/StockAnalysis/ETFList.csv'
  
oldSymbols = read.csv(oldSymbolFile, header=FALSE, sep=",")
newSymbols = read.csv(newSymbolFile, header=FALSE, sep=",")
ETFList = read.csv(ETFListFile, header=FALSE, sep=",")


nrow(newSymbols)-nrow(oldSymbols)

Date=c("7/3/2007","7/5/2007","7/6/2007","7/9/2007","7/10/2007","7/11/2007","7/12/2007","7/13/2007","7/16/2007","7/17/2008","7/18/2007")
Close=c(106.58,108.05,109.03,108.97,108.63,109.1,109.28,108.6,109.66,110.77,111.08)

Change=c(NA, 1.38,0.91,-0.06,-0.31,0.43,0.16,-0.62,0.98,1.01,0.28)

bex = data.frame(Date=Date,Close=Close,Change=Change)
		
# Read more: Option Volatility: Historical Volatility | Investopedia http://www.investopedia.com/university/optionvolatility/volatility2.asp#ixzz49iAjXaRe 
# Follow us: Investopedia on Facebook

#################### BUILD HISTORICAL VOLATILITY ##################################

library(gmailr)

mime() %>%
  to("webehren@gmail.com") %>%
  from("webehren@gmail.com") %>%
  text_body("My First Email using R.") -> first_part

first_part %>%
  subject("Test Mail from R") %>%
  # attach_file("BazaarQueriesforURLData.txt") -> file_attachment

 send_message()

file_attachment


























