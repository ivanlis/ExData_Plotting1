library(data.table)

# Simple data acquisition (and slow) ----
# read the whole data set
consumption <- read.table("household_power_consumption.txt", 
                          header = TRUE, sep = ";", na.strings = "?", 
                          colClasses = c("character", "character", 
                                         "numeric", "numeric", "numeric", 
                                         "numeric", "numeric", "numeric", "numeric"))
# only take the two days we are interested in, convert to data.table, which is more efficient
consDataSet <- as.data.table(
    consumption[as.Date(consumption$Date, "%d/%m/%Y") == as.Date("2007-02-01", "%Y-%m-%d") 
                | as.Date(consumption$Date, "%d/%m/%Y") == as.Date("2007-02-02", "%Y-%m-%d"),])
# delete the large data frame, we don't need it
rm(consumption)
# end of simple acquisition ----

# A faster version of data acquisition using data.table and grep ----
# It reads only those rows we really need.
## Just read the first line to know the column names
#colNames <- strsplit(readLines("household_power_consumption.txt", 1), ";")[[1]]
## The grep command has to be available
#consDataSet <- fread("grep \"^[12]/2/2007\" household_power_consumption.txt", sep = ";", na.strings = "?",
#                   col.names = colNames)
# end of the faster version of data acquisition ----

# Order by date and time (just in case)
consDataSet <- consDataSet[order(as.POSIXct(paste(Date, Time, sep = " "), 
                                                "%d/%m/%Y %H:%M:%S"))]

# Open the PNG graphic device
png(filename="plot2.png", width = 480, height = 480)

plot(1:nrow(consDataSet), consDataSet$Global_active_power, type = "n", xaxt = "n", 
     xlab = "", ylab = "Global Active Power (kilowatts)")
# Label the day weeks where they change (each 60 * 24 minutes)
axis(1, at = seq(1, nrow(consDataSet) + 1, 60 * 24), 
     labels = strftime(seq(as.Date(consDataSet[1, "Date"][[1]], "%d/%m/%Y"), 
                           as.Date(consDataSet[nrow(consDataSet), "Date"][[1]], "%d/%m/%Y") + 1, 1), 
                       "%a"))
# Build the graph
lines(1:nrow(consDataSet), consDataSet$Global_active_power)
# Save the file; close the device
dev.off()
