rm(list = ls())
gc()
# load packages
library(ggplot2)

# load data
activity <- read.csv("activity.csv",head=TRUE)

# removed NAs
activity <- activity[!is.na(activity$steps),]

# Group data by day and sum the total steps
activityByDaySum <- aggregate(activity$steps, by = list(activity$date), sum)
colnames(activityByDaySum) <- c("Date","SumSteps")

# Create Histogram
hist(activityByDaySum$SumSteps,main="Histogram for Total Numbers of Steps Per Day",
     xlab = "Total Number of Steps Per Day", col="red")

# Create statistics summary (mean/median)
mean1 <- mean(activityByDaySum$SumSteps)
median1 <- median(activityByDaySum$SumSteps)

# Group data by interval and average the steps
activityByIntervalAvg <- aggregate(activity$steps, by = list(activity$interval), mean)
colnames(activityByIntervalAvg) <- c("Interval","AvgSteps")

# Create plot
plot(activityByIntervalAvg$Interval,activityByIntervalAvg$AvgSteps, type="l",
     main="Mean Total Steps Taken Per Day",xlab="Time Interval during Day",
     ylab="Mean Number of Steps")

# Report interval for maximum steps
maxIntervalRow <- which.max(activityByIntervalAvg$AvgSteps)
maxInterval <- activityByIntervalAvg[maxIntervalRow,]

# Count NAs
activity <- read.csv("activity.csv",head=TRUE)
activityNAs <- activity[is.na(activity$steps),]
nrow(activityNAs)

activityNoNAs <- activity

for (i in 1:nrow(activityNoNAs)) {
  if (is.na(activityNoNAs$steps[i])) {
    activityNoNAs$steps[i] <- activityByIntervalAvg$AvgSteps[activityByIntervalAvg$Interval==activityNoNAs$interval[i]]
  }  
}

# Group data by day and sum the total steps
activityNoNAsByDaySum <- aggregate(activityNoNAs$steps, by = list(activityNoNAs$date), sum)
colnames(activityNoNAsByDaySum) <- c("Date","SumSteps")

# Create Histogram
hist(activityNoNAsByDaySum$SumSteps,main="Histogram for Total Numbers of Steps Per Day",
     xlab = "Total Number of Steps Per Day", col="blue")
    
# Comparison  statistics summary (mean/median)
mean2 <- mean(activityByDaySum$SumSteps)
median2 <- median(activityNoNAsByDaySum$SumSteps)

weekday <- weekdays(as.Date(activityNoNAs$date))
weekday[weekday %in% c("Saturday","Sunday")] <- "weekend"
weekday[weekday != "weekend"] <- "weekday"

weekday <- as.factor(weekday)
activityNoNAs$weekday <- weekday

weekdayActivityByIntervalAvg <- aggregate(steps ~ interval + weekday, data=activityNoNAs, mean)

qplot(interval, 
      steps, 
      data = weekdayActivityByIntervalAvg, 
      geom=c("line"),
      xlab = "Interval", 
      ylab = "Number of steps", 
      main = "Comparison of Weekday and Weekend Average Steps by Interval") +
  facet_wrap(~ weekday, ncol = 1)
