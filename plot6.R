
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

#Question 6: Has Baltimore City or Los Angeles County seen the biggest change in emissions over the years
#Load dplyr and ggplot2 packages
library(dplyr)
library(ggplot2)

#Identify motor vehicles in SCC data frame
#Include non-point from Data.Catagory as this includes some vehicles
#Exclude point from Data.Category to elimiate some non-vehicles
motor<-filter(SCC,grepl("[Mm]otor|[Vv]eh.(*)", Short.Name) & Data.Category !="Point")

#subset NEI data frame using selected motor vehicle SCC codes from SCC data frame
NEI1<-NEI[NEI$SCC %in% motor$SCC,]

#Select Baltimore City and Los Angeles County (fips=="24510" or fips=="06037")
NEI2<-filter(NEI1,fips=="24510"|fips=="06037")

#Convert fips codes to location names for Baltimore City and Los Angeles County
NEI2$fips<-replace(NEI2$fips,NEI2$fips=="24510",c("Baltimore City"))
NEI2$fips<-replace(NEI2$fips,NEI2$fips=="06037",c("Los Angeles County"))

#Group by year and source of emission 
NEI3<-group_by(NEI2,year,fips)

#Summarise total emissions by year and emission source
NEIyear<-summarise(NEI3,EmissionsTot=sum(Emissions))

#Output plot
h<-ggplot(NEIyear,aes(floor(year),EmissionsTot)) + 
  facet_grid(fips~., scale="free") + 
  geom_point(colour="Red", size = 4) +
  geom_smooth(method="lm",group=1, se=FALSE, size =1 ) +
  labs(title = "Total PM2.5 emissions in Baltimore City and LA County 1999 - 2008") +
  labs(x = "Year") +
  labs(y = "Total PM2.5 emissions (tons)")

png(file = "../plot6.png")
print(h)
dev.off()