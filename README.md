# EquityEvaluator
<i> A system to help employees better understand the value of their equity. </i>

# Overview
I've worked with a lot of CEO's who get very frustrated when their employees don’t appreciate the value of their equity.  I always say that, “Compensation is Communication”.  If someone doesn’t understand the message we’re sending, then we’re doing a bad job sending it.  So I wanted to see how we can use storytelling with data to help employees better understand the resources the company is providing to them.

The goal of this is to provide a system where the employee’s data can be piped into visualizations that help them better realize the value.  These visualizations should be strong enough to stand on their own, but would be the same tools that the employee’s manager uses at a live year-end meeting.

# Prototype
The [first version](https://www.linkedin.com/pulse/one-chart-gets-employees-excited-equity-john-kelly/) of this was built in google sheets.  I thought this would be the easiest way to get people using this method since google sheets/excel/libre office calc are very common in the business world.  All the back end calculations are public so it’s easy to copy this method.

The major downside of implementing this in an excel like format does mean a workbook needs to be generated for each employee.  Also the calculations are done by month, which make things like the cliff vesting payment look a bit off (it pays over a month as opposed to just in one day).

