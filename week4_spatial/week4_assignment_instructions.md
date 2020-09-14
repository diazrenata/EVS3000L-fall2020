Week 4 Spatial analysis
================

## Getting to UFApps

We will use a version of R that is hosted in the cloud for UF students
through UFApps.

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
copy-pasting into the virtual session. Click OK and continue.

This code will set up your file directories so you will be able to
download data files and save your results later:

``` r
if(!dir.exists("Documents/EVS3000L")) {
dir.create("Documents/EVS3000L")
}
if(!dir.exists("Documents/EVS3000L/week4")) {
dir.create("Documents/EVS3000L/week4")
}
if(!dir.exists("Documents/EVS3000L/week4/prism")) {
dir.create("Documents/EVS3000L/week4/prism")
}
setwd("Documents/EVS3000L/week4/prism")
```

This code will download the activate the tools we need to work with
spatial data in R. (R is an especially powerful programming environment
because R users all over the world volunteer to build **R packages**,
which are custom-built sets of functions to accomplish all kinds of
analyses and other tasks. R packages are free and open-source, which
means anyone can download them and use them for their work. Here we are
downloading and activating several R packages that are commonly used for
spatial analysis.)

``` r
install.packages(c("prism", "tigris", "raster", "rgdal"))


library(dplyr)
library(ggplot2)
library(prism)
library(tigris)
library(rgdal)
```

You may get “warning messages”. That’s okay.

Here we’ll tell R where to put the climate data we’re about to download:

``` r
options(prism.path = getwd())
```

## Download and load temperature and precipitation files

We’ll download spatial data files of *annual precipitation* and *mean
annual temperature* for the contiguous United States in 1985 and 2014
from the Prism Climate Project. This code will download the data files
to your files:

``` r
get_prism_annual(type="ppt", years = c(1985, 2014), keepZip=FALSE)
get_prism_annual(type="tmean", years = c(1985, 2014), keepZip=FALSE)
```

And this code will load the data files you just downloaded into your R
session:

``` r
prism_files <- ls_prism_data()
prism_dat <- prism_stack(prism_files)
names(prism_dat) <- c("precip_1985", "precip_2014", "temp_1985", "temp_2014")
```

## Plot temperature and precipitation data

It’s good practice to look at data whenever you first load it. We’ll
plot these data as heatmaps of precipitation and temperature:

``` r
plot(prism_dat)
```

## Compute variable change

Now let’s explore some ways to analyze this data. We’ll calculate how
much these climate variables have changed from 1985 until 2014. We’ll
subtract the 1985 values from the 2014 values, and plot the heatmaps of
*change*:

``` r
precip_change = prism_dat$precip_2014 - prism_dat$precip_1985
temp_change = prism_dat$temp_2014 - prism_dat$temp_1985

plot(precip_change)
plot(temp_change)
```

## Zoom in on a state

``` r
states <- states(cb = T)

states <- states[, "NAME"]
```

``` r
plot(dplyr::filter(states,
                   NAME != "United States Virgin Islands",
              NAME != "Commonwealth of the Northern Mariana Islands",
              NAME != "Hawaii",
              NAME != "Guam",
              NAME != "American Samoa",
              NAME != "Alaska",
              NAME != "Puerto Rico"))
```

Fill in a state (or territory) of your choice. Here are your options -
the text you fill in must match exactly.

``` r
unique(states$NAME)
```

``` r
my_state <- filter(states, NAME == "Florida")

plot(my_state)
```

## Plot precipitation and temperature change for that state

``` r
library(raster)

my_state_temp_change <- crop(mask(temp_change, my_state[1,]), my_state[1,])

my_state_precip_change <- crop(mask(precip_change, my_state[1,]), my_state[1,])

plot(my_state_temp_change)

plot(my_state_precip_change)
```

## Compute mean variable change for that state

``` r
mean_temp_change =extract(my_state_temp_change, my_state[1,], fun = mean, na.rm = T)

mean_precip_change =extract(my_state_precip_change, my_state[1,], fun = mean, na.rm = T)

mean_temp_change

mean_precip_change
```

## Results to submit

Running this code will save copies of your plots and results so you can
upload them to eLearning.

``` r
jpeg('temp_change.jpg')
plot(my_state_temp_change)
dev.off()


jpeg('precip_change.jpg')
plot(my_state_precip_change)
dev.off()

results <- data.frame(
  state = my_state$NAME[1],
  mean_temp_change = mean_temp_change,
  mean_precip_change = mean_precip_change
)

write.csv(results, "results.csv", row.names = F)
```

After you run this section, go ahead and exit RStudio.

## Uploading your results

Go back to the Apps page in UFApps.

Scroll to eLearning and launch it. Log in to Canvas.

Navigate to the Spatial Analysis assignment and go to Submit and File
Upload.

In the file selection navigation window, go to Documents \> EVS3000L \>
week4 \> prism. Select “precip\_change.jpg”, “temp\_change.jpg”, and
“results.csv”. Upload them and submit.

## Reflections

Please submit a text entry with your answers to these questions about
the analysis:
