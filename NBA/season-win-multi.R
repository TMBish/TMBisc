library(tidyverse)
library(nbastatR)
library(highcharter)
library(glue)
library(future)

Sys.setenv("VROOM_CONNECTION_SIZE" = 131072 * 2)
standings = nbastatR::standings(seasons = 2023)

# Bet Data ----------------------------------------------------------------

bets = tribble(
  ~nameTeam, ~line, ~ou,
  "Memphis Grizzlies", 48.5, "over",
  "Denver Nuggets", 51.5, "over",
  "New Orleans Pelicans", 45.5, "over",
  "Portland Trail Blazers", 39.5, "under"
)

# Record ------------------------------------------------------------------

standings %>% 
  select(slugSeason, nameTeam, pctWinTeam) %>%
  mutate(projectedWins = pctWinTeam * 82) %>%
  select(-pctWinTeam) %>%
  inner_join(bets)

  
  
  