library(tidyverse)
library(nbastatR)
library(highcharter)
library(glue)

# Getting Data
# ______________

# Total Team Salaries
salary_summary = nbastatR::hoops_hype_salary_summary()

# Player Salaries
salary_player = nbastatR::hoopshype_salaries()

salary_player %>%
  filter(namePlayer == "Kristaps Porzingis")

# 30m / year players with 3+ years contracted
big_dogs = 
  salary_player %>%
  filter(!isTeamOption) %>%
  group_by(namePlayer) %>%
  summarise(
    contract_size = sum(amountContract),
    years_left = n()
  ) %>%
  mutate(
    per_year = contract_size / years_left
  ) %>%
  filter(per_year >= 30000000) %>%
  arrange(desc(per_year))

# Basketball Reference Player Tables
bref_advanced = 
  bref_players_stats(
    seasons = 2020
  ) %>%
  select(namePlayer, VORP = ratioVORP, WS48 = ratioWSPer48)

# Images Nails
player_photo = 
  nbastatR::nba_players() %>%
  filter(isActive) %>%
  select(namePlayer, urlPlayerThumbnail)

# Compare
# ______________

big_dogs %>%
  inner_join(bref_advanced) %>%
  inner_join(player_photo) %>%
  hchart("scatter", hcaes(x = VORP, y = WS48, marker = )) %>%
  hc_plotOptions(
    scatter = 
      list(
        
        dataLabels = list(enabled = TRUE, formatter = JS("function(){return(this.point.namePlayer)}"))
      )
  ) %>%
  hc_add_theme(hc_theme_elementary()) %>%
  hc_title(text = "$30m / year Players")


chartList = 
  big_dogs %>%
  inner_join(bref_advanced) %>%
  inner_join(player_photo) %>%
  select(namePlayer, x = VORP, y = WS48, urlPlayerThumbnail) %>%
  pmap(
   function(namePlayer, x,y,urlPlayerThumbnail) {
     list(
       x = x,
       y = y,
       namePlayer = namePlayer,
       marker = list(symbol = glue("url({urlPlayerThumbnail})"), height = 60, width = 75)
     ) 
   }
  ) %>%
  list(
    name = "advanced",
    data = .
  ) %>%
  list()

highchart() %>%
  hc_chart(type = "scatter") %>%
  hc_add_series_list(chartList) %>%
  hc_plotOptions(
    scatter = 
      list(
        dataLabels = list(enabled = TRUE, formatter = JS("function(){return(this.point.namePlayer)}")),
        jitter = list(x = 0.1, y = 0.01)
      )
  ) %>%
  hc_add_theme(hc_theme_elementary()) %>%
  hc_title(text = "$30m / year Players")

