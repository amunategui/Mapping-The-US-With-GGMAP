require(RCurl)
require(xlsx)


# Load data from Hadley Wickham on Github 
# NOTE if you can't download the file automatically, download it manually at:
# 'http://www.psc.isr.umich.edu/dis/census/Features/tract2zip/'
urlfile <-'http://www.psc.isr.umich.edu/dis/census/Features/tract2zip/MedianZIP-3.xlsx'
destfile <- "census20062010.xlsx"
download.file(urlfile, destfile, mode="wb")
census <- read.xlsx2(destfile, sheetName = "Median")

# 
# setwd('//wn2123/so_company2$/EpicReporting/Reports/WIP/Manuel/ALLDATA')
# census <- read.csv('MedianZIP-3.csv')
census <- census[c('Zip','Median')]

# pad each zip codes with zeros in front if missing
census$Zip <- sprintf("%05d", as.numeric(census$Zip))
census$Median <- as.character(census$Median)
census$Median <- as.numeric(gsub(',','',census$Median))


library(zipcode)
data(zipcode)
census$Zip <- clean.zipcodes(census$Zip)
census <- merge(census, zipcode, by.x='Zip', by.y='zip')


library(ggmap)
library("ggplot2")
library("RColorBrewer")
map<-get_map(location='united states', zoom=4, maptype = "roadmap",
             source='google',color='color')

ggmap(map)+
        geom_point(
                aes(x=longitude, y=latitude, show_guide = TRUE, colour=Median), 
                data=census, alpha=.8, na.rm = T)  + 
        scale_color_gradient(low="beige", high="blue")
