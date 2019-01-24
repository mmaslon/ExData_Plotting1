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

#add new column, that has a date and time in the appropriate format
DT$datetime<-with(DT, as.POSIXct(paste(Date, Time),format="%d/%m/%Y %H:%M:%S"))

#subset required dates and store into new Dframe,
date1<-as.POSIXct("2007-02-01 00:00:00")
date2<-as.POSIXct("2007-02-02 23:59:59")
int<-interval(date1, date2)
DT_2days<-DT[DT$datetime %within% int,]
dim(DT_2days)


#change class to numeric
DT_2days$Global_active_power<-as.numeric(DT_2days$Global_active_power)
#graph no 1
png("plot1.png", width = 480, height = 480)
hist(DT_2days$Global_active_power, col="red", xlab="Global active power [kilowatts]", main = "Global active power")
dev.off()