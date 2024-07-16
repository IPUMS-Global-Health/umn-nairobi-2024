# Working with raster data

library(terra)
library(sf)
library(ggplot2)
library(ggspatial)
library(dplyr)

ke_chirts <- rast("data/ke_chirts_2013.nc")

# Basic raster manipulation ----------------------------------------------------

# Can get basic statistics easily.

# By default, it will calculate the statistic across layers.
# That is, for each pixel.

# This means we still get a raster back!
ke_chirts_mean <- mean(ke_chirts)

ke_chirts_mean

# Note the very strange `min value` though...

# Take a peek:
plot(ke_chirts_mean)

# These are missing values—we should *reclassify*

# Use `subst()` for simple reclassification
ke_chirts <- subst(ke_chirts, -9999, NA)

ke_chirts_mean <- mean(ke_chirts)

plot(ke_chirts_mean)

# For more advanced reclassification, use `classify()` -----------

# Classify using cut points ------------
breaks <- c(10, 20, 30, 40)

ke_chirts_binned <- classify(ke_chirts_mean, breaks)

# Values are now integers that correspond to a category:
head(values(ke_chirts_binned))

# The categories can be seen with `levels()`:
levels(ke_chirts_binned)

plot(ke_chirts_binned)

# You can also classify specific values. For instance, a
# two column matrix becomes a "from -> to" classification. (See exercises)

# Arithmetic

# It's also possible to do straightforward computations on each raster cell:
ke_chirts - 10

ke_chirts * 2

# Or even with 2 rasters:
ke_zero <- ke_chirts - ke_chirts
plot(ke_zero[[1]])

# Extent -----------------------------------------------------------------------

# Get the extent (bounding box) of the raster with `ext()`
ext(ke_chirts)

# We can crop our raster to a particular region with `crop()`
# This is very useful when you can only get raster data for a large area.
# Your first step should be to crop to your area of interest, as it drastically
# reduces the size of the raster files.

new_ext <- ext(35, 40, 0, 3)

# See the extent:
plot(ke_chirts[[1]])
plot(new_ext, add = TRUE)

chirts_crop <- crop(ke_chirts, new_ext)

# Note that the crop is applied to all layers
chirts_crop

plot(chirts_crop[[1]])

# Mask ----------------------

# Masking does not change the raster extent, but it converts all cells outside
# a given boundary to missing

chirts_mask <- mask(ke_chirts, new_ext)

plot(chirts_mask[[1]])

# This is often useful when making maps.
# For instance, to highlight a particular region:
ggplot() +
  layer_spatial(ke_chirts[[1]], alpha = 0.4) +
  layer_spatial(chirts_mask[[1]]) +
  scale_fill_viridis_c(na.value = "transparent") # Change color scale and make sure missing values are transparent

# -----------------------

# Raster <-> vector conversions

# Many operations can be applied to vector data

# Load our fake GPS points:
ke_gps <- st_read("data/ke_gps.shp", quiet = TRUE)

# We can select only those points inside our extent from above:
ke_gps_mask <- mask(vect(ke_gps), new_ext)

plot(ke_gps_mask)

# We can convert to a raster by counting the number of cluster points in each cell:
gps_rast <- rasterize(
  ke_gps_mask, # Provide input points
  rast(new_ext, resolution = 0.5), # Specify extent and resolution for output raster
  fun = "count" # Count points in each cell
)

plot(gps_rast)

# Plenty of other things terra can do -- zonal statistics, categorical raster manipulation,
# prediction, interpolation, etc. We don't have time to cover it all. This is just an introduction!

# Exercises ------------------

# 5.1 ---------

# Find the range of values for each cell in our `ke_chirts` raster. The range
# is the difference between the maximum and the minimum value for each cell.
# Plot the result (if you have extra time, use ggspatial)
#
# How does the map compare if you take the standard deviation of the
# raster cells instead of the range? (Hint: see `?terra::stdev`)

# 5.2 ---------

# Find the mean temperature value for a single month of CHIRTS data.
# You'll need to identify the layers corresponding to that month and then
# average the values of those layers.

# 5.3 ---------

# Using the DHS boundaries file from previous demos, filter to an administrative
# region of your choice and crop the `ke_chirts` raster to that region. Plot
# both the cropped raster and the border of the region you selected. (hint:
# this is probably easier done using ggspatial than base R `plot()`)

# After plotting, make some observations about how crop behaves when using
# a more complicated boundary. Compare this to the behavior of `mask()` as
# shown in the demo.
# (If you have time, feel free to use a mask to plot the raster around
# the same administrative region you selected)
