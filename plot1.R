
#Set the working directory as the git master directory
setwd("C:/Users/Ian/Documents/DataScience/ExploratoryAnalysis/Project2")

#use this to set up a sub-directory to store the download data in
if (!file.exists("Data")){
  dir.create("Data")
}

#Project data url
url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

#Use this to download the file
download.file(url, destfile="./FNEI_data.zip", mode="wb")

#Unzip the downloaded file into the data folder
unzip("./FNEI_data.zip", exdir="./data")

NEI <- readRDS(paste(getwd(),"/data/","summarySCC_PM25.rds",sep = ""))
SCC <- readRDS(paste(getwd(),"/data/","Source_Classification_Code.rds",sep = ""))

#Check the files are in memory
setwd("./data")
dir()

#Question 1: Have total pm25 emissions decreased in USA as a whole from 1999 to 2008
#Load dplyr package
library(dplyr)
#Group by year
NEI1<-group_by(NEI,year)
#Summarise emissions by year
NEIyear<-summarise(NEI1,EmissionsTot=sum(Emissions))
#Scale emmissions for plot
NEIyear<-mutate(NEIyear,EmissionsTot1 = EmissionsTot / 1000)
#Output plot
png(file = "../plot1.png")
with(NEIyear,barplot(EmissionsTot1, col = "blue", main="Total PM2.5 emissions in USA 1999-2008", names.arg=year, xlab="Year", ylab="PM2.5 emissions (thousands of tons)"))
dev.off()