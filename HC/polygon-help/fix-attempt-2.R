# To install `athletemonitoring`:
# devtools::install_github("mladenjovanovic/athletemonitoring")

require(tidyverse)
require(athletemonitoring)
require(plotly)
require(highcharter)
# Version
# Joshua Kunst (2020). highcharter: A Wrapper for the 'Highcharts' Library. R package version 0.8.2.
# https://CRAN.R-project.org/package=highcharter

# Plotting data from `athletemonitoring` package
# Contains body map polygon coordinates
data("asrbody")

set.seed(1667)

body_df <- expand_grid(
  day = seq(1:15),
  Area = unique(asrbody$Area)
) %>%
  mutate(rating = sample(c(NA, NA, NA, NA, NA, NA, 0:10), n(), replace = TRUE))

plot_df <- body_df %>%
  left_join(asrbody, by = "Area")

# Plot
gg <- ggplot(
  data = plot_df,
  aes(x = x, y = y, group = Area, fill = rating)) +
  geom_polygon(aes(frame = day), color = "black", size = 0.25) +
  scale_y_reverse() +
  scale_fill_gradient(low = "yellow", high = "red", na.value = "grey") +
  theme_linedraw() +
  theme(
    panel.grid = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    legend.position = "none")

# Animation
gg <- ggplotly(gg) %>%
  animation_opts(
    transition = 1
    #easing = "elastic-in"
  )
gg

# --------------------------------------
# Highcharter
# Create time series for tooltip
body_df_historical <- body_df %>%
  nest(-Area) %>%
  mutate(
    ttdata =
      data %>%
      map(mutate_mapping, hcaes(x = day, y = rating), drop = T) %>%
      map(list_parse)
  ) %>%
  select(-data)

plot_df_hc <-
  left_join(
    # Filter only the latest entry (i.e. day 15)
    filter(plot_df, day == max(day)),
    body_df_historical,
    by = "Area")

# This is how I fixed colors
# Create color palette
palette <- colorRampPalette(
  c("yellow", "red"))
palette <- palette(100)

cols <- plot_df_hc %>%
  select(Area, rating) %>%
  group_by(Area) %>%
  slice(1) %>%
  ungroup() %>%
  mutate(color_index =
           1 + floor(99 * ((rating - min(rating, na.rm = TRUE)) / (max(rating, na.rm = TRUE) - min(rating, na.rm = TRUE))))) %>%
  mutate(color = palette[color_index]) %>%
  mutate(color = if_else(is.na(color), "grey", color))

hchart(
  plot_df_hc,
  "ploygon",
  hcaes(x = x, y = y,  name = Area, group = Area)
) %>%
  hc_yAxis(reversed = T) %>%
  hc_tooltip(
    useHTML = TRUE,
    headerFormat = "<b>{point.key}</b>",
    pointFormatter = tooltip_chart(
      accesor = "ttdata",
      hc_opts = list(
        chart = list(type = "area"),
        yAxis = list(title = list(text = "")),
        xAxis = list(title = list(text = "Day")),
        plotOptions = list(area = list(fillOpacity = 0.5))
      )
    )
  ) %>%
  hc_legend(enabled = FALSE) %>%
  #hc_add_theme(hc_theme_smpl()) %>%
  hc_xAxis(title = 0, tickWidth = 0, lineWidth = 0, gridLineWidth = 0, labels = 0) %>%
  hc_yAxis(title = 0, tickWidth = 0, lineWidth = 0, gridLineWidth = 0, labels = 0) %>%
  hc_colors(cols$color)


# Problem
# 1. How to do this more simply - like in ggplot, where color for the area is aes mapped and scale created
# 2. How to create multiple series in tooltip (i.e. one for athlete, one for group average)
# 3. How to make lines/area in tooltip black, rather than color of the area