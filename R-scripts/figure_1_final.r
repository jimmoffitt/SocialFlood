library("reshape2")
library("ggplot2")
library("gridExtra")
library("scales")

figure1_data <- read.csv("~/work/hpt/BoulderFlood/plots/figure1_data.csv",sep=",")

# format ts
figure1_data$timestamp2 <- as.POSIXct(figure1_data$timestamp, format="%Y-%m-%d %H:%M")
figure1_data$timestamp3 <- figure1_data$timestamp2 + 16*60*60 #adds 6 hours

#Figure 1
#Rain increments, stage data, Tweets increments.

#--------------------------------------------------------------------------------------------------
#Hourly Rain

plot1 = ggplot(data=figure1_data) + 
  geom_bar(aes(x=timestamp3, y=rain_incr, color="blue"),stat="identity") + 
  ylab("Hourly rainfall (inches)") +  
  xlab("") + 
  theme(axis.text = element_text(size=16)
        , text = element_text(size=20)
        , legend.position="none"
        , axis.text.x = element_text(angle=0, vjust=.5))+  
  scale_x_datetime(
    breaks="24 hour"
    , minor_breaks="12 hour"
    , labels=date_format("%b-%d")
    , limits=c(as.POSIXct("2013-09-11 00:00:00"),as.POSIXct("2013-09-17 00:00:00"))
  )


#--------------------------------------------------------------------------------------------------
#Stage - with thresholds.
figure1_data$"Minor Flooding" <- 1
figure1_data$"Moderate Flooding" <- 2
figure1_data$"Major Flooding" <- 3
figure1_data$"Creek Level" <- 4
plot2 = ggplot(data=figure1_data) + 
  geom_line(aes(x=timestamp3, y=MinorFlooding, color="Stream Bank Full")) + 
  geom_line(aes(x=timestamp3, y=ModerateFlooding, color="Moderate Flooding")) + 
  geom_line(aes(x=timestamp3, y=MajorFlooding, color="Major Flooding")) + 
  geom_line(aes(x=timestamp3, y=stage,color="Stream Level")) + 
  geom_point(aes(x=timestamp3, y=stage),color="Blue") + 
  scale_color_manual(values=c("red","brown","orange","blue")) +
  ylab("Boulder Creek Stream Level (feet) \n") +  
  theme(axis.text = element_text(size=16)
        , text = element_text(size=20)
        , legend.position = c(.92,.23)
        , legend.title=element_blank()
        , axis.text.x = element_text(angle=0, vjust=.5)) +  
  scale_y_continuous(limits=c(0, 10),breaks=0:10) + 
  scale_x_datetime(
    breaks="24 hour"
    , minor_breaks="12 hour"
    , labels=date_format("%b-%d")
    , limits=c(as.POSIXct("2013-09-11 00:00:00"),as.POSIXct("2013-09-17 00:00:00"))
  ) +   xlab("")

#--------------------------------------------------------------------------------------------------
figure1_data$"Event Tweets"=1
figure1_data$"Baseline Tweets"=2
plot3 = ggplot(data=figure1_data) + 
  geom_line(aes(x=timestamp3, y=tweets_incr,color="Event Tweets")) + 
  geom_point(aes(x=timestamp3, y=tweets_incr),color="red") + 
  geom_line(aes(x=timestamp3, y=tweets_incr_baseline,color="Baseline Tweets")) + 
  geom_point(aes(x=timestamp3, y=tweets_incr_baseline),color="blue") + 
  scale_color_manual(values=c("blue","red"))+
  ylab("Tweets per hour") +  
  xlab("Date")+
  theme(axis.text = element_text(size=16)
        , text = element_text(size=20)
        , legend.position = c(.915,.86),legend.title=element_blank()
        , axis.text.x = element_text(angle=0, vjust=.5))+  
  scale_y_continuous(limits=c(0, 6000),breaks=c(0,1000,2000,3000,4000,5000,6000)) + 
  scale_x_datetime(
    breaks="24 hour"
    , minor_breaks="12 hour"
    , labels=date_format("%b-%d")
    , limits=c(as.POSIXct("2013-09-10 23:59:00"),as.POSIXct("2013-09-17 00:00:00"))
  )

grid.arrange(plot1, plot2, plot3, nrow=3)
