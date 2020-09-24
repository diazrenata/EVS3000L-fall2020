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
annual temperature* (in degrees C) for the contiguous United States in
1985 and 2014 from the Prism Climate Project. This code will download
the data files to your files:

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

## State boundaries

Say we are interested in how climate has changed in a particular state
over this period. We can filter the PRISM climate data to focus on a
particular geographic area. To filter to a specific state, we need the
state boundaries.

The US Census department publishes quite a lot of useful data products,
including maps of state boundaries. This code will load the census map
of state boundaries in to R, and filter it to remove the non-contiguous
states and territories (which are not included in the PRISM climate
data).

``` r
states <- states(cb = T)

states <- states[, "NAME"]

states <- filter(states,
                   NAME != "United States Virgin Islands",
              NAME != "Commonwealth of the Northern Mariana Islands",
              NAME != "Hawaii",
              NAME != "Guam",
              NAME != "American Samoa",
              NAME != "Alaska",
              NAME != "Puerto Rico")
```

Let’s plot what we have just loaded.

``` r
plot(states)
```

We have the boundaries for all the states and territories. **We’ll work
through the next few chunks of code focusing on Florida. Then, re-do
this analysis yourself using a different state.**

## Extracting Florida

This will extract just the boundaries for Florida:

``` r
florida_boundaries <- filter(states, NAME == "Florida")

plot(florida_boundaries)
```

## Plot precipitation and temperature change for Florida

We use the `crop` and `mask` functions to filter our maps of temperature
and precipitation change for the whole US, to just Florida:

``` r
library(raster)

florida_temp_change <- crop(mask(temp_change, florida_boundaries[1,]), florida_boundaries[1,])

florida_precip_change <- crop(mask(precip_change, florida_boundaries[1,]), florida_boundaries[1,])

plot(florida_temp_change)

plot(florida_precip_change)
```

## Compute mean variable change for Florida

We can extract the actual data values and compute summary statistics on
them. For example, we can compute the mean temperature change and mean
precipitation change across the whole state:

``` r
florida_mean_temp_change =extract(florida_temp_change, florida_boundaries[1,], fun = mean, na.rm = T)

florida_mean_precip_change =extract(florida_precip_change, florida_boundaries[1,], fun = mean, na.rm = T)

print(paste0("Mean temperature change: ", florida_mean_temp_change))

print(paste0("Mean precipitation change: ", florida_mean_precip_change))
```

## Run with a diffferent state

Now you’ll repeat the filtering and summary statistic computation using
a state other than Florida. To do this, run the following code and
replace `NAME == "Florida"` below with `NAME == "(the name of the state
you choose)"`.

As of 1:30pm on 9/24/20, I’ll also ask you to choose a state *other than
Colorado*. If you did the assignment before 1:30pm on 9/24, that’s ok.

``` r
my_state <- filter(states, NAME == "Florida")

plot(my_state)
```

**You must spell the name of your state, and capitalize it, exactly as
it is spelled in the data file R has\!** This will give you a list of
exactly how everything is spelled in the data file.

``` r
unique(states$NAME)[ which(unique(states$NAME) != "Colorado")]
```

## Plot precipitation and temperature change for your state

``` r
my_state_temp_change <- crop(mask(temp_change, my_state[1,]), my_state[1,])

my_state_precip_change <- crop(mask(precip_change, my_state[1,]), my_state[1,])

plot(my_state_temp_change)

plot(my_state_precip_change)
```

## Compute mean variable change for your state

``` r
mean_temp_change =extract(my_state_temp_change, my_state[1,], fun = mean, na.rm = T)

mean_precip_change =extract(my_state_precip_change, my_state[1,], fun = mean, na.rm = T)

print(paste0("Mean temperature change: ", mean_temp_change))

print(paste0("Mean precipitation change: ", mean_precip_change))
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

Please also upload a Word or text document with your answers to these
questions about the exercise:

  - How do the map, direction, or magnitude of change in your chosen
    state compare or contrast with your intuition or previous
    expectations?
  - Are there other variables you think might give you a more
    informative or complete picture?
  - More broadly, can you think of ways you could combine spatial
    information, like what we’ve used here, with the local biodiversity
    sampling you have done so far to learn more about the state of
    ecosystems locally or more generally?

## Package and data citations

``` r
citation("dplyr")
```

    ## 
    ## To cite package 'dplyr' in publications use:
    ## 
    ##   Hadley Wickham, Romain François, Lionel Henry and Kirill Müller
    ##   (2020). dplyr: A Grammar of Data Manipulation. R package version
    ##   1.0.1. https://CRAN.R-project.org/package=dplyr
    ## 
    ## A BibTeX entry for LaTeX users is
    ## 
    ##   @Manual{,
    ##     title = {dplyr: A Grammar of Data Manipulation},
    ##     author = {Hadley Wickham and Romain François and Lionel Henry and Kirill Müller},
    ##     year = {2020},
    ##     note = {R package version 1.0.1},
    ##     url = {https://CRAN.R-project.org/package=dplyr},
    ##   }

``` r
citation("ggplot2")
```

    ## 
    ## To cite ggplot2 in publications, please use:
    ## 
    ##   H. Wickham. ggplot2: Elegant Graphics for Data Analysis.
    ##   Springer-Verlag New York, 2016.
    ## 
    ## A BibTeX entry for LaTeX users is
    ## 
    ##   @Book{,
    ##     author = {Hadley Wickham},
    ##     title = {ggplot2: Elegant Graphics for Data Analysis},
    ##     publisher = {Springer-Verlag New York},
    ##     year = {2016},
    ##     isbn = {978-3-319-24277-4},
    ##     url = {https://ggplot2.tidyverse.org},
    ##   }

``` r
citation("prism")
```

    ## 
    ##   Edmund M. Hart and Kendon Bell (2015) prism: Download data from the
    ##   Oregon prism project. R package version 0.0.6
    ##   http://github.com/ropensci/prism DOI: 10.5281/zenodo.33663
    ## 
    ## A BibTeX entry for LaTeX users is
    ## 
    ##   @Manual{,
    ##     title = {prism: Download data from the Oregon prism project},
    ##     author = {Edmund M. Hart and Kendon Bell},
    ##     year = {2015},
    ##     note = {R package version 0.0.6},
    ##     url = {http://github.com/ropensci/prism},
    ##     doi = {10.5281/zenodo.33663},
    ##   }

``` r
citation("tigris")
```

    ## 
    ## To cite package 'tigris' in publications use:
    ## 
    ##   Kyle Walker (2020). tigris: Load Census TIGER/Line Shapefiles. R
    ##   package version 1.0. https://CRAN.R-project.org/package=tigris
    ## 
    ## A BibTeX entry for LaTeX users is
    ## 
    ##   @Manual{,
    ##     title = {tigris: Load Census TIGER/Line Shapefiles},
    ##     author = {Kyle Walker},
    ##     year = {2020},
    ##     note = {R package version 1.0},
    ##     url = {https://CRAN.R-project.org/package=tigris},
    ##   }

``` r
citation("rgdal")
```

    ## 
    ## To cite package 'rgdal' in publications use:
    ## 
    ##   Roger Bivand, Tim Keitt and Barry Rowlingson (2020). rgdal: Bindings
    ##   for the 'Geospatial' Data Abstraction Library. R package version
    ##   1.5-16. https://CRAN.R-project.org/package=rgdal
    ## 
    ## A BibTeX entry for LaTeX users is
    ## 
    ##   @Manual{,
    ##     title = {rgdal: Bindings for the 'Geospatial' Data Abstraction Library},
    ##     author = {Roger Bivand and Tim Keitt and Barry Rowlingson},
    ##     year = {2020},
    ##     note = {R package version 1.5-16},
    ##     url = {https://CRAN.R-project.org/package=rgdal},
    ##   }

``` r
citation("raster")
```

    ## 
    ## To cite package 'raster' in publications use:
    ## 
    ##   Robert J. Hijmans (2020). raster: Geographic Data Analysis and
    ##   Modeling. R package version 3.3-13.
    ##   https://CRAN.R-project.org/package=raster
    ## 
    ## A BibTeX entry for LaTeX users is
    ## 
    ##   @Manual{,
    ##     title = {raster: Geographic Data Analysis and Modeling},
    ##     author = {Robert J. Hijmans},
    ##     year = {2020},
    ##     note = {R package version 3.3-13},
    ##     url = {https://CRAN.R-project.org/package=raster},
    ##   }

PRISM Climate Data: PRISM Climate Group, Oregon State University,
<http://prism.oregonstate.edu>, created 4 Feb 2004

US Census Bureau. “TIGER/Line shapefiles.” US Census Bureau (2010).
<https://www.census.gov/geographies/mapping-files/time-series/geo/tiger-line-file.html>
