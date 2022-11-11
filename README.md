# Equity Evaluator
<i> A system to help employees better understand the value of their equity. </i>

# Overview
I've worked with a lot of CEO's who get very frustrated when their employees don’t appreciate the value of their equity.  I always say that, “Compensation is Communication”.  If someone doesn’t understand the message we’re sending, then we’re doing a bad job sending it.  So I want to explore how we can use storytelling with data to help employees better understand the resources the company is providing to them.

The goal of this is to develop a system where the employee’s data can be piped into visualizations that help them better realize the value.  These visualizations should be strong enough to stand on their own, but would be the same tools that the employee’s manager uses at a live year-end meeting or HR would use in analytics.

# Prototype
The [first version](https://www.linkedin.com/pulse/one-chart-gets-employees-excited-equity-john-kelly/) of this was built in google sheets.  I thought this would be the easiest way to encourage adoption since google sheets/excel/libre office calc are very common in the business world.  I made all the back end calculations public so it’s easy to copy this method.

This system was designed to give employees an idea of the value of their equity, in a way that corporations can’t explicitly express.  
- Since there is risk that equity value will become worthless if the company does poorly, corporations can’t give a dollar value on the equity.
- At the same point, just giving the raw grant amounts to the employee requires them to do a lot of analysis that they generally don’t have the time or expertise to do.

To solve both issues this method pulls in the raw equity grant amounts (which HR stores in the HRIS system) but has the employee decide how quickly they expect the company to grow.  This means they can can see the increasing value of their equity (due to vesting, new grants, and company growth), without having to worry about the data behind it.  The final results are expressed in dollar value (not units) so it provides a real cash estimate.

<kbd><img src="https://github.com/LookHere/EquityEvaluator/blob/main/images/CompensaitonGoogleSheetsChart.png" width=100% height=100%></kbd>


The major downside of implementing this in an excel-like format is that (generally) a new workbook would need to be built for each employee with their specific data.  It’s possible to be build something that’s more salable, but with this technology it’s challenging to move confidential data so that only the employee has access to there own information.   Another problem is that the calculations are done by month, which make things like the cliff vesting payment look a bit off (there is a slope over a full month when it should be paid over just in one day).

# R model 

To overcome the issues in excel, I moved the project to R.  This way we can bring this code into any system that already has security for an employee to only see their own units.  In R we have much for flexibility to generate the entire vest history, just with basic information about the grant:

    GrantDate <- as.Date(c("2018-01-01", "2020-01-01", "2021-06-01"))
    GrantUnits <- c(1000, 200, 300)
    GrantPeriodM <- c(48, 12, 12)  # the grant period in months (including the vest)
    GrantCliffM <- c(12, 0, 0)     # the vest period in months

From the basic grant information, the system develops a dataframe for each grant, and then pulls them together.  This makes it possible to very quickly model an unlimited number of grants…something valuable for the employee view but even more important when we use the same system to model burndown chart estimates. 

Running these grants through the system generates this chart showing the units vested at any point in time.  Note that the first vest has a 12 month cliff so no units are vested in 2018 and 1/4th of the units are vested on the first day in 2019.  Unlike in the prototype, here we can see the growth is jagged, where units only vest once a month.  The height of these steps is a good visualization of how many units are vesting each month.  

<kbd><img src="https://github.com/LookHere/EquityEvaluator/blob/main/images/VestingChart.png" width=100% height=100%></kbd>

Manipulating the data into a different format, we can also provide charts to make other reporting and analysis easier.  Here we can see for the first grant how after the waiting period 250 units move from Unvested to Vested; then only about 20 units move each month.  The second grant has no waiting period so units start vesting immediately.  (The system is assumes units generally vest monthly and is allowing fractional units.)

<kbd><img src="https://github.com/LookHere/EquityEvaluator/blob/main/images/VestingChartGrid.png" width=100% height=100%></kbd>

# Project Roadmap
- [x] Build a prototype to explore visualization options from a vesting chart
- [x] Use basic grant information to built a vesting chart
- [x] Combine vesting charts into one dataframe
- [x] Build visualization and chart view of grants
- [ ] Make it Shiny!
- [ ] Add in a company growth slider so the employee and estimate value
- [ ] Build burndown charts
- [ ] Integrate it into other compensation elements (base, bonus, commissions) for a year-end value statement 


