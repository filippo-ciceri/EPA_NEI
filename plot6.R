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
SCC_vector <- SCC[grep("On-Road Gasoline|On-Road Diesel",SCC$EI.Sector),"SCC"]
NEI_BA <- NEI[NEI$year %in% c(1999,2002,2005,2008) &
              NEI$SCC %in% SCC_vector &
              NEI$fips=="24510",]
NEI_LA <- NEI[NEI$year %in% c(1999,2002,2005,2008) &
                  NEI$SCC %in% SCC_vector &
                  NEI$fips=="06037",]

#calculate the sums
total_emissions_SCC_filtered_BA <- tapply(NEI_BA$Emissions, as.factor(NEI_BA$year), sum)
total_emissions_SCC_filtered_BA_df <- data.frame(date=c(1999,2002,2005,2008),
                                                 em=total_emissions_SCC_filtered_BA)
total_emissions_SCC_filtered_LA <- tapply(NEI_LA$Emissions, as.factor(NEI_LA$year), sum)
total_emissions_SCC_filtered_LA_df <- data.frame(date=c(1999,2002,2005,2008),
                                                 em=total_emissions_SCC_filtered_LA)

#create the graph
dev.new()
par(bg = 'white')
plot(total_emissions_SCC_filtered_BA_df, 
     type='l',
     main='Total Emissions (motor vehicles)',
     ylab='Total Emissions', 
     xaxt='n',
     col='blue',
     ylim=c(100,5000))
lines(total_emissions_SCC_filtered_LA_df, 
     type='l',
     main='Total Emissions (motor vehicles)',
     ylab='Total Emissions', 
     xaxt='n',
     col='red')
axis(side=1,at=c(1999,2002,2005,2008),labels=c("1999","2002","2005","2008"))
legend("topright", 
       legend=c('Baltimore City','Los Angeles'),
       col=c('blue','red'),
       lwd = 2)
dev.copy(png, "plot6.png", width = 480, height = 480)
dev.off()