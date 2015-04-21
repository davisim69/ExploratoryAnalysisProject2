
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

#Question 5: how have emissions from motor vehicles changed over years in Baltimore City
#Load dplyr and ggplot2 packages
library(dplyr)
library(ggplot2)

#Identify motor vehicles in SCC data frame
#Include non-point from Data.Catagory as this includes some vehicles
motor<-filter(SCC,grepl("[Mm]otor|[Vv]eh.(*)", Short.Name) & Data.Category !="Point")

#subset NEI data frame using selected motor vehicle SCC codes from SCC data frame
NEI1<-NEI[NEI$SCC %in% motor$SCC,]

#Select Baltimore City, Maryland (fips=="24510")
NEI2<-filter(NEI1,fips=="24510")

#Group by year and source of emission 
NEI3<-group_by(NEI2,year)
#Summarise emissions by year and emission source
NEIyear<-summarise(NEI3,EmissionsTot=sum(Emissions))
#Scale emmissions for plot
NEIyear<-mutate(NEIyear,EmissionsTot1 = EmissionsTot / 1000)
#Output plot
png(file = "../plot5.png")
h<-ggplot(NEIyear,aes(as.character(year),EmissionsTot1)) + geom_bar(stat="identity", fill="blue")
h + labs(title = "Total PM2.5 emissions from motor vehicles in Baltimore City 1999 - 2008") +
    labs(x = "Year") +
    labs(y = "Total PM2.5 emissions (thousands of tons")
dev.off()