# This is version 8.  For the most up to date version, go here: https://github.com/LookHere/EquityEvaluator

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


#### Creates a function that creates temporary dataframe of one specific grant's vesting and integrate that into the HistoryAllEquity 

g = 1 # temporary placeholder for which grant this will process

# Builds a dataframe "HistoryTemp" for every day between the grant issuance and 10 years after the last grant
DaysAll <- seq(GrantInfo$GrantDate[g],LatestDate, by = "1 day")
HistoryTemp <- data.frame(DaysAll)

# Defaults all rows to the final amount of 100% vested.  
# (This way all we need to do is fix the days that have some unvested amounts)
HistoryTemp$Vested <- GrantInfo$GrantUnits[g]
HistoryTemp$Unvested <- 0

# Set a variable that holds the vest per month
VestPerMonth <- GrantInfo$GrantUnits[g] / GrantInfo$GrantPeriodM[g]

# Set a variable that will hold the current date to change
DayChange <- GrantInfo$GrantDate[g] ## are we using this?????????????????????????????


# Find out how many days of cliff there is (doing it by days to avoid leap year issues)

# Turn the grant start date into POSIXlt so we can manipulate it
CliffEndDate <- as.POSIXlt(GrantInfo$GrantDate[g])
# Add the months of the cliff
CliffEndDate$mon <-   CliffEndDate$mon + GrantInfo$GrantCliffM[g]
# Find out the number of days of cliff by subtracting cliff end by grant start
DaysOfCliff <- as.Date(CliffEndDate) - GrantInfo$GrantDate[g]

# Set those number of days before the cliff to 0% vested, 100% unvested
HistoryTemp$Vested[1:DaysOfCliff] <- 0
HistoryTemp$Unvested[1:DaysOfCliff] <- GrantInfo$GrantUnits[g]


'
# Vest the all of the units from the cliff on the day after the cliff is done.  The unvested units is the opposite of this.
HistoryTemp$Vested[DaysOfCliff +1] <- GrantInfo$GrantUnits[g] * (GrantInfo$GrantCliffM[g] / GrantInfo$GrantPeriodM[g])
HistoryTemp$Unvested[DaysOfCliff +1] <- GrantInfo$GrantUnits[g] * (1- (GrantInfo$GrantCliffM[g] / GrantInfo$GrantPeriodM[g]))
'

# Variable to hold month currently being processed (starts with month after vest)
TempMonth <- GrantInfo$GrantCliffM[g] + 1
# Variables to hold how many units are vested and unvested after cliff
TempVested <- GrantInfo$GrantUnits[g] * (GrantInfo$GrantCliffM[g] / GrantInfo$GrantPeriodM[g])
TempUnvested <- GrantInfo$GrantUnits[g] * (1- (GrantInfo$GrantCliffM[g] / GrantInfo$GrantPeriodM[g]))

# Default MStart to the first month after the cliff
MStart <- as.POSIXlt(GrantInfo$GrantDate[g]) + (DaysOfCliff)


# Move units from unvested to vested every month
while(TempMonth <= GrantInfo$GrantPeriodM[g]) {

  # Identify the row that's the first day of the month we're changing
  MStartRow <- as.Date(MStart) - GrantInfo$GrantDate[g] +1
  
  # Identify the row that's the last day of the month we're changing (add 1 month and subtract 1 day)
  MEnd <- as.POSIXlt(MStart)
  MEnd$mon <- MEnd$mon +1
  #MEnd$mday <- MEnd$mday -1
  MEndRow <- as.Date(MEnd) - GrantInfo$GrantDate[g]
  
  # Overwrite the current month with the updated vested and unvested numbers
  HistoryTemp$Vested[MStartRow:MEndRow] <- TempVested
  HistoryTemp$Unvested[MStartRow:MEndRow] <- TempUnvested
  
  
  # Update the vested amounts for the next month
  TempVested = TempVested + VestPerMonth
  TempUnvested  = TempUnvested - VestPerMonth

  
  # Progress MStart to the next month
  MStart <- as.POSIXlt.Date(GrantInfo$GrantDate[g])
  MStart$mon <- MStart$mon + TempMonth
  
  
  # Progress the month count
  TempMonth <- TempMonth + 1    
  
}

# Rename the columns based on the grant number
colnames(HistoryTemp) <- c("DaysAll",  paste(g, " Grant Vested") , paste(g, " Grant Unvested"))

# Merge the temporary dataframe into the HistoryAllEquity dataframe
HistoryAllEquity <- merge(HistoryAllEquity, HistoryTemp, by.x = "DaysAll", by.y = "DaysAll")




