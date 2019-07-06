library(dplyr)
library(tidyr)
library(lubridate)

# download file
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipfilename <- "./exdata_data_household_power_consumption.zip"
download.file(url, zipfilename)

# unzip data file
unzip(zipfilename, files = NULL, list = FALSE, overwrite = TRUE,
      junkpaths = FALSE, exdir = ".", unzip = "internal",
      setTimes = FALSE)

# read original source data
data <- read.table("./household_power_consumption.txt", header = TRUE, sep=";", stringsAsFactors = FALSE)

# subset data frame and create new date and time variables
df <-  data %>%
    select(everything()) %>%
    filter(Date=="1/2/2007" | Date=="2/2/2007") %>%
    mutate(
        DateTime=as.POSIXct(paste(Date,Time, sep=" "), format="%d/%m/%Y %H:%M:%S"), 
        dtDate=as.Date(strptime(Date,"%d/%m/%Y")),
        weekday=weekdays(dtDate, abbreviate=TRUE))


df[, 7] <- as.numeric(df[, 7])
df[, 8] <- as.numeric(df[, 8])
df[, 9] <- as.numeric(df[, 9])

# set up graphics device 
png("plot3.png", 480, 480)

# create plot and add lines
plot(df$DateTime, df$Sub_metering_1, main="", xlab="",
     ylab="Energy sub metering", type="l", col="black")

points(df$DateTime, df$Sub_metering_2, type="l", col="red")
lines(df$DateTime, df$Sub_metering_2, type="l", col="red")

points(df$DateTime, df$Sub_metering_3, type="l", col="blue")
lines(df$DateTime, df$Sub_metering_3, type="l", col="blue")

# add a legend
legend("topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), 
       lwd = 2,
       bty = "o", 
       pt.cex = 1, 
       cex = .8, 
       text.col = "black", 
       horiz = FALSE) 
       
dev.off()