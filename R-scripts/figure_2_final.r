library("reshape2")
library("ggplot2")
library("gridExtra")
library("scales")

#Figure 2
#Followers.

figure2_data <- read.csv("~/work/hpt/BoulderFlood/plots/figure2_data.csv",sep=",")
#Format the dates for plots.
figure2_data$timestamp2 <- as.POSIXct(figure2_data$timestamp, format="%Y-%m-%d %H:%M",tz="UTC")


#With figure 2, we are not renaming columns until sub-dataframe is created.
#colnames(figure2_data) <- c("Date","RainAccum", "RainIncr","stage","combined_incr","combined_accum")

#--------------------------------------------------------------------------------------------------
#Plot 1 - Hourly Rain Accumulation

plot1 = ggplot(data=figure2_data) + 
  geom_line(aes(x=timestamp2, y=rain_accum),color="red") + 
  geom_point(aes(x=timestamp2, y=rain_accum),color="red") + 
  ylab("Total Rain (inches) \n") +  
  xlab("")+
  theme(axis.text = element_text(size=16)
        , text = element_text(size=20)
        , legend.position="none"
        , axis.text.x = element_text(angle=0, vjust=.5))+  
  scale_y_continuous(limits=c(0, 15),breaks=0:15) + 
  scale_x_datetime(
    breaks="24 hour"
    , minor_breaks="12 hour"
    , labels=date_format("%b-%d")
    , limits=c(as.POSIXct("2013-09-10 23:59:00"),as.POSIXct("2013-09-17 00:00:00"))
  )


#--------------------------------------------------------------------------------------------------
#Plot 2 - New followers.
plot2 = ggplot(data=figure2_data) + 
  geom_line(aes(x=timestamp2, y=combined_accum),color="blue") + 
  geom_point(aes(x=timestamp2, y=combined_accum),color="blue") + 
  ylab("New Followers") +  
  xlab("Date")+
  theme(axis.text = element_text(size=16)
        , text = element_text(size=20)
        , legend.position="none"
        , axis.text.x = element_text(angle=0, vjust=.5))+  
  scale_y_continuous(limits=c(0, 6000),breaks=c(0,1000,2000,3000,4000,5000,6000)) + 
  scale_x_datetime(
    breaks="24 hour"
    , minor_breaks="12 hour"
    , labels=date_format("%b-%d")
    , limits=c(as.POSIXct("2013-09-10 23:59:00"),as.POSIXct("2013-09-17 00:00:00"))
  )

grid.arrange(plot1, plot2, nrow=2)