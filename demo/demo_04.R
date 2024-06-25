# Working with vector data

library(sf)
library(ggspatial)
library(stringr)

# sf ---------------------------------------------------------------------------

# Load data
ke_gps <- st_read("data/ke_gps.shp", quiet = TRUE)

ke_borders <- st_read(
  "data/ke_boundaries/sdr_subnational_boundaries2.shp", 
  quiet = TRUE
)

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

# 1. Identify the 5 KE regions with the most DHS clusters

# 2. Identify the 5 KE regions with the largest area-to-perimeter ratio

# 3. Find the DHS cluster that is furthest from the Kenyan national border
#    You will need to first combine border polygons as demonstrated above.
#    I have converted the polygons to linestring geometries for you:

ke_borders <- st_cast(ke_borders, to = "MULTILINESTRING")


