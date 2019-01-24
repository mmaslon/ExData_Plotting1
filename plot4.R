#set path
#create variable which contains path to working directory
library(dplyr)
library(data.table)
library(lubridate)
library(ggplot2)
path<-getwd()

#create variable specifying URL where the data is stored\
fileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

#create variable specifying file name for the dataset 
filename<-"dataset.zip"

#download dataset
if(!file.exists(path)) { dir.create(path) }
download.file(fileUrl,destfile = filename, method="curl")

#unzip and list the files, this requires the user to select the file when prompted
zipF<-file.choose()
unzip(zipF,exdir=path)

#read appropriate data sets using fread, check system time required first

system.time(DT <- fread("household_power_consumption.txt")) 
#read using fread and remove NA values, which are "?"
DT <- fread("household_power_consumption.txt", na.strings=c("?"))

#add new column, that has a da
DT$datetime<-with(DT, as.POSIXct(paste(Date, Time),format="%d/%m/%Y %H:%M:%S"))

#subset required dates and store into new Dframe,
date1<-as.POSIXct("2007-02-01 00:00:00")
date2<-as.POSIXct("2007-02-02 23:59:59")
int<-interval(date1, date2)
DT_2days<-DT[DT$datetime %within% int,]
dim(DT_2days)


#change class to numeric
DT_2days$Global_active_power<-as.numeric(DT_2days$Global_active_power)

#plot
library(gridExtra)

png("plot4.png", width = 480, height = 480)

p1<-ggplot(DT_2days,aes(datetime,Global_active_power)) +theme(axis.title.y = element_text(size=4))+theme_bw()+theme(axis.title.x=element_blank()) +geom_line()+theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+scale_x_datetime(date_labels=("%a"), date_breaks = "1 day") + labs(y="Global active power(kilowatts)")
p1<-p1+theme(axis.title = element_text(size=8), plot.margin = unit(c(1,1,1,1), "lines"))
p2<-ggplot(DT_2days,aes(datetime,Voltage)) +geom_line()+scale_x_datetime(date_labels=("%a"), date_breaks = "1 day") + labs(y="Voltage")+theme_bw()+scale_y_continuous(breaks=c(234,238,242,246))+theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())
p2<-p2+theme(axis.title = element_text(size=8), plot.margin = unit(c(1,1,1,1), "lines"))
p3<-ggplot(data = DT_2days_melted, aes(x=datetime, y=value)) + geom_line(aes(colour=variable))+ scale_color_manual(values = c("black", "red", "blue")) +scale_x_datetime(date_labels=("%a"), date_breaks = "1 day") +ylab("Energy sub metering") +theme_bw()+theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+theme(legend.title=element_blank())+theme(axis.title.x=element_blank())+theme(legend.position=c(0.9,0.9))
p3<-p3+theme(axis.title = element_text(size=8),legend.text = element_text(size=6),plot.margin = unit(c(1,1,1,1), "lines"))
p4<-ggplot(DT_2days,aes(datetime,Global_reactive_power)) +geom_line()+scale_x_datetime(date_labels=("%a"), date_breaks = "1 day") + labs(y="Global_reactive_power")+theme_bw()+scale_y_continuous(breaks=c(0.0,0.1,0.2,0.3,0.4,0.5))+theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())
p4<-p4+theme(axis.title = element_text(size=8), plot.margin = unit(c(1,1,1,1), "lines"))
grid.arrange(p1, p2, p3, p4, nrow = 2, ncol=2)
dev.off()