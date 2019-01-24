#set path
#create variable which contains path to working directory
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
DT <- fread("household_power_consumption.txt")