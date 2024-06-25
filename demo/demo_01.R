# Introduction to R + RStudio

# Anatomy of RStudio -----------------------------------------------------------

# Console
# Files
# Environment

# Preferences: my setup may look a bit different than yours 

# How to use RStudio -----------------------------------------------------------

## Commands in console
## Scripts

# Basic concepts ---------------------------------------------------------------

## Data types --------

# Character/string
"Hello, world"

# Numeric
1.5
50

# Integer
50L

# Logical/Boolean
TRUE
FALSE

# Check type
typeof(TRUE)
typeof(1L)

# Missing 
NA

## Comments --------

# `#` is the comment sign. It prevents code from being run
# Whitespace is also ignored

# But, don't write code like this!
4 +
  3      / 3

## Computations -------

# Basic arithmetic (operators)

2 * 4
5 + 8
5 / 2
9 - 5
2 ^ 3

# Other arithmetic

(30 * 2) / 4.3
10 %% 4 # Remainder

14 %/% 5 # Integer division
15 %/% 5

round(4.942432, 2)
floor(4.11)
ceiling(4.20)

# Logical operations
3 > 4
2 == 1
(2 + 2) >= 4

# And/Or
TRUE & FALSE
FALSE | TRUE | FALSE

# Missing values
NA + 1

# The assignment operator -------
 
# `<-` (`<` and `-`)
x <- 10
y <- 20

x + y

# `x` and `y` are known as "variables"
# The variables are stored in your "environment"

z <- (x + y) / 10

z

# You can't access a variable before it has been assigned:
my_variable

### Collections of objects -------

# Vectors
fruits <- c("apple", "banana", "cherry")
numbers <- seq(11, 20) # Sequence 

# Indexing
fruits[1]
fruits[1:2]
numbers[c(5, 8)]

# Properties
length(fruits)
typeof(fruits) # One type

# Lists
my_list <- list("A", 1, TRUE)

# Indexing
my_list[[1]]
my_list[1]

my_list[[1:2]]
my_list[1:2]

# Names
my_named_list <- list(
  a = 1,
  b = 2,
  c = 3
)

my_named_list[["a"]]
my_named_list["a"]

my_named_list[c("a", "b")]

# Vectorized functions --------

x <- c(1, 4, 10)
y <- c(2, 4, 2)

x + y
x / y

x > 5

mean(x) + mean(y)

# Index with logical values
l <- c(TRUE, TRUE, FALSE)
x[l]

## More than one line ------

## Functions
# `c()`, `seq()`, `dim()`, `colnames()` ... all "functions"

## Arguments -- functions often have many options
seq(1, 10, by = 2) # `by` is an argument to the `seq()` function

## The "Pipe"
## |> (`|` + `>`)

# Chains functions together
mean(seq(1, 10, by = 2))
seq(1, 10, by = 2) |> mean()

# This can be useful when doing more complex data operations
# You may also see `%>%`

# R Packages -------------------------------------------------------------------

# What is a package?

# CRAN
# install.packages("ipumsr")

# GitHub

# Using a package ---------

# `::`
ipumsr::ipums_data_collections()

ipums_data_collections() # Can't find it!

# More commonly:
library(ipumsr)

ipums_data_collections()

# `install.packages()` and `library()` are distinct operations

# Getting help -----------------------------------------------------------------

# `?` operator
?sd

# Resources -----------

# Open-Source books
# Stack Overflow
# GitHub

# Interpreting error messages ---------

# Reproducible examples
# Look for existing solutions (i.e. packages)!

# Workshop materials -----------------------------------------------------------

# Rmarkdown ----------

# What is it
# How to use it
# slides_code.Rmd

# Exercises --------------------------------------------------------------------

# 1. --------

# What will this return? What does this tell you about order of operations in R?
2 + 2 < 3

# If we modify the code as follows, what do you expect the output to be? Why?
2 + (2 < 3)

# 2. --------

# Why are we unable to compute this mean? 
# How can we modify the code to produce a valid value?
x <- c(1, 4, 3, NA, 2, 4)
mean(x)

# 3. --------

# What's the problem here?
x <- c(1, 3, 5)
mean("x")

# 4. --------

# What will the following code produce? Why?
v <- c("A", 1, 2)
v[2] + v[3]

# 5. --------

# Write code to extract all the elements greater than 12 from the vector `x`:
x <- seq(1, 20, by = 2)