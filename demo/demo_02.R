# Exploring Tabular Data

# Loading data -----------------------------------------------------------------

# ipumsr -----------

library(ipumsr)

# Load the metadata file
ke_ddi <- read_ipums_ddi("data/idhs_00023.xml") # Use your own file name here 

# Use metadata to load the data correctly
ke_dhs <- read_ipums_micro(ke_ddi)

ke_dhs

# You can also load data directly
ke_dhs <- read_ipums_micro("data/idhs_00023.xml")

# However, having the metadata (`ke_ddi`) separate can be handy in some cases

# readr ------------

library(readr)

# Example file path to CSV
example_file <- readr_example("mtcars.csv")

df <- read_csv(example_file)

df

# IPUMS metadata ---------------------------------------------------------------

var_info <- ipums_var_info(ke_dhs)

var_info$var_name
var_info$var_label

var_info$val_labels # More complex output!

# More comprehensive metadata on website
ipums_website("dhs", var = "HEIGHTFEM")

# Explore ----------------------------------------------------------------------

unique(ke_dhs$KIDSEX)
range(ke_dhs$BIRTHWT)

library(dplyr)

ke_dhs |> 
  count(KIDSEX)

ke_dhs |> 
  count(DHSID, KIDSEX)

# More dplyr later!

# ggplot2 ----------------------------------------------------------------------

library(ggplot2)

# There are many `geom_` functions

# geom_point()
# geom_bar()
# geom_histogram()
# geom_boxplot()
# ...

# Each geom has its own "aesthetics" that can/must be provided

# For instance, geom_point() requires `x` and `y`, which
# correspond to the plot axes:
ggplot(ke_dhs) +
  geom_point(
    aes(             # Aesthetics go inside `aes()`
      x = BIRTHWT,   # Here, we map the x-axis to the BIRTHWT variable
      y = AGE        # And the y-axis to the AGE variable
    )
  )

# We can use multiple geoms in one plot. They are assembled as layers
ggplot(ke_dhs) +
  geom_point(aes(x = BIRTHWT, y = AGE)) +
  geom_vline(aes(xintercept = 2400)) # xintercept aesthetic is needed for vertical line geom

ggplot(ke_dhs) +
  geom_bar(aes(x = WEALTHQ))

# We can add visual features as well
ggplot(ke_dhs) +
  geom_bar(aes(x = WEALTHQ), fill = "blue", alpha = 0.4)

# More interestingly, we can add visual aesthetics that *vary based on the data*
# In these cases, the visual aesthetics should go *inside* `aes()`
ggplot(ke_dhs) +
  geom_point(aes(x = BIRTHWT, y = AGE, color = AGE))

# You may need to convert variables to the appropriate type
# discrete values need to be factors:
ggplot(ke_dhs) + 
  geom_bar(aes(x = WEALTHQ, fill = as.factor(WEALTHQ)))

# You can also group data without changing visual aesthetics
ggplot(ke_dhs)+
  geom_boxplot(aes(x = BIRTHWT, group = as.factor(KIDSEX)))

# Color scales ----------

# Continuous values
ggplot(ke_dhs) +
  geom_point(aes(x = BIRTHWT, y = AGE, color = AGE)) +
  scale_color_gradient(low = "#003f5c", high = "#ffa600")

# Manual colors
ggplot(ke_dhs) + 
  geom_bar(aes(x = WEALTHQ, fill = as.factor(WEALTHQ))) +
  scale_fill_manual(values = c("black", "gray", "gray", "gray", "gray"))

# Pre-built palettes! (RColorBrewer)
ggplot(ke_dhs) + 
  geom_bar(aes(x = WEALTHQ, fill = as.factor(WEALTHQ))) +
  scale_fill_brewer(palette = "Accent")

# Layouts
ggplot(ke_dhs) +
  geom_point(aes(x = BIRTHWT, y = AGE, color = as.factor(RESIDENT))) +
  facet_grid(~ as.factor(RESIDENT)) +
  scale_color_manual(values = c("slateblue", "firebrick", "red"))

# Exercises --------------------------------------------------------------------

# 2.1 ----------

# In the slides we showed the distribution of BIRTHWT:
ggplot(ke_dhs) +
  geom_histogram(aes(x = BIRTHWT))

# Use the IPUMS metadata to identify why we have so many large values for this
# variable.

# 2.2 ----------

# Above, we made the following plot.
# How can we modify the code to produce a plot where the bars run horizontally?
#
# Hint: look at the documentation for `geom_bar()` by running `?geom_bar()`.
# `?aes_position` may also be useful.
ggplot(ke_dhs) +
  geom_bar(aes(x = WEALTHQ))

# 2.3 ----------

# Why does this plot produce bars that are filled with red, not blue?
ggplot(ke_dhs) +
  geom_bar(aes(x = WEALTHQ, fill = "blue"))

# Hint: This plot works:
ggplot(ke_dhs) +
  geom_bar(aes(x = WEALTHQ), fill = "blue")

# 2.4 ---------

# See if you can create a bar plot (`geom_bar()`) that shows the count of 
# observations in each WEALTHQ, but colored by KIDSEX. There are multiple ways
# to do this—feel free to explore the ggplot2 documentation!

# 5. ---------

# Take some time to read ggplot2 documentation and look at example plots.
# Play around with our data and try to make different plots!