library(tidyverse)
library(nbastatR)
library(highcharter)
library(glue)
library(furrr)

# Getting Data
# ______________

# plan(multiprocess)

regSeason = game_logs(2000:2021, season_types = "Regular Season")

# Highcharts Theme
source("https://raw.githubusercontent.com/TMBish/TMBisc/master/HC/hc_theme_tmbish.R")


# Regular Season FT %
# ____________________

regSeason %>%
  group_by(slugSeason) %>%
  summarise(
    ft_pct = sum(ftm) / sum(fta)
  ) %>%
  hchart("line", hcaes(x = slugSeason, y = ft_pct)) %>%
  hc_add_theme(hc_theme_tmbish())


gameLevel = 
  regSeason %>%
  filter(slugSeason == "2019-20") %>%
  group_by(dateGame, idGame) %>%
  summarise(
    pctFG3 = sum(fg3m) / sum(fg3a)
  ) %>%
  ungroup() %>%
  mutate(
    pctFG3_roll10 = zoo::rollmean(pctFG3, k = 25, fill = NA, align = "right")
  )

gameLevel %>%
  hchart("scatter", hcaes(y = pctFG3), name = "Overall 3PT%", opacity = 0.1, showInLegend = TRUE) %>%
  hc_add_series(gameLevel, "line", hcaes(y = pctFG3_roll10), name = "Rolling 10 Game", showInLegend = TRUE) %>%
  hc_add_theme(hc_theme_tmbish())


regSeason %>%
  filter(slugSeason == "2019-20") %>%
  group_by(dateGame, idGame, slugTeam) %>%
  summarise(
    makes_3pt = sum(fg3m),
    attempts_3pt = sum(fg3a),
    pct_3pt = sum(fg3m) /  sum(fg3a)
  ) %>%
  ungroup() %>%
  filter(attempts_3pt >= 30) %>%
  arrange(desc(pct_3pt))


# Playoffs vs Regular Season
# ____________________

regularSeasonAvg = 
  regSeason %>%
  group_by(slugSeason) %>%
  summarise(
    pctFG3_reg = sum(fg3m) / sum(fg3a)
  )

playoffAvg = 
  playoffHistory %>%
  group_by(slugSeason) %>%
  summarise(
    pctFG3_playoff = sum(fg3m) / sum(fg3a)
  )

pct3averages = 
  regularSeasonAvg %>%
  inner_join(
    playoffAvg
  ) %>%
  mutate(
    delta = round((pctFG3_playoff - pctFG3_reg) / pctFG3_reg,3),
    delta_label = case_when(
      delta < 0 ~ glue("<span style='color: #d00000'> {scales::percent(delta)} </span>"),
      TRUE ~ glue("<span style='color: #2a9d8f'> {scales::percent(delta)} </span>")
    )
  )


hchart(
  pct3averages, 
  "line", 
  hcaes(x = slugSeason, y = pctFG3_reg), 
  name = "Regular Season Avg",
  showInLegend = TRUE
) %>%
hc_add_series(
  pct3averages, 
  "scatter", 
  hcaes(x = slugSeason, y = pctFG3_playoff), 
  name = "Playoff Avg",
  marker = list(
    symbol = "circle",
    width  = 40,
    height = 40
  ),
  showInLegend = TRUE,
  dataLabels = list(
    HTML = TRUE,
    enabled = TRUE,
    y = -3,
    formatter = JS("function(){return(this.point.delta_label)}")
  )
) %>%
hc_chart(backgroundColor = "#FFF") %>%
hc_colors(c( "#D6D6D6" ,"#000000")) %>%
hc_yAxis(title = list(text = "3PT%"), labels = list(formatter = JS("function(){return( Math.round(this.value * 100) + '%')}"))) %>%
hc_xAxis(title = list(text = "Season")) %>%
hc_add_theme(hc_theme_tmbish()) %>%
hc_title(text = "Bubble Shooting Effect", align = "center") %>%
hc_subtitle(text = "Regular Sesason vs Playoffs 3PT shooting %", align = "center")

