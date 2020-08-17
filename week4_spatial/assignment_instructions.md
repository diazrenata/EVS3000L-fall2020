Week 4 Spatial analysis
================

## Setup

Copy and paste this code to set up:

``` r
install.packages(c("prism", "tigris" "raster", "rgdal"))


if(!dir.exists("Documents/EVS3000L")) {
dir.create("Documents/EVS3000L")
}
if(!dir.exists("Documents/EVS3000L/week4")) {
dir.create("Documents/EVS3000L/week4")
}
if(!dir.exists("Documents/EVS3000L/week4/prism")) {
dir.create("Documents/EVS3000L/week4/prism")
}
setwd("Documents/EVS3000L/week4")
```

``` r
library(dplyr)
library(ggplot2)
library(prism)
library(tigris)
library(rgdal)
```

``` r
options(prism.path = "Documents/EVS3000L/week4/prism")
```

## Download and load temperature and precipitation files

``` r
get_prism_annual(type="ppt", years = c(1985, 2014), keepZip=FALSE)
get_prism_annual(type="tmean", years = c(1985, 2014), keepZip=FALSE)

prism_files <- ls_prism_data()
prism_dat <- prism_stack(prism_files)
names(prism_dat) <- c("precip_1985", "precip_2014", "temp_1985", "temp_2014")
```

## Plot temperature and precipitation data

``` r
plot(prism_dat)
```

## Compute variable change

``` r
precip_change = prism_dat$precip_2014 - prism_dat$precip_1985
temp_change = prism_dat$temp_2014 - prism_dat$temp_1985

plot(precip_change)
plot(temp_change)
```

## Zoom in on a state

``` r
states <- states(cb = T)

states <- states %>%
  dplyr::select(NAME)
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

## Reflection questions
