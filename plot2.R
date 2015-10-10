## filename: plot2.R
## purpose: to build a time series line chart of global active power as per
##          JHU's Data Science Course: Exporatory Data Analysis
##          Assignment 1, part 2

## NOTE: this is raw script file, no functions to call.
## assumes the data is in the current working directory.
## purposefully didn't add error checking or processing.
## ALSO: focused on 2 specific days, and knowingly "cheated" a bit.
##      I mean, yeah, I probably should have read the whole thing in &
##      then subset() on the days we're interested in.  However, I 
##      would rather not waste processing power & ram to read in
##      a huge file when I *know* I only need 10% (or less) of it

## so therefore, I start reading at line 66638, as that's when our day of interest begins.
## only read 2880 lines, as that's when the observation window closes.
power_data<-read.table('household_power_consumption.txt',header=F,
                       sep=";",skip=66637,nrows=2880,na.strings='?'
                      )
## since I didn't read in the first line, I have to grab it for headers.
headers<-read.table('household_power_consumption.txt',header=T,
                    sep=";",nrows=1
                    )

##now give the data of interest the column names I want from the header file.
colnames(power_data)<- colnames(headers)
## we end up with a data table with proper column names of only the days of interest.

## as a final step to clean up the data, I make two new columns, one that combines
##   date & time into one string, and then another that is a datetime object with
##   the combined value.  Could I have done it in one step?  Yes, probably.  I didn't.
power_data<-transform(power_data,FullDateTimeString=paste(Date,Time,sep=" "))
power_data<-transform(power_data,Date<-as.Date(Date,format="%d/%m/%Y"))
power_data<-transform(power_data,Time<-strptime(Time,format="%T"))
power_data<-transform(power_data,EventDateTime=strptime(FullDateTimeString,format="%d/%m/%Y %T"))
## poof!  data cleaned.

## because I'm a lazy typer, I am going ot save the data points of interest
## into twp variables x & y.  makes easier adjustment if/when I have to work
## this code.
x<-power_data$EventDateTime
y<-power_data$Global_active_power

## now work the magic.  Open a PNG to write to, write the line chart to it, and close
##    the stream.
png(filename="plot2.png",width=480,heigh=480,units="px")
plot(x,y,type="l",xlab="",ylab="Global Active Power (kilowatts")
dev.off()
