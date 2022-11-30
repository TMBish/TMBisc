library(tidyverse)
library(nbastatR)
library(highcharter)
library(glue)
library(future)

Sys.setenv("VROOM_CONNECTION_SIZE" = 131072 * 2)
source("https://raw.githubusercontent.com/TMBish/TMBisc/master/HC/hc_theme_tmbish.R")

# Data----------------------------------------------------------------

gamelogs =game_logs(seasons = 2023)

player_profiles = 
  player_profiles(
    gamelogs %>%
      filter(minutes > 0) %>%
      distinct(namePlayer) %>%
      pull()
  )

# Analysis ------------------------------------------------------------------


gamelogs %>%
  filter(minutes > 0) %>%
  select(nameTeam, namePlayer, minutes) %>%
  inner_join(player_profiles %>% select(namePlayer, heightInches)) %>%
  group_by(nameTeam, namePlayer, heightInches) %>%
  summarise(across(minutes, sum), .groups = "drop") %>%
  group_by(nameTeam) %>%
  summarise(
    height_average_by_minutes = sum(heightInches * minutes) / sum(minutes)
  ) %>%
  hchart("line", hcaes(x = nameTeam, y = height_average_by_minutes)) %>%
  hc_add_theme(hc_theme_tmbish())



gamelogs %>%
  filter(minutes > 0) %>%
  select(nameTeam, namePlayer, minutes) %>%
  inner_join(player_profiles %>% select(namePlayer, weightLBS)) %>%
  group_by(nameTeam, namePlayer, weightLBS) %>%
  summarise(across(minutes, sum), .groups = "drop") %>%
  group_by(nameTeam) %>%
  summarise(
    weight_pounds_minute_weighted_avg = sum(weightLBS * minutes) / sum(minutes)
  ) %>%
  hchart("line", hcaes(x = nameTeam, y = weight_pounds_minute_weighted_avg)) %>%
  hc_add_theme(hc_theme_tmbish())