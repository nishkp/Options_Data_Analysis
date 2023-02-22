#'[Imports and Library's]
  library(tidyverse) 
  library(dplyr)
  library(RColorBrewer)
  library(pals)
  display.brewer.all()
  view(optionData)

#'*Creating Data Frames*
  optionData$TimeSeNum <- as.double(substr(optionData$TimeSe, 18 , 27))
  optionData$TimeOmOutNum <- as.double(substr(optionData$TimeOmOut, 18 , 27))
  optionData$TimeOmInNum <- as.double(substr(optionData$TimeOmIn, 18 , 27))
    optionData$ExecutionTime = optionDaAFta$TimeOmInNum - optionData$TimeOmOutNum
    optionData$TotalTime = optionData$TimeOmInNum - optionData$TimeOmOutNum
    optionData$order_market = optionData$Size/optionData$MarketSize
  
  adjOptionData <- optionData %>% filter(OrderEventTypeOmIn != "")
  
  order_cancel <- subset(adjOptionData, OrderEventTypeOmIn == "CANCEL")
  order_fill <- subset(adjOptionData, OrderEventTypeOmIn == "FILL")

#'*Before Research Metrics*
  cat("Avg Time in Force:", mean(adjOptionData$TotalTime))
  rejected =  ((nrow(optionData) - nrow(adjOptionData))/nrow(optionData))
  cat("Rejected:", (rejected * 100), "%")
  mean(adjOptionData$ExecutionTime)
  sum(adjOptionData$ExecutionTime)
  

#'*Price VS Order Type and Analysis*
  optionData$total_price = optionData$Price * optionData$Size
  #t-test
  x1 = print(median(order_cancel$total_price))
  y1 = print(median(order_fill$total_price))
  t.test(order_cancel$total_price, order_fill$total_price)
  #plot
  ggplot(adjOptionData, aes (OrderEventTypeOmIn, total_price, color = OrderEventTypeOmIn)) +
    geom_jitter(width = .15, alpha = .5, size = .5) +
    geom_hline(yintercept=x1, linetype="dashed", color = "red") +
    geom_hline(yintercept=y1, linetype="dashed", color = "blue") +
    scale_y_continuous(trans = "log2") +
    labs(x = "Order Event Type", y = "Value of Buy or Sell", title = "Order Event Type VS Total Value")+
    theme_minimal() +
    theme(legend.position = "none") +
    theme(plot.title = element_text(hjust = 0.5))
  
  ggplot(order_cancel, aes (total_price)) +
    geom_freqpoly() +
    scale_y_continuous(trans = "log2") +
    labs(x = "Order Price Cancel", y = "Count")+
    theme_minimal() +
    theme(legend.position = "none") +
    theme(plot.title = element_text(hjust = 0.5))
  
  ggplot(order_fill, aes (total_price)) +
    geom_freqpoly() +
    scale_y_continuous(trans = "log2") +
    labs(x = "Order Price Fill", y = "Count")+
    theme_minimal() +
    theme(legend.position = "none") +
    theme(plot.title = element_text(hjust = 0.5))
  

#'*Portion of Market Size VS Order Event Type*
  #t-test
  t.test(order_cancel$order_market, order_fill$order_market)
    x2 = print(median(order_cancel$order_market))
    y2 = print(median(order_fill$order_market))
  #plot
  ggplot(adjOptionData, aes (OrderEventTypeOmIn, order_market, color = OrderEventTypeOmIn)) +
    geom_jitter(size = .4, width = .1, alpha = .75) +
    geom_hline(yintercept=x2, linetype="dashed", color = "red") +
    geom_hline(yintercept=y2, linetype="dashed", color = "blue") +
    labs(x = "Order Event Type", y = "% of Market Size", title = "% of Market Size VS Order Event Type")+
    theme_minimal() +
    theme(legend.position = "none") +
    theme(plot.title = element_text(hjust = 0.5))
  

#'*Exchange VS Time in Force*
  ggplot(adjOptionData, aes (Exchange, TotalTime, color = Exchange)) +
    geom_jitter(size = .4, width = .4, alpha = .55) +
    labs(x = "Exchange", y = "Time In Force", title = "Time in Force VS Exchange") +
    scale_color_manual(values=as.vector(okabe())) + 
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))
  
  
#'*Rejected VS Underlying Symbol*
  ggplot(optionData, aes (UnderlyingSymbol, Exchange, color = OrderEventType)) +
    geom_jitter(size = .2, width = .2, alpha = .5) +
    labs(x = "Underylying Symbol", y = "Exchange") +
    scale_color_manual(values=as.vector(glasbey())) + 
    theme_minimal()+
    theme(plot.title = element_text(hjust = 0.5))
  

#'*Post-Analysis Metrics*
  finalOptionData = subset(adjOptionData, Exchange!="AMEX" & Exchange!="PHLX")
  mean(finalOptionData$ExecutionTime)  
  sum(finalOptionData$ExecutionTime)    
  
  