# Vector data and ggspatial

library(sf)
library(ggspatial)
library(stringr)

# sf ---------------------------------------------------------------------------

# Load data
ke_gps <- st_read("data/ke_gps.shp", quiet = TRUE)

ke_borders <- st_read(
  "data/ke_boundaries/sdr_subnational_boundaries2.shp", 
  quiet = TRUE
) |> 
  st_make_valid() # For joining later

# Working with attributes ------------------------------------------------------

# Same as a normal table
ke_borders$FIPS

ke_borders |> 
  filter(REGNAME == "nairobi")

ke_borders |> 
  filter(str_detect(REGNAME, "na"))

# Count clusters north of equator
# Note that this is not really a "spatial" operation in this case
ke_gps |> 
  group_by(north_of_eq = LATNUM > 0) |> 
  summarize(n = n())

# Working with geometries ------------------------------------------------------

# Geometries
st_geometry(ke_gps)
st_geometry(ke_borders)

# Polygon operations
cnty_centroid <- st_centroid(ke_borders)

ggplot() +
  layer_spatial(ke_borders) +
  layer_spatial(cnty_centroid)

cnty_area <- st_area(ke_borders)

ggplot() +
  layer_spatial(ke_borders, aes(fill = as.numeric(cnty_area))) +
  layer_spatial(cnty_centroid, color = "black") +
  scale_fill_gradient(low = "#dedad2", high = "#c80064") # Can use color scales the same as before!

# Union/Dissolve
ke_national_border <- st_union(ke_borders)

ggplot() +
  layer_spatial(ke_national_border) +
  layer_spatial(st_centroid(ke_national_border))

# Multiple spatial layers — find points that are within a given polygon:
joined <- st_join(
  ke_gps,
  ke_borders[1, ],
  join = st_within,
  left = FALSE
)

plot(joined[, 1])


# Exercises --------------------------------------------------------------------

# 4.1 ---------

# Using the `DHSREGNA` variable in our DHS cluster point data, identify the
# 5 KE regions with the most DHS clusters

# 4.2 ---------

# Using the `DHSREGEN` variable in our Kenya administrative boundaries file,
# identify the 5 KE regions with the largest area-to-perimeter ratio

# Bonus: make a map where each administrative region is colored by its
# area-to-perimeter ratio. (Hint: you may need to convert your calculated
# area-to-perimeter to a number with `as.numeric()`)

# 4.3 ---------

# Find the DHS cluster that is furthest from the Kenyan national border
#
# You will need to use the dissolved national border file from the demo to
# do so. I've converted it from a polygon to a linestring object for you.
#
# Bonus: make a map where each DHS cluster point is colored by its distance
# to the national border

ke_national_border <- st_union(ke_borders)
ke_borders_lines <- st_cast(ke_national_border, to = "MULTILINESTRING")

# 4.4 ----------

# Identify the 5 Kenya administrative regions with the highest density
# of DHS clusters. That is, which regions have the most clusters per unit
# of area? Use the `DHSREGEN` variable in the boundary file to identify
# regions.
#
# Hint: this will require joining cluster points with the administrative
# boundary file as shown in the demo.
