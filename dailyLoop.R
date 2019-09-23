## Script to execute the three main scripts for daily stock data updates
## updates to technical analyses, and execution of the stock performance script
dailyLoop <- function() { 
start_time = Sys.time()

# Execute the daily update script
updateData()


# Execute script to update technicals data
technicalsLoop()

#execute script to compare technicals and identify top movers
stockPerfScripts()

end_time = Sys.time()

return(end_time - start_time)

}
