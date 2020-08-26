library(tidyverse)
library(highcharter)

covid = read_csv("population/covid-data.csv")



covid %>%
  slice(1:30) %>%
  hchart("column", hcaes(x = country, y = population))


# China And India
outlier_population = 
  covid %>%
  filter(country %in% c("China", "India")) %>%
  summarise(population = sum(population))


# Everyone else
covid %>%
  #filter(!country %in% c("China", "India")) %>%
  filter(population >= 1000000) %>%
  arrange(population) %>%
  mutate(
    cumulative_population = cumsum(population)
  ) %>%
  hchart(
    "area", hcaes(x = country, y = cumulative_population),
    fillOpacity = 0.2
  ) %>%
  hc_add_theme(hc_theme_elementary()) %>%
  hc_xAxis(title = list(text = "")) %>%
  hc_title(text = "World Population") %>%
  hc_subtitle(text = "Excluing China and India") %>%
  hc_yAxis(
    title = list(text= "Cumulative Population"),
    plotLines = list(
      list(
        value = outlier_population$population,
        label = list(
          text = "China + India Population"
        )
      )
    )
  )