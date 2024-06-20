# ------------------------------------------------------------------------------
#
# Generate synthetic dataset of cluster coordinates based on regions present
# in DHS GPS coordinate shapefile.
#
# Synthetic data is used for workshop to eliminate need for all workshop
# participants to obtain access to DHS GPS coordinates.
#
# ------------------------------------------------------------------------------

library(sf)
library(dplyr)

set.seed(134)

# 2022 KE boundary shapfile from DHS
ke_bnds <- st_read("data/local/sdr_subnational_boundaries_2024-06-20/shps/sdr_subnational_boundaries2.shp") |> 
  st_make_valid() |> 
  # st_union() |> 
  st_simplify(dTolerance = 100)

# KE GPS coordinates from DHS
ke_gps <- ipumsr::read_ipums_sf("data/local/KEGE71FL.zip") |> 
  mutate(ADM1NAME_LOWER = tolower(ADM1NAME))

# Count clusters by admin region
reg_samp_n <- ke_gps |> 
  st_drop_geometry() |> 
  count(ADM1NAME_LOWER)
  
# Link number of clusters and region polygons for spatial sample within each
# polygon
bnds_samp <- ke_bnds |> 
  select(REGNAME) |> 
  left_join(reg_samp_n, by = c("REGNAME" = "ADM1NAME_LOWER"))

# Randomly sample new cluster locations within each region polygon 
# using original number of clusters within that region
samp_pts <- st_sample(bnds_samp, size = bnds_samp$n)

# Overwrite DHS GPS coordinates with synthetic cluster coordinates
synth_clust <- st_set_geometry(ke_gps, samp_pts) |> 
  select(-ADM1NAME_LOWER)

st_write(synth_clust, "data/ke_gps.shp")
