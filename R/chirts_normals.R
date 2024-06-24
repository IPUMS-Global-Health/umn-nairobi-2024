library(sf)
library(terra)

ke_chirts <- rast("data/ke_chirts_2013.nc")

chirts_monthly_mean <- function(object, year, month) {
  message("Getting CHIRTS daily for ", year, "...")
  
  chirts <- chirps::get_chirts(
    object,
    dates = c(
      paste0(year, "-", month, "-01"), 
      paste0(year, "-", month, "-", lubridate::days_in_month(month))
    ),
    var = "Tmax"
  )
  
  NAflag(chirts) <- -9999
  
  chirts_mean <- mean(chirts)
  
  chirts_mean
}

purrr::walk(
  1:12,
  function(m) {
    chirts_months <- purrr::map(
      2000:2009,
      function(y) {
        chirts_monthly_mean(vect(ext(ke_chirts)), year = y, month = m)
      }
    )
    
    monthly_mean <- mean(rast(chirts_months))
    
    file <- paste0("chirts_mean_2000_2009_", stringr::str_pad(m, 2, pad = "0"), ".tif")
    
    writeRaster(
      monthly_mean, 
      file.path(here::here("data/chirts"), file),
      overwrite = TRUE
    )
  }
)
