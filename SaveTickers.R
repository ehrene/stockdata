#Get ticker listing data
listings <- stockSymbols()

#order it ascend/descen
#listings <- listings[order(listings$MarketCap,decreasing=TRUE),]

#Generate files for each of the exchanges ticker symbols
listings <- stockSymbols("NYSE")
write.table(listings, file="tickersNYSE.txt",na="",sep="\t",row.names=FALSE)
listings <- stockSymbols("NASDAQ")
write.table(listings, file="tickersNASDAQ.txt",na="",sep="\t",row.names=FALSE)
listings <- stockSymbols("AMEX")
write.table(listings, file="tickersAMEX.txt",na="",sep="\t",row.names=FALSE)


#separate the symbols only, unique removes duplicates 
tickers <- unique(gsub("-.*","",listings$Symbol))

#order alphabetically
tickers <- tickers[order(tickers,decreasing=FALSE)]

#Write to file, tab separated
write.table(tickers, file="tickers.txt", na="", sep="\t", row.names = FALSE)