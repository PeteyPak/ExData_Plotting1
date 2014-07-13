# Get just the first row, to get the column names
temp <- read.table("household_power_consumption.txt", header=TRUE, sep=";", na.strings="?", nrows=1)

# Now get the data we want (Line numbers found using Notepad++)
raw <- read.table("household_power_consumption.txt", header=FALSE, sep=";", na.strings="?", skip=66637, nrows=69517-66637)
colnames(raw) <- colnames(temp)
# Convert the date and time columns (the others become numerics automatically)
raw$datetime <- strptime(paste(raw$Date, raw$Time, sep=" "), format="%d/%m/%Y %H:%M:%S")

# Set up plotting parameters (Win7, RStudio 0.98)
par(ps=12)

# Plot 1
hist(raw$Global_active_power, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)")

# Plot 4 combines plots 2 and 3, and two extra plots.
par(mfcol=c(2,2))

# Plot 2
plot(x=raw$datetime, y=raw$Global_active_power, type="l", xlab=NA, ylab="Global Active Power (kilowatts)")

# Plot 3
colrs <- c("black", "red", "blue")
plot( x=raw$datetime, y=raw$Sub_metering_1, type="l", col=colrs[1], xlab=NA, ylab="Energy sub-metering")
lines(x=raw$datetime, y=raw$Sub_metering_2, type="l", col=colrs[2])
lines(x=raw$datetime, y=raw$Sub_metering_3, type="l", col=colrs[3])
legend("topright", lty=1, col=colrs, legend=colnames(raw)[7:9], bty="n", text.width=90000, y.intersp=0.4)
# text.width and y.intersp were necessary for correct plotting, reason unknown (Win7, RStudio 0.98).

# For Plot 4
with(raw, plot(datetime, Voltage, type="l"))
with(raw, plot(datetime, Global_reactive_power, type="l"))

dev.copy(png, file = "plot4.png")
dev.off()
