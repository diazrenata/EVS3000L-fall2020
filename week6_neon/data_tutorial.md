NEON + UF Environmental Science Lab Class
================
Felipe Sanchez, <fsanchez@battelleecology.org> Renata Diaz (formatting)
October 5, 2020

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
```

``` r
library(neonUtilities)
library(ggplot2)
```

The `loadByProduct` function will download data for a particular site
and time period automatically\! Here, we ask for air temperature data
for three NEON sites from November and December 2019.

``` r
Temp_SBF <- loadByProduct(dpID = "DP1.00002.001", site =c("SUGG","BARC","FLNT"),
                          startdate = "2019-11", enddate = "2019-12",
                          package = "basic", avg = 30, check.size =F )


list2env(Temp_SBF, .GlobalEnv)
```

Let’s look at the data we downloaded:

``` r
View(SAAT_30min)

Temp_all_sites <- SAAT_30min

table(Temp_all_sites$siteID)
```

We can make a plot of temperature from our three sites:

``` r
#Plot temperature data for all three sites
ggplot(Temp_all_sites, aes(x=startDateTime, y=tempSingleMean,color = siteID))+
  geom_line()+
  ggtitle("30 min Mean Single Aspirated Temperature at D03 BARC,SUGG,and FLNT sites")+
  xlab("Date")+ylab("Temperature (C)")
```
