# This is version 5

library(shiny)
library(ggplot2)

setwd("D:/CompensationScience/CompDashboard")

### Create a dataframe where we store the equity grant date, units, and vesting type (cliff or immediate)

# In the UI out in a way to enter the grants

GrantDate <- as.Date(c("2020/1/1", "2020/5/1"))
GrantUnits <- c(1000, 200)
GrantStrike <- c(5, 10)
GrantPeriodM <- c(48, 12)  # the grant period in months (including the vest)
GrantCliffM <- c(12, 0)     # the vest period in months

GrantInfo <- data.frame(GrantDate, GrantUnits, GrantPeriodM, GrantCliffM)


##### Create a dataframe that takes the grant information and expands them over the life of the grant

# Find the earliest date the earliest grant (this will be the start of the dataframe)
EarliestDate <- min(GrantInfo$GrantDate)

# Find 10 years after the last grant (this will be the end of the dataframe)
LatestDate <- as.POSIXlt(max(GrantInfo$GrantDate))
LatestDate$year <- LatestDate$year+10
LatestDate<- as.Date(LatestDate)

# Builds a dataframe "HistoryAllEquity" for every day between the first grant and 10 years after the last grant
DaysAll <- seq(EarliestDate,LatestDate, by = "1 day")
HistoryAllEquity <- data.frame(DaysAll)
# Delete the DaysAll list
rm(DaysAll)


#### Creates a function that creates a dataframe of a grant's vesting and integrate that into the HistoryAllEquity 

# Builds a dataframe "HistoryTemp" for every day between the grant issuance and 10 years after the last grant
DaysAll <- seq(GrantInfo$GrantDate[1],LatestDate, by = "1 day")
HistoryTemp <- data.frame(DaysAll)

# Defaults all rows to the final amount of 100% vested.  
# (This way all we need to do is fix the days that have some unvested amounts)
HistoryTemp$Vested <- GrantInfo$GrantUnits[1]
HistoryTemp$Unvested <- 0

# Set a variable that holds the vest per month
VestPerMonth <- GrantInfo$GrantUnits[1] / GrantInfo$GrantPeriodM[1]

# Set a variable that will hold the current date to change
DayChange <- GrantInfo$GrantDate[1]

# find how many days of cliff vesting


# zero's out the vested and 100%'s the unvest for the entire cliff

#DaysAll <- seq(GrantInfo$GrantDate[1],LatestDate, by = "1 day")
#HistoryTemp <- data.frame(DaysAll)

# Find out how many days of cliff there is (doing it by days to avoid leap year issues)

# Turn the grant start date into POSIXlt so we can manipulate it
CliffEndDate <- as.POSIXlt(GrantInfo$GrantDate[1])
# Add the months of the cliff
CliffEndDate$mon <-   CliffEndDate$mon + GrantInfo$GrantCliffM[1]
# Find out the number of days of cliff by subtracting cliff end by grant start
DaysOfCliff <- as.Date(CliffEndDate) - GrantInfo$GrantDate[1]

# Set those number of days to 0% vested, 100% unvested
HistoryTemp$Vested[1:DaysOfCliff] <- 0
HistoryTemp$Unvested[1:DaysOfCliff] <- GrantInfo$GrantUnits[1]


# have the cliff vest amount on the first day after the vesting is done


HistoryTemp$Vested[1] <- 0
HistoryTemp$Unvested[1] <- GrantInfo$GrantUnits[1]


GrantCliffM




LatestDateGrant <- as.POSIXlt(GrantInfo$GrantDate[1] )


GrantInfo$GrantPeriodM[1] * 12

LatestDateGrant$year <- LatestDateGrant$year+1  ## maybe we should change the 1 here to be a variable for vesting period
LatestDateGrant <- as.Date(LatestDateGrant)

VestingPeriod <- LatestDateGrant - GrantInfo$GrantDate[1] 
VestingPerMonth <- GrantInfo$GrantUnits[1] / as.numeric(VestingPeriod / 12)


# Names the columns based on the grant number



# Puts this grant on the HistoryAllEquity dataframe

#HistoryAllEquity

# Deletes the dataframe

# Delete the DaysAll list
rm(DaysAll)




GrantDate <- as.Date(c("2020/1/1", "2020/2/1","2020/3/1","2020/4/1","2020/5/1","2020/6/1", "2020/2/1","2020/3/1","2020/4/1","2020/5/1","2020/6/1","2020/7/1"))
VestedUnits <- c(0, 0, 100, 200, 300, 400, 0, 0, 100, 200, 300, 400  )
UnvestedType <- c(1000,1000,900,800,700,600, 1000,1000,900,800,700,600)
GrantNumber <- c("Grant1","Grant1","Grant1","Grant1","Grant1","Grant1","Grant2","Grant2","Grant2","Grant2","Grant2","Grant2")

History <- data.frame(GrantDate, VestedUnits, UnvestedType, GrantNumber)

p <- ggplot(History, aes(x=GrantDate, y=VestedUnits, fill=GrantNumber))+ 
  geom_area(position = 'stack')
p + scale_fill_brewer(palette="Dark2") 
p + theme(legend.position="bottom")


## Build a slider under the graph.  The slider is the date of exit.  There is a line on the graph the just identifies the date of exit.  The slider also drives a table displays the vested/unvested as of that date
