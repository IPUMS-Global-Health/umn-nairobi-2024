# Cleaning tabular data

ke_dhs <- read_ipums_micro(ke_ddi)

# dplyr ------------------------------------------------------------------------

# summarize BIRTHWT values
ke_dhs |> 
  summarize(mean_birthwt = mean(BIRTHWT))

# Summarize by group
ke_dhs |> 
  group_by(DHSID) |> 
  summarize(mean_birthwt = mean(BIRTHWT))

# Need to deal with missing values first
ke_dhs |> 
  mutate(BIRTHWT = if_else(BIRTHWT > 9995, NA, BIRTHWT / 1000)) |> 
  group_by(DHSID) |> 
  summarize(mean_birthwt = mean(BIRTHWT))

ke_dhs |> 
  mutate(BIRTHWT = if_else(BIRTHWT > 9995, NA, BIRTHWT / 1000)) |>
  filter(!is.na(BIRTHWT)) |> 
  group_by(DHSID) |> 
  summarize(mean_birthwt = mean(BIRTHWT))

# Alternatively:
ke_dhs |> 
  mutate(BIRTHWT = if_else(BIRTHWT > 9995, NA, BIRTHWT / 1000)) |>
  group_by(DHSID) |> 
  summarize(mean_birthwt = mean(BIRTHWT, na.rm = TRUE))

# Exercises --------------------------------------------------------------------

# 3.1 ---------

# The BIRTHWT histogram we showed in the slides had some frequent values
# Summarize the ke_dhs data to see which values were more common.
# What are the most common BIRTHWT values?
# Are there any other variables with similar patterns?

# 3.2 ---------

# Our IVs will be FLOOR, TOILETTYPE, DRINKWTR, FEVRECENT, DIARRECENT
# 
# Explore these variables to identify whether they may need any modifications 
# before being used in analysis.
#
# Some useful tools:
# - Basic R (unique(), range(), etc.)
# - ipumsr metadata functions (e.g. ipums_var_info(), ipums_val_labels(), ipums_var_desc())
# - dplyr functions (e.g. summarize(), count())
# - ggplot2

# 3.3 ---------

# If any of the above variables need additional cleaning, try to write code
# to prepare the variables accordingly.
