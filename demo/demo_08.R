# Joining Data Sources

library(ipumsr)
library(dplyr)
library(tidyr)
library(lubridate)
library(stringr)
library(sf)
library(terra)

# Joining on multiple rows a la CHIRTS post

# This is reproduced from workshop, in case I need to regenerate any data:
ke_dhs <- read_ipums_micro("data/idhs_00023.xml") |>
  mutate(KIDID = str_squish(paste(IDHSPID, BIDX)))

ke_gps <- st_read("data/ke_gps.shp", quiet = TRUE)

ke_chirts <- rast("data/ke_chirts_2013.nc")
ke_chirts <- subst(ke_chirts, -9999, NA)

ke_chirts_mean_mnths <- tapp(
  ke_chirts,
  fun = mean,
  index = "yearmonths"
)

ke_buffer <- st_buffer(ke_gps, dist = 10000)

ke_chirts_clust <- terra::extract(
  ke_chirts_mean_mnths, # Extract values for each month of temperature data
  ke_buffer,            # Use all cluster polygons
  weights = TRUE,
  fun = mean
)

ke_chirts_clust$ID <- ke_buffer$DHSID

ke_chirts_long <- ke_chirts_clust |>
  pivot_longer(
    cols = -ID,
    names_to = "CHIRTS_DATE",
    values_to = "MEAN_TEMP"
  ) |>
  mutate(
    CHIRTS_DATE = str_replace(CHIRTS_DATE, "ym_", ""),
    CHIRTS_DATE = ym(CHIRTS_DATE),
    CHIRTS_DATE = (year(CHIRTS_DATE) - 1900) * 12 + month(CHIRTS_DATE)
  )

# Demo -------------------------------------------------------------------------

# Join Types ---------------------

# We used an inner join in the workshop, but it can be useful to use other
# join types in some cases.

# For instance, a left join would preserve all rows in the DHS survey data
# even if they had no match in the CHIRTS data:
ke_dhs_chirts_left <- left_join(
  ke_dhs,
  ke_chirts_long,
  by = c("DHSID" = "ID", "KIDDOBCMC" = "CHIRTS_DATE")
)

# Note that some records don't have an associated MEAN_TEMP:
ke_dhs_chirts_left |> 
  select(KIDID, DHSID, KIDDOBCMC, MEAN_TEMP)

# More complex joins ---------------------------

# In the workshop, we joined data by matching directly on each child's birth
# date. However, this may not always be the most relevant temperature value
# to use when considering temperature's effects on birth weight.

# For instance, imagine we were more interested in the conditions the year
# before each child's birth date.

ke_chirts_long

# We need to calculate the CMC that corresponds to a year prior to the 
# CHIRTS_DATE:

ke_chirts_long2 <- ke_chirts_long |> 
  mutate(CHIRTS_YEAR_PRIOR = CHIRTS_DATE - 12)

ke_chirts_long2

inner_join(
  ke_dhs,
  ke_chirts_long2,
  by = c(
    "DHSID" = "ID", 
    "KIDDOBCMC" = "CHIRTS_YEAR_PRIOR" # Join on temperature 12 months prior to child birth
  )
)

# This metric is a little bit strange conceptually. (It would probably make more
# sense when assessing precipitation or vegetation, when discrete growing 
# seasons may matter more.)

# Joining multiple rows ----------------------

# Instead, we could assess the temperature exposure across the entire
# pregnancy time frame.

# Now, we can't simply join by matching column values, we need to specify
# a more complex matching process:

# First, calculate the conception month as 9 months prior to the birth month
ke_dhs2 <- ke_dhs |> 
  mutate(KIDCONCEPTCMC = KIDDOBCMC - 9)

# Then, we can use `join_by()` to specify a more complex join:

# Join 9 months of CHIRTS data to each child record
ke_dhs_chirts <- inner_join(
  ke_dhs2,
  ke_chirts_long,
  by = join_by(
    DHSID == ID, # Cluster ID needs to match
    KIDDOBCMC > CHIRTS_DATE, # DOB needs to be after all joined temp. data
    KIDCONCEPTCMC <= CHIRTS_DATE # Conception date needs to be before all joined temp. data
  )
)

# We can see that a single kid is now associated with 9 months of CHIRTS data:
ke_dhs_chirts |> 
  filter(KIDID == "40406 0003076 02 1") |> 
  select(KIDID, DHSID, KIDDOBCMC, CHIRTS_DATE, MEAN_TEMP)

# Note that because we are using limited data for this demo, not all kids
# have all 9 months of data represented:
ke_dhs_chirts |> 
  filter(KIDID == "40406 0001033 02 1") |> 
  select(KIDID, DHSID, KIDDOBCMC, CHIRTS_DATE, MEAN_TEMP)

min(ke_chirts_long$CHIRTS_DATE)

# At this point, we could aggregate the temperature values for each child, 
# producing an estimate of the temperature exposure across the 9 months
# before their birth.
ke_dhs_chirts |> 
  group_by(KIDID) |> 
  summarize(MEAN_TEMP_CONCEPT = mean(MEAN_TEMP))

# Exercises --------------------------------------------------------------------

# 8.1 ---------

# The appropriate time period to consider when attaching environmental 
# data to survey data can be difficult to determine.
#
# Brainstorm some examples of how the timing of environmental data may impact
# the way we decide to assess individual exposures when joining environmental
# data to survey data (whether from the DHS or elsewhere). Consider different
# climate variables (e.g. precipitation, heat, vegetation, or others) and
# different outcome variables of interest. Think through the pathways of how
# and when these climate variables might impact people in different
# circumstances, and think about how this might affect how we decide to attach
# climate data to our survey