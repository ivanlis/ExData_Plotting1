library(data.table)
#TODO: simple, slow data acquisition version


# Read just the first line to know the column names
colNames <- strsplit(readLines("household_power_consumption.txt", 1), ";")[[1]]
# The grep command has to be available
consDataSet <- fread("grep \"^[12]/2/2007\" household_power_consumption.txt", sep = ";", na.strings = "?",
                   col.names = colNames)

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
