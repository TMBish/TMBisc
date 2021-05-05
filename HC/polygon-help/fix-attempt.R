library(highcharter)
library(tidyverse)
library(ggplot2)

load("HC/polygon-help/sample-data.Rda")

hchart(
  filter(plot_data, panel == "Athlete"),
  "polygon",
  hcaes(
    x = x, 
    y = y, 
    name = Area, 
    group = Area,
    value = value, 
    color = value, 
    fill = value
  ),
  colorKey = "value"
) %>%
hc_yAxis(reversed = T) %>%
hc_tooltip(
  useHTML = TRUE,
  headerFormat = "<b>{point.key}</b>",
  pointFormatter = tooltip_chart(
    accesor = "ttdata",
    hc_opts = list(
      chart = list(type = "area"),
      yAxis = list(tite = list(text = "Rating")),
      xAxis = list(title = list(text = "Day")),
      plotOptions = list(area = list(fillOpacity = 0.2))
    )
  )
) %>%
hc_legend(enabled = FALSE) %>%
hc_xAxis(title = 0, tickWidth = 0, lineWidth = 0, gridLines = 0, labels = 0) %>%
hc_yAxis(title = 0, tickWidth = 0, lineWidth = 0, gridLines = 0, labels = 0) %>%
hc_colorAxis(minColor = "yellow", maxColor = "red")





ggplot(
  plot_data, aes(x = x, y = y, group = Area, fill = value)
) + 
geom_polygon(aes(frame = day), color = "black") + 
scale_y_reverse() +
facet_wrap(~panel) + 
scale_fill_gradient(
  low = "yellow",
  high = "red",
  na.value = "white"
) + 
theme_linedraw() +
theme(
  panel.grid = element_blank(),
  axis.text = element_blank(),
  axis.ticks = element_blank(),
  axis.title = element_blank(),
  legend.position = "none"
)