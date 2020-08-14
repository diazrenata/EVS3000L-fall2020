install.packages('prism')
install.packages("rgdal")

library(prism)
get_prism_annual(type="ppt", years = c(1985, 2014), keepZip=FALSE)
prism_files <- ls_prism_data()
prism_dat <- prism_stack(prism_files)

library(rgdal)
plot(prism_dat)

temp_change <- prism_dat$PRISM_tmean_stable_4kmM3_2014_bil - 
  prism_dat$PRISM_tmean_stable_4kmM3_1985_bil

precip_change <- prism_dat$PRISM_ppt_stable_4kmM3_2014_bil - 
  prism_dat$PRISM_ppt_stable_4kmM3_1985_bil

plot(temp_change)

plot(precip_change)

install.packages("tigris")

library(tigris)
states <- states(cb = T)
plot(states)

library(ggplot2)
library(dplyr)
library(raster)

states_climate <- states %>%
  select(NAME, geometry)

onestate_temp_change <- crop(mask(temp_change, states_climate[1,]), states_climate[1,])

extract(temp_change, states_climate[1,], fun = mean, na.rm = T)
