Week 5 Temporal analysis
================

## Getting to UFApps

Here are the instructions to get to UFApps - they are the same as last
week.  

Navigate to: <https://info.apps.ufl.edu>

Click on the orange “Login to UFApps” button in the upper right. This
link may also take you to the login page: <https://apps.ufl.edu/>

Log in using your GatorLink.

Click on “Apps” in the top menu bar. Scroll down to RStudio and click on
it to launch it. It may take a minute. Sometimes the connection will not
go through, but if you launch it again it works. If you consistently
can’t get through, reach out to Renata and she will try and figure out
another solution.

You may see a prompt to “set up secure access to your files”. There’s no
need to do this for this course, so go ahead and click Not Now.

## Setup

Select “File”, “New File”, and “RScript” in the top left menu bar. This
will give you a place to copy and paste code.

To run code, either highlight it and click the “Run” button in the top
right of the top left pane, or highlight it and press Ctrl + Enter.

Copy and paste this code to set up. You may get a notification about
copy-pasting stuff into the virtual session. Click OK and continue.

## Download data

We will download data on a community of desert rodents located in
southeastern Arizona. This community has been monitored on a monthly
basis for over 40 years.

## Plot abundance and species richness data

We will look at how two aspects of this community have changed over the
past 40 years: the total number of species present, or species richness,
and the total number of *individuals* present, or total abundance.

**What dynamics do you notice in these two time series? Do they look
like they are increasing, decreasing, or not changing?** Include your
observations from these plots in your text submission.

## Statistical analysis

We will use a basic statistical test to see whether we can detect
evidence that these timeseries are changing. Specifically, we will fit a
**linear model**, which will tell us whether the line-of-best-fit for
the timeseries has a slope that is statistically distinguishable from 0.
A slope of 0 reflects no systematic change over time.

\[fit lm\]

\[plot fit\]

\[print results\]

**What do the linear models tell us about change in species richness and
abundance over the time series?**

## Results to submit

Save your plots and results with this code:

Upload your plots and results to eLearning. \[elearning upload
instructions\]

## Reflections

Finish your text submission by answering these questions:

  - Whenever we use a statistical model, we need to think critically
    about whether it is the appropriate tool for the question we are
    interested in. In this case, do you think the linear model is
    accurately describing what you see in the data? Is there something
    else you might want to try and capture with a more complicated or
    nuanced model?
  - Last week we saw a little bit of what kinds of spatial and
    environmental data we can access from other sources. Can you
    brainstorm questions you might be able to answer by combining
    spatial environmental data with timeseries data like what we have
    here?
