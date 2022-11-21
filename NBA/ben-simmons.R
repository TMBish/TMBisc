library(tidyverse)
library(nbastatR)
library(highcharter)
library(glue)
library(future)

Sys.setenv(VROOM_CONNECTION_SIZE=500072)

# Getting Data
# ______________

gamelogs = nbastatR::game_logs(2017:2023)

source("https://raw.githubusercontent.com/TMBish/TMBisc/master/HC/hc_theme_tmbish.R")

# Basic Processing
# ______________

gamelogs %>%
  filter(slugSeason == "2022-23") %>%
  group_by(namePlayer) %>%
  summarise(across(c(minutes, pts, fga), sum)) %>%
  filter(minutes > 200) %>%
  mutate(
    pts_per_36 = 36 * (pts/minutes),
    fga_per_36 = 36 * (fga/minutes),
    is_simmons = ifelse(namePlayer == "Ben Simmons", "Y", "N")
  ) %>% 
  arrange(fga_per_36) %>%
  mutate(
    n = 1:n()
  ) %>%
  hchart("scatter", hcaes(x = n, y = fga_per_36, group = is_simmons)) %>%
  hc_add_theme(hc_theme_tmbish()) %>%
  hc_xAxis(title = list(text = "")) %>%
  hc_yAxis(title = list(text = "Points Per 36 Minutes")) %>%
  hc_title(text = "Ben Simmons Scoring 22-23") %>%
  hc_legend(title = list(text = "Is Ben Simmons")) 

# Previous Years
# ______________


gamelogs %>%
  filter(namePlayer == "Ben Simmons") %>%
  group_by(slugSeason) %>%
  summarise(across(c(minutes, pts, fga), sum)) %>%
  filter(minutes > 200) %>%
  mutate(
    pts_per_36 = 36 * (pts/minutes),
    fga_per_36 = 36 * (fga/minutes)
  ) %>% 
  hchart("line", hcaes(x = slugSeason, y = fga_per_36)) %>%
  hc_add_theme(hc_theme_tmbish()) %>%
  hc_xAxis(title = list(text = "")) %>%
  hc_yAxis(title = list(text = "Points Per 36 Minutes"), min = 7) %>%
  hc_title(text = "Ben Simmons Scoring") %>%
  hc_subtitle(text = "Scoring Through The Years")


