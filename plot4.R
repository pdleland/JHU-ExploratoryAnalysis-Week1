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

# convert numeric columns to numeric values
df[, 3] <- as.numeric(df[, 3])
df[, 4] <- as.numeric(df[, 4])
df[, 5] <- as.numeric(df[, 5])
df[, 6] <- as.numeric(df[, 6])
df[, 7] <- as.numeric(df[, 7])
df[, 8] <- as.numeric(df[, 8])
df[, 9] <- as.numeric(df[, 9])

# set up graphics device for a 2 x 2 matrix of plots
png("plot4.png", 480, 480)
par(mfcol=c(2,2))

#first plot
plot(df$DateTime, df$Global_active_power, main="", xlab="", 
     ylab="Global Active Power", type="l", col="black")

#second plot
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
       lwd = 1,
       bty = "n", 
       pt.cex = 1, 
       cex = .7, 
       text.col = "black", 
       horiz = FALSE) 

#third plot
plot(df$DateTime, df$Voltage, main="", xlab="datetime", 
     ylab="Voltage", type="l", col="black")


#fourth plot
plot(df$DateTime, df$Global_reactive_power, main="", xlab="datetime", 
     ylab="Global_reactive_power", type="l", col="black")

dev.off()