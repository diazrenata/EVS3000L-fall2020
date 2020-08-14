install.packages('prism')
install.packages("rgdal")

library(prism)
get_prism_annual(type="ppt", years = c(1985, 2014), keepZip=FALSE)
get_prism_annual(type="tmean", years = c(1985, 2014), keepZip=FALSE)

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

library(ggplot2)
library(raster)

onestate_temp_change <- crop(mask(temp_change, states[1,]), states[1,])

extract(temp_change, states[1,], fun = mean, na.rm = T)
