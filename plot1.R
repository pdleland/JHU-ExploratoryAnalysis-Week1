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

df[, 3] <- as.numeric(df[, 3])

# set up graphics device 
png("plot1.png", 480, 480)


hist(df$Global_active_power, 
     main="Global Active Power", 
     xlab="Global Active Power (kilowatts)", 
     col="red")

dev.off()
