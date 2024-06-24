# Save 2013 CHIRTS NetCDF file for ease of use

library(sf)
library(terra)

ke_borders <- st_read(
  "data/ke_boundaries/sdr_subnational_boundaries2.shp", 
  quiet = TRUE
)

ke_borders <- ke_borders |> 
  st_make_valid() |> 
  st_union() |> 
  st_simplify(dTolerance = 10) |> 
  st_transform(crs = 32637) |> 
  st_buffer(dist = 10000) |> 
  st_transform(crs = 4326)

ke_chirts <- chirps::get_chirts(
  vect(ke_borders),
  dates = c("2013-01-01", "2013-12-31"),
  var = "Tmax"
)

time(ke_chirts) <- seq(
  lubridate::ymd("2013-01-01"), 
  lubridate::ymd("2013-12-31"),
  by = "days"
)

writeCDF(
  ke_chirts,
  filename = "data/ke_chirts_2013.nc",
  overwrite = TRUE
)