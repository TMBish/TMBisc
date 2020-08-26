library(highcharter)
library(tidyverse)


df = read_csv("HC/data/dumbbell.csv")


df_wide = 
  df %>%
  pivot_wider(names_from = flag, values_from = price) 

hchart(df_wide, "dumbbell", hcaes(name = selection_name, low = min_price, high = max_price)) %>%
  hc_chart(inverted = TRUE) %>%
  hc_xAxis(categories = df_wide$selection_name) %>%
  hc_yAxis(type = "logarithmic")