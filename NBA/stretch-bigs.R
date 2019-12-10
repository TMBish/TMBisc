library(tidyverse)
library(nbastatR)
library(highcharter)
library(glue)
library(furrr)


# Some Extra Stuff
# ______________

# Highcharts Theme
source("https://raw.githubusercontent.com/TMBish/lab_posts/master/00_utilities/highcharts-theme.R")

# Getting Data
# ______________

plan(multiprocess)

gamelogs = game_logs(1990:2020)

# Images Nails
player_photo = 
  nbastatR::nba_players() %>%
  select(idPlayer, namePlayer, urlPlayerThumbnail)

# Player Height
combine = 
  nbastatR::draft_combines(1990:2020)

# Stretch Bigs
# ______________

# 3PM
threes = 
  gamelogs %>%
  filter(yearSeason >= 2000) %>%
  filter(typeSeason == "Regular Season") %>%
  group_by(idPlayer, namePlayer, slugSeason) %>%
  summarise(fg3m = sum(fg3m), fg3a = sum(fg3a), games = n()) %>%
  ungroup()
 
# Player Info
player_profiles = 
  player_profiles(threes %>% distinct(namePlayer) %>% pull())


# Total Attempts
threes %>%
  left_join(
    player_profiles %>% select(idPlayer, heightInches)
  ) %>%
  filter(!is.na(heightInches), heightInches >= 82) %>%
  group_by(slugSeason) %>%
  summarise(
    fg3m = sum(fg3m),
    fg3a = sum(fg3a)
  ) %>%
  hchart("column", hcaes(x = slugSeason, y = fg3a)) %>%
  hc_add_theme(high_tmbish()) %>%
  hc_xAxis(title = list(text = "")) %>%
  hc_yAxis(title = list(text = "Total 3PT FG Attempts")) %>%
  hc_title(text = "Stretch Bigs") %>%
  hc_subtitle(text = "Total 3PT attempts by players 6 foot 10 or taller")

# Shooting Efficiency
threes %>%
  left_join(
    player_profiles %>% select(idPlayer, heightInches)
  ) %>%
  filter(!is.na(heightInches), heightInches >= 82) %>%
  group_by(slugSeason) %>%
  summarise(
    fg3m = sum(fg3m),
    fg3a = sum(fg3a)
  ) %>%
  mutate(
    fg3pct = fg3m / fg3a
  ) %>%
  hchart("line", hcaes(x = slugSeason, y = fg3pct)) %>%
  hc_add_theme(high_tmbish()) %>%
  hc_xAxis(title = list(text = "")) %>%
  hc_yAxis(title = list(text = "3PT%")) %>%
  hc_title(text = "Stretch Bigs") %>%
  hc_subtitle(text = "3PT % by players 6 foot 10 or taller")

# 3 Attempts Per Game, >38% shooting
threes %>%
  left_join(
    player_profiles %>% select(idPlayer, heightInches)
  ) %>%
  filter(!is.na(heightInches), heightInches >= 82) %>%
  mutate(fg3a_game = fg3a  / games, fg3pct = fg3m / fg3a) %>%
  group_by(slugSeason) %>%
  summarise(
    attempt_3_38_pct = sum(ifelse(fg3a_game >= 3 & fg3pct >= 0.38, 1, 0))
  ) %>%
  hchart("column", hcaes(x = slugSeason, y = attempt_3_38_pct)) %>%
  hc_add_theme(high_tmbish()) %>%
  hc_xAxis(title = list(text = "")) %>%
  hc_yAxis(title = list(text = "Players >= 3 3PT FGA + >= 38% 3PT%")) %>%
  hc_title(text = "Stretch Bigs") %>%
  hc_subtitle(text = "Players 6 foot 10 or taller")
