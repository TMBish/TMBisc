library(tidyverse)
library(nbastatR)
library(highcharter)
library(glue)
library(future)

Sys.setenv("VROOM_CONNECTION_SIZE" = 131072 * 2)
source("https://raw.githubusercontent.com/TMBish/TMBisc/master/HC/hc_theme_tmbish.R")

# Data----------------------------------------------------------------

gamelogs = game_logs(seasons = 1990:2023)

# Analysis ------------------------------------------------------------------


gamelogs %>%
  filter(minutes > 20) %>%
  mutate(
    triple_double = case_when(
      pts >= 10 & treb >= 10 & ast >= 10 ~ 1,
      TRUE ~ 0
    ),
    kash_triple_double = case_when(
      pts >= 12 & treb >= 12 & ast >= 12 ~ 1,
      TRUE ~ 0
    )
  ) %>%
  group_by(slugSeason) %>%
  summarise(
    n = n(),
    across(c(triple_double, kash_triple_double), sum)
  ) %>%
  mutate(
    triple_doubles_per_1000_games = (triple_double / n) * 1000,
    kash_triple_doubles_per_1000_games = (kash_triple_double / n) * 1000,
  ) %>%
  select(slugSeason, matches("triple_doubles")) %>%
  pivot_longer(-slugSeason) %>%
  hchart("line", hcaes(x = slugSeason, y = value, group = name)) %>%
  hc_add_theme(hc_theme_tmbish()) %>%
  hc_legend(verticalAlign = "bottom", align = "center") %>%
  hc_yAxis(
    title = list(text = ""),
    plotLines = list(
      list(value = 2, label = list(text="2 per 1000 games"))
    )
  ) %>%
  hc_title(text = "Inflation Adjusted Triple Doubles")





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