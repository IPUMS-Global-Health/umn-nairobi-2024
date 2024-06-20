# ------------------------------------------------------------------------------
#
# Validate and simplify Kenya Integrated boundaries from IPUMS DHS.
# Some boundaries produce holes and invalid features when unioned.
#
# ------------------------------------------------------------------------------

library(sf)

ke_borders <- st_read("data/geo_ke1989_2014/geo_ke1989_2014.shp")

ke_borders_clean <- ke_borders |> 
  st_make_valid() |> 
  st_simplify(dTolerance = 1)

st_write(ke_borders_clean, "data/geo_ke1989_2014_cleaned.shp")
