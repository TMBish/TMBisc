library(tidyverse)
library(nbastatR)
library(highcharter)
library(glue)
library(furrr)

# Getting Data
# ______________

regSeason = game_logs(1988:2021, season_types = "Regular Season")

# Highcharts Theme
source("https://raw.githubusercontent.com/TMBish/TMBisc/master/HC/hc_theme_tmbish.R")

# True Shooting %
# ____________________

# Number of games so far in 20-21 season
games2021 = 
  regSeason %>%
  filter(slugSeason == "2020-21") %>%
  distinct(idGame) %>%
  nrow()


regSeason %>%
  group_by(slugSeason) %>%
  mutate(seasonGameNumber = dense_rank(idGame)) %>%
  ungroup() %>%
  filter(seasonGameNumber <= games2021) %>%
  group_by(slugSeason) %>%
  summarise(
    across(c(fga, fgm, fg3a, fg3m, fta, ftm, pts), sum)
  ) %>%
  mutate(
    fg3_pct = fg3m / fg3a,
    ft_pct = ftm / fta,
    ts_pct = pts / (2 * (fga + 0.44 * fta)),
    clr = ifelse(slugSeason == "2020-21", "y", "n")
  ) %>%
  hchart(
    "scatter", hcaes(x = ts_pct, y = fg3_pct, group = clr),
    showInLegend = FALSE,
    dataLabels = list(
      HTML = TRUE,
      enabled = TRUE,
      y = -3,
      formatter = JS("function(){return(this.point.slugSeason)}")
    )
  ) %>%
  hc_add_theme(hc_theme_tmbish()) %>%
  hc_colors(c("#D3D3D3", "#2EC4B6")) %>%
  hc_yAxis(title = list(text = "3PT%"), labels = list(formatter = JS("function(){return( Math.round(this.value * 1000) / 10 + '%')}"))) %>%
  hc_xAxis(
    title = list(text = "TS%"), 
    labels = list(formatter = JS("function(){return( Math.round(this.value * 1000) / 10 + '%')}")),
    min = 0.5, max = 0.575
  ) %>%
  hc_title(text = "NBA True Shooting", align = "center") %>%
  hc_subtitle(text = glue("First {games2021} games of regular season since 1988"), align = "center")



# 50-40-90 Players
# ____________________


regSeason %>%
  group_by(slugSeason) %>%
  mutate(seasonGameNumber = dense_rank(idGame)) %>%
  ungroup() %>%
  filter(seasonGameNumber <= games2021) %>%
  group_by(slugSeason, namePlayer) %>%
  summarise(
    across(c(fga, fgm, fg3a, fg3m, fta, ftm, pts), sum)
  ) %>%
  mutate(
    fg3_pct = fg3m / fg3a,
    fg_pct = fgm / fga,
    ft_pct = ftm / fta,
  ) %>%
  filter_all(all_vars(!is.na(.))) %>%
  filter(fga >= 100, fta >= 20) %>%
  group_by(slugSeason) %>%
  summarise(
    players = sum(ifelse(fg_pct >= 0.5 & fg3_pct >= 0.4 & ft_pct >= 0.9,1,0 ))
  ) %>%
  mutate(clr = ifelse(slugSeason == "2020-21", "y", "n")) %>%
  hchart(
    "column", hcaes(x = slugSeason, y = players, color = colorize(clr, c("#D3D3D3", "#2EC4B6"))),
    showInLegend = FALSE,
    dataLabels = list(enabled = TRUE, formatter=JS("function(){return(this.point.players)}"))
  ) %>%
  hc_add_theme(hc_theme_tmbish()) %>%
  hc_yAxis(
    visible = FALSE
  ) %>%
  #  title = list(text = "50-40-90 Players")) %>%
  hc_xAxis(title = list(text = "Season")) %>%
  hc_title(text = "50-40-90 Players", align = "center") %>%
  hc_subtitle(text = glue("First {games2021} games of regular season | 100+ FGAs & 20+ FTAs"), align = "center")
