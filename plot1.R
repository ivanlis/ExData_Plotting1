# Simple data acquisition (and slow) ----
# read the whole data set
consumption <- read.table("household_power_consumption.txt", 
                          header = TRUE, sep = ";", na.strings = "?", 
                          colClasses = c("character", "character", 
                                         "numeric", "numeric", "numeric", 
                                         "numeric", "numeric", "numeric", "numeric"))

# only take the two days we are interested in
consDataSet <- 
    consumption[as.Date(consumption$Date, "%d/%m/%Y") == as.Date("2007-02-01", "%Y-%m-%d") 
                | as.Date(consumption$Date, "%d/%m/%Y") == as.Date("2007-02-02", "%Y-%m-%d"),]

# delete the large data frame, we don't need it
rm(consumption)
# end of simple data acquisition ----

# A faster version of data acquisition using the data.table package. ----
# library(data.table)
# The grep command has to be available
#colNames <- strsplit(readLines("household_power_consumption.txt", 1), ";")[[1]]
#consDataSet <- fread("grep \"^[12]/2/2007\" household_power_consumption.txt", sep = ";", na.strings = "?",
#                   col.names = colNames)
# end of the faster version of data acquisition ----

# open the PNG graphic device
png(filename="plot1.png", width = 480, height = 480)
# draw the histogram
hist(consDataSet$Global_active_power, 
     xlab = "Global Active Power (kilowatts)", ylab = "Frequency", 
     col = "red", ylim = c(0, 1200), main = "Global Active Power")
# close the device, save the file
dev.off()