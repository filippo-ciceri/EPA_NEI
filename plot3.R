library(ggplot2)
library(reshape2)

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
NEI <- NEI[NEI$year %in% c(1999,2002,2005,2008),]

#calculate the sum by type
total_emissions_by_type <- tapply(NEI$Emissions, list(as.factor(NEI$year),NEI$type), sum)

#organize the dafatrame for plotting
total_emissions_by_type <- data.frame(total_emissions_by_type)
colnames(total_emissions_by_type) <- c("Non.Road","Non.Point","On.Road","Point")
total_emissions_by_type['Year'] = row.names(total_emissions_by_type)
total_emissions_by_type <- melt(total_emissions_by_type, id="Year", measures=colnames(total_emissions_by_type))

#create the graph
dev.new()
ggplot(data=total_emissions_by_type, 
       aes(Year,value, group=variable, color=variable)) +
geom_point() + 
    geom_line() + 
xlab('Date') +
ylab('Emission') +
labs(title = 'Emissions in Baltimore city') +
theme(legend.position="right")

dev.copy(png, "plot3.png", width = 480, height = 480)
dev.off()