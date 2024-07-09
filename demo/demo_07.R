# Raster aggregation

# Temporal raster aggregation is quite flexible
# We can provide our own workflows to calculate a variety of different
# values from our daily raster

ke_chirts <- rast("data/ke_chirts_2013.nc")
ke_chirts <- subst(ke_chirts, -9999, NA)

# Alternative heat exposure metrics -----------------

# For instance, we can identify all the days that exceeded a certain threshold
# temperature.

# First, we find the days above a certain temperature:
ke_bin <- ke_chirts > 35

# Rasters can contain TRUE/FALSE values!
ke_bin

plot(ke_bin[[1]])

# TRUE/FALSE is treated as 1/0 in R, so we can sum the binary raster to count
# the number of layers (days) above the temperature:
ke_count_above_35 <- sum(ke_bin)

ggplot() +
  layer_spatial(
    mask(ke_count_above_35, ke_borders), 
    alpha = 0.9
  ) +
  layer_spatial(ke_borders, fill = NA, color = "#444444") +
  labs(
    title = "Number of days above 35°C", 
    subtitle = "Kenya, 2013", 
    fill = ""
  ) +
  scale_fill_viridis_c(na.value = NA) +
  theme_minimal()

# Aggregating to monthly level ---------------

# What if we want to do this for each month, like we demonstrated previously?

tapp(
  ke_chirts,
  fun = , # ???
  index = "yearmonths"
)

# We have to write our OWN function!

ke_count_monthly <- tapp(
  ke_chirts,
  fun = function(x) sum(x > 35),
  index = "yearmonths"
)

ke_count_monthly

# The confusing part here is `function(x) sum(x > 35)`...what's going on?

# This line tells terra that we want to use our own function. That function
# is going to take each raster layer (`x`), determine if it is above 35, and
# sum all the layers within each month.

# We could actually write other functions that we've already used this way, too:
tapp(
  ke_chirts,
  fun = function(x) mean(x),
  index = "yearmonths"
)

# terra simply provides the shorthand for convenience (and speed):
tapp(
  ke_chirts,
  fun = mean,
  index = "yearmonths"
)

# Really, all we've done is taken what we did above and compress it into one line 
# that we can provide to `tapp()`.

plot(ke_count_monthly)

# Exercises --------------------------------------------------------------------

# 7.1 ---------

# Discuss with a partner some different ideas for how we could summarize
# temperature data at the monthly level to measure temperature exposure
# (or at other time levels).
#
# For the possible temperature exposure metric(s) you come up with, 
# think about how we could calculate those metrics from the CHIRTS raster
# data we have been working with. What would be the processing steps 
# required to calculate your metric(s)? What would be the advantages and
# disadvantages of the metric(s)?
#
# If you're feeling ambitious, you can try to implement any of your ideas
# in R.

# 7.2 ---------

# In the workshop, we averaged raster values within DHS clusters. Can you
# think of cases where it might be more appropriate to use a different
# aggregation method, like a maximum or minimum (or others)?
