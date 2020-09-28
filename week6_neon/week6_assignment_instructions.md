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

## Setting up to use NEON data in R

Go to the landing page for UFApps and launch RStudio.

As before, RStudio may have saved your workspace from last week’s lab.
We want a clean area to copy-paste code. If the top left pane has
anything in it (“Untitled1”, “Untitled2”), close them - you don’t need
to save them. When you close everything the top left pane may minimize.
That’s OK, it will come back\!

Select “File”, “New File”, and “RScript” in the top left menu bar. This
will give you a new place to copy and paste code.

To run code, either highlight it and click the “Run” button in the top
right of the top left pane, or highlight it and press Ctrl + Enter.

Copy-paste this code to set up your files on UFApps for this week’s
exercise:

``` r
setwd("~")

if(!dir.exists("EVS3000L")) {
  dir.create("EVS3000L")
}

if(!dir.exists("EVS3000L/week6")) {
dir.create("EVS3000L/week6")
}

setwd("EVS3000L/week6/")
```

We will need to install and load the `neonUtilities` package, which is
NEON’s R package for working seamlessly with NEON data in R.

``` r
install.packages("neonUtilities")

library(neonUtilities)
```

\[Here we can switch to standard instructions for R\]

Here is code to download and open some data. Run this, and when
prompted, type “y” in the console (bottom left pane).

``` r
testdat <- loadByProduct(dpID = "DP1.00002.001", startdate = "2018-11",
              enddate = "2018-12", site = "BARC")
```

Now run:

``` r
list2env(testdat, .GlobalEnv)
```
