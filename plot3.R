
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

#Question 3: Which of the four sources of emissions have seen increases/decreases in Baltimore City
#Load dplyr and ggplot2 packages
library(dplyr)
library(ggplot2)
#Select Baltimore City (fips=="24510")
NEI1<-filter(NEI,fips=="24510")
#Group by year and source of emission 
NEI1<-group_by(NEI1,year,type)
#Summarise emissions by year and emission source
NEIyear<-summarise(NEI1,EmissionsTot=sum(Emissions))
#Scale emmissions for plot
NEIyear<-mutate(NEIyear,EmissionsTot1 = EmissionsTot / 1000)
#Output plot
png(file = "../plot3.png")
h<-ggplot(NEIyear,aes(as.character(year),EmissionsTot1)) + facet_grid(.~type) + geom_bar(stat="identity", fill="blue")
h + labs(title = "Total PM2.5 emissions in Baltimore City 1999 - 2008") +
    labs(x = "Year") +
    labs(y = "Total PM2.5 emissions (thousands of tons")
dev.off()