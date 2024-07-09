# Projections

library(terra)
library(sf)
library(ggplot2)
library(ggspatial)

# Exercises --------------------------------------------------------------------

# 6.1 ---------

# Inaccurate projections

# 6.1a

# We demonstrated how to project the Kenya GPS coordinates to UTM 37N.
# Now, project the Kenya boundary file to UTM 49S coordinates. (This is 
# a projection more appropriate for parts of Indonesia). Use https://epsg.io/
# to find the EPSG code for the projection. (Hint: we want the projection for
# the WGS 84 coordinate reference system, since that is what our borders
# are based on).
#
# After projecting, Use ggspatial to plot the projected boundaries. What
# do you notice?

# 6.1b

# Now, project to the WGS 1984 Lambert Azimuthal Equal Area North Pole 
# projection (https://epsg.io/?q=102017).
#
# Note that this projection is provided by ESRI, so it doesn't have an EPSG
# number. You can use the ESRI number by specifying `"ESRI:102017"`
# as the CRS.
#
# After projecting, Use ggspatial to plot the projected boundaries.

# 6.1c

# Now, use ggspatial to plot both of the projected boundaries that you just
# created on the same map. What do you notice? 
#
# Try changing the order of the layers. Does anything change?

# 6.2 ---------

# Raster projection

# 6.2a

# Generally, it's better to avoid projecting raster data. However, it is possible.
#
# Project the `ke_chirts` raster to the UTM 49S coordinate system used above
# (you will need to use `"epsg:32749"` instead of just the number for this
# operation, as this is what terra expects.)
#
# What do you notice? Does this provide any insight into why raster projection
# may not always be advisable?

# 6.2b

# Calculate the cell size for the unprojected and projected raster you just
# created. (Hint: use terra's `cellSize()` function)
#
# `cellSize()` produces a raster object. Plot this object for both the
# projected and unprojected rasters. 
#
# What differences do you notice about these results? Is there anything
# that surprises you?

# 6.2c

# Having observed the results of raster projection, do you have any more
# ideas about when raster projection can produce inaccurate spatial calculations?
