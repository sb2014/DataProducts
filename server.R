#server.R
library(shiny)
library(googleVis)

getWeeklyStockData <- function(tckr1 = "AAPL",
                               tckr2="MSFT",
                               chartid ="MyStockAnalysis", 
                               startDate=14975,
                               investmentTckr1=1000.00,
                               investmentTckr2=1000.00,
                               result='P'){
#       tckr1 <- "AAPL"
#       tckr2 <- "MSFT"
#       startDate <- 14975
#       chartid <- "Analysis"
#       investmentTckr1 <- 1000.00
#       investmentTckr2 <- 1000.00
#         result <- 'P'
  
  start.date <- as.Date(startDate, origin="1970-01-01")
  start.year <- format(start.date, "%Y")
  start.month <- format(start.date, "%m")
  start.day <- format(start.date, "%d")
  ## Yahoo finance sets January to 00 hence: 
  start.month <- as.numeric(start.month)  - 1
  start.month <- ifelse(start.month < 10, 
                        paste("0", start.month, sep=""), m)
  
  d <- Sys.time() 
  current.year <- format(d, "%Y")
  current.month <- format(d, "%m")
  current.day <- format(d, "%d")
  ## Yahoo finance sets January to 00 hence: 
  current.month <- as.numeric(current.month)  - 1
  current.month <- ifelse(current.month < 10, 
                          paste("0", current.month, sep=""), m)
  
  ## Get weekly stock prices for selected Tickers from Yahoo
  
  fn1 <- sprintf('http://ichart.finance.yahoo.com/table.csv?s=%s&a=%s&b=%s&c=%s&d=%s&e=%s&f=%s&g=w&ignore=.csv',
                 tckr1, start.month, start.day, start.year, current.month, current.day, current.year)
  data1 <- read.csv(fn1, colClasses=c("Date", rep("numeric",6)))
  tckr1BuyPrice <- data1[which.min(data1[,1]),7]
  tckr1CurrentPrice <- data1[which.max(data1[,1]),7]
  
  fn2 <- sprintf('http://ichart.finance.yahoo.com/table.csv?s=%s&a=%s&b=%s&c=%s&d=%s&e=%s&f=%s&g=w&ignore=.csv',
                 tckr2, start.month, start.day, start.year, current.month, current.day, current.year)
  data2 <- read.csv(fn2, colClasses=c("Date", rep("numeric",6)))
  tckr2BuyPrice <- data2[which.min(data2[,1]),7]
  tckr2CurrentPrice <- data2[which.max(data2[,1]),7]
  
  currValue1 <- investmentTckr1 + (investmentTckr1 * (tckr1CurrentPrice-tckr1BuyPrice) / tckr1BuyPrice)
  currValue2 <- investmentTckr2 + (investmentTckr2 * (tckr2CurrentPrice-tckr2BuyPrice) / tckr2BuyPrice)
  currValue <- currValue1 + currValue2
  
  data1$Ticker <- tckr1
  data2$Ticker <- tckr2
  data <- rbind(data1, data2)
  #data <- rbind(data, data.frame(Date = "2050-01-01", Open=0, High=0, Low=0, Close=0, Volume=0, Adj.Close=currValue, Ticker='XXX' ))
  
  
    if(result=='P') 
    (gvisAnnotatedTimeLine(
      data, 
      datevar="Date", 
      numvar="Adj.Close", 
      idvar="Ticker", 
      chartid=chartid,
      options=list( 
        colors="['blue', 'green']", 
        zoomStartTime=start.date, 
        zoomEndTime=as.Date(d), 
        legendPosition='newRow', 
        width="600px", height="400px", 
        scaleColumns='[0,1]', 
        scaleType='allmaximized')
    ))
  else
      paste("$",format(round(currValue, 2), nsmall = 2))

}

shinyServer(function(input, output) {
  
    output$view <- renderGvis({
            getWeeklyStockData(tckr1 = input$stock1,
                               tckr2 = input$stock2,
                               chartid = "MyStockAnalysis", 
                               startDate = input$invDate,
                               investmentTckr1 = input$inv1,
                               investmentTckr2 = input$inv2,
                               result = 'P'
                               )
  })
  
    output$currValue <- renderText({
    getWeeklyStockData(tckr1 = input$stock1,
                               tckr2 = input$stock2,
                               chartid = "MyStockAnalysis", 
                               startDate = input$invDate,
                               investmentTckr1 = input$inv1,
                               investmentTckr2 = input$inv2,
                               result = 'V'
                      )
  })
  })

