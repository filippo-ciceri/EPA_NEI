#download raw data
if (!file.exists("Source_Classification_Code.rds")|!file.exists("summarySCC_PM25.rds")) { 
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    filename <- "temp.zip"
    download.file(fileURL, filename)
    unzip(filename)
    file.remove(filename)
}

#read the tables
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#filter NEI dataset
NEI <- NEI[NEI$year %in% c(1999,2002,2005,2008) &
           NEI$fips=="24510",]

#calculate the sums
total_emissions <- tapply(NEI$Emissions, as.factor(NEI$year), sum)
total_emissions_df <- data.frame(date=c(1999,2002,2005,2008),
                                 em=total_emissions)

#create the graph
dev.new()
par(bg = 'white')
plot(total_emissions_df, 
     type='l',
     main='Total Emissions  in Baltimore City',
     ylab='Total Emissions', 
     xaxt='n')
axis(side=1,at=c(1999,2002,2005,2008),labels=c("1999","2002","2005","2008"))
dev.copy(png, "plot2.png", width = 480, height = 480)
dev.off()