
tickers <- read.csv("/Users/ehren/Documents/StockAnalysis/tickerSymbols.csv", header=FALSE)$V1
tickers <- as.character(tickers)

getSymbolsCont <- 
  function(tickers, from=NULL, to=Sys.Date(), src="yahoo") { 
    lookback = 60
    startDate = Sys.Date() - lookback
    thePath = "/Users/ehren/Documents/StockAnalysis/stockData/"
    theFiles = list.files(path=thePath,pattern=".csv")
    ok = FALSE 
    n = NROW(tickers) 
    i = 1 
    while(i <= n | !ok) { 
      
      print(tickers[i]) 
      
      sym = NULL 
      try ( sym <- getSymbols(tickers[i], from=from, to=to, src=src, 
                              auto.assign=FALSE)) 
      
      if(!is.null(sym)) { 
        assign(tickers[i], sym, envir = .GlobalEnv) 
        i = i+1 
        ok=TRUE 
      } else {ok=FALSE} 
      
      Sys.sleep(1) 
    } 
    return(sym)
  } 

