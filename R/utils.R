# Base theme elements
theme_dhs_base <- function() {
  ggplot2::`%+replace%`(
    ggplot2::theme_minimal(),
    ggplot2::theme(
      text = ggplot2::element_text(
        # family = "cabrito", 
        size = 10
      ), 
      plot.title = ggplot2::element_text(
        hjust = 0,
        size = 18, 
        color = "#00263A", # IPUMS navy
        margin = ggplot2::margin(b = 7)
      ), 
      plot.subtitle = ggplot2::element_text(
        size = 12, 
        hjust = 0,
        color = "#00000099",
        margin = ggplot2::margin(b = 10)
      ),
      plot.caption = ggplot2::element_text(
        size = 10,
        hjust = 1,
        color = "#00000099",
        margin = ggplot2::margin(t = 5)
      ),
      legend.position = "right",
      legend.title.position = "left",
      legend.title = ggplot2::element_text(size = 10, hjust = 0.5),
      legend.key.height = ggplot2::unit(30, "points"),
      legend.key.width = ggplot2::unit(7, "points"),
      legend.ticks = ggplot2::element_line(color = "white", linewidth = 0.2),
      legend.ticks.length = ggplot2::unit(1, "points"),
      legend.frame = ggplot2::element_rect(
        fill = NA, 
        color = "#999999", 
        linewidth = 0.2
      )
    )
  )
}


# Add map scale bar and update guides
theme_dhs_map <- function(show_scale = TRUE, continuous = TRUE) {
  if (show_scale) {
    scale <- annotation_scale(
      aes(style = "ticks", location = "br"), 
      text_col = "#999999",
      line_col = "#999999",
      height = unit(0.2, "cm")
    )
  } else {
    scale <- NULL
  }
  
  if (continuous) {
    guide <- guides(
      fill = guide_colorbar(draw.llim = FALSE, draw.ulim = FALSE)
    )
  } else {
    guide <- guides(
      fill = guide_colorsteps(draw.llim = FALSE, draw.ulim = FALSE)
    )
  }
  
  list(scale, guide)
}

# ggplot2 layer for continuous scale for selected palette
scale_fill_chirts_c <- function(na.value = NA, ...) {
  pal <- colorRampPalette(c("#bad3e8", "#ffd3a3", "#da5831", "#872e38"))
  ggplot2::scale_fill_gradientn(colors = pal(256), na.value = na.value, ...)
}

# Function to build individual panels for a small-multiple map using 
# continuous color scheme
chirts_panel_continuous <- function(x,
                                    borders,
                                    panel_title = "",
                                    show_scale = TRUE,
                                    fill_lab = "",
                                    ...) {
  x_mask <- mask(x, borders, inverse = FALSE)
  
  ggplot() + 
    layer_spatial(x_mask, alpha = 0.9, na.rm = TRUE) +
    # layer_spatial(borders, fill = NA, color = "#eeeeee") +
    layer_spatial(borders, fill = NA, color = "#7f7f7f") +
    labs(subtitle = panel_title, fill = fill_lab) +
    scale_fill_chirts_c(...) +
    theme_dhs_map(show_scale = show_scale) +
    theme(
      axis.text.x = element_blank(), 
      axis.text.y = element_blank(),
      plot.subtitle = element_text(hjust = 0.5, size = 12),
      panel.grid = element_blank()
    )
}

# Function to build individual panels for a small-multiple map using 
# diverging color scheme
chirts_panel_diverging <- function(x,
                                   borders,
                                   panel_title = "",
                                   show_scale = TRUE,
                                   fill_lab = "",
                                   ...) {
  x_mask <- mask(x, borders, inverse = FALSE)
  
  ggplot() + 
    layer_spatial(x_mask, alpha = 0.9, na.rm = TRUE) +
    # layer_spatial(borders, fill = NA, color = "#eeeeee") +
    layer_spatial(borders, fill = NA, color = "#7f7f7f") +
    labs(subtitle = panel_title, fill = fill_lab) +
    scale_fill_gradient2(...) +
    theme_dhs_map(show_scale = show_scale) +
    theme(
      axis.text.x = element_blank(), 
      axis.text.y = element_blank(),
      plot.subtitle = element_text(hjust = 0.5, size = 12),
      panel.grid = element_blank()
    )
}

# Helper to split raster layers into a list for small-multiple panel mapping
split_raster <- function(r) {
  purrr::map(seq_len(nlyr(r)), function(i) r[[i]])
}
